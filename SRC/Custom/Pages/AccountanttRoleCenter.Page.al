page 50220 AccountanttRoleCenter
{
    Caption = 'General';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control11)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Wide;
                ShowCaption = false;
                part(Control2; "Park Journal Line")
                {
                }
            }
            group(Control10)
            {
                ShowCaption = false;
                part(Control3; "Park Ledger Entries")
                {
                    Editable = false;
                }
                part(Control5; "Park Customer List")
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
            action("Customer Ledger Entries")
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Customer Ledger Entries";
            }
            action("Park Ledger Entries")
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Park Ledger Entries";
            }
            action("Park Journal Line")
            {
                Image = Journal;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Park Journal Line";
            }
        }
        area(processing)
        {
            action("Montlhy Report")
            {
                Image = ReleaseDoc;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Codeunit ReportRunner;
            }
            action("General Journal")
            {
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "General Journal";
            }
        }
    }

    var
        DetailedRep: Report MonthlyReportNew;
        NonDetailedRep: Report CustomerTypeInvoice;
}

