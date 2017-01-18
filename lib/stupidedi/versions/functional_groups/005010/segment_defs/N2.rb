# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N2 = s::SegmentDef.build(:N2, "Additional Name Information",
            "To specify additional names",
            e::E93  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E93  .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end
