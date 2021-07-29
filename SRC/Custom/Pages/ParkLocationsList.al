page 50320 ParkLocationsList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Park Site";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {

                }

                field(Address; Address)
                {

                }

                field(City; City)
                {

                }
                field("Total Spaces"; "Total Spaces")
                {

                }

                field("Taken Spaces"; "Taken Spaces")
                {


                }

                field("Free Spaces"; "Free Spaces")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}