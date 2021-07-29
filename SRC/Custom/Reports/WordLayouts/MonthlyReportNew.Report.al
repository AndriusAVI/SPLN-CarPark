report 50070 MonthlyReportNew
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC/Custom/Reports/RdlcLayouts/MonthlyReportNew.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Park Header"; "Posted Park Header")
        {
            column(No_PostedParkHeader; "Posted Park Header"."No.")
            {
            }
            column(EmployeeNo_PostedParkHeader; "Posted Park Header"."Employee No.")
            {
            }
            column(CustomerNo_PostedParkHeader; "Posted Park Header"."Customer No.")
            {
            }
            column(CustomerType_PostedParkHeader; "Posted Park Header"."Customer Type")
            {
            }
            column(DocumentDate_PostedParkHeader; "Posted Park Header"."Document Date")
            {
            }
            column(PostingDate_PostedParkHeader; "Posted Park Header"."Posting Date")
            {
            }
            column(TotalAmount_PostedParkHeader; "Posted Park Header"."Total Amount")
            {
            }
            column(CustomerName_PostedParkHeader; "Posted Park Header"."Customer Name")
            {
            }
            column(Address_PostedParkHeader; "Posted Park Header".Address)
            {
            }
            column(PostCode_PostedParkHeader; "Posted Park Header"."Post Code")
            {
            }
            column(City_PostedParkHeader; "Posted Park Header".City)
            {
            }
            column(Payed_PostedParkHeader; "Posted Park Header".Payed)
            {
            }
            column(NoSeries_PostedParkHeader; "Posted Park Header"."No. Series")
            {
            }
            column(Invalid_PostedParkHeader; "Posted Park Header".Invalid)
            {
            }
            column(TotalSum; TotalSum)
            {
            }
            dataitem("Posted Park Line"; "Posted Park Line")
            {
                DataItemLink = "Park Order No." = FIELD("No.");
                column(ParkOrderNo_PostedParkLine; "Posted Park Line"."Park Order No.")
                {
                }
                column(LineNo_PostedParkLine; "Posted Park Line"."Line No.")
                {
                }
                column(CustomerNo_PostedParkLine; "Posted Park Line"."Customer No.")
                {
                }
                column(VehicleNo_PostedParkLine; "Posted Park Line"."Vehicle No.")
                {
                }
                column(ParkCity_PostedParkLine; "Posted Park Line"."Park City")
                {
                }
                column(ParkLocation_PostedParkLine; "Posted Park Line"."Park Location")
                {
                }
                column(ParkLocationAddress_PostedParkLine; "Posted Park Line"."Park Location Address")
                {
                }
                column(ParkingDate_PostedParkLine; "Posted Park Line"."Parking Date")
                {
                }
                column(ParkingEndDate_PostedParkLine; "Posted Park Line"."Parking End Date")
                {
                }
                column(Price_PostedParkLine; "Posted Park Line".Price)
                {
                }
                column(Payed_PostedParkLine; "Posted Park Line".Payed)
                {
                }
                column(CustomerTypeFilter1; CustomerTypeFilter1)
                {

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
                column(DateFrom; DateFrom)
                {
                }
                column(DateTo; DateTo)
                {
                }
                column(SumAbo; SumAbonement)
                {
                }
                column(SumGue; SumGuest)
                {
                }
                column(SumMon; SumMonthly)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; DateFrom)
                {
                }
                field("To Date"; DateTo)
                {
                }
                field("Customer Type"; CustomerTypeFilterOption)
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
                    end;
        "Posted Park Header".SetRange("Document Date", DateFrom, DateTo);
        "Posted Park Header".SetFilter("Customer Type", Format("Posted Park Header"."Customer Type"::Abonement));
        if "Posted Park Header".Find('-') then begin
            repeat
                if "Posted Park Header"."Total Amount" <> 0 then
                    SumAbonement := SumAbonement + "Posted Park Header"."Total Amount";
            until "Posted Park Header".Next = 0;
        end;

        "Posted Park Header".Reset;

        "Posted Park Header".SetRange("Document Date", DateFrom, DateTo);
        "Posted Park Header".SetFilter("Customer Type", 'Guest');
        if "Posted Park Header".Find('-') then begin
            repeat
                "Posted Park Line".Reset;
                "Posted Park Line".SetFilter("Park Order No.", "Posted Park Header"."No.");
                if "Posted Park Line".FindFirst then
                    SumGuest := SumGuest + "Posted Park Line".Price;
            until "Posted Park Header".Next = 0;
        end;
        "Posted Park Header".Reset;
        "Posted Park Header".SetRange("Document Date", DateFrom, DateTo);
        "Posted Park Header".SetFilter("Customer Type", 'Monthly');
        if "Posted Park Header".Find('-') then begin
            repeat
                "Posted Park Line".Reset;
                "Posted Park Line".SetFilter("Park Order No.", "Posted Park Header"."No.");
                if "Posted Park Line".FindFirst then
                    SumMonthly := SumMonthly + "Posted Park Line".Price;
            until "Posted Park Header".Next = 0;
        end;
        "Posted Park Header".Reset;
    end;

    var
        TotalSum: Decimal;
        CustomerTypeFilter1: Text;
        CustomerTypeFilter3: Text;
        CustomerTypeFilter2: Text;
        CustomerTypeFilterOption: Option " ",Guest,Abonement,Monthly;
        DateFrom: Date;
        DateTo: Date;
        SumAbonement: Decimal;
        SumMonthly: Decimal;
        SumGuest: Decimal;
}

