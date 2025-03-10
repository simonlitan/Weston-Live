page 75039 "HRM-Appraisal Sup. Emp. List"
{
    Caption = 'Appraisal Supervisor Employee List';
    CardPageID = "HRM-Appraisal Sup. Emp Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HRM-Employee C";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = All;

                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Home Phone Number"; Rec."Home Phone Number")
                {
                    ApplicationArea = All;
                }
                field("Cellular Phone Number"; Rec."Cellular Phone Number")
                {
                    ApplicationArea = All;
                }
                field("Work Phone Number"; Rec."Work Phone Number")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Student)
            {
                Caption = 'Staff';
                action("Appraisal Targets")
                {
                    Caption = 'Appraisal Targets';
                    Image = BOMRegisters;

                    RunObject = Page "HRM-Appraisal Emp Targets-SUP";
                    ApplicationArea = All;
                    // RunPageLink ="Agreed Score"=FIELD("No.");
                }
                action("Appraisee Training Requirements")
                {
                    Caption = 'Appraisee Training Requirements';
                    Image = Translation;

                    RunObject = Page "HRM-Appraisal Training Needs";
                    RunPageLink = "PF. No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Supervisor Comments")
                {
                    Caption = 'Supervisor Comments';
                    Image = CalculateWIP;

                    RunObject = Page "HRM-Appraisal Supervisor Com.";
                    RunPageLink = "PF. No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        rec.SETFILTER("Job Title", HRMJobs."Job ID");
    end;

    trigger OnOpenPage()
    begin
        IF NOT UserSetup.GET(USERID) THEN ERROR('Access Denied');
        UserSetup.TESTFIELD("Employee No.");
        HRMJobs.RESET;
        HRMJobs.SETRANGE("Supervisor/Manager", UserSetup."Employee No.");
        IF NOT HRMJobs.FIND('-') THEN ERROR('You are not an HOD. \**Access denied');
        rec.SETFILTER("Job Title", HRMJobs."Job ID");
    end;

    var
        stud: Record Customer;
        CourseRegistration: Record "HRM-Appraisal Registration";
        PictureExists: Boolean;
        StudentRec: Record Customer;
        CourseReg: Record "HRM-Appraisal Registration";
        districtname: Text[50];
        Cust: Record Customer;
        GenJnl: Record "Gen. Journal Line";
        PDate: Date;
        CReg: Record "HRM-Appraisal Registration";
        Prog: Record "HRM-Appraisal Jobs";
        TransInv: Boolean;
        TransRec: Boolean;
        CustL: Record "Cust. Ledger Entry";
        Units: Record "HRM-Appraisal Targets";
        GenSetUp: Record "HRM-Appraisal Gen. Setup";
        CurrentBill: Decimal;
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        VendLedg: Record "Vendor Ledger Entry";
        DVendLedg: Record "Detailed Vendor Ledg. Entry";
        VATEntry: Record "VAT Entry";
        CustLed2: Record "Cust. Ledger Entry";
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        CustLedg: Record "Cust. Ledger Entry";
        DueDate: Date;
        Sems: Record "HRM-Appraisal Periods";
        ChangeLog: Record "Change Log Entry";
        CurrentBal: Decimal;
        "Settlement Type": Record "HRM-Employee Category";
        AccPayment: Boolean;
        SettlementType: Code[20];
        UserSetup: Record "User Setup";
        HRMJobs: Record "HRM-Jobs";

    procedure GetSelectionFilter(): Code[80]
    var
        Cust: Record Customer;
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        CustCount := Cust.COUNT;
        IF CustCount > 0 THEN BEGIN
            Cust.FIND('-');
            WHILE CustCount > 0 DO BEGIN
                CustCount := CustCount - 1;
                Cust.MARKEDONLY(FALSE);
                FirstCust := Cust."No.";
                LastCust := FirstCust;
                More := (CustCount > 0);
                WHILE More DO
                    IF Cust.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT Cust.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastCust := Cust."No.";
                            CustCount := CustCount - 1;
                            IF CustCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstCust = LastCust THEN
                    SelectionFilter := SelectionFilter + FirstCust
                ELSE
                    SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
                IF CustCount > 0 THEN BEGIN
                    Cust.MARKEDONLY(TRUE);
                    Cust.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;

    procedure SetSelection(var Cust: Record Customer)
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
    end;
}

