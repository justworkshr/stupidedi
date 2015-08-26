module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          INS = s::SegmentDef.build(:INS, "Member Level Detail",
            "To provide benefit information on insured entities",
            e::E1073.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1069.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E875 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1203.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1216.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1216.simple_use(r::Optional,   s::RepeatCount.bounded(1)), # TODO: Fix to be C052 when we figure out how to pass composite values
            e::E1219.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E584 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1220.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1250.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1251.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1165.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E19  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E156 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E26  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1470.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end
