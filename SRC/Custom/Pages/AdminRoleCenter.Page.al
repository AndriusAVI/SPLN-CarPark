page 50200 AdminRoleCenter
{
    Caption = 'General';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Customer)
            {
                part(Control19; "Parking Prices")
                {
                }
                part(Control6; "Park Customer List")
                {
                }
                part(Control5; "Customer Vehicle")
                {
                }
            }
            group(Parking)
            {
                part(Control3; "Free Spaces")
                {
                    Editable = false;
                }
                part(Control2; "Parking Time")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(Customers)
            {
                Image = Customer;
                RunObject = Page "Park Customer List";
            }
            action("Parking Orders")
            {
                Image = "Order";
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Park Order List";
            }
            action("Cumulative Payments")
            {
                Image = PaymentDays;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Cumulative Payments";
            }
            action("Customer Car Registering")
            {
                Image = Registered;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Customer Vehicle";
            }
            action("Abonement Car Registering")
            {
                RunObject = Page "Abonement Car Registering";
            }
            action("Park Employee List")
            {
                Image = Accounts;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Park Employee List";
            }
            action("Parking Prices")
            {
                Image = PriceAdjustment;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Parking Prices";
            }
            action("Registered Orders")
            {
                Image = OrderList;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Posted Park Order List";
            }
        }
        area(processing)
        {
            action("Monthly Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedOnly = true;
                RunObject = Report "Montlhy Invoice";
            }
        }
    }
}

