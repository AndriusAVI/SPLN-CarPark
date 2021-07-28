tableextension 50018 tableextension50018 extends Customer
{
    fields
    {

        //Unsupported feature: Code Modification on ""No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "No." <> xRec."No." then begin
          SalesSetup.Get;
          NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
          "No. Series" := '';
        end;
        if "Invoice Disc. Code" = '' then
          "Invoice Disc. Code" := "No.";
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7

        if "No." = '' then begin
          SalesSetup.Get;
          SalesSetup.TestField("Customer Nos.");
          NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
        */
        //end;
        field(850; "Customer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Guest,Abonement,Monthly;
        }
        field(860; IsParkCustomer; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

