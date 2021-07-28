page 50300 EmpLocationRC
{
    PageType = CardPart;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Location := EmpLoc.GetLocation;
    end;

    trigger OnOpenPage()
    begin
        if EmpLoc.GetLocation = '' then
            EmpLoc.RunRC;
    end;

    var
        Location: Text[200];
        EmpLoc: Codeunit "Employee Location";
}

