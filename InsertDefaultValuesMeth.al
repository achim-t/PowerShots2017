codeunit 70000003 "Insert Default Values Meth."
{
    trigger OnRun();
    begin
    end;

    procedure InsertDefaultValues();
    var
        Handled: Boolean;
    begin
        OnBeforeInsertDefaultValue(Handled);

        DoInsertDefaultValues(Handled);

        OnAfterInsertDefaultValue;
    end;

    local procedure DoInsertDefaultValues(var Handled: Boolean);
    begin
        IF Handled THEN EXIT;

        InsertDefaultValue('A', 'Sold often', 5, FALSE);
        InsertDefaultValue('B', 'Sold rarely', 3, TRUE);
        InsertDefaultValue('C', 'Sold never', 0, TRUE);
    end;

    local procedure InsertDefaultValue(pCode : Code[10];pDescription : Text[50];pMinimumSalesCount : Decimal;pWarning : Boolean);
    var
        ItemClassification: Record "Item Classification";
    begin
        WITH ItemClassification DO BEGIN
            Code := pCode;
            Description := pDescription;
            "Minimum Sales Count" := pMinimumSalesCount;
            Warning := pWarning;
            INSERT;
        END;
    end;
    [Integration(false, false)]
    procedure OnBeforeInsertDefaultValue(var Handled: Boolean);begin end;
    [Integration(false, false)]
    procedure OnAfterInsertDefaultValue();begin end;    
}