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
              s::DTP.use(400, r::Optional,  d::RepeatCount.unbounded),
              s::QTY.use(600, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("1000A", d::RepeatCount.bounded(1),
                s::N1.use(700, r::Mandatory, d::RepeatCount.bounded(1))),
              d::LoopDef.build("1000B", d::RepeatCount.bounded(1),
                s::N1.use(700, r::Mandatory, d::RepeatCount.bounded(1))),
              d::LoopDef.build("1000A", d::RepeatCount.bounded(1),
                s::N1.use(700, r::Optional, d::RepeatCount.bounded(1)))),

            d::TableDef.header("Table 2 - Detail",
              d::LoopDef.build("2000", d::RepeatCount.bounded(1),
                s::INS.use(100, r::Mandatory, d::RepeatCount.bounded(1)))))

        end
      end
    end
  end
end
