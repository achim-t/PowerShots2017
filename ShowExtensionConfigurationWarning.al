codeunit 70000005 ShowExtensionConfigurationWarn
{
procedure ShowExtensionConfigurationWarn();
var Handled: Boolean;
begin
    OnBeforeShowExtensionConfigurationWarning(Handled);
    DoShowExtensionConfigurationWarn(Handled);
    OnAfterShowExtensionConfigurationWarning;
end;


procedure HandleExtensionConfigurationWarning_RunWizard(ItemWarningNotification : Notification);
begin
    PAGE.RUN(PAGE::"Item Classification Wizard");
end;


LOCAL procedure SendExtensionConfigurationWarning();
var ItemWarningNotification: Notification;
    ExtensionConfigurationWarningTxt: TextConst ENU='You havent set up the "Item Classification" setup yet. You can do that';
begin
    ItemWarningNotification.MESSAGE(ExtensionConfigurationWarningTxt);
    ItemWarningNotification.ADDACTION('here',
    CODEUNIT::ShowExtensionConfigurationWarn, 'HandleExtensionConfigurationWarning_RunWizard');
    ItemWarningNotification.SEND;
end;


 [EventSubscriber(ObjectType::Table,37,'OnAfterValidateEvent','No.',true,true)] 
LOCAL procedure ShowExtensionConfigurationWarning_OnValidateItemNoOnSalesLine(VAR Rec : Record "Sales Line";VAR xRec : Record "Sales Line";CurrFieldNo : Integer);
begin
    ShowExtensionConfigurationWarn;
end;


LOCAL procedure DoShowExtensionConfigurationWarn(VAR Handled : Boolean);
var ItemClassification: Record "Item Classification";
begin
    IF Handled THEN EXIT;

    IF ItemClassification.ISEMPTY THEN
        SendExtensionConfigurationWarning;  
end;

[Integration(false,false)]
LOCAL procedure OnBeforeShowExtensionConfigurationWarning(VAR Handled : Boolean);
begin end;
[Integration(false,false)]
LOCAL procedure OnAfterShowExtensionConfigurationWarning();
begin

end;

[EventSubscriber(ObjectType::Page,31,'OnOpenPageEvent','', true,true)]
LOCAL procedure ShowExtensionConfigurationWarning_OnOpenItemList(VAR Rec : Record Item);
begin
    ShowExtensionConfigurationWarn;
end;

[EventSubscriber(ObjectType::Page,30,'OnOpenPageEvent','', true,true)]
LOCAL procedure ShowExtensionConfigurationWarning_OnOpenItemCard(VAR Rec : Record Item);
begin
    ShowExtensionConfigurationWarn;
end;
}