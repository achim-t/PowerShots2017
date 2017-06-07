codeunit 70000000 "CalcItem Classification Meth."
{
    trigger OnRun();
    begin
    end;
    procedure CalcItemClassification(Item: Record 27);
    var
        Handled : Boolean;
    begin
        OnBeforeCalcItemClassification(Handled);
        DoCalcItemClassification(Item, Handled);
        OnAfterCalcItemClassification();
    end;
    local procedure DoCalcItemClassification(Item: Record 27; Handled: Boolean);
    var
        SalesCount : Integer;
    begin
        IF Handled THEN 
            EXIT;

        SalesCount := GetItemSalesCount(Item);
        Item."Item Classification Code" := GetItemClassificationCode(SalesCount);
        Item.MODIFY;
    end;
    local procedure GetItemSalesCount(Item: Record 27):Integer;
    var
        ItemLedgerEntry : Record 32;
    begin
        WITH ItemLedgerEntry do BEGIN
            SETRANGE("Item No.", Item."No.");
            SETRANGE("Entry Type", "Entry Type"::Sale);
            EXIT(COUNT);
        END;
    end;

    procedure GetItemClassificationCode(SalesCount:Integer):Code[10];
    var
        ItemClassification : Record 70000000;
    begin
        WITH ItemClassification DO BEGIN
            SETFILTER("Minimum Sales Count", '<=%1', SalesCount);
            SETASCENDING(Code, TRUE);
            IF NOT FINDFIRST THEN 
                EXIT('')
            ELSE 
                EXIT(Code);
        END;
    end;

    [Integration(false, false)]
    procedure OnBeforeCalcItemClassification(var Handled: Boolean);
    begin
    end;

    [Integration(false, false)]
    procedure OnAfterCalcItemClassification();
    begin
    end;
}