page 50160 WatcherRoleCenter
{
    Caption = 'General';
    CardPageID = "Vehicle Traffic Registering";
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control9)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                ShowCaption = false;
                part(Control3; "Customer Vehicle")
                {
                    UpdatePropagation = Both;
                }
                part(Control8; "Park Customer List")
                {
                }
                part(Employee; EmpLocationRC)
                {
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
            action("Registered Orders")
            {
                Image = OrderList;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Posted Park Order List";
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
        }
        area(processing)
        {
            action("Register Traffic")
            {
                Image = Attach;
                RunObject = Page "Vehicle Traffic Registering";
            }
            action("Free Spaces")
            {
                Image = ItemGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Free Spaces";
            }
            action("Parking Durations")
            {
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Parking Time";
            }
            action("Abonement Summary")
            {
                Image = Document;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Report MonthlyAboInvoice;
            }
        }
    }

    var
        EmpLocation: Codeunit "Employee Location";
        ParkSite: Page "Park Site";
        "Vehicle No.": Code[20];
}

