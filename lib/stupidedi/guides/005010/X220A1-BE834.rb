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
              b::Element(e::NotUsed,     "Free-form Information")),

            d::LoopDef.build("1000A",
              d::RepeatCount.bounded(1),
              b::Segment(700, s::N1, "Sponsor Name",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("P5")),
                b::Element(e::Situational, "Name", b::MaxLength(60)),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("24", "FI")),
                b::Element(e::Situational, "Identification Code", b::MaxLength(80)),
                b::Element(e::NotUsed,     "Entity Identifier Code"),
                b::Element(e::NotUsed,     "Entity Relationship Code"))),

            d::LoopDef.build("1000B",
              d::RepeatCount.bounded(1),
              b::Segment(700, s::N1, "Payer",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("IN")),
                b::Element(e::Situational, "Name", b::MaxLength(60)),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("XV", "FI")),
                b::Element(e::Situational, "Identification Code", b::MaxLength(80)),
                b::Element(e::NotUsed,     "Entity Identifier Code"),
                b::Element(e::NotUsed,     "Entity Relationship Code")))),

          d::TableDef.header("Table 2 - Detail",
            d::LoopDef.build("1000C",
              d::RepeatCount.bounded(1),
              b::Segment(700, s::N1, "TPA/Broker Name",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("BO", "TV")),
                b::Element(e::Situational, "Name", b::MaxLength(60)),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("XV", "FI")),
                b::Element(e::Situational, "Identification Code", b::MaxLength(80)),
                b::Element(e::NotUsed,     "Entity Identifier Code"),
                b::Element(e::NotUsed,     "Entity Relationship Code"))),

            d::LoopDef.build("2000",
              d::RepeatCount.bounded(1),
              b::Segment(100, s::INS, "Member Level Detail",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Yes/No Condition or Reponse Code", b::Values("Y", "N")),
                b::Element(e::Required,    "Individual Relationship Code", b::Values("01","03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "23", "24", "25", "26", "31", "38", "53", "60", "D2", "G8", "G9")),
                b::Element(e::Required,    "Maintenance Type Code", b::Values("001", "021", "024", "025", "030")),
                b::Element(e::Situational, "Maintenance Reason Code", b::Values("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "14", "15", "16", "17", "18", "20", "21", "22", "25", "26", "27", "28", "29", "31", "32", "33", "37", "38", "39", "40", "41", "43", "59", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AL", "EC", "XN", "XT")),
                b::Element(e::Situational, "Benefit Status Code", b::Values("A", "C", "S", "T")),
                b::Element(e::Situational, "Medicare Status Code"),
                b::Element(e::Situational, "Consolidated Omnibus Budget Reconciliation Act (COBRA) Qualifying Event Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "ZZ")),
                b::Element(e::Situational, "Employment Status Code", b::Values("AC", "AO", "AU", "FT", "L1", "PT", "RT", "TE")),
                b::Element(e::Situational, "Student Status Code", b::Values("F", "N", "P")),
                b::Element(e::Situational, "Yes/No Condition or Response Code", b::Values("Y", "N")),
                b::Element(e::Situational, "Date Time Period Qualifier", b::Values("D8")),
                b::Element(e::Situational, "Date Time Period", b::MaxLength(35)),
                b::Element(e::Situational, "Confidentiality Code", b::Values("R", "U")),
                b::Element(e::Situational, "City Name", b::MaxLength(30)),
                b::Element(e::Situational, "State or Province Code", b::MaxLength(2)),
                b::Element(e::Situational, "Country Code", b::MaxLength(3)),
                b::Element(e::Situational, "Number", b::MaxLength(9))))))

      end
    end
  end
end
