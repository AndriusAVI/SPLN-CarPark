page 50040 "Park Employee List"
{
    PageType = List;
    SourceTable = Employee;
    SourceTableView = WHERE (IsParkEmployee = FILTER (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Address"; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("City"; City)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field("User"; User)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IsParkEmployee := true;
    end;
}

