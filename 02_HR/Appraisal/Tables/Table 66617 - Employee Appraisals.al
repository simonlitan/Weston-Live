table 66617 "Employee Appraisals"
{

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HRM-Employee C"."No.";

            trigger OnValidate()
            begin
                IF Employee.GET("Employee No") THEN
                    "Job ID" := Employee.Position;
            end;
        }
        field(2; "Appraisal Type"; Code[20])
        {
            TableRelation = "Appraisal Types".Code;
        }
        field(3; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Appraisal Periods".Period;
        }
        field(4; "No. Supervised (Directly)"; Integer)
        {
        }
        field(5; "No. Supervised (In-Directly)"; Integer)
        {
        }
        field(6; "Job ID"; Code[20])
        {
            TableRelation = "HRM-Company Jobs"."Job ID";
        }
        field(7; "Agreement With Rating"; Option)
        {
            OptionMembers = Entirely,Mostly,"To some extent","Not at all";
        }
        field(8; "General Comments"; Text[250])
        {
        }
        field(9; Date; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No", "Appraisal Type", "Appraisal Period")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record "HRM-Employee C";
}

