page 50260 "Park Journal Line Edit"
{
    PageType = Card;
    SourceTable = "Park Journal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Customer  Name"; "Customer  Name")
                {
                }
                field("Car No."; "Car No.")
                {
                }
                field("Park Time"; "Park Time")
                {
                }
                field(Amount; Amount)
                {
                    CaptionClass = TextCurrr;
                }
                field(Type; Type)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Amount (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
}

