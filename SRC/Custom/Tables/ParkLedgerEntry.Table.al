table 50140 "Park Ledger Entry"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Park Customer"."No.";
        }
        field(25; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Customer  Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Car No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Park Time"; Duration)
        {
            DataClassification = ToBeClassified;
        }
        field(80; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Parking Payment","Abonement Payment";
        }
        field(100; "Ledger Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Invoice,Payment;
        }
        field(110; Open; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Applies To Doc"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

