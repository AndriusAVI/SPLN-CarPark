report 50030 "Montlhy Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './MontlhyInvoice.rdlc';
    UsageCategory = ReportsAndAnalysis;

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
            column(Price; "Posted Park Line".Price)
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
            column(PriceAbo; PriceAbo)
            {
            }
            column("Integer"; Cnt)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PostedParkHeaderRec.SetFilter("No.", "Posted Park Line"."Park Order No.");
                PostedParkHeaderRec.FindFirst;
                Price := "Posted Park Line".Price + PostedParkHeaderRec."Total Amount";

                CustomerType := PostedParkHeaderRec."Customer Type";
                DurationVar := "Posted Park Line"."Parking End Date" - "Posted Park Line"."Parking Date";
                DurationVar := Round(DurationVar, 1000);
                CustomerName := PostedParkHeaderRec."Customer Name";
                DocumentDate := PostedParkHeaderRec."Document Date";
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
                field(CustomerType; CustomerTypeFilterOption)
                {
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
        if CustomerTypeFilterOption = 0 then begin
            CustomerTypeFilter1 := 'Guest';
            CustomerTypeFilter2 := 'Abonement';
            CustomerTypeFilter3 := 'Monthly';
        end
        else
            if CustomerTypeFilterOption = 1 then begin
                CustomerTypeFilter1 := 'Guest';

            end
            else
                if CustomerTypeFilterOption = 2 then begin
                    CustomerTypeFilter2 := 'Abonement';
                end
                else
                    if CustomerTypeFilterOption = 3 then begin
                        CustomerTypeFilter2 := 'Monthly';
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
        PriceAbo: Decimal;
        Cnt: Integer;
}

