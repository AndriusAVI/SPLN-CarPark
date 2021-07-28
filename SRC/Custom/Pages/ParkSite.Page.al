page 50020 "Park Site"
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Location; LocCode)
            {
                DrillDown = false;
                TableRelation = "Park Site"."No.";

                trigger OnValidate()
                begin
                    if Locations.Get(LocCode) then begin
                        SetLocationCode.SetLocation(Locations."No.");
                    end;
                end;
            }
        }
    }

    actions
    {
    }

    var
        SetLocationCode: Codeunit "Employee Location";
        Locations: Record "Park Site";
        LocCode: Code[20];
        ParkOrder: Page "Park Order List";
}

