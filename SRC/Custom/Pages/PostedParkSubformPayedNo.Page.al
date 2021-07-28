page 50310 "Posted Park SubformPayedNo"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Park Line";
    SourceTableView = SORTING ("Park Order No.", "Line No.")
                      WHERE (Payed = FILTER (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Park Order No."; "Park Order No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Vehicle No."; "Vehicle No.")
                {
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
                field(Payed; Payed)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if PostedParkHeader.Get("Park Order No.") then
            if PostedParkHeader.Payed = true then begin
                Rec.Payed := true;
            end
            else
                Rec.Payed := false;
        Rec.Modify;
    end;

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Price (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
        PostedParkHeader: Record "Posted Park Header";
}

