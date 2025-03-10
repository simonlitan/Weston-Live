table 52178879 "Audit Rsk Assessment"
{

    fields
    {
        field(1; "Risk Assessment No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Risk Findings"; Text[250])
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

