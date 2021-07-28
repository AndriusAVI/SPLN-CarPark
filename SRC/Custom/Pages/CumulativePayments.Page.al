page 50130 "Cumulative Payments"
{
    // 

    Editable = false;
    PageType = List;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Contact; Contact)
                {
                    StyleExpr = styleVar;
                }
                field(Address; Address)
                {
                    StyleExpr = styleVar;
                }
                field("Address 2"; "Address 2")
                {
                    StyleExpr = styleVar;
                }
                field("Customer Type"; "Customer Type")
                {
                    StyleExpr = styleVar;
                }
            }
            group(Control7)
            {
                ShowCaption = false;
                part(Control15; "Posted Park SubformPayedNo")
                {
                    SubPageLink = "Customer No." = FIELD ("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Comulative Payment Confirmation")
            {
                Enabled = disabledbool;
                Image = ConfirmAndPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    dialogCustomer: Page MontlhyCustDialog;
                begin
                    dialogCustomer.SetData(Rec."No.");
                    dialogCustomer.Run;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Customer Type" = 2 then begin
            disabledbool := true;
        end
        else
            disabledbool := false;
    end;

    trigger OnAfterGetRecord()
    begin
        PostedParkHeader.SetFilter("Customer Type", 'Monthly');
        PostedParkHeader.SetFilter("Customer No.", Rec."No.");
        PostedParkHeader.SetFilter(Payed, Format(false));

        if PostedParkHeader.Find('-') then begin
            repeat
                if (minDate > PostedParkHeader."Posting Date") or (minDate = 0D) then
                    minDate := PostedParkHeader."Posting Date";
            until PostedParkHeader.Next = 0;
            if Today - minDate >= 0 then begin
                styleVar := 'Unfavorable';
            end
            else
                styleVar := '';
        end
        else
            styleVar := '';
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Customer Type", '(Monthly) | (Abonement)');
    end;

    var
        CustomerNo: Code[20];
        MyDialog: Dialog;
        disabledbool: Boolean;
        PostedParkHeader: Record "Posted Park Header";
        styleVar: Text[250];
        minDate: Date;
        pdate: Date;
}

