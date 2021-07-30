codeunit 50010 ParkPosting
{
    //     GenJournal.INIT;
    //     GenJournal."Posting Date":=CALCDATE('<CM+365D>',TODAY);
    //      GenJournal.VALIDATE("Posting Date");
    //        GenJournal.Description:=PostedParkHeaderRec."Customer Name";
    //     GenJournal."Document Type":=2;
    //           GenJournal.VALIDATE("Document Type");
    //     GenJournal."Account Type":=1;
    //        GenJournal.VALIDATE("Account Type");
    //     GenJournal."Account No.":=PostedParkHeaderRec."Customer No.";
    //        GenJournal."Document No.":=PostedParkHeaderRec."No.";
    //    GenJournal.VALIDATE("Document No.");
    // 
    //    GenJournal.Amount:=ParkLineRec.Price;
    //    GenJournal.VALIDATE(Amount);
    //    GenJournal."Bal. Account Type":=3;
    //          GenJournal.VALIDATE("Bal. Account Type");
    //    GenJournal."Bal. Account No.":='GIRO';
    //    GenJournal.VALIDATE("Bal. Account No.");
    //    GenJournal."Journal Template Name":='GENERAL';
    //        GenJournal.VALIDATE("Journal Template Name");
    //    GenJournal."Journal Batch Name":='CASH';
    //       GenJournal.VALIDATE("Journal Batch Name");
    // 
    //  GenJournal."Currency Code":=CurrRec.GetCurrencyCode('');
    //  GenJournal.VALIDATE("Currency Code");
    // 
    //   // MESSAGE(FORMAT(GenJournal."Document Type"));
    //  //  MESSAGE(FORMAT(GenJournal."Account Type"));
    //  //  MESSAGE(FORMAT(GenJournal."Bal. Account Type"));
    // 
    //    GenJournal.INSERT;
    // 
    // PostCU.setDialog(TRUE);
    // PostCU.RUN(GenJournal);
    //    // CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournal);
    //     //SLEEP(1000);
    //     GenJournal.RESET;
    //       GenJournal.INIT;
    // 
    //     GenJournal."Posting Date":=CALCDATE('<CM+365D>',TODAY);
    //        GenJournal.VALIDATE("Posting Date");
    //        GenJournal.Description:=PostedParkHeaderRec."Customer Name";
    //     GenJournal."Document Type":=1;
    //           GenJournal.VALIDATE("Document Type");
    //     GenJournal."Account Type":=1;
    //        GenJournal.VALIDATE("Account Type");
    //     GenJournal."Account No.":=PostedParkHeaderRec."Customer No.";
    //        GenJournal."Document No.":='Payment '+PostedParkHeaderRec."No.";
    //    GenJournal.VALIDATE("Document No.");
    //    GenJournal."Applies-to Doc. Type":=GenJournal."Applies-to Doc. Type"::Invoice;
    //    GenJournal.Amount:=ParkLineRec.Price*-1;
    //    GenJournal.VALIDATE(Amount);
    //    GenJournal."Bal. Account Type":=3;
    //          GenJournal.VALIDATE("Bal. Account Type");
    //    GenJournal."Bal. Account No.":='GIRO';
    //    GenJournal.VALIDATE("Bal. Account No.");
    //    GenJournal."Journal Template Name":='GENERAL';
    //        GenJournal.VALIDATE("Journal Template Name");
    //    GenJournal."Journal Batch Name":='CASH';
    //       GenJournal.VALIDATE("Journal Batch Name");
    // 
    //  GenJournal."Currency Code":=CurrRec.GetCurrencyCode('');
    //  GenJournal.VALIDATE("Currency Code");
    // GenJournal.VALIDATE("Applies-to Doc. Type");
    //  GenJournal."Applies-to Doc. No.":=PostedParkHeaderRec."No.";
    //  GenJournal.INSERT;
    // 
    // //MESSAGE(FORMAT(GenJournal."Line No."));
    //  //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournal);
    // 
    // PostCU.setDialog(TRUE);
    // PostCU.RUN(GenJournal);


    trigger OnRun()
    begin
    end;




    procedure Post(var ParkHeaderRec: Record "Park Header")
    var
        ParkLineRec: Record "Park Line";
        PostedParkLineRec: Record "Posted Park Line";
        PostedParkHeaderRec: Record "Posted Park Header";
        ParkJournalLineRec: Record "Park Journal Line";
        ParkSetupRec: Record "Parking Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        MaxEntryNo: Integer;
        MaxDetEntryNo: Integer;
        CustomerRec: Record Customer;
        JournalLineRec: Record "Park Journal Line";
        ParkLedgerEntry: Record "Park Ledger Entry";
        LineNo: Integer;
        MaxAmt: Integer;
        GenJournal: Record "Gen. Journal Line";
        CurrRec: Record "General Ledger Setup";
        ApplyEntries: Codeunit "Gen. Jnl.-Apply";
        CLedgerEntry: Record "Cust. Ledger Entry";
        PostCU: Codeunit "Gen. Jnl.-Post";
        HideDialog: Boolean;
        EventSubscriber: Codeunit EventSubscriber;
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin

        CurrRec.Get;
        if CustomerRec.Get(ParkHeaderRec."Customer No.") then
            if CustomerRec."Customer Type" = 0 then begin
                PostedParkHeaderRec.Init;
                ParkSetupRec.Get(Format(2));
                ParkSetupRec.TestField("Posted Park Nos.");
                NoSeriesMgt.InitSeries(ParkSetupRec."Posted Park Nos.", PostedParkHeaderRec."No. Series", 0D, PostedParkHeaderRec."No.", PostedParkHeaderRec."No. Series");
                PostedParkHeaderRec."Employee No." := ParkHeaderRec."Employee No.";
                PostedParkHeaderRec."Customer No." := ParkHeaderRec."Customer No.";
                PostedParkHeaderRec."Document Date" := ParkHeaderRec."Document Date";
                PostedParkHeaderRec."Posting Date" := Today;
                PostedParkHeaderRec."Total Amount" := ParkHeaderRec."Total Amount";
                PostedParkHeaderRec."Customer Name" := ParkHeaderRec."Customer Name";
                PostedParkHeaderRec.Address := ParkHeaderRec.Address;
                PostedParkHeaderRec."Post Code" := PostedParkHeaderRec."Post Code";
                PostedParkHeaderRec.City := ParkHeaderRec.City;
                PostedParkHeaderRec."Customer Type" := CustomerRec."Customer Type";
                PostedParkHeaderRec.Payed := true;

                PostedParkHeaderRec.Insert;
                ParkLineRec.SetFilter("Park Order No.", ParkHeaderRec."No.");
                if ParkLineRec.Find('-') then begin
                    repeat
                        PostedParkLineRec.Init;
                        PostedParkLineRec."Park Order No." := PostedParkHeaderRec."No.";
                        PostedParkLineRec."Line No." := ParkLineRec."Line No.";
                        PostedParkLineRec."Customer No." := ParkLineRec."Customer No.";
                        PostedParkLineRec."Vehicle No." := ParkLineRec."Vehicle No.";
                        PostedParkLineRec."Park City" := ParkLineRec."Park City";
                        PostedParkLineRec."Park Location" := ParkLineRec."Park Location";
                        PostedParkLineRec."Park Location Address" := ParkLineRec."Park Location Address";
                        PostedParkLineRec."Parking Date" := ParkLineRec."Parking Date";
                        PostedParkLineRec."Parking End Date" := ParkLineRec."Parking End Date";
                        PostedParkLineRec.Price := ParkLineRec.Price;
                        PostedParkLineRec.Insert;
                        ParkLineRec.Delete;
                    until ParkLineRec.Next = 0;
                end;
                ParkHeaderRec.Delete;


                CustLedgerEntry.Init;
                PostedParkLineRec.Reset;
                PostedParkLineRec.SetFilter("Park Order No.", PostedParkHeaderRec."No.");
                if PostedParkLineRec.Find('-') then begin
                    repeat
                        // ApplyEntries.RUN(GenJournal);
                        ParkJournalLineRec.Init;
                        ParkJournalLineRec."Customer No." := PostedParkHeaderRec."Customer No.";
                        ParkJournalLineRec."Document No." := PostedParkHeaderRec."No.";
                        ParkJournalLineRec."Posting Date" := Today;
                        ParkJournalLineRec."Customer  Name" := CustomerRec.Contact;
                        ParkJournalLineRec."Car No." := PostedParkLineRec."Vehicle No.";
                        ParkJournalLineRec."Park Time" := PostedParkLineRec."Parking End Date" - ParkLineRec."Parking Date";
                        ParkJournalLineRec.Amount := PostedParkLineRec.Price;
                        ParkJournalLineRec.Type := 0;
                        ParkJournalLineRec.Insert;
                    until PostedParkLineRec.Next = 0;
                    GenJournal.Init;
                    GenJournal."Posting Date" := CalcDate('<CM+365D>', Today);
                    GenJournal.Validate("Posting Date");
                    GenJournal.Description := PostedParkHeaderRec."Customer Name";
                    GenJournal."Document Type" := 2;
                    GenJournal.Validate("Document Type");
                    GenJournal."Account Type" := 1;
                    GenJournal.Validate("Account Type");
                    GenJournal."Account No." := PostedParkHeaderRec."Customer No.";
                    GenJournal."Document No." := PostedParkHeaderRec."No.";
                    GenJournal.Validate("Document No.");
                    GenJournal.Amount := ParkLineRec.Price;
                    GenJournal.Validate(Amount);
                    GenJournal."Bal. Account Type" := GenJournal."Bal. Account Type"::"G/L Account";
                    GenJournal.Validate("Bal. Account Type");
                    GenJournal."Bal. Account No." := '2910';
                    GenJournal.Validate("Bal. Account No.");
                    GenJournal."Journal Template Name" := 'GENERAL';
                    GenJournal.Validate("Journal Template Name");
                    GenJournal."Journal Batch Name" := 'CASH';
                    GenJournal.Validate("Journal Batch Name");

                    GenJournal."Currency Code" := CurrRec.GetCurrencyCode('');
                    GenJournal.Validate("Currency Code");


                    GenJournal.Insert;

                    SingleInstanceCU.Set_HideDialog(true);
                    SingleInstanceCU.Set_isHandled(true);
                    PostCU.Run(GenJournal);
                    SingleInstanceCU.Set_isHandled(false);
                    SingleInstanceCU.Set_HideDialog(false);

                    GenJournal.Reset;
                    GenJournal.Init;

                    GenJournal."Posting Date" := CalcDate('<CM+365D>', Today);
                    GenJournal.Validate("Posting Date");
                    GenJournal.Description := PostedParkHeaderRec."Customer Name";
                    GenJournal."Document Type" := 1;
                    GenJournal.Validate("Document Type");
                    GenJournal."Account Type" := 1;
                    GenJournal.Validate("Account Type");
                    GenJournal."Account No." := PostedParkHeaderRec."Customer No.";
                    GenJournal."Document No." := 'Payment ' + PostedParkHeaderRec."No.";
                    GenJournal.Validate("Document No.");
                    GenJournal."Applies-to Doc. Type" := GenJournal."Applies-to Doc. Type"::Invoice;
                    GenJournal.Amount := ParkLineRec.Price * -1;
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
                    GenJournal."Applies-to Doc. No." := PostedParkHeaderRec."No.";
                    GenJournal.Insert;


                    SingleInstanceCU.Set_HideDialog(true);
                    SingleInstanceCU.Set_isHandled(true);
                    PostCU.Run(GenJournal);
                    SingleInstanceCU.Set_isHandled(false);
                    SingleInstanceCU.Set_HideDialog(false);



                end;

            end
            else
                if CustomerRec."Customer Type" = 2 then begin
                    PostedParkHeaderRec.Init;
                    ParkSetupRec.Get(Format(3));
                    ParkSetupRec.TestField("Posted Park Nos.");
                    NoSeriesMgt.InitSeries(ParkSetupRec."Posted Park Nos.", PostedParkHeaderRec."No. Series", 0D, PostedParkHeaderRec."No.", PostedParkHeaderRec."No. Series");
                    PostedParkHeaderRec."Employee No." := ParkHeaderRec."Employee No.";
                    PostedParkHeaderRec."Customer No." := ParkHeaderRec."Customer No.";
                    PostedParkHeaderRec."Document Date" := ParkHeaderRec."Document Date";
                    PostedParkHeaderRec."Posting Date" := Today;
                    PostedParkHeaderRec."Total Amount" := ParkHeaderRec."Total Amount";
                    PostedParkHeaderRec."Customer Name" := ParkHeaderRec."Customer Name";
                    PostedParkHeaderRec.Address := ParkHeaderRec.Address;
                    PostedParkHeaderRec."Post Code" := PostedParkHeaderRec."Post Code";
                    PostedParkHeaderRec.City := ParkHeaderRec.City;
                    PostedParkHeaderRec."Customer Type" := CustomerRec."Customer Type";
                    PostedParkHeaderRec.Payed := false;
                    PostedParkHeaderRec.Insert;
                    ParkLineRec.SetFilter("Park Order No.", ParkHeaderRec."No.");




                    if ParkJournalLineRec.Find('-') then begin
                        repeat
                            LineNo := ParkJournalLineRec."Entry No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until ParkJournalLineRec.Next = 0;
                    end;



                    if ParkLineRec.Find('-') then begin
                        repeat
                            PostedParkLineRec.Init;
                            PostedParkLineRec."Park Order No." := PostedParkHeaderRec."No.";
                            PostedParkLineRec."Line No." := ParkLineRec."Line No.";
                            PostedParkLineRec."Customer No." := ParkLineRec."Customer No.";
                            PostedParkLineRec."Vehicle No." := ParkLineRec."Vehicle No.";
                            PostedParkLineRec."Park City" := ParkLineRec."Park City";
                            PostedParkLineRec."Park Location" := ParkLineRec."Park Location";
                            PostedParkLineRec."Park Location Address" := ParkLineRec."Park Location Address";
                            PostedParkLineRec."Parking Date" := ParkLineRec."Parking Date";
                            PostedParkLineRec."Parking End Date" := ParkLineRec."Parking End Date";
                            PostedParkLineRec.Price := ParkLineRec.Price;
                            PostedParkLineRec.Insert;
                            ParkLineRec.Delete;


                            GenJournal.Init;
                            GenJournal."Posting Date" := CalcDate('<CM+365D>', Today);
                            GenJournal.Validate("Posting Date");
                            GenJournal.Description := PostedParkHeaderRec."Customer Name";
                            GenJournal."Document Type" := 2;
                            GenJournal.Validate("Document Type");
                            GenJournal."Account Type" := 1;
                            GenJournal.Validate("Account Type");
                            GenJournal."Account No." := PostedParkHeaderRec."Customer No.";
                            GenJournal."Document No." := PostedParkHeaderRec."No.";
                            GenJournal.Validate("Document No.");

                            GenJournal.Amount := ParkLineRec.Price;
                            GenJournal.Validate(Amount);
                            GenJournal."Bal. Account Type" := GenJournal."Bal. Account Type"::"G/L Account";
                            GenJournal.Validate("Bal. Account Type");
                            GenJournal."Bal. Account No." := '2910';
                            GenJournal.Validate("Bal. Account No.");
                            GenJournal."Journal Template Name" := 'GENERAL';
                            GenJournal.Validate("Journal Template Name");
                            GenJournal."Journal Batch Name" := 'CASH';
                            GenJournal.Validate("Journal Batch Name");
                            CurrRec.Get;
                            GenJournal."Currency Code" := CurrRec.GetCurrencyCode('');
                            GenJournal.Validate("Currency Code");

                            GenJournal.Insert;
                            //Posting CodeUnit
                            SingleInstanceCU.Set_HideDialog(true);
                            SingleInstanceCU.Set_isHandled(true);
                            PostCU.Run(GenJournal);
                            SingleInstanceCU.Set_isHandled(false);
                            SingleInstanceCU.Set_HideDialog(false);




                            ParkJournalLineRec.Init;
                            ParkJournalLineRec."Entry No." := MaxAmt + 1;
                            ParkJournalLineRec."Customer No." := PostedParkLineRec."Customer No.";
                            ParkJournalLineRec."Document No." := PostedParkLineRec."Park Order No.";
                            ParkJournalLineRec."Posting Date" := Today;
                            if CustomerRec.Get(PostedParkLineRec."Customer No.") then
                                ParkJournalLineRec."Customer  Name" := CustomerRec.Contact;
                            ParkJournalLineRec."Car No." := PostedParkLineRec."Vehicle No.";
                            ParkJournalLineRec."Park Time" := PostedParkLineRec."Parking End Date" - PostedParkLineRec."Parking Date";
                            ParkJournalLineRec.Amount := PostedParkLineRec.Price;
                            ParkJournalLineRec.Type := 0;

                            ParkJournalLineRec.Insert;

                        until ParkLineRec.Next = 0;
                        ParkHeaderRec.Delete;


                    end;


                end
                else
                    if CustomerRec."Customer Type" = 1 then begin

                        PostedParkHeaderRec.Init;
                        ParkSetupRec.Get(Format(4));
                        ParkSetupRec.TestField("Posted Park Nos.");
                        NoSeriesMgt.InitSeries(ParkSetupRec."Posted Park Nos.", PostedParkHeaderRec."No. Series", 0D, PostedParkHeaderRec."No.", PostedParkHeaderRec."No. Series");
                        PostedParkHeaderRec."Employee No." := ParkHeaderRec."Employee No.";
                        PostedParkHeaderRec."Customer No." := ParkHeaderRec."Customer No.";
                        PostedParkHeaderRec."Document Date" := ParkHeaderRec."Document Date";
                        PostedParkHeaderRec."Posting Date" := Today;
                        PostedParkHeaderRec."Total Amount" := ParkHeaderRec."Total Amount";
                        PostedParkHeaderRec."Customer Name" := ParkHeaderRec."Customer Name";
                        PostedParkHeaderRec.Address := ParkHeaderRec.Address;
                        PostedParkHeaderRec."Post Code" := PostedParkHeaderRec."Post Code";
                        PostedParkHeaderRec.City := ParkHeaderRec.City;
                        PostedParkHeaderRec."Customer Type" := CustomerRec."Customer Type";
                        PostedParkHeaderRec.Payed := true;
                        PostedParkHeaderRec.Insert;
                        ParkHeaderRec.Delete;

                        ParkJournalLineRec.Init;
                        ParkJournalLineRec."Customer No." := PostedParkHeaderRec."Customer No.";
                        ParkJournalLineRec."Document No." := PostedParkHeaderRec."No.";
                        ParkJournalLineRec."Posting Date" := Today;
                        ParkJournalLineRec."Customer  Name" := CustomerRec.Contact;
                        ParkJournalLineRec.Amount := PostedParkHeaderRec."Total Amount";
                        ParkJournalLineRec.Type := 1;
                        ParkJournalLineRec.Insert;

                        GenJournal.Init;
                        GenJournal."Posting Date" := CalcDate('<CM+365D>', Today);
                        GenJournal.Validate("Posting Date");
                        GenJournal.Description := PostedParkHeaderRec."Customer Name";
                        GenJournal."Document Type" := 2;
                        GenJournal.Validate("Document Type");
                        GenJournal."Account Type" := 1;
                        GenJournal.Validate("Account Type");
                        GenJournal."Account No." := PostedParkHeaderRec."Customer No.";
                        GenJournal."Document No." := PostedParkHeaderRec."No.";
                        GenJournal.Validate("Document No.");

                        GenJournal.Amount := PostedParkHeaderRec."Total Amount";
                        GenJournal.Validate(Amount);
                        GenJournal."Bal. Account Type" := GenJournal."Bal. Account Type"::"G/L Account";
                        GenJournal.Validate("Bal. Account Type");
                        GenJournal."Bal. Account No." := '2910';
                        GenJournal.Validate("Bal. Account No.");
                        GenJournal."Journal Template Name" := 'GENERAL';
                        GenJournal.Validate("Journal Template Name");
                        GenJournal."Journal Batch Name" := 'CASH';
                        GenJournal.Validate("Journal Batch Name");
                        CurrRec.Get;
                        GenJournal."Currency Code" := CurrRec.GetCurrencyCode('');
                        GenJournal.Validate("Currency Code");

                        GenJournal.Insert;
                        //Posting codeunit

                        SingleInstanceCU.Set_HideDialog(true);
                        SingleInstanceCU.Set_isHandled(true);
                        PostCU.Run(GenJournal);
                        SingleInstanceCU.Set_isHandled(false);
                        SingleInstanceCU.Set_HideDialog(false);

                        GenJournal.Reset;


                        GenJournal."Posting Date" := CalcDate('<CM+365D>', Today);
                        GenJournal.Validate("Posting Date");
                        GenJournal.Description := PostedParkHeaderRec."Customer Name";
                        GenJournal."Document Type" := 1;
                        GenJournal.Validate("Document Type");
                        GenJournal."Account Type" := 1;
                        GenJournal.Validate("Account Type");
                        GenJournal."Account No." := PostedParkHeaderRec."Customer No.";
                        GenJournal."Document No." := 'Payment ' + PostedParkHeaderRec."No.";
                        GenJournal.Validate("Document No.");
                        GenJournal."Applies-to Doc. Type" := GenJournal."Applies-to Doc. Type"::Invoice;
                        GenJournal.Amount := PostedParkHeaderRec."Total Amount" * -1;
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
                        GenJournal."Applies-to Doc. No." := PostedParkHeaderRec."No.";
                        GenJournal.Insert;


                        //Post payment

                        SingleInstanceCU.Set_HideDialog(true);
                        SingleInstanceCU.Set_isHandled(true);
                        PostCU.Run(GenJournal);
                        SingleInstanceCU.Set_isHandled(false);
                        SingleInstanceCU.Set_HideDialog(false);

                    end;


        ParkJournalLineRec.Reset;






        if (CustomerRec."Customer Type" = 0) or (CustomerRec."Customer Type" = 1) then begin
            ParkJournalLineRec.SetFilter("Document No.", PostedParkHeaderRec."No.");
            if ParkJournalLineRec.Find('-') then begin
                repeat

                    if ParkLedgerEntry.Find('-') then begin
                        repeat
                            LineNo := ParkLedgerEntry."Entry No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until ParkLedgerEntry.Next = 0;
                    end;



                    ParkLedgerEntry.Init;

                    ParkLedgerEntry."Entry No." := MaxAmt + 2;

                    ParkLedgerEntry."Customer No." := ParkJournalLineRec."Customer No.";
                    ParkLedgerEntry."Document No." := 'Payment ' + Format(ParkLedgerEntry."Entry No.");
                    ParkLedgerEntry."Posting Date" := ParkJournalLineRec."Posting Date";
                    ParkLedgerEntry."Customer  Name" := ParkJournalLineRec."Customer  Name";
                    ParkLedgerEntry."Car No." := ParkJournalLineRec."Car No.";
                    ParkLedgerEntry."Park Time" := ParkJournalLineRec."Park Time";
                    ParkLedgerEntry.Amount := ParkJournalLineRec.Amount;
                    ParkLedgerEntry.Type := ParkJournalLineRec.Type;

                    ParkLedgerEntry."Ledger Type" := 1;
                    ParkLedgerEntry.Open := false;
                    ParkLedgerEntry.Insert;
                    ParkJournalLineRec.Delete;



                    ParkLedgerEntry.Init;
                    ParkLedgerEntry."Applies To Doc" := Format(MaxAmt + 2);
                    ParkLedgerEntry."Entry No." := MaxAmt + 1;
                    ParkLedgerEntry."Customer No." := ParkJournalLineRec."Customer No.";
                    ParkLedgerEntry."Document No." := ParkJournalLineRec."Document No.";
                    ParkLedgerEntry."Posting Date" := ParkJournalLineRec."Posting Date";
                    ParkLedgerEntry."Customer  Name" := ParkJournalLineRec."Customer  Name";
                    ParkLedgerEntry."Car No." := ParkJournalLineRec."Car No.";
                    ParkLedgerEntry."Park Time" := ParkJournalLineRec."Park Time";
                    ParkLedgerEntry.Amount := ParkJournalLineRec.Amount * -1;
                    ParkLedgerEntry.Type := ParkJournalLineRec.Type;
                    ParkLedgerEntry."Ledger Type" := 0;
                    ParkLedgerEntry.Open := false;
                    ParkLedgerEntry.Insert;

                until ParkJournalLineRec.Next = 0;
            end;

        end
        else begin

            ParkJournalLineRec.SetFilter("Document No.", PostedParkHeaderRec."No.");
            ParkJournalLineRec.SetFilter("Customer No.", PostedParkHeaderRec."Customer No.");
            if ParkJournalLineRec.Find('-') then begin
                repeat


                    if ParkLedgerEntry.Find('-') then begin
                        repeat
                            LineNo := ParkLedgerEntry."Entry No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until ParkLedgerEntry.Next = 0;
                    end;

                    ParkLedgerEntry.Init;

                    ParkLedgerEntry."Entry No." := MaxAmt + 1;
                    ParkLedgerEntry."Customer No." := ParkJournalLineRec."Customer No.";
                    ParkLedgerEntry."Document No." := ParkJournalLineRec."Document No.";
                    ParkLedgerEntry."Posting Date" := ParkJournalLineRec."Posting Date";
                    ParkLedgerEntry."Customer  Name" := ParkJournalLineRec."Customer  Name";
                    ParkLedgerEntry."Car No." := ParkJournalLineRec."Car No.";
                    ParkLedgerEntry."Park Time" := ParkJournalLineRec."Park Time";
                    ParkLedgerEntry.Amount := ParkJournalLineRec.Amount * -1;
                    ParkLedgerEntry.Type := ParkJournalLineRec.Type;
                    ParkLedgerEntry."Ledger Type" := 0;
                    ParkLedgerEntry.Open := true;
                    ParkLedgerEntry.Insert;

                until ParkJournalLineRec.Next = 0;
                ParkJournalLineRec.DeleteAll;

            end;
        end;
    end;

    procedure PrintAbo(DocNo: Code[20])
    var
        AbonementRep: Report "Abonement Cheque";
        ParkHeaderrc: Record "Park Header";
    begin
        if ParkHeaderrc.Get(DocNo) then begin
            Clear(AbonementRep);
            AbonementRep.SetData(ParkHeaderrc."Customer Name", ParkHeaderrc.Address, ParkHeaderrc."Post Code", ParkHeaderrc.City, ParkHeaderrc."Total Amount");
            AbonementRep.SetTableView(ParkHeaderrc);
            AbonementRep.RunModal;
        end;
    end;


}

