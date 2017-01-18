# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          REF = s::SegmentDef.build(:REF, "Reference Identification",
            "To specify identifying information",
            e::E128 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C040 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(2, 3))

        end
      end
    end
  end
end
