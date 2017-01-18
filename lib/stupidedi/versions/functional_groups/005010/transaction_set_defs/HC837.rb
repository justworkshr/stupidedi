# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          HC837 = d::TransactionSetDef.build("HC", "837",
            "Health Care Claim",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use( 50, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BHT.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::REF.use(150, r::Optional,  d::RepeatCount.bounded(3)),

              d::LoopDef.build("1000", d::RepeatCount.bounded(10),
                s::NM1.use(200, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N2.use(250, r::Optional,  d::RepeatCount.bounded(2)),
                s:: N3.use(300, r::Optional,  d::RepeatCount.bounded(2)),
                s:: N4.use(350, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(400, r::Optional,  d::RepeatCount.bounded(2)),
                s::PER.use(450, r::Optional,  d::RepeatCount.bounded(2)))),

            d::TableDef.detail("Table 2 - Detail",
              d::LoopDef.build("2000", d::RepeatCount.unbounded,
                s:: HL.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
                s::PRV.use( 30, r::Optional,  d::RepeatCount.bounded(1)),
                s::SBR.use( 50, r::Optional,  d::RepeatCount.bounded(1)),
                s::PAT.use( 70, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTP.use( 90, r::Optional,  d::RepeatCount.bounded(5)),
                s::CUR.use(100, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("2010", d::RepeatCount.bounded(10),
                  s::NM1.use(150, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N2.use(200, r::Optional,  d::RepeatCount.bounded(2)),
                  s:: N3.use(250, r::Optional,  d::RepeatCount.bounded(2)),
                  s:: N4.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DMG.use(320, r::Optional,  d::RepeatCount.bounded(1)),
                  s::REF.use(350, r::Optional,  d::RepeatCount.bounded(20)),
                  s::PER.use(400, r::Optional,  d::RepeatCount.bounded(2))),

                d::LoopDef.build("2300", d::RepeatCount.bounded(100),
                  s::CLM.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTP.use(1350, r::Optional,  d::RepeatCount.bounded(150)),
                  s::CL1.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DN1.use(1450, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DN2.use(1500, r::Optional,  d::RepeatCount.bounded(35)),
                  s::PWK.use(1550, r::Optional,  d::RepeatCount.bounded(10)),
                  s::CN1.use(1600, r::Optional,  d::RepeatCount.bounded(1)),
                # s::DSB.use(1650, r::Optional,  d::RepeatCount.bounded(1)),
                # s:: UR.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                  s::AMT.use(1750, r::Optional,  d::RepeatCount.bounded(40)),
                  s::REF.use(1800, r::Optional,  d::RepeatCount.bounded(30)),
                  s:: K3.use(1850, r::Optional,  d::RepeatCount.bounded(10)),
                  s::NTE.use(1900, r::Optional,  d::RepeatCount.bounded(20)),
                  s::CR1.use(1950, r::Optional,  d::RepeatCount.bounded(1)),
                  s::CR2.use(2000, r::Optional,  d::RepeatCount.bounded(1)),
                  s::CR3.use(2050, r::Optional,  d::RepeatCount.bounded(1)),
                # s::CR4.use(2100, r::Optional,  d::RepeatCount.bounded(3)),
                # s::CR5.use(2150, r::Optional,  d::RepeatCount.bounded(1)),
                # s::CR6.use(2160, r::Optional,  d::RepeatCount.bounded(1)),
                # s::CR8.use(2190, r::Optional,  d::RepeatCount.bounded(9)),
                  s::CRC.use(2200, r::Optional,  d::RepeatCount.bounded(100)),
                  s:: HI.use(2310, r::Optional,  d::RepeatCount.bounded(25)),
                  s::QTY.use(2400, r::Optional,  d::RepeatCount.bounded(10)),
                  s::HCP.use(2410, r::Optional,  d::RepeatCount.bounded(1)),

                # d::LoopDef.build("2305", d::RepeatCount.bounded(6),
                #   s::CR7.use(2420, r::Optional,  d::RepeatCount.bounded(1)),
                #   s::HSD.use(2430, r::Optional,  d::RepeatCount.bounded(12))),

                  d::LoopDef.build("2310", d::RepeatCount.bounded(9),
                    s::NM1.use(2500, r::Optional,  d::RepeatCount.bounded(1)),
                    s::PRV.use(2550, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N2.use(2600, r::Optional,  d::RepeatCount.bounded(2)),
                    s:: N3.use(2650, r::Optional,  d::RepeatCount.bounded(2)),
                    s:: N4.use(2700, r::Optional,  d::RepeatCount.bounded(1)),
                    s::REF.use(2710, r::Optional,  d::RepeatCount.bounded(20)),
                    s::PER.use(2750, r::Optional,  d::RepeatCount.bounded(2))),

                  d::LoopDef.build("2320", d::RepeatCount.bounded(10),
                    s::SBR.use(2900, r::Optional,  d::RepeatCount.bounded(1)),
                    s::CAS.use(2950, r::Optional,  d::RepeatCount.bounded(1)),
                    s::AMT.use(3000, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DMG.use(3050, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: OI.use(3100, r::Optional,  d::RepeatCount.bounded(1)),
                    s::MIA.use(3150, r::Optional,  d::RepeatCount.bounded(1)),
                    s::MOA.use(3200, r::Optional,  d::RepeatCount.bounded(1)),

                    d::LoopDef.build("2330", d::RepeatCount.bounded(10),
                      s::NM1.use(3250, r::Optional,  d::RepeatCount.bounded(1)),
                      s:: N2.use(3300, r::Optional,  d::RepeatCount.bounded(2)),
                      s:: N3.use(3320, r::Optional,  d::RepeatCount.bounded(2)),
                      s:: N4.use(3400, r::Optional,  d::RepeatCount.bounded(1)),
                      s::PER.use(3450, r::Optional,  d::RepeatCount.bounded(2)),
                      s::DTP.use(3500, r::Optional,  d::RepeatCount.bounded(9)),
                      s::REF.use(3550, r::Optional,  d::RepeatCount.unbounded))),

                  d::LoopDef.build("2400", d::RepeatCount.unbounded,
                    s:: LX.use(3650, r::Optional,  d::RepeatCount.bounded(1)),
                    s::SV1.use(3700, r::Optional,  d::RepeatCount.bounded(1)),
                    s::SV2.use(3750, r::Optional,  d::RepeatCount.bounded(1)),
                    s::SV3.use(3800, r::Optional,  d::RepeatCount.bounded(1)),
                    s::TOO.use(3820, r::Optional,  d::RepeatCount.bounded(32)),
                  # s::SV4.use(3850, r::Optional,  d::RepeatCount.bounded(1)),
                    s::SV5.use(4000, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::SV6.use(4050, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::SV7.use(4100, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: HI.use(4150, r::Optional,  d::RepeatCount.bounded(25)),
                    s::PWK.use(4200, r::Optional,  d::RepeatCount.bounded(10)),
                    s::CR1.use(4250, r::Optional,  d::RepeatCount.bounded(1)),
                    s::CR2.use(4300, r::Optional,  d::RepeatCount.bounded(5)),
                    s::CR3.use(4350, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::CR4.use(4400, r::Optional,  d::RepeatCount.bounded(3)),
                  # s::CR5.use(4450, r::Optional,  d::RepeatCount.bounded(1)),
                    s::CRC.use(4500, r::Optional,  d::RepeatCount.bounded(3)),
                    s::DTP.use(4550, r::Optional,  d::RepeatCount.bounded(15)),
                    s::QTY.use(4600, r::Optional,  d::RepeatCount.bounded(5)),
                    s::MEA.use(4620, r::Optional,  d::RepeatCount.bounded(20)),
                    s::CN1.use(4650, r::Optional,  d::RepeatCount.bounded(1)),
                    s::REF.use(4700, r::Optional,  d::RepeatCount.bounded(30)),
                    s::AMT.use(4750, r::Optional,  d::RepeatCount.bounded(15)),
                    s:: K3.use(4800, r::Optional,  d::RepeatCount.bounded(10)),
                    s::NTE.use(4850, r::Optional,  d::RepeatCount.bounded(10)),
                    s::PS1.use(4880, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::IMM.use(4900, r::Optional,  d::RepeatCount.unbounded),
                  # s::HSD.use(4910, r::Optional,  d::RepeatCount.bounded(1)),
                    s::HCP.use(4920, r::Optional,  d::RepeatCount.bounded(1)),

                    d::LoopDef.build("2410", d::RepeatCount.unbounded,
                      s::LIN.use(4930, r::Optional,  d::RepeatCount.bounded(1)),
                      s::CTP.use(4940, r::Optional,  d::RepeatCount.bounded(1)),
                      s::REF.use(4950, r::Optional,  d::RepeatCount.bounded(1))),

                    d::LoopDef.build("2420", d::RepeatCount.bounded(10),
                      s::NM1.use(5000, r::Optional,  d::RepeatCount.bounded(1)),
                      s::PRV.use(5050, r::Optional,  d::RepeatCount.bounded(1)),
                      s:: N2.use(5100, r::Optional,  d::RepeatCount.bounded(2)),
                      s:: N3.use(5140, r::Optional,  d::RepeatCount.bounded(2)),
                      s:: N4.use(5200, r::Optional,  d::RepeatCount.bounded(1)),
                      s::REF.use(5250, r::Optional,  d::RepeatCount.bounded(20)),
                      s::PER.use(5300, r::Optional,  d::RepeatCount.bounded(2))),

                    d::LoopDef.build("2430", d::RepeatCount.unbounded,
                      s::SVD.use(5400, r::Optional,  d::RepeatCount.bounded(1)),
                      s::CAS.use(5450, r::Optional,  d::RepeatCount.bounded(99)),
                      s::DTP.use(5500, r::Optional,  d::RepeatCount.bounded(9)),
                      s::AMT.use(5505, r::Optional,  d::RepeatCount.bounded(20))),

                    d::LoopDef.build("2440", d::RepeatCount.unbounded,
                      s:: LQ.use(5510, r::Optional,  d::RepeatCount.bounded(1)),
                      s::FRM.use(5520, r::Mandatory, d::RepeatCount.bounded(99)))))),

              s:: SE.use(5550, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end
