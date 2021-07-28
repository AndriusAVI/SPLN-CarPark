table 50000 "Customer Vehicle"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE (IsParkCustomer = FILTER (true));
        }
        field(30; Make; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(40; Model; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Color; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Country of Registration"; Text[5])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
        }
        field(60; "License Plate Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "License Plate Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

