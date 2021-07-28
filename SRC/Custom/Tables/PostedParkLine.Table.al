table 50100 "Posted Park Line"
{

    fields
    {
        field(10; "Park Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(20; "Vehicle No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Vehicle".Make WHERE ("Customer No." = FIELD ("Customer No."));
        }
        field(23; "Park City"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Park Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Park Site"."No.";
        }
        field(25; "Park Location Address"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Parking Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Parking End Date"; DateTime)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin


                //ELSE BEGIN
            end;
        }
        field(50; Price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; Payed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Park Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

