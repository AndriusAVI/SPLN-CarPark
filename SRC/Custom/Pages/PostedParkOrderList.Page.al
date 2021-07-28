page 50120 "Posted Park Order List"
{
    CardPageID = "Posted Park Order";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Park Header";

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
                field("Customer Type"; "Customer Type")
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
                field(Invalid; Invalid)
                {
                }
                field(Payed; Payed)
                {
                }
            }
            part(Control13; "Posted Park Subform")
            {
                SubPageLink = "Park Order No." = FIELD ("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CheckAbonements)
            {
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    PostedParkHeader.SetFilter("Customer Type", 'Abonement');
                    if PostedParkHeader.Find('-') then begin
                        repeat
                            if Today - PostedParkHeader."Document Date" >= 30 then begin
                                PostedParkHeader.Invalid := true;
                                PostedParkHeader.Modify;
                            end;
                        until PostedParkHeader.Next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Total Amount (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        "Customer Type": Option Guest,Abonement,Monthly;
        CustomerRec: Record Customer;
        PostedParkHeader: Record "Posted Park Header";
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
}

