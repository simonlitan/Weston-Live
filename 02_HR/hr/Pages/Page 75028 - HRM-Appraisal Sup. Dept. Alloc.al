page 75028 "HRM-Appraisal Sup. Dept. Alloc"
{
    PageType = ListPart;
    SourceTable = "HRM-HOD Dept. Loading";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Appraisal Job Code"; Rec."Appraisal Job Code")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Target"; Rec."Appraisal Target")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Period Code"; Rec."Appraisal Period Code")
                {
                    ApplicationArea = All;
                }
                field(HOD; Rec.HOD)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Appraisal Target Description"; Rec."Appraisal Target Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //Units.RESET;
        //IF Units.GET(Programme,Stage,Unit) THEN
    end;

    var
        Units: Record "HRM-Appraisal Targets";
}

