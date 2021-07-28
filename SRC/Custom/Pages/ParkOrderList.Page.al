page 50030 "Park Order List"
{
    CardPageID = "Park Order";
    PageType = List;
    SourceTable = "Park Header";

    layout
    {
        area(content)
        {
            repeater(Group)
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
                }
                field("Customer Type"; CustomerType)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                    CaptionClass = TextCurrr;
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Address; Address)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
            }
            part(Control17; "Park Order Subform")
            {
                SubPageLink = "Park Order No." = FIELD ("No.");
            }
        }
        area(factboxes)
        {
            part(Control19; "Free Spaces")
            {
            }
            part(Control20; "Parking Time")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Register)
            {
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ParkLine.SetFilter("Park Order No.", Rec."No.");
                    if ParkLine.Find('-') then
                        if (ParkLine."Parking Date" <> 0DT) and (ParkLine."Parking End Date" <> 0DT) then begin

                            if Customerrec.Get(Rec."Customer No.") then
                                if Customerrec."Customer Type" = 0 then begin
                                    Message('Guest');
                                    ParkPost.Post(Rec);
                                end;


                            if Customerrec.Get(Rec."Customer No.") then
                                if Customerrec."Customer Type" = 2 then begin
                                    Message('Monthly');
                                    ParkPost.Post(Rec);
                                end;
                        end;

                    if Customerrec.Get(Rec."Customer No.") then
                        if Customerrec."Customer Type" = 1 then begin
                            Message('Abonement');
                            PostedParkOrder.SetFilter("Customer No.", Customerrec."No.");
                            PostedParkOrder.SetFilter(Invalid, Format(false));
                            if PostedParkOrder.FindFirst then begin
                                Error('There is already a valid abonement order');
                            end
                            else begin
                                Clear(AbonementRep);
                                AbonementRep.SetData(Rec."Customer Name", Rec.Address, Rec."Post Code", Rec.City, Rec."Total Amount");
                                AbonementRep.SetTableView(Rec);
                                AbonementRep.RunModal;
                                ParkPost.Post(Rec);
                            end;




                        end
                        else
                            Error('There is empty parking date fields');

                end;
            }
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
                    ParkLineRec.SetFilter("Park Order No.", Rec."No.");
                    if ParkLineRec.FindFirst then begin
                        if ParkLineRec."Parking Date" > CurrentDateTime then
                            Error('Park date cant be later than now');
                        ParkLineRec."Parking End Date" := CurrentDateTime;
                        ParkLineRec.Modify(true);
                        ParkLineRec.Validate("Parking End Date");
                    end;
                end;
            }
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        Customerrec.SetFilter("No.", "Customer No.");
        if Customerrec.FindFirst then
            CustomerType := Customerrec."Customer Type";
    end;

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Total Ammount (%1)', GLSetup.GetCurrencySymbol)
    end;

    var
        EmpLocation: Codeunit "Employee Location";
        ParkSite: Page "Park Site";
        ParkPost: Codeunit ParkPosting;
        Customerrec: Record Customer;
        AbonementRep: Report "Abonement Cheque";
        PostedParkOrder: Record "Posted Park Header";
        CustomerType: Option Guest,Abonement,Monthly;
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
        ParkLine: Record "Park Line";
}

