page 52179042 "FLT-Model List"
{
    PageType = List;
    SourceTable = "FLT-Flt Model";
    Caption = 'FLT-Model List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

