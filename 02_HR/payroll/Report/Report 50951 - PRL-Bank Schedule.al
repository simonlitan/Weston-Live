report 50951 "PRL-Bank Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './payroll/Report/SSR/PRL-Bank Schedule.rdl';

    dataset
    {
        dataitem("PRL-Period Transactions"; "PRL-Period Transactions")
        {
            DataItemTableView = SORTING("Employee Code", "Transaction Code", "Period Month", "Period Year", Membership, "Reference No") ORDER(Ascending) WHERE("Transaction Code" = FILTER('NPAY'));
            RequestFilterFields = "Payroll Period";
            column(CompName; CompanyInformation.Name)
            {
            }
            column(picture; CompanyInformation.Picture)
            { }

            column(CompAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2")
            {
            }
            column(PhoneNo; CompanyInformation."Phone No." + ' ' + CompanyInformation."Phone No. 2")
            {
            }
            column(PeriodName; PayrollPeriods."Period Name")
            {
            }
            column(TransAmount; "PRL-Period Transactions".Amount)
            {
                DecimalPlaces = 0 : 0;
            }
            column(EmpNames; HRMEmployeeD."First Name" + ' ' + HRMEmployeeD."Middle Name" + ' ' + HRMEmployeeD."Last Name")
            {
            }
            column(EmpCode; "PRL-Period Transactions"."Employee Code")
            {
            }
            column(AccNo; HRMEmployeeD."Bank Account Number")
            {
            }

            column(MainBankcode; HRMEmployeeD."Main Bank" + '' + HRMEmployeeD."Branch Bank")
            {
            }
            column(Mainbankname; HRMEmployeeD."Main Bank Name")
            { }
            column(Branchbankcode; HRMEmployeeD."Branch Bank")
            { }
            column(BranchbankName; HRMEmployeeD."Branch Bank Name")
            {
            }
            column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);

                if HRMEmployeeD.Get("PRL-Period Transactions"."Employee Code") then
                    if ((HRMEmployeeD."Employee Category" = 'CASUALS') OR (HRMEmployeeD."Employee Category" = 'PART-TIME'))
                        then
                        CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                if "PRL-Period Transactions".GetFilter("PRL-Period Transactions"."Payroll Period") = '' then Error('Specify a period on the filters');
                PayrollPeriods.Reset;
                PayrollPeriods.SetFilter("Date Opened", "PRL-Period Transactions".GetFilter("PRL-Period Transactions"."Payroll Period"));
                if PayrollPeriods.Find('-') then begin
                end;
            end;
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin

        end;
    end;

    var
        Bank_ScheduleCaptionLbl: Label 'Bank Schedule';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        KBA_Branch_CodeCaptionLbl: Label 'KBA Branch Code';
        Period_TotalCaptionLbl: Label 'Period Total';
        Full_NamesCaptionLbl: Label 'Full Names';
        Net_PayCaptionLbl: Label 'Net Pay';
        TransAmount: Decimal;
        TotalCaptionLbl: Label 'Total';
        PeriodTRans: Record "PRL-Period Transactions";
        NPay: Decimal;
        TNpay: Decimal;
        GrantTotal: Decimal;
        PayrollPeriods: Record "PRL-Payroll Periods";
        CompanyInformation: Record "Company Information";
        PRLBankStructure: Record "PRL-Bank Structure";
        HRMEmployeeD: Record "HRM-Employee C";
}

