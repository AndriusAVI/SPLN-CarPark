page 50170 CustomerNew
{
    PageType = Card;
    SourceTable = "Park Customer";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    LookupPageID = CustomerListNew;
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Customer Type"; "Customer Type")
                {
                }
                field(City; City)
                {
                }
                field(Address; Address)
                {
                }
                field(Address2; Address2)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

