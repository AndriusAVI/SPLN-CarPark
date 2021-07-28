table 50050 "Park Line"
{

    fields
    {
        field(10; "Park Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE (IsParkCustomer = FILTER (true));
        }
        field(20; "Vehicle No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Customer No." = FILTER (<> ' ')) "Customer Vehicle"."License Plate Number" WHERE ("Customer No." = FIELD ("Customer No."));

            trigger OnValidate()
            begin
                ParkHeaderCusNo.SetFilter("No.", "Park Order No.");
                if ParkHeaderCusNo.FindFirst then begin
                    if ParkHeaderCusNo."Customer No." = '' then begin
                        Vehicle.SetFilter("License Plate Number", "Vehicle No.");
                        if Vehicle.FindFirst then begin
                            ParkHeaderCusNo."Customer No." := Vehicle."Customer No.";
                            ParkHeaderCusNo.Modify;
                            ParkHeaderCusNo.Validate("Customer No.", Vehicle."Customer No.");
                        end
                        else
                            ParkHeaderCusNo.Validate("Customer No.", 'GUEST');
                    end;
                end;

            end;
        }
        field(23; "Park City"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Park Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Park Site"."No.";

            trigger OnValidate()
            begin
                if ParkSite.Get(LocationGet.GetLocation)
                  then begin

                    ParkSiteCount.SetFilter("Park Location", LocationGet.GetLocation);
                    CarCount := ParkSiteCount.Count;

                    if ParkSite."Total Spaces" <= CarCount then begin
                        Error('There is no parking space left in this parking lot');
                    end

                    else begin
                        "Park City" := ParkSite.City;
                        "Park Location Address" := ParkSite.Address;
                    end;

                end
                else
                    if ParkSite.Get("Park Location") then begin
                        ParkSiteCount.SetFilter("Park Location", "Park Location");
                        CarCount := ParkSiteCount.Count;
                        Message(Format(CarCount));
                        if ParkSite."Total Spaces" <= CarCount then begin
                            Error('There is no parking space left in this parking lot');
                        end
                        else begin
                            "Park City" := ParkSite.City;
                            "Park Location Address" := ParkSite.Address;
                        end;
                    end;
            end;
        }
        field(25; "Park Location Address"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Parking Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Parking End Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50; Price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Park Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if ParkHeader.Get("Park Order No.") then
            if CustomerRec.Get(ParkHeader."Customer No.") then
                ParkHeader.CalcFields("Car Count");
        if ParkHeader."Car Count" >= 1 then begin
            Error('One line per park', "Park Order No.");
        end
        else
            if (CustomerRec."Customer Type" = 1) then begin
                Error('Register car traffic for abonement users in other page');
            end
            else begin
                if LocationGet.GetLocation <> ''
         then begin
                    "Park Location" := LocationGet.GetLocation;
                    Validate("Park Location");
                end;
                if "Park Order No." <> ''
                  then begin
                    if ParkHeader.Get("Park Order No.")
                      then begin
                        "Customer No." := ParkHeader."Customer No.";
                    end
                    else begin
                        if PostedParkHeader.Get("Park Order No.") then
                            "Customer No." := PostedParkHeader."Customer No.";
                    end;
                    "Parking Date" := CurrentDateTime;
                end;
            end;
    end;

    trigger OnModify()
    begin
        if PostedParkHeader.Get("Park Order No.") then begin
            if ("Parking Date" <> 0DT) and ("Parking End Date" <> 0DT) then
                Price := 0;
        end
        else begin
            if ("Parking Date" <> 0DT) and ("Parking End Date" <> 0DT) then begin
                if ParkHeader.Get("Park Order No.") then begin
                    CustomerRec.SetFilter("No.", ParkHeader."Customer No.");
                    if CustomerRec.FindFirst then begin
                        if CustomerRec."Customer Type" = 0 then begin
                            ParkPrices.SetFilter("Customer Type", 'Guest');
                            if ParkPrices.Find('-') then begin

                                Duration := "Parking End Date" - "Parking Date";
                                Hoursdur := ((Duration / 1000) / 60) / 60;
                                ParkPrices.SetFilter(Hours, '>=%1', Hoursdur);
                                if not ParkPrices.FindLast then begin
                                    ParkPrices.Reset;
                                    ParkPrices.SetFilter("Customer Type", 'Guest');
                                    if ParkPrices.Find('-') then begin
                                        MinRate := ParkPrices.Hours;
                                        repeat
                                            if MinRate < ParkPrices.Hours then
                                                MinRate := ParkPrices.Hours;
                                        until ParkPrices.Next = 0;
                                    end;
                                    ParkPrices.SetFilter(Hours, Format(MinRate));
                                end;

                                ParkPrc.Reset;
                                ParkPrc.SetFilter("Customer Type", 'Guest');
                                if ParkPrc.Find('-') then begin
                                    MinVar := ParkPrices.Hours;
                                    repeat
                                        if MinVar > ParkPrc.Hours then
                                            MinVar := ParkPrc.Hours;
                                    until ParkPrc.Next = 0;
                                end;



                                ParkPrices.FindFirst;

                                if MinVar > Hoursdur then begin
                                    ParkPrices.Reset;
                                    ParkPrices.SetFilter("Customer Type", 'MINGuest');
                                    ParkPrices.FindFirst;
                                    Hoursdur := Round(Hoursdur, 1, '<') + 1;
                                    Price := ParkPrices.Rate * Hoursdur;
                                end else begin
                                    Hoursdur := Round(Hoursdur, 1, '<') + 1;
                                    Price := ParkPrices.Rate * Hoursdur;
                                end;



                            end;
                        end
                        else begin
                            if CustomerRec."Customer Type" = 2 then begin
                                ParkPrices.SetFilter("Customer Type", 'Monthly');
                                if ParkPrices.Find('-') then begin
                                    Duration := "Parking End Date" - "Parking Date";
                                    Hoursdur := ((Duration / 1000) / 60) / 60;
                                    ParkPrices.SetFilter(Hours, '>=%1', Hoursdur);
                                    if not ParkPrices.IsEmpty then begin
                                        ParkPrices.FindFirst;
                                        Hoursdur := Round(Hoursdur, 1, '<') + 1;
                                        Price := ParkPrices.Rate * Hoursdur;

                                    end
                                    else begin
                                        ParkPrices.Reset;
                                        ParkPrices.SetFilter("Customer Type", 'Monthly');
                                        if ParkPrices.Find('-') then begin
                                            MinRate := ParkPrices.Hours;
                                            repeat
                                                if MinRate < ParkPrices.Hours then
                                                    MinRate := ParkPrices.Hours;
                                            until ParkPrices.Next = 0;
                                        end;

                                        ParkPrices.Reset;
                                        ParkPrices.SetFilter("Customer Type", 'Monthly');
                                        ParkPrices.SetFilter(Hours, Format(MinRate));
                                        Hoursdur := Round(Hoursdur, 1, '<') + 1;
                                        if ParkPrices.FindFirst then
                                            Price := ParkPrices.Rate * Hoursdur;
                                    end;
                                end;
                            end;



                        end;
                    end;
                end;
                if CustomerRec."Customer Type" = 0 then begin
                    Clear(OneTimeCheque);
                    OneTimeCheque.SetData("Vehicle No.", ParkPrices.Rate, Hoursdur, ParkPrices.Rate * Hoursdur, "Parking Date", "Parking End Date");
                    OneTimeCheque.SetTableView(Rec);
                    Message('Vehicle Out');
                    OneTimeCheque.RunModal;


                    //ELSE BEGIN
                end;
                if CustomerRec."Customer Type" = 2 then begin
                    Clear(ParkingRep);
                    ParkingRep.SetData("Vehicle No.", "Parking End Date" - "Parking Date", "Parking Date", "Parking End Date", ParkPrices.Rate * Hoursdur);
                    Message('Vehicle Out');
                    ParkingRep.RunModal;
                end;


            end;
        end;
    end;

    var
        ParkPrices: Record "Parking Prices";
        ParkHeader: Record "Park Header";
        LocationGet: Codeunit "Employee Location";
        ParkSite: Record "Park Site";
        Duration: Duration;
        Hoursdur: Decimal;
        CustomerRec: Record Customer;
        MinRate: Decimal;
        ParkLineRec: Record "Park Line";
        OneTimeCheque: Report ChequeOneTimeUser;
        Vehicle: Record "Customer Vehicle";
        PostedParkHeader: Record "Posted Park Header";
        ParkHeaderCusNo: Record "Park Header";
        CarCount: Integer;
        ParkSiteCount: Record "Park Line";
        ParkPrc: Record "Parking Prices";
        MinVar: Decimal;
        ParkingRep: Report ParkingTicket;
}

