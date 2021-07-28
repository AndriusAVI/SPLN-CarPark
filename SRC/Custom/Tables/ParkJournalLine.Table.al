table 50120 "Park Journal Line"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
            AutoIncrement = true;
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

    var
        ParkJournalLineRec: Record "Park Journal Line";
}

