page 52179083 "FLT-Closed Daily Work Ticket"
{
    PageType = Document;
    SourceTable = "FLT-Daily Work Ticket Header";
    SourceTableView = WHERE(Status = CONST(Closed));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Ticket No."; Rec."Ticket No.")
                {
                    ApplicationArea = All;
                }
                field("Previous W.T. No."; Rec."Previous W.T. No.")
                {
                    ApplicationArea = All;
                }
                field("G.K. No."; Rec."G.K. No.")
                {
                    ApplicationArea = All;
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = All;
                }
                field("Total Milleage"; Rec."Total Milleage")
                {
                    ApplicationArea = All;
                }
                field("Total Fuel Cost"; Rec."Total Fuel Cost")
                {
                    ApplicationArea = All;
                }
                field(Ministry; Rec.Ministry)
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                }
                field("Total Fuel Consumed"; Rec."Total Fuel Consumed")
                {
                    ApplicationArea = All;
                }
                field("Oil Consumed"; Rec."Oil Consumed")
                {
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
            }
            part("Authorizing Officers"; "FLT-Ticket Authorizing Off.")
            {
                Caption = 'Authorizing Officers';
                ApplicationArea = All;
            }
            part(Control21; "FLT-Daily Work Ticket Drivers")
            {
                SubPageLink = "Ticket No." = FIELD("Ticket No.");
                ApplicationArea = All;
            }
            part(Control20; "FLT-Work Ticket Lines")
            {
                SubPageLink = "Ticket No." = FIELD("Ticket No.");
                ApplicationArea = All;
            }


        }
    }

    actions
    {
        area(creation)
        {
            action(WorkTicket)
            {
                Caption = 'Preview WT';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    if Rec."Ticket No." = '' then Error('No Record Selected.');

                    ticket.Reset;
                    ticket.SetRange(ticket."Ticket No.", Rec."Ticket No.");

                    if ticket.Find('-') then
                        REPORT.Run(39005746, true, true, ticket);
                end;
            }
        }
    }

    var
        ticket: Record "FLT-Daily Work Ticket Header";
}

