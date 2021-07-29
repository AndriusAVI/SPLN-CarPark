report 50050 ParkingTicket
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC/Custom/Reports/RdlcLayouts/ParkingTicket.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Park Line"; "Posted Park Line")
        {
            column(LicensePlate; LicensePlateNo)
            {
            }
            column(FromT; FromT)
            {
            }
            column(ToT; ToT)
            {
            }
            column(Hours; DurationH)
            {
            }
            column(Pricee; Pricee)
            {
            }
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
        DurationH: Duration;
        LicensePlateNo: Code[20];
        FromT: DateTime;
        ToT: DateTime;
        Pricee: Decimal;

    procedure SetData(LicensePlate: Code[20]; TimeDif: Decimal; FromTVar: DateTime; ToTVar: DateTime; PriceP: Decimal)
    begin
        LicensePlateNo := LicensePlate;
        FromT := FromTVar;
        ToT := ToTVar;
        DurationH := TimeDif;
        DurationH := Round(DurationH, 1000);
        Pricee := PriceP;
    end;
}

