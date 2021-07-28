table 50070 "Customer Setup"
{

    fields
    {
        field(10; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Customer Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

