page 50070 "Customer Vehicle"
{
    CardPageID = "Customer Vehicle Edit";
    PageType = List;
    SourceTable = "Customer Vehicle";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(Make; Make)
                {
                }
                field(Model; Model)
                {
                }
                field(Color; Color)
                {
                }
                field("Country of Registration"; "Country of Registration")
                {
                }
                field("License Plate Number"; "License Plate Number")
                {
                }
            }
        }
    }

    actions
    {
    }
}

