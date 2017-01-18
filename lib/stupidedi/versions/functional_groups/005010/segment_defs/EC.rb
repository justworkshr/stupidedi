# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          EC = s::SegmentDef.build(:EC, "Health Coverage",
            "To provide information on health coverage",
            e::E1176.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E1176.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E1176.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E954 .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E1201.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E1149.simple_use(r::Optional, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

