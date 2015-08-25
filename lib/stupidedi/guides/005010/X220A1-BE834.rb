module Stupidedi
  module Guides
    module FiftyTen
      module X220A1
        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FiftyTen::SegmentDefs
        t = Versions::FunctionalGroups::FiftyTen::TransactionSetDefs

        BE834 = b.build(t::BE834,
          d::TableDef.header("Table 1 - Header",
            b::Segment(100, s::ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("834")),
              b::Element(e::Required,    "Transaction Set Control Number"),
              b::Element(e::Required,     "Implementation Guide Version Name")),
            b::Segment(200, s::BGN, "Beginning Segment",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00", "15", "22")),
              b::Element(e::Situational, "Reference Identification", b::MaxLength(50)),
              b::Element(e::Required,    "Date"),
              b::Element(e::Situational, "Time"),
              b::Element(e::Situational, "Time Code", b::Values("AD", "AS", "AT", "CD", "CS", "CT", "ED", "ES", "ET", "GM", "HD", "HS", "HT", "MD", "MS", "PD", "PS", "PT", "UT")),
              b::Element(e::Situational, "Reference Identification", b::MaxLength(50)),
              b::Element(e::Situational, "Transaction Type Code"),
              b::Element(e::Situational, "Action Code", b::Values("2", "4", "RX"))),
            b::Segment(300, s::REF, "Receiver Identification",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reference Identification Qualifier", b::Values("38")),
              b::Element(e::Required,    "Receiver Identifier"),
              b::Element(e::NotUsed,     "Description"),
              b::Element(e::NotUsed,     "REFERENCE IDENTIFIER")),
            b::Segment(400, s::DTP, "File Effective Date",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Date/Time Qualifier", b::Values("007")),
              b::Element(e::Required,    "Date Time Period Format Qualifier", b::Values("D8")),
              b::Element(e::Required,    "Date Time Period")),
            b::Segment(600, s::QTY, "Transaction Set Control Totals",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Quantity Qualifier", b::Values("DT", "ET", "TO")),
              b::Element(e::Required,    "Quantity", b::MaxLength(15)),
              b::Element(e::NotUsed,     "Composite Unit of Measure"),
              b::Element(e::NotUsed,     "Free-form Information"))))

      end
    end
  end
end
