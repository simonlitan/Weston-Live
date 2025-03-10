page 50000 "HRM-Welfare Application"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;

    PromotedActionCategories = 'New,Process,Report';

    SourceTable = "HRM-Employee C";

    layout
    {
        area(content)
        {
            group("Details")
            {
                Caption = 'Details';
                field("P/NO"; Rec."No.")
                {
                    Caption = 'Employee No';
                    ApplicationArea = all;
                    TableRelation = "HRM-Employee C"."No." where(Status = filter(Active));

                    trigger OnValidate()
                    begin
                        if rec.get(Rec."No.") then
                            Rec.date := Today;
                        Rec.Status := HREmp.Status;
                        rec."User ID" := UserId;



                    end;
                }
                field("Employee Name"; Rec.Names)
                {
                    ApplicationArea = all;
                    Caption = 'Employee Name';
                    Editable = false;
                }

                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }



                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = all;
                }

                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = all;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = all;
                }
                field("Work Station and address"; Rec.Station)
                {

                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;

                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = all;
                }

                field("Name of Spouse"; Rec."spouse")
                {
                    ApplicationArea = all;
                }

                field("Next of Kin"; rec."Next of Kin")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                // field("Activity Status"; Rec."Activity Status")
                // {
                //     ApplicationArea = all;
                // }
            }
            part(Control1102755011; "HRM-Employee Kin SF")
            {
                ApplicationArea = all;
                SubPageLink = "ID No/Passport No" = FIELD("ID Number");
            }
        }


    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action("Get Participants")
                {
                    ApplicationArea = all;
                    Image = SalesPurchaseTeam;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        //Rec.TestField(Closed, false);
                        //TESTFIELD(Status,Status::New);

                        //DELETE ANY PREVIOS RECORDS RELATED TO THIS ACTIVITY
                        //HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Rec.Code);
                        if HRActivityApprovalEntry.Find('-') then
                            HRActivityApprovalEntry.DeleteAll;

                        //GET ONLY ACTIVE EMPLOYEES
                        HREmp.Reset;
                        HREmp.SetRange(HREmp.Status, HREmp.Status::Active);
                        HREmp.SetFilter(HREmp."User ID", '<>%1', '');
                        HREmp.FindFirst;
                        begin
                            HRActivityApprovalEntry.Reset;
                            repeat
                                HRActivityApprovalEntry.Init;
                                HREmp.TestField(HREmp."User ID");
                                HRActivityApprovalEntry.Participant := HREmp."No.";
                                HRActivityApprovalEntry."Partipant Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                                //HRActivityApprovalEntry."Document No." := Rec.Code;
                                HRActivityApprovalEntry.Validate(HRActivityApprovalEntry.Participant);
                                HRActivityApprovalEntry.Insert();
                            until HREmp.Next = 0;
                        end;
                    end;
                }
                action("Notify Participants")
                {
                    ApplicationArea = all;
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        //Rec.TestField(Closed, false);

                        HRActivityApprovalEntry.Reset;
                        //HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Rec.Code);

                        //IF NO PARTICIPANTS ARE IMPORTED
                        if HRActivityApprovalEntry.Count = 0 then
                            Error('You must get participants to notify before using this function');

                        //ELSE
                        //Rec.Get(Rec.Code);
                        HRActivityApprovalEntry.Reset;

                        DocType := DocType::"Company Activity";


                        HRActivityApprovalEntry.SetRange("Table ID", DATABASE::"HRM-Activity Participants");
                        HRActivityApprovalEntry.SetRange("Document Type", DocType);
                        // HRActivityApprovalEntry.SetRange("Document No.", Rec.Code);
                        HRActivityApprovalEntry.SetRange("Activity Status", HRActivityApprovalEntry."Activity Status"::Created);
                        if HRActivityApprovalEntry.FindSet(true, false) then begin

                            repeat

                                //ApprovalsMgtNotification.SendActivityNotificationMail(Rec,HRActivityApprovalEntry);

                                HRActivityApprovalEntry.Notified := true;
                                HRActivityApprovalEntry.Modify;

                            until HRActivityApprovalEntry.Next = 0;
                            Message('%1', Text001)
                        end
                    end;
                }
                action(Close)
                {
                    ApplicationArea = all;
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        // Rec.Closed := true;
                        Rec.Modify;
                        // Message('Event :: %1 :: has been marked as Closed', Rec.Description);
                        CurrPage.Close;
                    end;
                }
                action("Re-Open")
                {
                    ApplicationArea = all;
                    Image = Open;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        // Rec.Closed := false;
                        Rec.Modify;
                        // Message('Event :: %1 :: has been Re-Opened', Rec.Description);
                        CurrPage.Close;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = all;
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;
                    //RunObject= report "Welfare App. Form";
                    // trigger OnAction()
                    // begin
                    //     HRCompanyActivities.Reset;
                    //     //HRCompanyActivities.SetRange(HRCompanyActivities.Code, Rec.Code);
                    //     if HRCompanyActivities.Find('-') then
                    //         REPORT.Run(39005492, true, true, HRCompanyActivities);
                    // end;
                }
            }
            group(Approval)
            {
                Caption = 'Approvals';
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Fin-Approval Entries";
                    RunPageLink = "Document No." = field("No.");
                }
                action("Send Approval Request")
                {
                    ApplicationArea = all;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Send this Company Activity for Approval?', true) = false then exit;
                        //AppMgmt.CancelJVApprovalRequest(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = all;
                    Caption = 'Cancel Approval Request';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Approval Request for this Company Activity?', true) = false then exit;
                        //AppMgmt.FinishExitApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
            }
        }
    }


    var
        D: Date;
        SMTP: Codeunit "Mail Management";
        CTEXTURL: Text[500];
        HREmp: Record "HRM-Employee C";
        //ApprovalSetup: Record "Approval Setup";
        //ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
        HRCompanyActivities: Record "HRM-Company Activities";
        HRActivityApprovalEntry: Record "HRM-Activity Participants";
        DocType: Option "Company Activity";
        Text001: Label 'All Participants have been notified via E-Mail';
        GenJournal: Record "Gen. Journal Line";
        LineNo: Integer;


}