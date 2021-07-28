table 50110 "Posted Park Header"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Park Employee"."No.";
        }
        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(40; "Customer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Guest,Abonement,Monthly;
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
            DataClassification = ToBeClassified;
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
        field(106; Payed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(110; Invalid; Boolean)
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
}

