table 52178784 "Board Member Qualifications"
{

    fields
    {
        field(1; "Board No."; Code[20])
        {
            TableRelation = "NW-Board Members"."No.";
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,Internal,External,Others';
            OptionMembers = " ",Internal,External,Others;
        }
        field(3; "From Date"; Date)
        {
        }
        field(4; "To Date"; Date)
        {
        }
        field(5; Institution; Code[30])
        {
            TableRelation = "HRM-Institutions"."Institution Code";
        }
        field(6; Description; Text[150])
        {
        }
        field(7; Qualification; Option)
        {
            OptionCaption = ' ,Certificate,Diploma,Undergraduate,Masters,PHD,Higher Diploma';
            OptionMembers = " ",Certificate,Diploma,Undergraduate,Masters,PHD,"Higher Diploma";
        }
        field(8; "Institution Name"; Text[250])
        {
            CalcFormula = Lookup("HRM-Institutions"."Institution Name" WHERE("Institution Code" = FIELD(Institution)));
            FieldClass = FlowField;
        }
        field(9; "Highest Qualification"; Boolean)
        {

            trigger OnValidate()
            begin
                if ("Highest Qualification" = true) then begin
                    qual.Reset;
                    qual.SetRange(qual."Board No.", "Board No.");
                    qual.SetRange(qual."Highest Qualification", true);
                    if qual.Find('-') then begin
                        if qual.Count > 0 then Error('You cannot have more than one highest qualifications for' + Format(qual."Board No."));
                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Board No.", Qualification, Type)
        {
        }
    }

    fieldgroups
    {
    }

    var
        qual: Record "Board Member Qualifications";
}
