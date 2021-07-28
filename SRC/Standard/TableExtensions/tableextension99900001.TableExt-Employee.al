tableextension 99900001 tableextension99900001 extends Employee
{
    fields
    {
        field(8010; User; Guid)
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Security ID";
        }
        field(8020; IsParkEmployee; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

