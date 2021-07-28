page 50280 ParkLedgerCard
{
    Editable = false;
    PageType = Card;
    SourceTable = "Park Ledger Entry";

    layout
    {
        area(content)
        {
            group("Ledger View")
            {
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

    trigger OnAfterGetRecord()
    begin
        "Park Time" := Round("Park Time", 1000);
    end;
}

