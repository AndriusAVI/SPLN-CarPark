page 50010 "Park Order Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Park Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Park Order No."; "Park Order No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                }
                field("Customer Type"; CustomerType)
                {

                    trigger OnValidate()
                    begin
                        if Customerrec.Get("Customer No.") then
                            CustomerType := Customerrec."Customer Type";
                    end;
                }
                field("Park City"; "Park City")
                {
                }
                field("Park Location"; "Park Location")
                {
                }
                field("Park Location Address"; "Park Location Address")
                {
                }
                field("Parking Date"; "Parking Date")
                {
                }
                field("Parking End Date"; "Parking End Date")
                {
                }
                field(Price; Price)
                {
                    CaptionClass = TextCurrr;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action12)
            {
            }
        }
    }

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Price (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
        CustomerType: Option Guest,Abonement,Monthly;
        Customerrec: Record Customer;
}

