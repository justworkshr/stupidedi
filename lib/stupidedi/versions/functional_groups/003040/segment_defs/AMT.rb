# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AMT = s::SegmentDef.build(:AMT, "Monetary Amount",
            "To indicate the total monetary amount",
            e::E522 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end
