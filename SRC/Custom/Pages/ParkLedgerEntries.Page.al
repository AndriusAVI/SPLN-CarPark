page 50230 "Park Ledger Entries"
{
    CardPageID = ParkLedgerCard;
    Editable = false;
    PageType = List;
    SourceTable = "Park Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Ledger Type"; "Ledger Type")
                {
                }
                field(Open; Open)
                {
                }
                field("<Applies To Entry>"; "Applies To Doc")
                {
                    Caption = 'Applies To Entry';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        "Park Time" := Round("Park Time", 1000);
    end;

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Amount (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];

    procedure ApplyEntries()
    var
        Invoices: Record "Park Ledger Entry";
        Payments: Record "Park Ledger Entry";
    begin
    end;
}

