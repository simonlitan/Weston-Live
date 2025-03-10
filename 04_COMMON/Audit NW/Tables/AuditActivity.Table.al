table 52178868 "Audit-Activity"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(8; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Depart Code"; Code[50])
        {
            Caption = 'Project';

            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; Department; Text[250])
        {
            Caption = 'Project Name';
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(2)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Activities; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(25; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Timeline; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(37; Duration; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(40; Budget; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Created By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Review Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "End of Review"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Depart Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        IF FORMAT("End Date") < FORMAT("Start Date") THEN
            ERROR('End date cannot be lesser than start date');
    end;
}

