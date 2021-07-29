report 50020 "Abonement Cheque"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC/Custom/Reports/RdlcLayouts/AbonementCheque.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Park Header"; "Park Header")
        {
            column(Name; NameVar)
            {
            }
            column(Address; AddressVar)
            {
            }
            column(PostCode; PostCodeVar)
            {
            }
            column(City; CityVar)
            {
            }
            column(Price; TotalAmountVar)
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
        NameVar: Text[250];
        AddressVar: Text[250];
        PostCodeVar: Code[20];
        CityVar: Text[250];
        TotalAmountVar: Decimal;

    procedure SetData(name: Text[250]; address: Text[250]; pcode: Code[20]; city: Text[250]; price: Decimal)
    begin

        NameVar := name;
        AddressVar := address;
        PostCodeVar := pcode;
        CityVar := city;
        TotalAmountVar := price;
    end;
}

