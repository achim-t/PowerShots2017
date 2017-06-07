table 70000000 "Item Classification"
{

    fields
    {
        field(1;Code;Code[10])  { }
        field(2;Description;Text[50])  { }
        field(3;"Minimum Sales Count";Decimal)  { }
        field(4;Warning;Boolean){}
    }

    keys
    {
        key(1;PK;Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

    procedure InsertDefaultValues();
    var 
        InsertDefaultValuesMeth: Codeunit "Insert Default Values Meth.";
    begin
        InsertDefaultValuesMeth.InsertDefaultValues;
    end;

}