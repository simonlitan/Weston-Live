table 75013 "HRM-Appraisal Training Needs"
{
    //DrillDownPageID = 75031;
    //LookupPageID = 75031;

    fields
    {
        field(2; "PF. No."; Code[20])
        {
            Editable = true;
            NotBlank = true;
        }
        field(3; "Appraisal Period Code"; Code[20])
        {
            Editable = true;
            NotBlank = false;
        }
        field(4; "Appraisal Job Code"; Code[20])
        {
            Editable = true;
            NotBlank = false;
        }
        field(7; "Training Need Code"; Code[20])
        {
            Editable = true;
            NotBlank = true;
        }
        field(72; "Entry No."; Integer)
        {
        }
        field(50015; "Appraisal year Code"; Code[20])
        {
        }
        field(50103; "Training Need Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Mitigating Factor"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Profesional Development Needs"; Text[100])
        {
        }
        field(6; "Resources/Support Needed"; Text[100])
        {
        }
        field(9; "Target Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Appraisal Job Code", "Training Need Code", "Appraisal Period Code", "PF. No.", "Appraisal year Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if not UserSetup.Get(UserId) then Error('Invalid User Account!');
        UserSetup.TestField("Employee No.");
        //"PF. No.":=UserSetup."Employee No.";
        if HRMEmployeeC.Get(UserSetup."Employee No.") then "Appraisal Job Code" := HRMEmployeeC."Job Title";
        HRMAppraisalYears.Reset;
        HRMAppraisalYears.SetRange(Closed, false);
        if not HRMAppraisalYears.Find('-') then Error('There is no open appraisal year.');
        "Appraisal year Code" := HRMAppraisalYears.Code;

        HRMAppraisalPeriods.Reset;
        HRMAppraisalPeriods.SetRange("Period Code", HRMAppraisalYears.Code);
        //HRMAppraisalPeriods.SETRANGE(Closed,FALSE);
        if not HRMAppraisalPeriods.Find('-') then Error('There is no open period in the filters');
        "Appraisal Period Code" := HRMAppraisalPeriods."Period Code";
    end;

    var
        coreg: Record "HRM-Appraisal Registration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenSetup: Record "HRM-Appraisal Gen. Setup";
        TotalCost: Decimal;
        RecFound: Boolean;
        CReg: Record "HRM-Appraisal Registration";
        UnitsS: Record "HRM-Appraisal Targets";
        StudUnits: Record "HRM-Appraisal Emp. Targets";
        StudUnits2: Record "HRM-Appraisal Emp. Targets";
        UTaken: Integer;
        UFound: Boolean;
        CourseReg: Record "HRM-Appraisal Registration";
        Prog: Record "HRM-Appraisal Jobs";
        ExamR: Record "HRM-Appraisal Results";
        Studnits: Record "HRM-Appraisal Emp. Targets";
        ExamSetup: Record "HRM-Appraisal Res. Setup";
        HRMEmployeeC: Record "HRM-Employee C";
        UserSetup: Record "User Setup";
        HRMAppraisalYears: Record "HRM-Appraisal Years";
        HRMAppraisalPeriods: Record "HRM-Appraisal Periods Set";
}

