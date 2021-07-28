page 50210 "Parking Prices"
{
    CardPageID = "Parking Prices Edit";
    PageType = List;
    SourceTable = "Parking Prices";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Type"; "Customer Type")
                {
                }
                field(Hours; Hours)
                {
                }
                field(Rate; Rate)
                {
                    CaptionClass = TextCurrr;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Rate (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
}

