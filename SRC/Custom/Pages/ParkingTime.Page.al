page 50080 "Parking Time"
{
    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Park Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle No."; "Vehicle No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Type"; "Client Type")
                {
                }
                field("Park City"; "Park City")
                {
                }
                field("Park Location"; "Park Location")
                {
                }
                field("Park Location Address"; "Park Location Address")
                {
                }
                field(Duration; Duration)
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

        if Rec."Parking Date" <> 0DT
          then begin
            Duration := Round(CurrentDateTime - Rec."Parking Date", 1000);
        end
        else
            Duration := 0;
        if CustomerRec.Get("Customer No.") then
            "Client Type" := CustomerRec."Customer Type";


        if ("Park Order No." = '') or ("Vehicle No." = '') then
            Rec.Delete;
    end;

    var
        Duration: Duration;
        "Client Type": Option Guest,Abonnement,Monthly;
        CustomerRec: Record Customer;
}

