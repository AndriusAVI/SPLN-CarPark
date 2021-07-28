page 50150 "Abonement Car Registering"
{
    Editable = true;
    PageType = List;
    SourceTable = "Posted Park Header";
    SourceTableView = WHERE("Customer Type" = FILTER(Abonement),
                            Invalid = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Employee No."; "Employee No.")
                {
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                }
                field("Customer Type"; "Customer Type")
                {
                    Editable = false;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
                {
                    Editable = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = false;
                }
                field(Address; Address)
                {
                    Editable = false;
                }
                field("Post Code"; "Post Code")
                {
                    Editable = false;
                }
                field(City; City)
                {
                    Editable = false;
                }
            }
            part("Parked Cars"; "Park Order Subform")
            {
                SubPageLink = "Park Order No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part(Control14; "Free Spaces")
            {
            }
            part(Control16; "Parking Time")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Park End")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ParkLineRec: Record "Park Line";
                    ParkLinePage: Page "Park Order Subform";
                begin
                    CurrPage."Parked Cars".PAGE.GetRecord(ParkLineRec);
                    PostedParkLineRec.SetFilter("Park Order No.", ParkLineRec."Park Order No.");
                    if PostedParkLineRec.Find('-') then begin
                        repeat
                            LineNo := PostedParkLineRec."Line No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until PostedParkLineRec.Next = 0;
                    end;
                    MaxAmt := MaxAmt + 1;

                    PostedParkLineRec.Init;
                    PostedParkLineRec."Park Order No." := ParkLineRec."Park Order No.";
                    PostedParkLineRec."Line No." := MaxAmt;
                    PostedParkLineRec."Customer No." := ParkLineRec."Customer No.";
                    PostedParkLineRec."Vehicle No." := ParkLineRec."Vehicle No.";
                    PostedParkLineRec."Park City" := ParkLineRec."Park City";
                    PostedParkLineRec."Park Location" := ParkLineRec."Park Location";
                    PostedParkLineRec."Park Location Address" := ParkLineRec."Park Location Address";
                    PostedParkLineRec."Parking Date" := ParkLineRec."Parking Date";
                    PostedParkLineRec."Parking End Date" := CurrentDateTime;
                    PostedParkLineRec.Price := 0;

                    Durationn := PostedParkLineRec."Parking End Date" - PostedParkLineRec."Parking Date";
                    Clear(ParkingTicket);

                    ParkingTicket.SetTableView(PostedParkLineRec);
                    ParkingTicket.RunModal;

                    PostedParkLineRec.Insert;


                    ParkLineRec.Delete;
                end;
            }
        }
    }

    var
        ParkLineRec: Record "Park Line";
        PostedParkLineRec: Record "Posted Park Line";
        LineNo: Integer;
        MaxAmt: Integer;
        ParkingTicket: Report MonthlyAboInvoice;
        Durationn: Duration;
}

