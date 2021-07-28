codeunit 50020 ReportRunner
{

    trigger OnRun()
    begin
        if DIALOG.Confirm('Detailed report?') then begin
            Clear(DetailedRep);
            DetailedRep.RunModal;
        end
        else begin
            Clear(NonDetailedRep);
            NonDetailedRep.RunModal;
        end;
    end;

    var
        DetailedRep: Report MonthlyReportNew;
        NonDetailedRep: Report CustomerTypeInvoice;
}

