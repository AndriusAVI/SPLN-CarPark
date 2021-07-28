codeunit 50100 "Employee Location"
}
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;
    Subtype = Normal;

    trigger OnRun()
    begin
    end;

    var
        Location: Code[20];
        ParkSite: Page "Park Site";

    procedure SetLocation(Loc: Code[20])
    begin
        Location := Loc;
    end;

    procedure GetLocation() Locc: Code[20]
    begin
        Locc := Location;
        exit(Locc);
    end;

    procedure RunRC()
    begin
        ParkSite.Run;
    end;
}

