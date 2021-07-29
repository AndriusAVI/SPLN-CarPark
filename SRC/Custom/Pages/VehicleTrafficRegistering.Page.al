page 50270 "Vehicle Traffic Registering"
{
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {

            field("Licence Plate"; VehReg)
            {
                ShowMandatory = true;
                StyleExpr = TRUE;

                trigger OnValidate()
                begin
                    if VehReg = '' then begin
                        exit;
                    end
                    else
                        if (StrLen(VehReg) <> 7) then begin
                            Error('Invalid vehicle number');
                        end
                        else begin
                            RegF(VehReg);
                            VehReg := '';
                        end;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Free Spaces")
            {
                Image = ItemGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Free Spaces";
            }
            action("Parking Durations")
            {
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Parking Time";
            }
        }
    }

    var
        VehicleReg: Code[20];
        ParkHeader: Record "Park Header";
        ParkLine: Record "Park Line";
        CusV: Record "Customer Vehicle";
        Cus: Record Customer;
        Emp: Record Employee;
        EmpLoc: Codeunit "Employee Location";
        LineNo: Integer;
        MaxAmt: Integer;
        ParkLineNomax: Record "Park Line";
        ParkLoc: Record "Park Site";
        ParkLineIF: Record "Park Line";
        ParkCount: Integer;
        ParkLocationF: Record "Park Site";
        PParkHeader: Record "Posted Park Header";
        PParkLine: Record "Posted Park Line";
        ParkingSetup: Record "Parking Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ParkingTicket: Report ParkingTicket;
        Durationn: Duration;
        ParkPost: Codeunit ParkPosting;
        ifans: Boolean;
        Text0025: Text[250];
        ifnot: Boolean;
        CustomerNewPG: Page CustomerNewFromDialog;
        VehReg: Code[20];
        ParkPrices: Record "Parking Prices";
        AbonementRep: Report "Abonement Cheque";
        ParkJournalLine: Record "Park Journal Line";
        ParkLedgerEntry: Record "Park Ledger Entry";
        ParkJournalLineRec: Record "Park Journal Line";
        MaxAmmt: Integer;
        PARKHEADERREP: Record "Park Header";

    procedure ValidateField()
    begin
    end;

    procedure RegF(VehNo: Code[20])
    begin
        ParkLine.SetFilter("Vehicle No.", VehNo);
        if ParkLine.FindFirst then begin

            Cus.SetFilter("No.", ParkLine."Customer No.");
            if Cus.FindFirst then
                if (Cus."Customer Type" = 0) or (Cus."Customer Type" = 2) then begin

                    if ParkLine."Parking Date" > CurrentDateTime then
                        Error('Park date cant be later than now');
                    ParkLine."Parking End Date" := CurrentDateTime;
                    ParkLine.Modify(true);
                    ParkLine.Validate("Parking End Date");
                    ParkHeader.Get(ParkLine."Park Order No.");
                    if Cus.Get(ParkHeader."Customer No.") then
                        if Cus."Customer Type" = 0 then begin
                            ParkPost.Post(ParkHeader);
                        end;


                    if Cus.Get(ParkHeader."Customer No.") then
                        if Cus."Customer Type" = 2 then begin
                            ParkPost.Post(ParkHeader);

                        end;

                end //Guest , Montlhy
                else begin

                    PParkLine.SetFilter("Park Order No.", ParkLine."Park Order No.");

                    if PParkLine.Find('-') then begin
                        repeat
                            LineNo := PParkLine."Line No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until PParkLine.Next = 0;
                    end;
                    MaxAmt := MaxAmt + 1;

                    PParkLine.Init;
                    PParkLine."Park Order No." := ParkLine."Park Order No.";
                    PParkLine."Line No." := MaxAmt;
                    PParkLine."Customer No." := ParkLine."Customer No.";
                    PParkLine."Vehicle No." := ParkLine."Vehicle No.";
                    PParkLine."Park City" := ParkLine."Park City";
                    PParkLine."Park Location" := ParkLine."Park Location";
                    PParkLine."Park Location Address" := ParkLine."Park Location Address";
                    PParkLine."Parking Date" := ParkLine."Parking Date";
                    PParkLine."Parking End Date" := CurrentDateTime;
                    PParkLine.Price := 0;

                    if ParkJournalLine.Find('-') then begin
                        repeat
                            LineNo := ParkJournalLine."Entry No.";
                            if LineNo > MaxAmt then
                                MaxAmt := LineNo;
                        until ParkJournalLine.Next = 0;
                    end;
                    MaxAmt := MaxAmt + 1;

                    ParkJournalLine.Init;
                    ParkJournalLine."Entry No." := MaxAmt;
                    ParkJournalLine."Customer No." := PParkLine."Customer No.";
                    ParkJournalLine."Document No." := PParkLine."Park Order No.";
                    ParkJournalLine."Posting Date" := Today;
                    if Cus.Get(PParkLine."Customer No.") then
                        ParkJournalLine."Customer  Name" := Cus.Contact;
                    ParkJournalLine."Car No." := PParkLine."Vehicle No.";
                    Durationn := PParkLine."Parking End Date" - PParkLine."Parking Date";
                    ParkJournalLine."Park Time" := Durationn;
                    ParkJournalLine.Amount := 0;
                    ParkJournalLine.Type := 0;




                    Message('Vehicle Out');
                    Clear(ParkingTicket);


                    ParkingTicket.SetData(PParkLine."Vehicle No.", Durationn, PParkLine."Parking Date", PParkLine."Parking End Date", 0);
                    ParkingTicket.RunModal;
                    ParkJournalLine.Insert;
                    PParkLine.Insert;


                    ParkJournalLineRec.SetFilter("Document No.", PParkLine."Park Order No.");
                    if ParkJournalLineRec.Find('-') then begin
                        repeat

                            if ParkLedgerEntry.Find('-') then begin
                                repeat
                                    LineNo := ParkLedgerEntry."Entry No.";
                                    if LineNo > MaxAmmt then
                                        MaxAmmt := LineNo;
                                until ParkLedgerEntry.Next = 0;
                            end;
                            ParkLedgerEntry.Init;
                            ParkLedgerEntry."Entry No." := MaxAmmt + 1;
                            ParkLedgerEntry."Applies To Doc" := Format(MaxAmmt + 2);
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


                            ParkLedgerEntry.Init;

                            ParkLedgerEntry."Entry No." := MaxAmmt + 2;

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
                        until ParkJournalLineRec.Next = 0;
                    end;


                    ParkLine.Delete;

                end; //Abonement

        end
        else begin
            CusV.Reset;
            CusV.SetFilter("License Plate Number", VehNo);
            if CusV.FindFirst then begin
                Cus.SetFilter("No.", CusV."Customer No.");
            end
            else
                Cus.SetFilter("No.", 'GUEST');
            if Cus.FindFirst then
                if Cus."Customer Type" = 1 then begin

                    ParkLineIF.SetFilter("Park Location", EmpLoc.GetLocation);
                    ParkCount := ParkLineIF.Count;
                    ParkLocationF.SetFilter("No.", EmpLoc.GetLocation);
                    if ParkLocationF.FindFirst then
                        if ParkLocationF."Total Spaces" > ParkCount then begin


                            PParkHeader.SetFilter("Customer No.", Cus."No.");
                            PParkHeader.SetFilter("Customer Type", 'Abonement');
                            PParkHeader.SetFilter(Invalid, Format(false));
                            if PParkHeader.FindFirst then begin

                                ParkLine.Init;
                                ParkLine."Park Order No." := PParkHeader."No.";

                                ParkLineNomax.SetFilter("Park Order No.", PParkHeader."No.");
                                if ParkLineNomax.Find('-') then begin
                                    repeat
                                        LineNo := ParkLineNomax."Line No.";
                                        if LineNo > MaxAmt then
                                            MaxAmt := LineNo;
                                    until ParkLineNomax.Next = 0;
                                end;

                                ParkLine."Line No." := MaxAmt + 1;
                                ParkLine."Vehicle No." := VehNo;
                                ParkLine."Customer No." := Cus."No.";
                                if ParkLoc.Get(EmpLoc.GetLocation) then begin
                                    ParkLine."Park City" := ParkLoc.City;
                                    ParkLine."Park Location" := ParkLoc."No.";
                                    ParkLine."Park Location Address" := ParkLoc.Address;
                                end;
                                ParkLine."Parking Date" := CurrentDateTime;
                                ParkLine.Insert;
                                Message('Vehicle In');
                            end
                            else begin


                                if DIALOG.Confirm('This abonement does not have any valid agreements, do you want to create one?') then begin
                                    //begin

                                    Emp.SetFilter(User, UserSecurityId);
                                    if Emp.FindFirst then
                                        ParkHeader.Init;
                                    //from here

                                    ParkHeader."Employee No." := Emp."No.";
                                    ParkHeader."Customer No." := Cus."No.";
                                    ParkHeader.Validate("No."); //changed
                                    ParkHeader."Document Date" := Today;
                                    ParkPrices.SetFilter("Customer Type", 'Abonement');
                                    ParkPrices.FindFirst;
                                    ParkHeader."Total Amount" := ParkPrices.Rate;
                                    ParkHeader."Customer Name" := Cus.Contact;
                                    ParkHeader.Address := Cus.Address;
                                    ParkHeader."Post Code" := Cus."Post Code";
                                    ParkHeader.City := Cus.City;



                                    ParkHeader.Insert;


                                    ParkHeader.Modify(true);
                                    Message('Vehicle In');
                                    Commit;
                                    Clear(AbonementRep);

                                    AbonementRep.SetData(ParkHeader."Customer Name", ParkHeader.Address, ParkHeader."Post Code", ParkHeader.City, ParkHeader."Total Amount");
                                    AbonementRep.SetTableView(ParkHeader);
                                    AbonementRep.RunModal;

                                    ParkPost.Post(ParkHeader);

                                    CusV.Reset;
                                    CusV.SetFilter("License Plate Number", VehNo);
                                    if CusV.FindFirst then
                                        Cus.SetFilter("No.", CusV."Customer No.");
                                    Cus.FindFirst;
                                    ParkLineIF.SetFilter("Park Location", EmpLoc.GetLocation);
                                    ParkCount := ParkLineIF.Count;
                                    ParkLocationF.SetFilter("No.", EmpLoc.GetLocation);
                                    if ParkLocationF.FindFirst then
                                        if ParkLocationF."Total Spaces" > ParkCount then begin


                                            PParkHeader.SetFilter("Customer No.", Cus."No.");
                                            PParkHeader.SetFilter("Customer Type", 'Abonement');
                                            PParkHeader.SetFilter(Invalid, Format(false));
                                            if PParkHeader.FindFirst then begin

                                                ParkLine.Init;
                                                ParkLine."Park Order No." := PParkHeader."No.";

                                                ParkLineNomax.SetFilter("Park Order No.", PParkHeader."No.");
                                                if ParkLineNomax.Find('-') then begin
                                                    repeat
                                                        LineNo := ParkLineNomax."Line No.";
                                                        if LineNo > MaxAmt then
                                                            MaxAmt := LineNo;
                                                    until ParkLineNomax.Next = 0;
                                                end;

                                                ParkLine."Line No." := MaxAmt + 1;
                                                ParkLine."Vehicle No." := VehNo;
                                                ParkLine."Customer No." := Cus."No.";
                                                if ParkLoc.Get(EmpLoc.GetLocation) then begin
                                                    ParkLine."Park City" := ParkLoc.City;
                                                    ParkLine."Park Location" := ParkLoc."No.";
                                                    ParkLine."Park Location Address" := ParkLoc.Address;
                                                end;
                                                ParkLine."Parking Date" := CurrentDateTime;

                                                ParkLine.Insert;

                                            end
                                        end;

                                    //end


                                end;

                            end;


                        end
                        else
                            if ParkLocationF."Total Spaces" <= ParkCount then
                                Error('There is no spaces left in this parking lot');


                end
                else begin

                    ParkHeader.Reset;
                    ParkHeader.Init;
                    ParkHeader."No." := '';
                    //from here;
                    ParkHeader."Document Date" := Today;
                    ParkLineIF.SetFilter("Park Location", EmpLoc.GetLocation);
                    ParkCount := ParkLineIF.Count;
                    ParkLocationF.SetFilter("No.", EmpLoc.GetLocation);
                    if ParkLocationF.FindFirst then
                        if ParkLocationF."Total Spaces" > ParkCount then begin
                            Emp.SetFilter(User, UserSecurityId);
                            if Emp.FindFirst then
                                ParkHeader."Employee No." := Emp."No.";

                            CusV.SetFilter("License Plate Number", VehNo);
                            if CusV.FindFirst then begin
                                Cus.SetFilter("No.", CusV."Customer No.");
                                if Cus.FindFirst then begin
                                    ParkHeader."Customer No." := Cus."No.";
                                    ParkHeader."Customer Name" := Cus.Contact;
                                    ParkHeader.Validate("No."); //changed
                                    ParkHeader.Address := Cus.Address + '' + Cus."Address 2";
                                    ParkHeader."Post Code" := Cus."Post Code";
                                    ParkHeader.City := Cus.City;
                                end;
                                ParkHeader.Insert;
                                ParkLine.Init;
                                ParkLine."Park Order No." := ParkHeader."No.";

                                ParkLineNomax.SetFilter("Park Order No.", ParkHeader."No.");
                                if ParkLineNomax.Find('-') then begin
                                    repeat
                                        LineNo := ParkLineNomax."Line No.";
                                        if LineNo > MaxAmt then
                                            MaxAmt := LineNo;
                                    until ParkLineNomax.Next = 0;
                                end;
                                ParkLine."Line No." := MaxAmt + 1;
                                ParkLine."Customer No." := ParkHeader."Customer No.";
                                ParkLine."Vehicle No." := VehNo;
                                if ParkLoc.Get(EmpLoc.GetLocation) then begin
                                    ParkLine."Park City" := ParkLoc.City;
                                    ParkLine."Park Location" := ParkLoc."No.";
                                    ParkLine."Park Location Address" := ParkLoc.Address;
                                end;
                                ParkLine."Parking Date" := CurrentDateTime;
                                ParkLine.Insert;
                                Message('Vehicle in');


                            end
                            else begin
                                //guest
                                Emp.SetFilter(User, UserSecurityId);
                                if Emp.FindFirst then
                                    ParkHeader."Employee No." := Emp."No.";

                                Cus.SetFilter("No.", 'GUEST');
                                if DIALOG.Confirm('Do you want to create this customer?') then begin
                                    Commit;
                                    Clear(CustomerNewPG);
                                    CustomerNewPG.SetData(VehNo);
                                    CustomerNewPG.RunModal;



                                end
                                else begin
                                    if Cus.FindFirst then begin

                                        ParkHeader."Customer No." := Cus."No.";
                                        ParkHeader."Customer Name" := Cus.Contact;
                                        ParkHeader.Validate("No.");
                                        ParkHeader.Address := Cus.Address + '' + Cus."Address 2";
                                        ParkHeader."Post Code" := Cus."Post Code";
                                        ParkHeader.City := Cus.City;
                                    end;


                                    ParkHeader.Insert;
                                    ParkLine.Init;
                                    ParkLine."Park Order No." := ParkHeader."No.";
                                    ParkLine."Customer No." := ParkHeader."Customer No.";
                                    ParkLineNomax.SetFilter("Park Order No.", ParkHeader."No.");
                                    if ParkLineNomax.Find('-') then begin
                                        repeat
                                            LineNo := ParkLineNomax."Line No.";
                                            if LineNo > MaxAmt then
                                                MaxAmt := LineNo;
                                        until ParkLineNomax.Next = 0;
                                    end;

                                    ParkLine."Line No." := MaxAmt + 1;
                                    ParkLine."Vehicle No." := VehNo;
                                    if ParkLoc.Get(EmpLoc.GetLocation) then begin
                                        ParkLine."Park City" := ParkLoc.City;
                                        ParkLine."Park Location" := ParkLoc."No.";
                                        ParkLine."Park Location Address" := ParkLoc.Address;
                                    end;
                                    ParkLine."Parking Date" := CurrentDateTime;
                                    ParkLine.Insert;
                                    Message('Vehicle in');
                                end;

                            end;


                        end
                        else
                            Error('There is no space left in this parking lot');

                end;

        end;
    end;
}

