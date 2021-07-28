table 50060 "Parking Setup"
{

    fields
    {
        field(10; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Park Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(30; "Posted Park Nos."; Code[20])
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

