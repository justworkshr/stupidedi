# frozen_string_literal: true
module Stupidedi
  using Refinements

  class Config

    #
    # The implementation version specified in GS08 and ST03 indicates which
    # implementation guide governs the transaction. Because each guide may
    # define multiple transaction sets (eg X212 and X279), the functional code
    # and transaction set code are needed to lookup a definition.
    #
    # In english, we can't just look at ST01 and link "837" to our definition of
    # 837P from the HIPAA guide.
    #
    class TransactionSetConfig
      include Inspect

      def initialize
        @table = Hash.new
      end

      def customize(&block)
        tap(&block)
      end

      # @example
      #   table = TransactionSetConfig.new
      #
      #   table.register("005010X212", "HR", "276") { Hipaa::X212::HR276 }
      #   table.register("005010X212", "HN", "277") { Hipaa::X212::HN277 }
      #
      #   table.register("005010X217", "HI", "278") { Hipaa::X217::HI278 }
      #   table.register("005010X218", "RA", "820") { Hipaa::X218::RA820 }
      #   table.register("005010X220", "BE", "834") { Hipaa::X220::BE834 }
      #   table.register("005010X221", "HP", "835") { Hipaa::X221::HP835 }
      #
      #   table.register("005010X222", "HC", "837") { Hipaa::X222::HC837 }
      #   table.register("005010X223", "HC", "837") { Hipaa::X223::HC837 }
      #   table.register("005010X224", "HC", "837") { Hipaa::X224::HC837 }
      #
      #   table.register("005010X230", "FA", "997") { Hipaa::X230::FA997 }
      #   table.register("005010X231", "FA", "999") { Hipaa::X231::FA999 }
      #
      #   table.register("005010X279", "HS", "270") { Hipaa::X279::HS270 }
      #   table.register("005010X279", "HB", "271") { Hipaa::X279::HB271 }
      #
      #   table.register("005010", "HR", "276") { Standards::HR276 }
      #   table.register("005010", "HS", "270") { Standards::HS270 }
      #   table.register("005010", "HB", "271") { Standards::HB271 }
      #   table.register("005010", "HN", "277") { Standards::HN277 }
      #   table.register("005010", "HI", "278") { Standards::HI278 }
      #   table.register("005010", "RA", "820") { Standards::RA820 }
      #   table.register("005010", "BE", "834") { Standards::BE834 }
      #   table.register("005010", "HP", "835") { Standards::HP835 }
      #   table.register("005010", "HC", "837") { Standards::HC837 }
      #   table.register("005010", "FA", "997") { Standards::FA997 }
      #   table.register("005010", "FA", "999") { Standards::FA999 }
      #
      # @return [void]
      def register(version, function, transaction, definition = nil, &constructor)
        if block_given?
          @table[Array[version, nil, transaction]] = constructor
        else
          @table[Array[version, nil, transaction]] = definition
        end
      end

      # @return [TransactionSetDef]
      def at(version, function, transaction)
        x = @table[Array[version, nil, transaction]]
        x.is_a?(Proc) ? x.call : x
      end

      def defined_at?(version, function, transaction)
        @table.defined_at?([version, nil, transaction])
      end

      # @return [void]
      def pretty_print(q)
        q.text "TransactionSetConfig"
        q.group(2, "(", ")") do
          q.breakable ""
          @table.keys.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

  end
end
