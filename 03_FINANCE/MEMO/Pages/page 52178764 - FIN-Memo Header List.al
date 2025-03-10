page 52178764 "FIN-Memo Header List"
{
    CardPageID = "FIN-Memo Header Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FIN-Memo Header";
    // SourceTableView = WHERE("Memo Status" = FILTER(Pending));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Date/Time"; Rec."Date/Time")
                {
                    ApplicationArea = all;
                }
                field(From; Rec.From)
                {
                    ApplicationArea = all;
                }
                field(Through; Rec.Through)
                {
                    ApplicationArea = all;
                }
                field("To"; Rec."To")
                {
                    ApplicationArea = all;
                }
                field("PRN No."; Rec."PRN No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Enabled = false;
                }
                field("Created by"; Rec."Created by")
                {
                    ApplicationArea = all;
                }
                field("Title/Ref."; Rec."Title/Ref.")
                {
                    ApplicationArea = all;
                }
                field("Paragraph 1"; Rec."Paragraph 1")
                {
                    ApplicationArea = all;
                }
                field("Paragraph 2"; Rec."Paragraph 2")
                {
                    ApplicationArea = all;
                }
                field("Paragraph 3"; Rec."Paragraph 3")
                {
                    ApplicationArea = all;
                }
                field("Compute P.A.Y.E."; Rec."Compute P.A.Y.E.")
                {
                    ApplicationArea = all;
                }
                field("P.A.Y.E. Rate"; Rec."P.A.Y.E. Rate")
                {
                    ApplicationArea = all;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = all;
                }
                field("Period Month"; Rec."Period Month")
                {
                    ApplicationArea = all;
                }
                field("Period Year"; Rec."Period Year")
                {
                    ApplicationArea = all;
                }
                field("Memo Status"; Rec."Memo Status")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ExpCodes)
            {
                ApplicationArea = all;
                Caption = 'Roles';
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "FIN-Memo Expense Codes";
                RunPageLink = "Memo No." = FIELD("No.");
            }
            action(MemRep)
            {
                ApplicationArea = all;
                Caption = 'Memo Report';
                Image = Continue;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FINMemoHeader.RESET;
                    FINMemoHeader.SETRANGE(FINMemoHeader."No.", Rec."No.");
                    IF FINMemoHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(64600, TRUE, FALSE, FINMemoHeader);
                    END;
                end;
            }
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
            action(sendApproval)
            {
                ApplicationArea = all;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    //  ApprovalMgt: Codeunit "439";
                    showmessage: Boolean;
                    ManualCancel: Boolean;
                    State: Option Open,"Pending Approval",Cancelled,Approved;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Sales Returns","Transfer Order",Payroll,"Casual Payroll",Memo;
                    tableNo: Integer;
                begin
                    IF Rec.PRN THEN BEGIN
                        Rec.CALCFIELDS("PRN Items Count");
                        IF Rec."PRN Items Count" = 0 THEN ERROR('PRN Memos must have details!');
                    END;
                    // Check Budget First
                    CommitBudget;
                    //Ensure No Items That should be committed that are not
                    State := State::Open;
                    IF Rec."Memo Status" <> Rec."Memo Status"::Pending THEN State := State::"Pending Approval";
                    DocType := DocType::Memo;
                    CLEAR(tableNo);
                    tableNo := DATABASE::"FIN-Memo Header";
                    // IF ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State) THEN;
                    //  IF ApprovalMgt.SendLeaveApprovalRequest(Rec) THEN;
                end;
            }
            action(cancellsApproval)
            {
                ApplicationArea = all;
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    // ApprovalMgt: Codeunit "439";
                    showmessage: Boolean;
                    ManualCancel: Boolean;
                    State: Option Open,"Pending Approval",Cancelled,Approved;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Sales Returns","Transfer Order",Payroll,"Casual Payroll",Memo;
                    tableNo: Integer;
                begin
                    IF CONFIRM('This will also reverse Busget Commitment, Continue?', FALSE) = FALSE THEN ERROR('Cancelled by user!');
                    CancelCommitment;
                    DocType := DocType::Memo;
                    showmessage := TRUE;
                    ManualCancel := TRUE;
                    CLEAR(tableNo);
                    tableNo := DATABASE::"FIN-Memo Header";
                    // IF ApprovalMgt.CancelApproval(tableNo, DocType, Rec."No.", showmessage, ManualCancel) THEN;

                    // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                end;
            }
            action(MarkPost)
            {
                ApplicationArea = all;
                Caption = 'Mark Posted';
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF Rec."Memo Status" <> Rec."Memo Status"::Approved THEN ERROR('Status must be Approved!');
                    IF CONFIRM('Mark as Posted?', FALSE) = FALSE THEN ERROR('Posting Cancelled!');
                    Rec."Memo Status" := Rec."Memo Status"::Posted;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //SETFILTER("Created by",USERID);
    end;

    trigger OnInit()
    begin
        //SETFILTER("Created by",USERID);
    end;

    trigger OnOpenPage()
    begin
        //Rec.SETFILTER("Created by", USERID);
    end;

    var
        FINMemoHeader: Record "FIN-Memo Header";
        BCSetup: Record "FIN-Budgetary Control Setup";
        FINBudgetEntries: Record "FIN-Budget Entries";
        DateEquivalent: Date;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Sales Returns","Transfer Order",Payroll,"Casual Payroll",Memo;
        ApprovalEntries: Page "Fin-Approval Entries";

    local procedure CommitBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
        FINMemoDetails: Record "FIN-Memo Details";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Payroll Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Programme Code");
        Rec.TESTFIELD("Department Code");
        Rec.TESTFIELD("Activity Code");
        Rec.TESTFIELD("Budget Account");

        FINMemoDetails.RESET;
        FINMemoDetails.SETRANGE("Memo No.", Rec."No.");
        IF FINMemoDetails.FIND('-') THEN FINMemoDetails.CALCSUMS(Amount);
        // Check if budget exists
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", Rec."Budget Account");
        IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
        DimensionValue.RESET;
        DimensionValue.SETRANGE(Code, Rec."Department Code");
        //   DimensionValue.SETRANGE("Global Dimension No.",2);
        IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
        FINBudgetEntries.RESET;
        FINBudgetEntries.SETRANGE("Budget Name", BCSetup."Current Budget Code");
        FINBudgetEntries.SETRANGE("G/L Account No.", Rec."Budget Account");
        FINBudgetEntries.SETRANGE("Global Dimension 1 Code", Rec."Programme Code");
        FINBudgetEntries.SETRANGE("Global Dimension 2 Code", Rec."Department Code");
        //FINBudgetEntries.SETRANGE("Global Dimension 3 Code",Rec."Activity Code");
        FINBudgetEntries.SETFILTER("Transaction Type", '%1|%2|%3', FINBudgetEntries."Transaction Type"::Expense, FINBudgetEntries."Transaction Type"::Commitment
        , FINBudgetEntries."Transaction Type"::Allocation);
        FINBudgetEntries.SETFILTER("Commitment Status", '%1|%2',
        FINBudgetEntries."Commitment Status"::" ", FINBudgetEntries."Commitment Status"::Commitment);
        CLEAR(DateEquivalent);
        IF EVALUATE(DateEquivalent, FORMAT(Rec."Date/Time")) THEN;
        FINBudgetEntries.SETFILTER(Date, PostBudgetEnties.GetBudgetStartAndEndDates(DateEquivalent));
        IF FINBudgetEntries.FIND('-') THEN BEGIN
            IF FINBudgetEntries.CALCSUMS(Amount) THEN BEGIN
                IF FINBudgetEntries.Amount > 0 THEN BEGIN
                    IF (FINMemoDetails.Amount > FINBudgetEntries.Amount) THEN ERROR('Less Funds, Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                    // Commit Budget Here
                    //          PostBudgetEnties.CheckBudgetAvailability(Rec."Budget Account",DateEquivalent,Rec."Programme Code",Rec."Department Code",Rec."Activity Code",
                    //   FINMemoDetails.Amount,'','MEMO',Rec."No."+Rec."Budget Account",'MEMO');
                END ELSE
                    ERROR('No allocation for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
            END;
        END ELSE
            ERROR('Missing Budget for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
    end;

    local procedure ExpenseBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
        FINMemoDetails: Record "FIN-Memo Details";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Payroll Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Programme Code");
        Rec.TESTFIELD("Department Code");
        Rec.TESTFIELD("Activity Code");
        Rec.TESTFIELD("Budget Account");
        //Get Current Lines to loop through
        // Expense Budget Here

        FINMemoDetails.RESET;
        FINMemoDetails.SETRANGE("Memo No.", Rec."No.");
        IF FINMemoDetails.FIND('-') THEN FINMemoDetails.CALCSUMS(Amount);
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", Rec."Budget Account");
        IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
        DimensionValue.RESET;
        DimensionValue.SETRANGE(Code, Rec."Activity Code");
        // DimensionValue.SETRANGE("Global Dimension No.",3);
        IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
        IF (FINMemoDetails.Amount > 0) THEN BEGIN
            // Commit Budget Here
            //   PostBudgetEnties.ExpenseBudget(Rec."Budget Account",DateEquivalent,Rec."Programme Code",Rec."Programme Code",Rec."Activity Code",
            //  FINMemoDetails.Amount,GLAccount.Name,USERID,TODAY,'MEMO',Rec."No."+Rec."Budget Account",'MEMO');
        END;
    end;

    local procedure CancelCommitment()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
        FINMemoDetails: Record "FIN-Memo Details";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Payroll Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Programme Code");
        Rec.TESTFIELD("Department Code");
        Rec.TESTFIELD("Activity Code");
        Rec.TESTFIELD("Budget Account");
        //Get Current Lines to loop through
        // Expense Budget Here

        FINMemoDetails.RESET;
        FINMemoDetails.SETRANGE("Memo No.", Rec."No.");
        IF FINMemoDetails.FIND('-') THEN FINMemoDetails.CALCSUMS(Amount);
        // Expense Budget Here
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", Rec."Budget Account");
        IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
        DimensionValue.RESET;
        DimensionValue.SETRANGE(Code, Rec."Activity Code");
        DimensionValue.SETRANGE("Global Dimension No.", 3);
        IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
        IF (FINMemoDetails.Amount > 0) THEN BEGIN
            // Commit Budget Here
            //   PostBudgetEnties.CancelBudgetCommitment(Rec."Budget Account",DateEquivalent,Rec."Programme Code",Rec."Department Code",Rec."Activity Code",
            //  FINMemoDetails.Amount,GLAccount.Name,USERID,'MEMO',Rec."No."+Rec."Budget Account",'MEMO');
        END;
    end;
}

