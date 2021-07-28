page 50060 "Free Spaces"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Park Site";

    layout
    {
        area(content)
        {
            repeater(Control7)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Address; Address)
                {
                }
                field(City; City)
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
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Free Spaces" := Rec."Total Spaces" - Rec."Taken Spaces";
    end;

    var
        ParkHeader: Record "Park Header";
        ParkLine: Record "Park Line";
}

