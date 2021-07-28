page 50090 "Park Journal Line"
{
    CardPageID = "Park Journal Line Edit";
    PageType = List;
    SourceTable = "Park Journal Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Customer  Name"; "Customer  Name")
                {
                }
                field("Car No."; "Car No.")
                {
                }
                field("Park Time"; "Park Time")
                {
                }
                field(Amount; Amount)
                {
                    CaptionClass = TextCurrr;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post to Ledger")
            {
                Image = Post;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if ParkJournalLine.Find('-') then begin
                        repeat
                            ParkLedgerEntry.Init;
                            ParkLedgerEntry."Entry No." := ParkJournalLine."Entry No.";
                            ParkLedgerEntry."Customer No." := ParkJournalLine."Customer No.";
                            ParkLedgerEntry."Document No." := ParkJournalLine."Document No.";
                            ParkLedgerEntry."Posting Date" := ParkJournalLine."Posting Date";
                            ParkLedgerEntry."Customer  Name" := ParkJournalLine."Customer  Name";
                            ParkLedgerEntry."Car No." := ParkJournalLine."Car No.";
                            ParkLedgerEntry."Park Time" := ParkJournalLine."Park Time";
                            ParkLedgerEntry.Amount := ParkJournalLine.Amount;
                            ParkLedgerEntry.Type := ParkJournalLine.Type;
                            ParkLedgerEntry.Insert;
                            ParkJournalLine.Delete;
                        until ParkJournalLine.Next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        "Park Time" := Round("Park Time", 1000);
    end;

    trigger OnInit()
    begin
        GLSetup.Get;
        TextCurrr := StrSubstNo('Amount (%1)', GLSetup.GetCurrencySymbol);
    end;

    var
        ParkLedgerEntry: Record "Park Ledger Entry";
        ParkJournalLine: Record "Park Journal Line";
        GLSetup: Record "General Ledger Setup";
        TextCurrr: Text[250];
}

