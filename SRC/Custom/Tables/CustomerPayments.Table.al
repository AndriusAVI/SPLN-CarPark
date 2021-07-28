table 50130 "Customer Payments"
{

    fields
    {
        field(10; "Entry No."; Code[20])
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
        field(40; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Invoice,Payment;
        }
        field(50; "Customer  Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Car No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Park Time"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(80; Amount; Decimal)
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

