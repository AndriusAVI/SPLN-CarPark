codeunit 50110 SingleInstanceCU
{
    SingleInstance = true;

    var
        HideDialog: Boolean;

    procedure Get_HideDialog(): Boolean
    begin
        exit(HideDialog);
    end;

    procedure Set_HideDialog(_HideDialog: Boolean)
    begin
        HideDialog := _HideDialog
    end;

}