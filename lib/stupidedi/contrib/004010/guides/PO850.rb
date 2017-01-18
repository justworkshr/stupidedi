# frozen_string_literal: true

module Stupidedi
  module Contrib
    module FortyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FortyTen::SegmentDefs
        t = Contrib::FortyTen::TransactionSetDefs

        #
        # Purchase Order
        #
        PO850 = b.build(t::PO850,
          d::TableDef.header("Heading",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("850")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::BEG, "Beginning Segment for Purchase Order",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00")),
              b::Element(e::Required,    "Purchase Order Type Code", b::Values("NE")),
              b::Element(e::Required,    "Purchase Order Number"),
              b::Element(e::Situational, "Release Number"),
              b::Element(e::Required,    "Date")),
            b::Segment(40, s::CUR, "Currency",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Entity Identifier Code", b::Values("BT","BY","CN","SH","SF","ST"),
              b::Element(e::Required,    "Currency Code")),
            b::Segment(50, s::REF, "Reference Identification",
              r::Situational, d::RepeatCount.unbounded,
              b::Element(e::Required,    "Reference Identification Qualifier", b::Values("ZZ", "OS")),
              b::Element(e::Situational, "Reference Identification")),
            b::Segment(60, s::PER, "Administrative Communications Contact",
              r::Situational, d::RepeatCount.bounded(3),
              b::Element(e::Required,    "Contact Function Code", b::Values("BD")),
              b::Element(e::Situational, "Name"),
              b::Element(e::Situational, "Communication Number Qualifier", b::Values("TE")),
              b::Element(e::Situational, "Communication Number")),
            b::Segment(150, s::DTM, "Date/Time Reference",
              r::Situational, d::RepeatCount.bounded(10),
              b::Element(e::Required,    "Date/Time Qualifier", b::Values("002")),
              b::Element(e::Situational, "Date")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment(310, s:: N1, "Name",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("SF", "ST")),
                b::Element(e::Required,    "Name"),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("91")),
                b::Element(e::Situational, "Identification Code")),
              b::Segment(330, s:: N3, "Address Information",
                r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Address Information"),
                b::Element(e::Situational, "Address Information")),
              b::Segment(340, s:: N4, "Geographic Location",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Situational, "City Name"),
                b::Element(e::Situational, "State or Province Code"),
                b::Element(e::Situational, "Postal Code"),
                b::Element(e::Situational, "Country Code")),
              b::Segment(350, s::REF, "Reference Identification",
                r::Situational, d::RepeatCount.bounded(12),
                b::Element(e::Required,    "Reference Identification Qualifier", b::Values("DP")),
                b::Element(e::Situational, "Reference Identification")))),

          d::TableDef.header("Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(100000),
              b::Segment(10, s::PO1, "Baseline Item Data",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "Assigned Identification"),
                b::Element(e::Situational, "Quantity Ordered"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code", b::Values("CA", "EA", "LB")),
                b::Element(e::Situational, "Unit Price"),
                b::Element(e::Situational, "Basis of Unit Price Code", b::values("PE","PP","UM")),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("VN", "VC")),
                b::Element(e::Situational, "Product/Service ID"))),
            d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
              b::Segment(50, s::PID, "Product/Item Description",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Item Description Type", b::Values("F")),
                b::Element(e::Situational, "Product/Process Characteristic Code"),
                b::Element(e::Situational, "Agency Qualifier Code"),
                b::Element(e::Situational, "Product Description Code"),
                b::Element(e::Situational, "Description"))),
            d::LoopDef.build("SCH", d::RepeatCount.bounded(200),
              b::Segment(295, s::SCH, "Line Item Schedule",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Numeric value ofquantiy"),
                b::Element(e::Required, "Unit or Basis for Measurement Code", b::Values("DZ", "EA", "FT", "RL")),
                b::Element(e::Situational, "Date/Time Qualifer"),
                b::Element(e::Situational, "Date"),
                b::Element(e::Situational, "Date/Time Qualifer"),
                b::Element(e::Situational, "Date"))),
            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment(350, s:: N1, "Name",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("SF", "ST")),
                b::Element(e::Required,    "Name"),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("91")),
                b::Element(e::Situational, "Identification Code")),
              b::Segment(370, s:: N3, "Address Information",
                r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Address Information"),
                b::Element(e::Situational, "Address Information")),
              b::Segment(380, s:: N4, "Geographic Location",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "City Name"),
                b::Element(e::Situational, "State or Province Code"),
                b::Element(e::Situational, "Postal Code"),
                b::Element(e::Situational, "Country Code")))),

          d::TableDef.header("Summary",
            d::LoopDef.build("CTT", d::RepeatCount.bounded(1),
              b::Segment(10, s::CTT, "Transaction Totals",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Number of Line Items"),
                b::Element(e::Situational, "Hash Total"))),
            b::Segment(30, s:: SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number")))))

      end
    end
  end
end
