codeunit 70000001 "ShowItemClassWarning Meth."
{
    trigger OnRun();
    begin
    end;

    procedure ShowItemClassWarning(var Item: Record Item);
    var
        Handled: Boolean;
        
    begin
        DoShowItemClassWarning(Item, Handled);
    end;

    procedure DoShowItemClassWarning(var Item: Record Item; var Handled: Boolean);

    begin
        if Handled then 
            exit;

        IF GetItemClassWarningStatus(Item) THEN
            SendItemClassWarning(Item);
    end;

    local procedure GetItemClassWarningStatus(var Item: Record Item):Boolean;
    var
        ItemClassification : Record "Item Classification";
    begin
        WITH ItemClassification DO BEGIN
            SETRANGE(Code, Item."Item Classification Code");
            
            IF FINDFIRST THEN
                EXIT(Warning);
        END;
    end;

    local procedure SendItemClassWarning(var Item: Record Item);
    var
        ItemWarningNotification: Notification;
        ItemClassificationWarningTxt: TextConst ENU='Warning: Item %1 has an Item Classification %2!';
    begin
        ItemWarningNotification.MESSAGE(STRSUBSTNO(ItemClassificationWarningTxt,Item.Description, Item."Item Classification Code"));
        ItemWarningNotification.SETDATA('ItemNumber', Item."No.");
        ItemWarningNotification.ADDACTION('Run Item Card',
        CODEUNIT::"ShowItemClassWarning Meth.", 'HandleItemClassWarning_RunItemCard');
        ItemWarningNotification.ADDACTION('Run Item Ledger Entries',
        CODEUNIT::"ShowItemClassWarning Meth.", 'HandleItemClassWarning_RunItemLedgerEntries');
        ItemWarningNotification.SEND;
    end;

    procedure HandleItemClassWarning_RunItemLedgerEntries(ItemWarningNotification: Notification);
    var
       
        ItemLedgerEntry: Record	"Item Ledger Entry";	
        ItemNo:	Code[10]; 
    begin
        ItemNo := ItemWarningNotification.GETDATA('ItemNumber');
        ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
        IF ItemLedgerEntry.FINDFIRST THEN
            PAGE.RUN(PAGE::"Item Ledger Entries", ItemLedgerEntry)
        ELSE
            ERROR('Could not find Item: ' + ItemNo);        
    end;

    procedure HandleItemClassWarning_RunItemCard(ItemWarningNotification: Notification);
    var
        ItemNo: Code[10];
        Item: Record Item;
        ItemCard: Page "Item Card";
    begin
        ItemNo := ItemWarningNotification.GETDATA('ItemNumber');
        IF Item.GET(ItemNo) THEN BEGIN
            ItemCard.SETRECORD(Item);
            ItemCard.RUN;
        END ELSE
            ERROR('Could not find Item: ' + ItemNo);
    end;

    [EventSubscriber(ObjectType::Table,37,'OnAfterValidateEvent','No.',true,true)]
    procedure ShowItemClassWarning_OnValidateItemNoOnSalesLine(var Rec: Record "Sales Line"
    );
    var
        ItemClassification: Record "Item Classification";
        Item: Record Item;
    begin
        IF ItemClassification.ISEMPTY THEN 
            EXIT;

        IF Rec.Type = Rec.Type::Item THEN BEGIN
            Item.GET(Rec."No.");
            ShowItemClassWarning(Item);
        END;
    end;

    [Integration(false,false)]
    procedure OnBeforeShowItemClassWarning(var Item: Record Item; var Handled: Boolean);begin end;

    [Integration(false,false)]
    procedure OnAfterShowItemClassWarning(var Item: Record Item);begin end;
}