pageextension 70000001 ItemListPageExtension extends "Item List"
{
    layout
    {
        addfirst(Item){
            field("Item Classification Code";"Item Classification Code"){}
        }
    }

    actions
    {
        addfirst (Item){
            action(CalcItemClassification){
                Promoted=true;
                PromotedCategory=Process;
                PromotedIsBig=true;
                Image=Calculate;

                trigger OnAction();
                var
                    CalcItemClassification: Codeunit "CalcItem Classification Meth.";
                begin
                    CalcItemClassification.CalcItemClassification(Rec);
                end;

            }
        }
    }
}