table 50020 "Park Employee"
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
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    "Full Name" := Employee.FullName;
                    Address := Employee.Address;
                    Address2 := Employee."Address 2";

                end;
            end;
        }
        field(30; "Employee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Admin,Manager,Watcher;
        }
        field(40; "Full Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Address; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(60; Address2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(110; User; Guid)
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Security ID";
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
        fieldgroup(DropDown; "No.", "Full Name", "Employee Type")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            EmpSetup.Get;
            EmpSetup.TestField("Emp Nos.");
            NoSeriesMgt.InitSeries(EmpSetup."Emp Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        Employee: Record Employee;
        EmpSetup: Record "Employee Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

