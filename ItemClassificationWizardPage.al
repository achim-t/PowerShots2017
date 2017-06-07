page 70000002 "Item Classification Wizard"
{
    PageType = NavigatePage;
    SourceTable = "Item Classification";

    layout
    {
        area(content)
        {
            group(FirstStep)
            {
                
                Visible=FirstStepVisible;
                group(Welcome){
                    InstructionalTextML = ENU='Welcome';
                }

                group(DataExists)
                {
                    Visible=TableHasData;
                    InstructionalTextML = ENU='There is already data in the Item Classification Table';
                }

                group(DataEmpty)
                {
                    Visible=NOT TableHasData;
                    InstructionalTextML = ENU='There is no data in the Item Classification table, so we have provided some default values. Click Next and review the data.';
                }
            }

            group(SecondStep)
            {
                Visible=SecondStepVisible;

                repeater(ItemClassificationData)
                {
                    field(Code;Code){}
                    field(Description;Description) {}
                    field("Minimum Sales Count";"Minimum Sales Count"){}
                    field(Warning;Warning){}
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                CaptionML=ENU='Back';
                Enabled=BackActionEnabled;
                Image=PreviousRecord;
                InFooterBar=true;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }

            action(ActionNext)
            {
                CaptionML=ENU='Next';
                Enabled=NextActionEnabled;
                Image=NextRecord;
                InFooterBar=true;
                trigger OnAction();
                begin
                    NextStep(false);
                end;            
            }

            action(ActionFinished)
            {
                CaptionML=ENU='Finish';
                Enabled=FinishActionEnabled;
                Image=Approve;
                InFooterBar=true;
                trigger OnAction();
                begin
                    FinishAction;
                end;                
            }
        }
    }
    trigger OnOpenPage();
    begin
        Step := Step::First;
        EnableControls;
    end;
    local procedure ResetControls();
    begin
        BackActionEnabled := true;
        NextActionEnabled:= true;
        FinishActionEnabled:= true;       
        FirstStepVisible := FALSE;
        SecondStepVisible := FALSE;
 
    end;

    local procedure EnableControls();
    begin
        ResetControls;

        CASE Step OF
            Step::First:
                ShowFirstStep;
            Step::Second:
                ShowSecondStep;
        END;
    end;

    local procedure ShowFirstStep();
    var
        ItemClassification: Record "Item Classification";
    begin
        FirstStepVisible := TRUE;
        IF ItemClassification.ISEMPTY THEN BEGIN
            TableHasData := FALSE;
            FinishActionEnabled := FALSE;
            BackActionEnabled := FALSE;

            ItemClassification.InsertDefaultValues;
        END ELSE BEGIN
            TableHasData := TRUE;
            NextActionEnabled := FALSE;
            BackActionEnabled := FALSE;
        END;
    end;
    local procedure ShowSecondStep();
    begin
        SecondStepVisible := TRUE;
        NextActionEnabled := FALSE;
        BackActionEnabled := FALSE;
    end;
    local procedure NextStep(Backwards: Boolean);
    begin
        IF Backwards THEN 
            Step := Step - 1
        ELSE 
            Step := Step + 1;
        EnableControls;
    end;
    local procedure FinishAction();
    begin
        CurrPage.Close;
    end;
    var 
        [InDataSet]TableHasData: Boolean;
        [InDataSet]FirstStepVisible: Boolean;
        [InDataSet]SecondStepVisible: Boolean;
        [InDataSet]BackActionEnabled: Boolean;
        [InDataSet]NextActionEnabled: Boolean;
        [InDataSet]FinishActionEnabled:Boolean;
        Step: Option First,Second;
}