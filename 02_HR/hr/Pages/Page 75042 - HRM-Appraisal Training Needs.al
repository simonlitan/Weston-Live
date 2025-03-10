page 69787 "HRM-Appraisal Training Needs"
{
    DeleteAllowed = false;
    PageType = Listpart;
    SourceTable = "HRM-Appraisal Training Needs";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field("Training Need Code"; Rec."Training Need Code")
                // {
                //     ApplicationArea = All;
                //     //Caption = 'Agreed Performance Targets/ Specific Tasks Assignment';
                // }
                // field("Training Need Description"; Rec."Training Need Description")
                // {
                //     ApplicationArea = All;
                // }

                field("Profesional Development Needs"; Rec."Profesional Development Needs")
                {
                }
                field("Resources/Support Needed"; Rec."Resources/Support Needed")
                {
                }
                field("Target Date"; Rec."Target Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SETFILTER("Appraisal year Code", HRMAppraisalYears.Code);
    end;

    trigger OnOpenPage()
    begin
        HRMAppraisalYears.RESET;
        HRMAppraisalYears.SETRANGE(Closed, FALSE);
        IF HRMAppraisalYears.FIND('-') THEN
            Rec.SETFILTER("Appraisal year Code", HRMAppraisalYears.Code);
    end;

    var
        UserSetup: Record "User Setup";
        HRMAppraisalYears: Record "HRM-Appraisal Years";
        HRMAppraisalPeriods: Record "HRM-Appraisal Periods";
        editability: Boolean;
}

