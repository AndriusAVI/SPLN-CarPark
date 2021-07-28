report 50060 CustomerTypeInvoice
{
    //   PParkLine.SETFILTER("Park Order No.",PostedParkHeader."No.");
    //      IF PParkLine.FIND('-')
    //   THEN
    //   REPEAT
    // CustomerRec.RESET;
    // CustomerRec.SETFILTER("No.",PParkLine."Customer No.");
    // IF CustomerRec.FINDFIRST THEN
    //   IF CustomerRec."Customer Type"=0 THEN BEGIN
    //     PriceGuest:=PriceGuest+PParkLine.Price;
    //     END
    //     ELSE
    //     IF CustomerRec."Customer Type"=2 THEN
    //       PriceMonthly:=PriceMonthly+PParkLine.Price;
    //   UNTIL PParkLine.NEXT =0;
    // 
    //   PostedParkHeader.SETFILTER("Customer Type",'Abonement');
    //   IF PostedParkHeader.FIND('-') THEN
    //     REPEAT
    // PriceAbonement:=PriceAbonement+PostedParkHeader."Total Amount";
    //       UNTIL PostedParkHeader.NEXT=0;
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerTypeInvoice.rdlc';

    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Park Line"; "Posted Park Line")
        {
            column(DateFrom; DateFrom)
            {
            }
            column(DateTo; DateTo)
            {
            }
            column(PriceGGuest; PriceGuest)
            {
            }
            column(PriceMMonthly; PriceMonthly)
            {
            }
            column(PriceAAbonement; PriceAbonement)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; DateFrom)
                {
                }
                field("To Date"; DateTo)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (DateFrom <> 0D) and (DateTo <> 0D) then
            PostedParkHeader.SetRange("Document Date", DateFrom, DateTo);
        if PostedParkHeader.Find('-') then begin
            repeat
                PParkLine.Reset;
                PParkLine.SetFilter("Park Order No.", PostedParkHeader."No.");
                if PParkLine.FindFirst then
                    CustomerRec.Reset;
                CustomerRec.SetFilter("No.", PParkLine."Customer No.");
                if CustomerRec.FindFirst then
                    if CustomerRec."Customer Type" = 0 then begin
                        PriceGuest := PriceGuest + PParkLine.Price;
                    end
                    else
                        if CustomerRec."Customer Type" = 2 then
                            PriceMonthly := PriceMonthly + PParkLine.Price;


                if PostedParkHeader."Customer Type" = 1 then
                    PriceAbonement := PriceAbonement + PostedParkHeader."Total Amount";
            until PostedParkHeader.Next = 0;
        end;

    end;

    var
        PostedParkHeader: Record "Posted Park Header";
        DateFrom: Date;
        DateTo: Date;
        CustomerType: Option;
        CustomerRec: Record Customer;
        PriceGuest: Decimal;
        PriceAbonement: Decimal;
        PriceMonthly: Decimal;
        PParkLine: Record "Posted Park Line";
        MyFilter: Text[2048];
}

