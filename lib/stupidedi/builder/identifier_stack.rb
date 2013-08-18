module Stupidedi
  module Builder

    class IdentifierStack
      def initialize(id)
        @state = Empty.new(id)
      end

      # Returns the current ID from whichever level is active
      #
      def id
        @state.id
      end

      # Create a new ISA12/IEA02 Interchange Control Number
      #
      # @return [Integer]
      def isa
        @state = @state.isa
        @state.id
      end

      # Create a new GS06/GE02 Group Control Number
      #
      # @return [Integer]
      def gs
        @state = @state.gs
        @state.id
      end

      # Create a new ST02/SE02 Transaction Set Control Number
      #
      # @return [String]
      def st
        @state = @state.st
        @state.id
      end

      # Create a new HL01 Hierarchical ID Number
      #
      # @return [String]
      def hl
        @state = @state.hl
        @state.id
      end

      # Return the ID of the current level, after removing that level
      #
      def pop
        @state.id.tap { @state = @state.pop }
      end

      def method_missing(name, *args)
        @state.__send__(name, *args)
      end

      # State Representations
      #########################################################################

      class Empty
        def initialize(id)
          @count, @next, @id = 0, id, id
        end

        # Create a new ISA12/IEA02 Interchange Control Number
        #
        # @return [ISA]
        def isa
          ISA.new(self, @next).tap { @count += 1; @next += 1 }
        end

        # Number of interchanges (not used)
        #
        # @return [Integer]
        def count
          @count
        end
      end

      class ISA
        attr_reader :id

        def initialize(parent, id)
          @count, @parent, @next, @id = 0, parent, id, id
        end

        # Create a new GS06/GE02 Group Control Number
        #
        # @return [GS]
        def gs
          GS.new(self, @next).tap { @count += 1; @next += 1 }
        end

        # IEA02 Number of Functional Groups (GS..GE)
        #
        # @return [Integer]
        def count
          @count
        end

        # @return [Empty]
        def pop
          @parent
        end
      end

      class GS
        attr_reader :id

        def initialize(parent, id)
          @count, @parent, @next, @id = 0, parent, id, id
        end

        # Create a new ST02/SE02 Transaction Set Control Number
        #
        # @return [ST]
        def st
          ST.new(self, @next).tap { @count += 1; @next += 1 }
        end

        # GE01 Number of Transaction Sets (within current functional group)
        #
        # @return [Integer]
        def count
          @count
        end

        # @return [ISA]
        def pop
          @parent
        end
      end

      class ST
        attr_writer :sequence

        def initialize(parent, id)
          @sequence, @parent, @id = 0, parent, id
        end

        # Create a new HL01 Hierarchical ID Number
        #
        # @return [HL]
        def hl
          HL.new(self, @sequence += 1)
        end

        # Current ST02 Transaction Set Control Number
        #
        # @return [String]
        def id
          @id.to_s.rjust(4, "0")
        end

        # ST01 Number of Included Segments (within current ST..SE inclusive)
        #
        # @return [Integer]
        def count(builder)
          m = Either.success(builder.machine)

          while m.defined?
            if m.flatmap(&:segment).map{|s| s.node.id == :ST }.fetch(false)
              return m.flatmap{|n| n.distance(builder.machine) }.fetch(0) + 2
            else
              m = m.flatmap(&:parent)
            end
          end
        end

        # @return [GS]
        def pop
          @parent
        end
      end

      class HL
        attr_writer :sequence

        def initialize(parent, id)
          @parent, @id, @sequence = parent, id, id
        end

        # Create a new HL01 Hierarchical ID Number
        #
        # @return [HL]
        def hl
          HL.new(self, @sequence += 1)
        end

        # Current HL01 Hierarchical ID Number
        #
        # @return [String]
        def id
          @id.to_s
        end

        # Current HL02 Parent Hierarchical ID Number
        #
        # @return [Integer]
        def parent
          case @parent
          when HL
            @parent.id
          end
        end

        def pop
          @parent.sequence = @sequence
          @parent
        end
      end
    end

  end
end
