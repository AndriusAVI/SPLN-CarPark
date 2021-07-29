codeunit 50120 EventSubscriber
{
    trigger OnRun()
    begin

    end;

    var
        DialogBool: Boolean;
        codeunit232: Codeunit 231;



    local procedure "Codeunit_231"()
    begin
    end;



    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Gen. Jnl.-Post", 'OnBeforeCode', '', true, true)]
    procedure Codeunit_231_OnBeforeCode_Subscriber(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        cusingle: Codeunit SingleInstanceCU;
    begin
        HideDialog := cusingle.Get_HideDialog();
    end;




    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Gen. Jnl.-Post", 'OnBeforeShowPostResultMessage', '', true, true)]
    procedure Codeunit_231_OnBeforeShowPostResultMessage_Subscriber(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10]; var IsHandled: Boolean)
    var
        cusingle: Codeunit SingleInstanceCU;
    begin
        IsHandled := cusingle.Get_isHandled();
    end;
}

