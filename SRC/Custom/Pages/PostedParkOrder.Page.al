page 50110 "Posted Park Order"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Posted Park Header";

    layout
    {
        area(content)
        {
            group("Posted Park Header")
            {
                field("No."; "No.")
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Customer No."; "Customer No.")
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
            part(Control14; "Posted Park Subform")
            {
                SubPageLink = "Park Order No." = FIELD ("No.");
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Total Amount (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
}

