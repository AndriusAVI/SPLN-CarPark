page 50290 CustomerNewFromDialog
{
    PageType = StandardDialog;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group("New Customer")
            {
                field("Customer No"; "No.")
                {
                    TableRelation = Customer."No." WHERE (IsParkCustomer = FILTER (true));

                    trigger OnValidate()
                    begin

                        if CusFind.Get("No.") then begin
                            Name := CusFind.Name;
                            "Search Name" := CusFind."Search Name";
                            Contact := CusFind.Contact;
                            Address := CusFind.Address;
                            Address2 := CusFind."Address 2";
                            CustomerPostingGroup := CusFind."Customer Posting Group";
                            City := CusFind.City;
                            CRCode := CusFind."Country/Region Code";
                            PostCode := CusFind."Post Code";
                            "Customer Type" := CusFind."Customer Type";
                            "Country Of Registration" := CusFind."Country/Region Code";
                        end;

                    end;
                }
                field(" Name"; Name)
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field(Contact; Contact)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; Address2)
                {
                }
                field(CustomerPostingGroup; CustomerPostingGroup)
                {
                    TableRelation = "Customer Posting Group".Code;
                }
                field(CountryRegion; CRCode)
                {
                    TableRelation = "Country/Region".Code;
                }
                field(City; City)
                {
                }
                field("Post Code"; PostCode)
                {
                    TableRelation = "Post Code";
                }
                field("Customer Type"; "Customer Type")
                {
                }
                field("Vehicle No."; CarNo)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Make; Make)
                {
                }
                field(Model; Model)
                {
                }
                field(Color; Color)
                {
                }
                field("Country of Registration"; "Country Of Registration")
                {
                    TableRelation = "Country/Region".Code;
                }
                field("VehicleNo."; "License Plate Number")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        "License Plate Number" := VehicleNoVar;
        CustomerRec.Init;
        CustomerRec.Validate("No.");
        "No." := CustomerRec."No.";
        CustomerCar.Init;
        CustomerCar."Customer No." := CustomerRec."No.";
        CarNo := VehicleNoVar;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then begin
            if CustomerRec.Get("No.") then begin

                CustomerCar.Init;
                CustomerCar."Customer No." := "No.";
                CustomerCar."No." := CarNo;
                CustomerCar.Make := Make;
                CustomerCar.Model := Model;
                CustomerRec.IsParkCustomer := true;
                CustomerCar.Color := Color;
                CustomerCar."Country of Registration" := "Country Of Registration";
                CustomerCar."License Plate Number" := VehicleNoVar;
                CustomerCar."Country of Registration" := CRCode;
                CustomerCar.Insert;
                VehicleRegisteringPage.RegF(VehicleNoVar);
            end
            else begin
                CustomerRec.Name := Name;
                CustomerRec."Search Name" := "Search Name";
                CustomerRec.Address := Address;
                CustomerRec."Address 2" := Address2;
                CustomerRec.City := City;
                CustomerRec."Customer Type" := "Customer Type";
                CustomerRec.Contact := Contact;
                CustomerRec.City := City;
                CustomerRec."Customer Posting Group" := CustomerPostingGroup;
                CustomerCar."No." := CarNo;
                CustomerCar.Make := Make;
                CustomerCar.Model := Model;
                CustomerRec.IsParkCustomer := true;
                CustomerCar.Color := Color;
                CustomerCar."Country of Registration" := "Country Of Registration";
                CustomerCar."License Plate Number" := VehicleNoVar;
                CustomerRec."Post Code" := PostCode;
                CustomerCar.Insert;
                CustomerRec.Insert;
                VehicleRegisteringPage.RegF(VehicleNoVar);
            end;
        end
        else begin
            exit;
        end;
    end;

    var
        VehicleNoVar: Code[20];
        CustomerCar: Record "Customer Vehicle";
        CarNo: Code[20];
        CustomerNo: Code[20];
        Make: Text[150];
        Model: Text[150];
        Color: Text[150];
        "Country Of Registration": Text[5];
        "License Plate Number": Code[20];
        "No.": Code[20];
        Name: Text[150];
        "Search Name": Text[150];
        Contact: Text[150];
        Address: Text[150];
        Address2: Text[150];
        City: Text[150];
        "Customer Type": Option ,Abonement,Monthly;
        CustomerRec: Record Customer;
        VehicleRegisteringPage: Page "Vehicle Traffic Registering";
        PostCode: Code[20];
        CustomerPostingGroup: Code[20];
        CusFind: Record Customer;
        CRCode: Code[20];

    procedure SetData(VehicleNo: Code[20])
    begin
        VehicleNoVar := VehicleNo;
    end;
}

