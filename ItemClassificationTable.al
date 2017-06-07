table 70000000 "Item Classification"
{

    fields
    {
        field(1;Code;Code[10])  { }
        field(2;Description;Text[50])  { }
        field(3;"Minimum Sales Count";Decimal)  { }
     
        
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

}