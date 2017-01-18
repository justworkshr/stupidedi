# frozen_string_literal: true

module Stupidedi
  module Contrib
    module ThirtyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::ThirtyTen::SegmentDefs
        t = Contrib::ThirtyTen::TransactionSetDefs
        #
        # 830 Planning Schedule with Release Capability
        #
        PS830 = b.build(t::PS830,
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("830")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::BFR, "Beginning Segment for Planning Schedule",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00")),
              b::Element(e::Situational,  "Reference Number NNA Release Period"),
              b::Element(e::Situational,  "Release Number"),
              b::Element(e::Required,    "Schedule Type Qualifier", b::Values("SH")),
              b::Element(e::Required,    "Schedule Quantity Qualifier", b::Values("A")),
              b::Element(e::Required,    "Date - Forecast Start Date"),
              b::Element(e::Required,    "Date - Horizon End Date"),
              b::Element(e::Required,    "Date - Release Issue Date"),
              b::Element(e::Required,    "Date"),
              b::Element(e::Situational,  "Purchase Order Number"))

            # b::Segment(30, s::NTE, "Note/Special Instruction",
            #   r::Situational, d::RepeatCount.bounded(100),
            #   b::Element(e::Situational, "Note Reference Code", b::Values("GEN","LIN")),
            #   b::Element(e::Required,  "Free Form Message"),

            d::LoopDef.build("N1 - LOOP1", d::RepeatCount.bounded(200),
              b::Segment(90, s:: N1, "Name",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("BT")),
                b::Element(e::Situational, "Name"),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("1")),
                b::Element(e::Situational,  "Identification Code")))),

          d::TableDef.header("Detail",
            d::LoopDef.build("LIN", d::RepeatCount.bounded(10000),
              b::Segment( 10, s::LIN, "Item Identification",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::NotUsed,     "LIN01"),
                b::Element(e::Required,    "Product/Service ID Qualifier - LIN02", b::Values("BP")),
                b::Element(e::Required,    "Product/Service ID"),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::NotUsed,     "LIN06"),
                b::Element(e::NotUsed,     "LIN07"),
                b::Element(e::NotUsed,     "LIN08"),
                b::Element(e::NotUsed,     "LIN09"),
                b::Element(e::NotUsed,     "LIN10"),
                b::Element(e::NotUsed,     "LIN11"),
                b::Element(e::NotUsed,     "LIN12"),
                b::Element(e::NotUsed,     "LIN13"),
                b::Element(e::NotUsed,     "LIN14"),
                b::Element(e::NotUsed,     "LIN15"),
                b::Element(e::NotUsed,     "LIN16"),
                b::Element(e::NotUsed,     "LIN17"),
                b::Element(e::NotUsed,     "LIN18"),
                b::Element(e::NotUsed,     "LIN19"),
                b::Element(e::NotUsed,     "LIN20"),
                b::Element(e::NotUsed,     "LIN21"),
                b::Element(e::NotUsed,     "LIN22"),
                b::Element(e::NotUsed,     "LIN23"),
                b::Element(e::NotUsed,     "LIN24"),
                b::Element(e::NotUsed,     "LIN25"),
                b::Element(e::NotUsed,     "LIN26"),
                b::Element(e::NotUsed,     "LIN27"),
                b::Element(e::NotUsed,     "LIN28"),
                b::Element(e::NotUsed,     "LIN29"),
                b::Element(e::NotUsed,     "LIN30"),
                b::Element(e::NotUsed,     "LIN31")),

              b::Segment( 20, s::UIT, "Unit Detail",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Unit or Basis for Measurement Code", b::Values("PC")),
                b::Element(e::Situational, "Unit Price")),

              b::Segment( 80, s::PID, "Product/Item Description",
                r::Situational, d::RepeatCount.bounded(1000),
                b::Element(e::Required,     "Item Description Type",  b::Values("F")),
                b::Element(e::Situational, "Product/Process Characteristic Code", b::Values("9B")),
                b::Element(e::NotUsed,     "PID03"),
                b::Element(e::NotUsed,     "PID04"),
                b::Element(e::Situational, "Description")),

              d::LoopDef.build("N1", d::RepeatCount.bounded(200),
                b::Segment(210, s:: N1, "Name",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Entity Identifier Code", b::Values("SF","ST")),
                  b::Element(e::Situational, "Name"),
                  b::Element(e::Situational, "Identification Code Qualifier", b::Values("92")),
                  b::Element(e::Situational,  "Identification Code"))),

              d::LoopDef.build("SDP", d::RepeatCount.bounded(100),
                b::Segment( 290, s::SDP, "Ship/Delivery Pattern",
                  r::Situational, d::RepeatCount.unbounded,
                  b::Element(e::Required,    "Ship/Delivery or Calendar Pattern Code", b::Values("Y")),
                  b::Element(e::Required,    "Ship/Delivery Pattern Time Code", b::Values("Y"))),

                b::Segment( 301, s::FST, "Forecast Schedule",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Quantity"),
                  b::Element(e::Required,    "Forecast Qualifier", b::Values("C","D")),
                  b::Element(e::Required,    "Forecast Timing Qualifier", b::Values("F")),
                  b::Element(e::Required,    "Date - Forecast Begin Date"),
                  b::Element(e::Situational, "Date - Forecast End Date"),
                  b::Element(e::NotUsed,     "FST06"),
                  b::Element(e::NotUsed,     "FST07"),
                  b::Element(e::Situational, "Reference Number Qualifier", b::Values("RE")),
                  b::Element(e::Situational, "Reference Number"))),

                d::LoopDef.build("NTE", d::RepeatCount.bounded(100),
                  b::Segment(30, s::NTE, "Note/Special Instruction",
                    r::Situational, d::RepeatCount.bounded(100),
                    b::Element(e::Situational, "Note Reference Code", b::Values("GEN","LIN")),
                    b::Element(e::Required,  "Free Form Message")),

                  b::Segment( 300, s::FST, "Forecast Schedule",
                    r::Situational, d::RepeatCount.bounded(260),
                    b::Element(e::Required,    "Quantity"),
                    b::Element(e::Required,    "Forecast Qualifier", b::Values("C","D")),
                    b::Element(e::Required,    "Forecast Timing Qualifier", b::Values("F")),
                    b::Element(e::Required,    "Date - Forecast Begin Date"),
                    b::Element(e::Situational, "Date - Forecast End Date"),
                    b::Element(e::NotUsed,     "FST06"),
                    b::Element(e::NotUsed,     "FST07"),
                    b::Element(e::Situational, "Reference Number Qualifier", b::Values("RE")),
                    b::Element(e::Situational, "Reference Number"))),

              d::LoopDef.build("SHP", d::RepeatCount.bounded(25),
                b::Segment(330, s::SHP, "Shipped/Received Information",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Situational, "Quantity Qualifier", b::Values("02")),
                  b::Element(e::Situational, "Quantity"),
                  b::Element(e::Situational, "Date/Time Qualifier", b::Values("003")),
                  b::Element(e::Situational, "Date -  Forecast Start Date"),
                  b::Element(e::Situational, "Date - Estimated Delivery/Horizon End Date")))),

          d::TableDef.header("Summary",
            b::Segment(10, s::CTT, "Transaction Totals",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Number of Line Items"),
              b::Element(e::Situational,  "Hash Total"),
              b::Element(e::NotUsed,  "CTT03"),
              b::Element(e::NotUsed,  "CTT04"),
              b::Element(e::NotUsed,  "CTT05"),
              b::Element(e::NotUsed,  "CTT06"),
              b::Element(e::NotUsed,  "CTT07")),
            b::Segment(20, s:: SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Number of Included Segments"),
              b::Element(e::Required, "Transaction Set Control Number"))))

      end
    end
  end
end
