page 50330 ParkingSetup
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Parking Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Primary Key"; "Primary Key")
                {

                }
                field("Park Nos."; "Park Nos.")
                {

                }

                field("Posted Park Nos."; "Posted Park Nos.")
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}