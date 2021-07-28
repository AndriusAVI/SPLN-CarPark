table 50040 "Park Header"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No." = '' then begin
                    if Customer.Get("Customer No.") then
                        if Customer."Customer Type" = Customer."Customer Type"::Guest then begin
                            ParkingSetup.Get(Format(2));
                            ParkingSetup.TestField("Park Nos.");
                            NoSeriesMgt.InitSeries(ParkingSetup."Park Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                        end
                        else
                            if Customer."Customer Type" = Customer."Customer Type"::Monthly then begin
                                ParkingSetup.Get(Format(3));
                                ParkingSetup.TestField("Park Nos.");
                                NoSeriesMgt.InitSeries(ParkingSetup."Park Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                            end
                            else
                                if Customer."Customer Type" = Customer."Customer Type"::Abonement then begin
                                    ParkingSetup.Get(Format(4));
                                    ParkingSetup.TestField("Park Nos.");
                                    NoSeriesMgt.InitSeries(ParkingSetup."Park Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                                end;

                end;
                "Document Date" := Today;
            end;
        }
        field(20; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Park Employee"."No.";
        }
        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE (IsParkCustomer = FILTER (true));

            trigger OnValidate()
            begin
                if Customer.Get("Customer No.") then
                    if Customer."Customer Type" = 1 then begin
                        ParkPrices.SetFilter("Customer Type", 'Abonement');
                        if ParkPrices.FindFirst then
                            "Total Amount" := ParkPrices.Rate;
                        "Customer Name" := Customer.Contact;
                        Address := Customer.Address;
                        "Post Code" := Customer."Post Code";
                        City := Customer.City;
                    end
                    else begin
                        "Total Amount" := 0;
                        "Customer Name" := Customer.Contact;
                        Address := Customer.Address;
                        "Post Code" := Customer."Post Code";
                        City := Customer.City;
                    end;
                Rec.Modify;

            end;
        }
        field(50; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Total Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(75; "Car Count"; Integer)
        {
            CalcFormula = Count ("Park Line" WHERE ("Park Order No." = FIELD ("No.")));
            FieldClass = FlowField;
        }
        field(80; "Customer Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(90; Address; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(105; City; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ParkingSetup: Record "Parking Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Customer: Record Customer;
        ParkSite: Record "Park Site";
        LocationGet: Codeunit "Employee Location";
        ParkPrices: Record "Parking Prices";
        AbonementRep: Report "Abonement Cheque";
}

