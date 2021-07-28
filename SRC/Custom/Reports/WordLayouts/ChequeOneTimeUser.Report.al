report 50000 ChequeOneTimeUser
{
    DefaultLayout = RDLC;
    RDLCLayout = './ChequeOneTimeUser.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Park Line"; "Park Line")
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
            column(Hours; TimeDiff)
            {
            }
            column(PriceRate; PriceRate)
            {
            }
            column(PriceP; PriceP)
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
        LicensePlateNo: Code[20];
        TimeDiff: Decimal;
        PriceRate: Decimal;
        PriceP: Decimal;
        FromT: DateTime;
        ToT: DateTime;

    procedure SetData(LicensePlate: Code[20]; Rate: Decimal; TimeDif: Decimal; PricePark: Decimal; FromTVar: DateTime; ToTVar: DateTime)
    begin
        LicensePlateNo := LicensePlate;
        PriceRate := Rate;
        TimeDiff := TimeDif;
        PriceP := PricePark;
        FromT := FromTVar;
        ToT := ToTVar;
    end;
}

