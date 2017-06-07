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
                    Visible = not TableHasData;
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

    var 
        TableHasData: Boolean;
        FirstStepVisible: Boolean;
        SecondStepVisible: Boolean;
}