/// <summary>
/// Report HR Leave Statement (ID 51176).
/// </summary>
report 51176 "HR Leave Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './hr/Reports/SSR/HRLeaveStatement.rdl';

    dataset
    {
        dataitem(DataItem9741; "HRM-Leave Requisition")
        {
            DataItemTableView = SORTING("No.","Employee No");
            RequestFilterFields =  "Employee No";


            column(CompName; CompanyInformation.Name)
            {
            }
            column(Address; CompanyInformation.Address + ' ' + CompanyInformation."Address 2")
            {
            }
            column(Phones; CompanyInformation."Phone No." + ' ' + CompanyInformation."Phone No. 2")
            {
            }

            column(Mails; CompanyInformation."E-Mail")
            {
            }

            column(pics; CompanyInformation.Picture)
            {
            }
            /* column(Address; Address + ' ' + "Address 2" + ' ' + City)
            {
            }
            column(pics; Picture)
            {
            }
            column(Phones; "Phone No." + '/' + "Phone No. 2")
            {
            }
            column(Mails; "E-Mail" + '/' + "Home Page")
            {
            } */
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            column(USERID; USERID)
            {
            }
            column(LeaveNo_; "No.")
            {
            }
            column(HR_Leave_Requisition_Date; Date)
            {
            }
            column(HR_Leave_Requisition__Employee_No_; "Employee No")
            {
            }
            column(HR_Leave_Requisition__Employee_Name_; "Employee Name")
            {
            }

            column(HR_Leave_Requisition__Department_Code_; "Department Code")
            {
            }
            column(HR_Leave_Requisition__Applied_Days_; "Applied Days")
            {
            }
            column(HR_Leave_Requisition__Starting_Date_; "Starting Date")
            {
            }
            column(HR_Leave_Requisition__End_Date_; "End Date")
            {
            }
            column(ReturnDate; "Return Date")
            {
            }
            column(HR_Leave_Requisition_Purpose; Purpose)
            {
            }
            column(HR_Leave_Requisition__Leave_Type_; "Leave Type")
            {
            }
            column(HR_Leave_Requisition__Leave_Balance_; "Leave Balance")
            {
            }
            column(Availabledays_DataItem9741; "Available days")
            {
            }
            column(AvaillableDays_DataItem9741; "Availlable Days")
            {
            }

            column(HR_Leave_Requisition_Status; Status)
            {
            }
            column(LEAVE_APPLICATIONCaption; LEAVE_APPLICATIONCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Leave_Requisition__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(HR_Leave_Requisition_DateCaption; FIELDCAPTION(Date))
            {
            }
            column(HR_Leave_Requisition__Employee_No_Caption; FIELDCAPTION("Employee No"))
            {
            }
            /* column(HR_Leave_Requisition__Campus_Code_Caption; FIELDCAPTION("Region Code"))
            {
            } */
            column(HR_Leave_Requisition__Department_Code_Caption; FIELDCAPTION("Department Code"))
            {
            }
            column(HR_Leave_Requisition__Applied_Days_Caption; FIELDCAPTION("Applied Days"))
            {
            }
            column(HR_Leave_Requisition__Starting_Date_Caption; FIELDCAPTION("Starting Date"))
            {
            }
            column(HR_Leave_Requisition__End_Date_Caption; FIELDCAPTION("End Date"))
            {
            }
            column(HR_Leave_Requisition_PurposeCaption; FIELDCAPTION(Purpose))
            {
            }
            column(HR_Leave_Requisition__Leave_Type_Caption; FIELDCAPTION("Leave Type"))
            {
            }
            column(HR_Leave_Requisition__Leave_Balance_Caption; FIELDCAPTION("Leave Balance"))
            {
            }
            column(HR_Leave_Requisition_StatusCaption; FIELDCAPTION(Status))
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(CurrentFinancialYear_DataItem9741; "Current Financial Year")
            {
            }
            column(PreviousFinancialYear_DataItem9741; "Previous Financial Year")
            {
            }
            column(Jobtitle_DataItem9741; "Job title")
            {
            }
            column(Salutation_DataItem9741; Salutation)
            {
            }
            column(DaysCarriedforward_DataItem9741; "Days Carried forward")
            {
            }
            column(AnnualLeavedays_DataItem9741; "Annual Leave days")
            {
            }
            dataitem(DataItem1171; "Approval Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");
                //DataItemTableView = SORTING("Table ID", "Document Type", "Document No.", "Sequence No.") ORDER(Ascending) WHERE("Approved The Document" = FILTER(true));
                column(Approval_Entry__Approver_ID_; "Approver ID")
                {
                }
                column(Approval_Entry_Status; Status)
                {
                }
                column(Approval_Entry__Last_Date_Time_Modified_; "Last Date-Time Modified")
                {
                }
                column(APPROVALSCaption; APPROVALSCaptionLbl)
                {
                }
                column(APPROVER_IDCaption; APPROVER_IDCaptionLbl)
                {
                }
                column(APPROVAL_DATECaption; APPROVAL_DATECaptionLbl)
                {
                }
                column(APPROVAL_ACTIONCaption; APPROVAL_ACTIONCaptionLbl)
                {
                }
                column(Approval_Entry_Table_ID; "Table ID")
                {
                }
                column(Approval_Entry_Document_Type; "Document Type")
                {
                }
                column(Approval_Entry_Document_No_; "Document No.")
                {
                }
                column(Approval_Entry_Sequence_No_; "Sequence No.")
                {
                }
                // column(ApprovalTitle; UserSetup."Approval Title")
                // {
                // }
                column(ApprovalSignature; UserSetup."User Signature")
                {
                }
                column(ApproveDateTime; "Last Date-Time Modified")
                {
                }

                trigger OnAfterGetRecord()
                var
                    emp: Record "HRM-Employee C";

                begin
                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", "Approver ID");
                    IF UserSetup.FIND('-') THEN UserSetup.CALCFIELDS("User Signature");
                    DataItem9741.CalcFields("Availlable Days");

                    emp.Reset();
                    emp.SetRange("No.", DataItem9741."Employee No");
                    if emp.Find('-') then begin
                        DataItem9741.Salutation := emp.Salutation;
                        DataItem9741."Job title" := emp."Job Title";
                        DataItem9741."Current Financial Year" := '2022/2023';
                        DataItem9741."Previous Financial Year" := '2021/2022';

                    end;

                end;

                trigger OnPreDataItem()
                begin
                    //   SETFILTER("Approver ID",'<>%1',"User ID");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
    trigger OnPreReport()
    begin

        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    trigger OnInitReport()
    begin
        /* RESET;
        IF FIND('-') THEN BEGIN
            CALCFIELDS(Picture);
        END; */
    end;

    var
        LEAVE_APPLICATIONCaptionLbl: Label 'LEAVE APPLICATION';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        NameCaptionLbl: Label 'Name';
        APPROVALSCaptionLbl: Label 'APPROVALS';
        APPROVER_IDCaptionLbl: Label 'APPROVER ID';
        APPROVAL_DATECaptionLbl: Label 'APPROVAL DATE';
        APPROVAL_ACTIONCaptionLbl: Label 'APPROVAL ACTION';
        Company: Record Company;
        CompanyInformation: Record "Company Information";
        UserSetup: Record "User Setup";

}

