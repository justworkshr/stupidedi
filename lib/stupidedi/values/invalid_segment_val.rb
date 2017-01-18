# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Values

    class InvalidSegmentVal < AbstractVal

      # @return [String]
      attr_reader :reason

      # @return [Reader::SegmentTok]
      attr_reader :segment_tok

      def_delegators :@segment_tok, :position

      def initialize(reason, segment_tok)
        @reason, @segment_tok =
          reason, segment_tok
      end

      # @return [SegmentVal]
      def copy(changes = {})
        InvalidSegmentVal.new \
          changes.fetch(:reason, @reason),
          changes.fetch(:segment_tok, @segment_tok)
      end

      # (see AbstractVal#size)
      def size
        0
      end

      # @return [Symbol]
      def id
        @segment_tok.id
      end

      # @return true
      def leaf?
        true
      end

      def valid?
        false
      end

      # (see AbstractVal#segment?)
      # @return true
      def segment?
        true
      end

      def empty?
        true
      end

      # @return nil
      def usage
        nil
      end

      # @return [void]
      def pretty_print(q)
        id = ansi.invalid("[#{@segment_tok.id}]")
        q.text(ansi.segment("InvalidSegmentVal#{id}"))
      end

      # @return [String]
      def inspect
        ansi.invalid(@segment_tok.id.to_s)
      end

      # @return [Boolean]
      def ==(other)
        eql?(other)
      end
    end

  end
end
