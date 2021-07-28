page 50140 MontlhyCustDialog
{
    // 

    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("Customer No."; CusNo)
            {
                Editable = false;
            }
            field("Total Amount"; TotalAmnt)
            {
                Editable = false;
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        PostedParkHeaderRec.Reset;
        PostedParkLineRec.Reset;

        PostedParkHeaderRec.SetFilter("Customer No.", CusNo);
        PostedParkHeaderRec.SetFilter(Payed, Format(false));
        PostedParkHeaderRec.SetFilter("Document Date", '<=%1', Today);
        if PostedParkHeaderRec.Find('-') then begin
            repeat
                MyFilter := MyFilter + PostedParkHeaderRec."No." + ' |';
            until PostedParkHeaderRec.Next = 0;
            Evaluate(MyFilter, CopyStr(MyFilter, 1, StrLen(MyFilter) - 1));
            PostedParkLineRec.SetFilter("Park Order No.", MyFilter);
            if PostedParkLineRec.Find('-') then begin
                MontlhyReport.SetTableView(PostedParkLineRec);
                MontlhyReport.SetCustData(CusNo);
                MontlhyReport.RunModal;
                ParkLedgerEntry.SetFilter("Customer No.", CusNo);
                ParkLedgerEntry.SetFilter("Ledger Type", 'Invoice');
                ParkLedgerEntry.SetFilter(Open, Format(true));
                if ParkLedgerEntry.Find('-') then begin

                    if ParkLedgerEntryIns.Find('-') then begin
                        repeat
                            LineNo := ParkLedgerEntryIns."Entry No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until ParkLedgerEntryIns.Next = 0;
                        PostedParkHeaderRec.ModifyAll(Payed, true);
                    end;

                    ParkLedgerEntryIns.Init;

                    ParkLedgerEntryIns."Entry No." := MaxAmt + 1;
                    ParkLedgerEntryIns."Customer No." := ParkLedgerEntry."Customer No.";
                    ParkLedgerEntryIns."Document No." := 'Payment ' + Format(ParkLedgerEntryIns."Entry No.");
                    ParkLedgerEntryIns."Posting Date" := ParkLedgerEntry."Posting Date";
                    ParkLedgerEntryIns."Customer  Name" := ParkLedgerEntry."Customer  Name";
                    ParkLedgerEntryIns."Car No." := '';
                    ParkLedgerEntryIns.Amount := TotalAmnt;
                    ParkLedgerEntryIns.Type := ParkLedgerEntry.Type;

                    ParkLedgerEntryIns."Ledger Type" := 1;
                    ParkLedgerEntryIns.Open := false;
                    ParkLedgerEntryIns.Insert;
                    ParkLedgerEntry.ModifyAll("Applies To Doc", Format(ParkLedgerEntryIns."Entry No."));
                    ParkLedgerEntry.ModifyAll(Open, false);


                end;

            end;


        end;
        CurrRec.Get;



        CustLedg.Reset;
        CustLedg.SetFilter("Customer No.", CusNo);
        CustLedg.SetFilter(Open, Format(true));
        CustLedg.SetFilter("Document Type", Format(CustLedg."Document Type"::Invoice));
        if CustLedg.FindFirst then begin

            CustLedg.Reset;
            repeat
                ;
                LineNo := CustLedg."Entry No.";
                if LineNo > MaxAmt then
                    MaxAmt := LineNo;
            until CustLedg.Next = 0;


            CustLedg.SetFilter("Customer No.", CusNo);
            CustLedg.SetFilter(Open, Format(true));
            CustLedg.SetFilter("Document Type", Format(CustLedg."Document Type"::Invoice));
            GenJournal."Posting Date" := CalcDate('<CM+365D>', Today);
            GenJournal.Validate("Posting Date");
            GenJournal.Description := CustLedg."Customer Name";
            GenJournal."Document Type" := 1;
            GenJournal.Validate("Document Type");
            GenJournal."Account Type" := 1;
            GenJournal.Validate("Account Type");
            GenJournal."Account No." := CusNo;
            GenJournal."Document No." := 'Payment ' + Format(MaxAmt + 1);
            GenJournal.Validate("Document No.");
            GenJournal."Applies-to Doc. Type" := GenJournal."Applies-to Doc. Type"::Invoice;
            GenJournal.Amount := TotalAmnt * -1;
            GenJournal.Validate(Amount);
            GenJournal."Bal. Account Type" := 3;
            GenJournal.Validate("Bal. Account Type");
            GenJournal."Bal. Account No." := 'GIRO';
            GenJournal.Validate("Bal. Account No.");
            GenJournal."Journal Template Name" := 'GENERAL';
            GenJournal.Validate("Journal Template Name");
            GenJournal."Journal Batch Name" := 'CASH';
            GenJournal.Validate("Journal Batch Name");

            GenJournal."Currency Code" := CurrRec.GetCurrencyCode('');
            GenJournal.Validate("Currency Code");
            GenJournal.Validate("Applies-to Doc. Type");
            ApplyID := GenJournal."Document No.";

            GenJournal.Insert;

            //MESSAGE(FORMAT(GenJournal."Line No."));
            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournal);

            PostCU.setDialog(true);
            PostCU.Run(GenJournal);

            CustLedgInv.SetFilter("Customer No.", CusNo);
            CustLedgInv.SetFilter("Document Type", Format(CustLedgInv."Document Type"::Invoice));
            CustLedgInv.SetFilter(Open, Format(true));
            if CustLedgInv.Find('-') then begin
                CustLedgPaym.SetFilter("Document No.", ApplyID);
                CustLedgPaym.FindFirst;

                repeat

                    CustLedgInv.CalcFields(Amount);
                    CustLedgInv."Applying Entry" := true;

                    CustLedgInv."Applies-to ID" := UserId;

                    CustLedgInv.CalcFields("Remaining Amount");
                    CustLedgInv.Validate("Amount to Apply", CustLedgInv."Remaining Amount");

                    CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", CustLedgInv);

                    Commit;


                until CustLedgInv.Next = 0;
                SetAppliesToID.SetApplId(CustLedgPaym, CustLedgInv, UserId);
                PostAppn.Apply(CustLedgPaym, UserId, CalcDate('<CM+365D>', Today));
            end;
        end;
    end;

    trigger OnOpenPage()
    begin

        PostedParkHeaderRec.SetFilter("Customer No.", CusNo);
        PostedParkHeaderRec.SetFilter(Payed, Format(false));
        if PostedParkHeaderRec.Find('-') then begin
            repeat
                PostedParkLineRec.Reset;
                PostedParkLineRec.SetFilter("Park Order No.", PostedParkHeaderRec."No.");
                if PostedParkLineRec.FindFirst then
                    TotalAmnt := TotalAmnt + PostedParkLineRec.Price;
            until PostedParkHeaderRec.Next = 0;
        end;

    end;

    var
        PostedParkLineRec: Record "Posted Park Line";
        PostedParkHeaderRec: Record "Posted Park Header";
        MontlhyReport: Report "Comulative Cheque";
        MyFilter: Code[2048];
        ParkJournalLineRec: Record "Park Journal Line";
        ParkCustomerRec: Record Customer;
        CusNo: Code[20];
        TotalAmnt: Decimal;
        ParkLedgerEntry: Record "Park Ledger Entry";
        MaxAmt: Integer;
        LineNo: Integer;
        EntryNoo: Integer;
        ParkLedgerEntryIns: Record "Park Ledger Entry";
        GenJournal: Record "Gen. Journal Line";
        CustLedg: Record "Cust. Ledger Entry";
        PostCU: Codeunit "Gen. Jnl.-Post";
        CurrRec: Record "General Ledger Setup";
        ApplyID: Code[20];
        CustLedgInv: Record "Cust. Ledger Entry";
        CustLedgPaym: Record "Cust. Ledger Entry";
        SetAppliesToID: Codeunit "Cust. Entry-SetAppl.ID";
        PostAppn: Codeunit "CustEntry-Apply Posted Entries";

    procedure SetData(CustomerNo: Code[20])
    begin
        CusNo := CustomerNo;
    end;
}

