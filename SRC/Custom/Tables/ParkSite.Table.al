table 50030 "Park Site"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Address; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(30; City; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Total Spaces"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Taken Spaces"; Integer)
        {
            CalcFormula = Count ("Park Line" WHERE ("Park Location" = FIELD ("No.")));
            FieldClass = FlowField;
        }
        field(60; "Free Spaces"; Integer)
        {
            FieldClass = Normal;
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
        fieldgroup(DropDown; "No.", City, Address)
        {
        }
    }
}

