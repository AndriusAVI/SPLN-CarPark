codeunit 50110 SingleInstanceCU
{
    SingleInstance = true;

    var
        HideDialog: Boolean;
        isHandled: Boolean;

    procedure Get_HideDialog(): Boolean
    begin
        exit(HideDialog);
    end;

    procedure Set_HideDialog(_HideDialog: Boolean)
    begin
        HideDialog := _HideDialog
    end;



    procedure Get_isHandled(): Boolean
    begin
        exit(isHandled);
    end;

    procedure Set_isHandled(_isHandled: Boolean)
    begin
        isHandled := _isHandled;
    end;
}