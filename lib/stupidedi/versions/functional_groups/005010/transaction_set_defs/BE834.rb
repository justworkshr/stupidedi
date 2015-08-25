module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs
          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          BE834 = d::TransactionSetDef.build("BE", "834",
            "Benefit Enrollment and Maintenance",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BGN.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              s::REF.use(300, r::Optional, d::RepeatCount.bounded(1)),
              s::TRN.use(400, r::Optional,  d::RepeatCount.bounded(1)),
              s::DTM.use(700, r::Optional,  d::RepeatCount.unbounded)))

        end
      end
    end
  end
end
