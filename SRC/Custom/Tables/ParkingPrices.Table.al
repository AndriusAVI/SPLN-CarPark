table 50080 "Parking Prices"
{

    fields
    {
        field(10; "Customer Type"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Hours; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; Rate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Customer Type", Hours, Rate)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

