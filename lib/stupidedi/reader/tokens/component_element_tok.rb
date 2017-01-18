# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader

    class ComponentElementTok
      include Inspect

      # @return [String]
      attr_reader :value

      # @return [Position]
      attr_reader :position

      # @return [Position]
      attr_reader :remainder

      def initialize(value, position, remainder)
        @value, @position, @remainder =
          value, position, remainder
      end

      def pretty_print(q)
        q.pp(:component.cons(@value.cons))
      end

      def blank?
        @value.blank?
      end

      def present?
        not blank?
      end

      def simple?
        true
      end

      def composite?
        false
      end
    end

    class << ComponentElementTok
      # @group Constructors
      #########################################################################

      # @return [ComponentElementTok]
      def build(value, position, remainder)
        new(value, position, remainder)
      end

      # @endgroup
      #########################################################################
    end

  end
end
