report 50040 MonthlyAboInvoice
{
    DefaultLayout = RDLC;
    RDLCLayout = './MonthlyAboInvoice.rdlc';
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Posted Park Line"; "Posted Park Line")
        {
            column(ParkOrderNo; "Posted Park Line"."Park Order No.")
            {
            }
            column(CarNo; "Posted Park Line"."Vehicle No.")
            {
            }
            column(ParkCity; "Posted Park Line"."Park City")
            {
            }
            column(CustomerNo; "Posted Park Line"."Customer No.")
            {
            }
            column(ParkAddress; "Posted Park Line"."Park Location Address")
            {
            }
            column(Price; Price)
            {
            }
            column(CustomerType; CustomerType)
            {
            }
            column(ParkDuration; DurationVar)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(DocumentDate; DocumentDate)
            {
            }
            column(DateFrom; DateFrom)
            {
            }
            column(DateTo; DateTo)
            {
            }
            column(CustomerTypeFilter1; CustomerTypeFilter1)
            {
                OptionMembers = ,Guest,Abonement,Monthly;
            }
            column(CustomerTypeFilter2; CustomerTypeFilter2)
            {
            }
            column(CustomerTypeFilter3; CustomerTypeFilter3)
            {
            }
            column(CustomerTypeFlterOption; CustomerTypeFilterOption)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PostedParkHeaderRec.SetFilter("No.", "Posted Park Line"."Park Order No.");
                if PostedParkHeaderRec.FindFirst then begin
                    Price := 0;
                    CustomerType := PostedParkHeaderRec."Customer Type";
                    DurationVar := "Posted Park Line"."Parking End Date" - "Posted Park Line"."Parking Date";
                    DurationVar := Round(DurationVar, 1000);
                    CustomerName := PostedParkHeaderRec."Customer Name";
                    DocumentDate := PostedParkHeaderRec."Document Date";
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Posted Park Line".SetFilter("Customer No.", CustomerNooo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date from"; DateFrom)
                {
                }
                field("Date to"; DateTo)
                {
                }
                field(Customer; CustomerNooo)
                {
                    TableRelation = Customer."No." WHERE ("Customer Type" = FILTER (Abonement));
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustomerTypeFilterOption := 2;
        if CustomerTypeFilterOption = 2 then begin
            CustomerTypeFilter2 := 'Abonement';
        end
    end;

    var
        CustomerType: Option Guest,Abonement,Monthly;
        Price: Decimal;
        PostedParkHeaderRec: Record "Posted Park Header";
        DurationVar: Duration;
        CustomerName: Text[255];
        DocumentDate: Date;
        DateFrom: Date;
        DateTo: Date;
        CustomerTypeFilter1: Text;
        CustomerTypeFilter3: Text;
        CustomerTypeFilter2: Text;
        CustomerTypeFilterOption: Option " ",Guest,Abonement,Monthly;
        CustomerNooo: Code[20];
}

