page 52178713 "FIN-Posted imprest list"
{
    CardPageID = "FIN-Posted Imprest Req. UP";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "FIN-Imprest Header";
    SourceTableView = WHERE(Status = CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Total Payment Amount"; Rec."Total Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Current Status"; Rec."Current Status")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = All;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = All;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field("Currency Reciprical"; Rec."Currency Reciprical")
                {
                    ApplicationArea = All;
                }
                field("Current Source A/C Bal."; Rec."Current Source A/C Bal.")
                {
                    ApplicationArea = All;
                }
                field("Cancellation Remarks"; Rec."Cancellation Remarks")
                {
                    ApplicationArea = All;
                }
                field("Register Number"; Rec."Register Number")
                {
                    ApplicationArea = All;
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = All;
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Division';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Caption = 'Region';
                    ApplicationArea = All;
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = All;
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Surrender Status"; Rec."Surrender Status")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Payment Voucher No"; Rec."Payment Voucher No")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Expenditure"; Rec."Actual Expenditure")
                {
                    ApplicationArea = All;
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    ApplicationArea = All;
                }
                field("Budget Balance"; Rec."Budget Balance")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Print Accounting Request")
                {
                    Image = PrintAttachment;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        Rec.RESET;
                        Rec.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(51267, TRUE, TRUE, Rec);
                        Rec.RESET;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetFilter("Requested By", UserID);
    end;

    trigger OnInit()
    begin
        rec.SetFilter("Requested By", UserID);
    end;

    trigger OnAfterGetRecord()
    begin
        rec.SetFilter("Requested By", UserID);
    end;
}