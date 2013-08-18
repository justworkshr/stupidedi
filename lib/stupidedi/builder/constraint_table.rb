module Stupidedi
  module Builder

    #
    # The {ConstraintTable} is a data structure that contains one or more
    # {Instruction} values for the same segment identifier. Each concrete
    # subclass implements different strategies for narrowing down the
    # {Instruction} list.
    #
    # Reducing the number of valid {Instruction} values is important because
    # executing more than one {Instruction} creates a non-deterministic state --
    # more than one valid parse tree exists -- which slows the parser. Most
    # often there is only one valid {Instruction} but the parser cannot
    # (efficiently or at all) narrow the tree down without evaluating the
    # constraints declared by each {Instruction}'s {Schema::SegmentUse}, which
    # is done here.
    #
    class ConstraintTable

      # @return [Array<Instruction>]
      abstract :matches, :args => %w(segment_tok)

      #
      # Performs no filtering of the {Instruction} list. This is used when there
      # already is a single {Instruction} or when a {Reader::SegmentTok} doesn't
      # provide any more information to filter the list.
      #
      class Stub < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
          @instructions
        end
      end

      #
      # Chooses the {Instruction} that pops the greatest number of states. For
      # example, in the X222 837P an HL segment signals the start of a new
      # 2000 loop, but may or may not begin a new Table 2 -- the specifications
      # aren't actually clear. This rule will always create a new Table 2 and
      # a new 2000 loop under it.
      #
      class Shallowest < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
          @__matches ||= begin
            shallowest = @instructions.head

            @instructions.tail.each do |i|
              if i.pop_count > shallowest.pop_count
                shallowest = i
              end
            end

            shallowest.cons
          end
        end
      end

      #
      # The only exception to the rule of preferring the {Instruction} which pops
      # the greatest number of states is when the {Instruction} is for ISA. We want
      # to reuse one root {TransmissionVal} container for all children.
      #
      class Deepest < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
          @__matches ||= begin
            deepest = @instructions.head

            @instructions.tail.each do |i|
              if i.pop_count < deepest.pop_count
                deepest = i
              end
            end

            deepest.cons
          end
        end
      end

      #
      # Chooses the subset of {Instruction} values based on the distinguishing
      # values allowed by each {Schema::SegmentUse}. For instance, there are
      # often several loops that begin with `NM1`, which are distinguished by
      # the qualifier in element `NM101`.
      #
      class ValueBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
          present, match = unique_match(segment_tok, strict)
          return match unless match.nil?

          narrow_search(segment_tok, present, strict)
        end

      private

        # Resolve conflicts between instructions that have identical SegmentUse
        # values. For each SegmentUse, this chooses the Instruction that pops
        # the greatest number of states.
        #
        # @return [Array<Instruction>]
        def shallowest(instructions)
          shallowest = Hash.new

          instructions.each do |i|
            key = i.segment_use.object_id

            if shallowest.defined_at?(key)
              if shallowest.at(key).pop_count < i.pop_count
                shallowest[key] = i
              end
            else
              shallowest[key] = i
            end
          end

          shallowest.values
        end

        # @return [Array(Array<(Integer, Integer, Map)>, Array<(Integer, Integer, Map)>)]
        def basis(instructions)
          disjoint_elements = []
          distinct_elements = []

          # The first SegmentUse is used to represent the structure that must
          # be shared by the others: number of elements and type of elements
          element_uses = instructions.head.segment_use.definition.element_uses

          # Iterate over each element across all SegmentUses (think columns)
          #   NM1*[IL]*[  ]*..*..*..*..*..*[  ]*..*..*{..}*..
          #   NM1*[40]*[  ]*..*..*..*..*..*[  ]*..*..*{..}*..
          element_uses.length.times do |n|
            if element_uses.at(n).composite?
              ms = 0 .. element_uses.at(n).definition.component_uses.length - 1
            else
              ms = [nil]
            end

            # If this is a composite element, we iterate over each component.
            # Otherwise this loop iterates once with the index {m} set to nil.
            ms.each do |m|
              last  = nil        # the last subset we examined
              total = Sets.empty # the union of all examined subsets

              distinct = false
              disjoint = true

              instructions.each do |i|
                element_use = i.segment_use.definition.element_uses.at(n)

                unless m.nil?
                  element_use = element_use.definition.component_uses.at(m)
                end

                allowed_vals = element_use.allowed_values

                # We want to know if every instruction's set of allowed values
                # is disjoint (with one another). Instead of comparing each set
                # with every other set, which takes (N-1)! comparisons, we can
                # do it in N steps.
                disjoint &&= allowed_vals.disjoint?(total)

                # We also want to know if one instruction's set of allowed vals
                # contains elements that aren't present in at least one other
                # set. The opposite condition is easy to test: all sets contain
                # the same elements (are equal). So we can similarly, check this
                # condition in N steps rather than (N-1)!
                distinct ||= allowed_vals != last unless last.nil?

                total = allowed_vals.union(total)
                last  = allowed_vals
              end

            # puts "#{n}.#{m}: disjoint(#{disjoint}) distinct(#{distinct})"

              if disjoint
                # Since each instruction's set of allowed values is disjoint, we
                # can build a function/hash that returns the single instruction,
                # given one of the values. When given a value outside the set of
                # all (combined) values, it returns nil.
                disjoint_elements << [[n, m], build_disjoint(total, n, m, instructions)]
              elsif distinct
                # Not all instructions have the same set of allowed values. So
                # we can build a function/hash that accepts one of the values
                # and returns the subset of the instructions where that value
                # can occur. This might be some, none, or all of the original
                # instructions, so clearly this provides less information than
                # if each allowed value set was disjoint.

                # Currently disabled (and untested) because it doesn't look like
                # any of the HIPAA schemas would use this -- so testing it would
                # be a pain.
                #
                distinct_elements << [[n, m], build_distinct(total, n, m, instructions)]
              end
            end
          end

          [disjoint_elements, distinct_elements]
        end

        # @return [Hash<String, Array<Instruction>>]
        def build_disjoint(total, n, m, instructions)
          if total.finite?
            # The sum of all allowed value sets is finite, so we know that each
            # individual allowed value set is finite (we can iterate over it).
            map = Hash.new

            instructions.each do |i|
              element_use = i.segment_use.definition.element_uses.at(n)

              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values
              allowed_vals.each{|v| map[v] = i.cons }
            end

            map
          else
            # At least one of allowed value sets is infinite. This happens when
            # it is RelativeComplement, which declares the values that are *not*
            # allowed in the set.
            map = Hash.new{|h,k| h[k] = instructions }

            instructions.each do |i|
              element_use = i.segment_use.definition.element_uses.at(n)
              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values

              unless allowed_vals.finite?
                allowed_vals.complement.each{|v| map[v] -= i }
              end
            end

            # Clear the default_proc so accesses don't change the Hash
            map.default = instructions
            map
          end
        end

        # @return [Hash<String, Array<Instruction>>]
        def build_distinct(total, n, m, instructions)
          if total.finite?
            # The sum of all allowed value sets is finite, so we know that each
            # individual allowed value set is finite (we can iterate over it).
            map = Hash.new{|h,k| h[k] = [] }

            instructions.each do |i|
              element_use  = i.segment_use.definition.element_uses.at(n)

              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values
              allowed_vals.each{|v| map[v] << i }
            end

            # Clear the default_proc so accesses don't change the Hash
            map.default = []
            map
          else
            # At least one of allowed value sets is infinite. This happens when
            # it is RelativeComplement, which declares the values that are *not*
            # allowed in the set.
            map = Hash.new{|h,k| h[k] = instructions }

            instructions.each do |i|
              element_use  = i.segment_use.definition.element_uses.at(n)

              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values

              unless allowed_vals.finite?
                allowed_vals.complement.each{|v| map[v] -= i }
              end
            end

            # Clear the default_proc so accesses don't change the Hash
            map.default = instructions
            map
          end
        end

        def unique_match(segment_tok, strict)
          # Were any uniquely distinguishing elements present in the input?
          present = false

          @__basis ||= basis(shallowest(@instructions))
          @__basis.first.each do |(n, m), map|
            element_tok = segment_tok.element_toks.at(n)
            next unless element_tok

            designator = strict ?
              "#{segment_tok.id}#{'%02d' % (n + 1)}" : nil

            present_, answer  =
              if element_tok.repeated?
                unique_repeated(element_tok, m, map, designator)
              else
                unique_singular(deconstruct(element_tok, m), map, designator)
              end

            present ||= present_
            return present, answer if answer
          end

          return present, nil
        end

        def narrow_search(segment_tok, present, strict)
          # If we reach this line, none of the present elements could, on its
          # own, narrow the search space to a single Instruction. We now test
          # the combination of elements to iteratively narrow the search space
          space = @instructions

          present_ok = present # were any distinguishing elements present?
          present_xx = true    # were all distinguishing elements invalid (if present)?

          @__basis ||= basis(shallowest(@instructions))
          @__basis.last.each do |(n, m), map|
            element_tok = segment_tok.element_toks.at(n)
            next unless element_tok

            designator = "#{segment_tok.id}#{'%02d' % n}"

            presentok_, presentxx_, space =
              if element_tok.repeated?
                # TODO: This only implements :superset, which means we're searching
                # for any instructions that match *all* given element occurences
                narrow_repeated_superset(element_tok, m, map, designator, space)
              else
                narrow_singular(element_tok, m, map, designator, space)
              end

            present_ok ||= presentok_
            present_xx &&= presentxx_
            return space if space.size <= 1
          end

          if present_ok and present_xx
            # The segment token *did* have values for distinguishing element
            # locations, but every one of them was an invalid value. Instead
            # of returning all of @instructions, we'll give up on this one.
            []
          else
            # We can still return the entire @instructions space if the segment
            # token just didn't have values in the interesting locations. These
            # instructions will at least be narrowed down by segment ID, but we
            # still risk an explosion of states.
            space
          end
        end

        def unique_singular(value, map, designator)
          present = false
          answer  = nil

          case value
          when nil, :not_used, :default
            # ignore
          else
            present = true
            answer  = map.at(value)

            if designator and answer.blank?
              designator << "-%02d" % m unless m.nil?
              raise ArgumentError,
                "#{value.inspect} is not allowed in #{designator}"
            end
          end

          return present, answer
        end

        def narrow_singular(element_tok, m, map, designator, space)
          present_ok = false
          present_xx = true
          value      = deconstruct(element_tok, m)

          case value
          when nil, :not_used, :default
            # ignore
          else
            subset     = map.at(value)
            present_ok = true

            unless subset.blank?
              present_xx = false
              space     &= subset
            else
              # We could immediately narrow the search space to the empty
              # set since *no* instructions can match this invalid value.
              # Instead we take the view that invalid input simply doesn't
              # provide useful information for our search and continue on
              # with the same search space we had.

              if designator
                designator << "-%02d" % m unless m.nil?
                raise ArgumentError,
                  "#{value.inspect} is not allowed in #{designator}"
              end
            end
          end

          return present_ok, present_xx, space
        end

        def unique_repeated(element_tok, m, map, designator)
          present = false

          # TODO: This only implements :superset, which means we're searching
          # for single instruction that matches *all* given element occurrences
          #
          # Futhermore, this branch is can ONLY be taken when different
          # instructions have entirely disjoint sets of allowed values. That
          # implies as long as we're not given a contradictory set of values,
          # the first occurrence would immediately narrow the list to one answer.

          space = @instructions
          given = []

          element_tok.element_toks.each do |occurrence_tok|
            value = deconstruct(occurrence_tok, m)

            case value
            when nil, :not_used, :default
              # ignore
            else
              present = true
              answer  = map.at(value)

              unless answer.nil?
                given << value
                space &= answer
              else
                if designator
                  designator << "-%02d" % m unless m.nil?
                  raise ArgumentError,
                    "#{value.inspect} is not allowed in #{designator}"
                end
              end

              if space.empty? and designator
                designator << "-%02d" % m unless m.nil?
                raise ArgumentError,
                  "#{given.uniq.join(", ")} are mutually exclusive in #{designator}"
              end

              break if space.empty?
            end
          end

          # For :superset, we had to iterate each and every given element
          # to make sure it's (a) value and (b) not mutually exclusive to
          # the other elements in the list. No early exit except on fail.
          return present, space if space.size == 1
        end

        def narrow_repeated_superset(element_tok, m, map, designator, space)
          given      = []
          present_ok = false
          present_xx = true

          # Extract the m'th component from each occurrence (or get the
          # whole value of the occurrence for non-composite elements)
          element_tok.element_toks.each do |occurrence_tok|
            value = deconstruct(occurrence_tok, m)

            case value
            when nil, :not_used, :default
              # ignore
            else
              present_ok = true
              subset     = map.at(value)

              unless answer.nil?
                present_xx = false
                given     << value
                space     &= subset
              else
                # We could immediately narrow the search space to the empty
                # set since *no* instructions can match this invalid value.
                # Instead we take the view that invalid input simply doesn't
                # provide useful information for our search and continue on
                # with the same search space we had.

                if designator
                  designator << "-%02d" % m unless m.nil?
                  raise ArgumentError,
                    "#{value.inspect} is not allowed in #{designator}"
                end
              end

              break if space.empty?
            end
          end

          if space.empty? and present_ok and designator
            designator << "-%02d" % m unless m.nil?
            raise ArgumentError,
              "#{given.uniq.join(", ")} are mutually exclusive in #{designator}"
          end

          return present_ok, present_xx, space
        end

        # Return the value of the `m`-th element, and if `n` is not nil, return
        # the value of the `n`-th component from the `n`-th element. When the
        # value is blank, the function returns `nil`.
        #
        # @param [Array<Reader::SimpleElementTok, Reader::CompositeElementTok>] element_toks
        # @param [Integer] m
        # @param [Integer, nil] n
        #
        # @return [String, nil]
        def deconstruct(element_tok, m)
          return nil if element_tok.blank?
          element_tok = element_tok.component_toks.at(m) unless m.nil?

          return nil if element_tok.blank?
          element_tok.value
        end

      end

    end

    class << ConstraintTable
      # @group Constructors
      #########################################################################

      # Given a list of {Instruction} values for the same segment identifier,
      # this method constructs the appropriate concrete subclass of
      # {ConstraintTable}.
      #
      # @param [Array<Instruction>] instructions
      # @return [ConstraintTable]
      def build(instructions)
        if instructions.length <= 1
          ConstraintTable::Stub.new(instructions)
        elsif instructions.any?{|i| i.segment_use.nil? } and
          not instructions.all?{|i| i.segment_use.nil? }
          # When one of the instructions has a nil segment_use, it means
          # the SegmentUse is determined when pushing the new state. There
          # isn't a way to know the segment constraints from here.
          ConstraintTable::Stub.new(instructions)
        else
          segment_uses = instructions.map{|i| i.segment_use }

          if segment_uses.map{|u| u.object_id }.uniq.length <= 1
            # The same SegmentUse may appear more than once, because the
            # segment can be placed at different levels in the tree. If
            # all the instructions have the same SegmentUse, they also have
            # the same element constraints so we can't use them to narrow
            # down the instruction list.
            instructions.head.segment_id == :ISA ?
              ConstraintTable::Deepest.new(instructions) :
              ConstraintTable::Shallowest.new(instructions)
          else
            ConstraintTable::ValueBased.new(instructions)
          end
        end
      end

      # @endgroup
      #########################################################################
    end

  end
end
