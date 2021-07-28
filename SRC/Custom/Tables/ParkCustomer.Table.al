table 50010 "Park Customer"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if CustomerRec.Get("No.") then begin
                    "Full Name" := CustomerRec.Contact;
                    City := CustomerRec.City;
                    Address := CustomerRec.Address;
                    Address2 := CustomerRec."Address 2";
                    "Post Code" := CustomerRec."Post Code";
                end;
            end;
        }
        field(20; "Full Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Customer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Guest,Abonement,Monthly;
        }
        field(35; City; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(40; Address; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(45; Address2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".Code;
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
        fieldgroup(DropDown; "No.", "Full Name", "Customer Type")
        {
        }
    }

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomerSetup: Record "Customer Setup";
        CustomerRec: Record Customer;
}

