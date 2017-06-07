tableextension 70000001 ItemTableExtension extends Item
{
    fields
    {
        field(60000;"Item Classification Code";Code[10])
        {
            TableRelation = "Item Classification".Code;
        }
    }
}