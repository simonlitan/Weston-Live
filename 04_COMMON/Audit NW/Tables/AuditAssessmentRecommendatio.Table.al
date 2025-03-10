table 52178870 "Audit Assessment Recommendatio"
{

    fields
    {
        field(1; "Risk Assessment No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Risk recommendations"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Risk Assessment No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

