report 50010 "Comulative Cheque"
{
    // =DATEDIFF("h",Fields!ParkingDate.Value,Fields!ParkingEndDate.Value) & ":" & DATEDIFF("n",Fields!ParkingDate.Value, Fields!ParkingEndDate.Value) MOD 60 & ":" & DATEDIFF("s",Fields!ParkingDate.Value, Fields!ParkingEndDate.Value) MOD 60
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC/Custom/Reports/RdlcLayouts/ComulativeCheque.rdlc';

    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Park Line"; "Posted Park Line")
        {
            column(ParkOrderNo; "Posted Park Line"."Park Order No.")
            {
            }
            column(VehicleNo; "Posted Park Line"."Vehicle No.")
            {
            }
            column(ParkingDate; "Posted Park Line"."Parking Date")
            {
            }
            column(ParkingEndDate; "Posted Park Line"."Parking End Date")
            {
            }
            column(DurationP; DurationPark)
            {
            }
            column(DurationSumm; DurationSum)
            {
            }
            column(Price; "Posted Park Line".Price)
            {
            }
            column(CustomerNo; CustomerNo)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(Address; Address)
            {
            }
            column(PostCode; PostCode)
            {
            }
            column(City; City)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DurationPark := "Posted Park Line"."Parking End Date" - "Posted Park Line"."Parking Date";
                DurationSum := DurationSum + DurationPark;
                DurationPark := Round(DurationPark, 1000);
                DurationSum := Round(DurationSum, 1000);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CustomerNo: Code[20];
        CustomerName: Code[20];
        Address: Code[20];
        PostCode: Code[20];
        City: Text[150];
        DurationPark: Duration;
        DurationSum: Duration;

    procedure SetCustData(CustomerNoParam: Code[20])
    var
        CustomerRec: Record Customer;
    begin
        if CustomerRec.Get(CustomerNoParam) then begin
            CustomerNo := CustomerRec."No.";
            CustomerName := CustomerRec.Contact;
            Address := CustomerRec.Address + ' ' + CustomerRec."Address 2";
            PostCode := CustomerRec."Post Code";
            City := CustomerRec.City;
        end;
    end;
}

