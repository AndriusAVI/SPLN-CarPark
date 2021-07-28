page 50190 "Park Customer List"
{
    PageType = List;
    SourceTable = Customer;
    SourceTableView = WHERE (IsParkCustomer = FILTER (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field(Address; Address)
                {
                }
                field(City; City)
                {
                }
                field(Contact; Contact)
                {
                }
                field("Customer Type"; "Customer Type")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IsParkCustomer := true;
    end;

    var
        EmpLoc: Codeunit "Employee Location";
}

