page 50180 CustomerListNew
{
    PageType = List;
    SourceTable = Customer;

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
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
                field(Contact; Contact)
                {
                }
            }
        }
    }

    actions
    {
    }
}

