page 50000 "Park Order"
{
    // MESSAGE(Rec."No.");
    //   ParkLineRec.SETFILTER("Park Order No.",Rec."No.");
    // IF ParkLineRec.FIND('-') THEN BEGIN
    //   REPEAT
    //     MESSAGE(ParkLineRec."Vehicle No.");
    //     UNTIL ParkLineRec.NEXT=0;
    //     END;

    PageType = Card;
    SourceTable = "Park Header";

    layout
    {
        area(content)
        {
            group("Park Header")
            {
                field("No."; "No.")
                {
                    Visible = false;
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Customer No."; "Customer No.")
                {

                    trigger OnValidate()
                    begin
                        if ParkCustomer.Get("Customer No.") then
                            if (ParkCustomer."Customer Type" = 0) or (ParkCustomer."Customer Type" = 2)
                              then begin
                                iSVisible := false;
                            end
                            else
                                iSVisible := true;

                        Postedparkheaderrec.SetFilter("Customer No.", Rec."Customer No.");
                        Postedparkheaderrec.SetFilter("Customer Type", 'Abonement');
                        Postedparkheaderrec.SetFilter(Invalid, Format(false));
                        if Postedparkheaderrec.FindFirst then
                            Error('There is already a valid order for this abonement');
                    end;
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(City; City)
                {
                }
                field(Address; Address)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field("Total Ammount"; "Total Amount")
                {
                    CaptionClass = TextCurr;
                }
                field("Car Count"; "Car Count")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
            }
            part(Control9; "Park Order Subform")
            {
                SubPageLink = "Park Order No." = FIELD ("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Free Spaces")
            {
                Image = ItemGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Free Spaces";
            }
            action("Parking Durations")
            {
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Parking Time";
            }
            action("Park End")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
            }
        }
    }

    trigger OnInit()
    begin
        GlSetup.Get;
        TextCurr := StrSubstNo('Total Amount (%1)', GlSetup.GetCurrencySymbol);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Validate("No.");
        ParkEmployee.SetFilter(User, UserSecurityId);
        if ParkEmployee.FindFirst then
            "Employee No." := ParkEmployee."No.";
    end;

    var
        EmpLocation: Codeunit "Employee Location";
        ParkSite: Page "Park Site";
        JournalLineRec: Record "Park Journal Line";
        ParkLineRec: Record "Park Line";
        ParkPost: Codeunit ParkPosting;
        iSVisible: Boolean;
        ParkCustomer: Record "Park Customer";
        Postedparkheaderrec: Record "Posted Park Header";
        ParkEmployee: Record Employee;
        TextCurr: Text[250];
        GlSetup: Record "General Ledger Setup";
}

