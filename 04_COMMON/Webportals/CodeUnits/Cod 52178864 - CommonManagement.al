codeunit 52178864 "Common Management"
{
  procedure LeaveApplication(username: Text; leaveType: Text; reliever: Text; appliedDays: Decimal; startDate: Date; endDate: Date; returnDate: Date; purpose: Text; resCenter: Text; department: Text; offDay: Integer; totalOffDays: Decimal) Message: Text
  var
    LeaveRequisition: Record "HRM-Leave Requisition";
    NextLeaveNo: Text;
    NoSeriesMngnt: Codeunit NoSeriesManagement;
    HRMSetup: Record "HRM-Setup";
    FullNames: Text;
    EmployeeCard: Record "HRM-Employee C";
  begin
    HRMSetup.Get();
    NextLeaveNo := NoSeriesMngnt.GetNextNo(HRMSetup."Leave Application Nos.", 0D, true);

    Clear(FullNames);
    EmployeeCard.Reset();
    EmployeeCard.SetRange("No.", username);
    if EmployeeCard.Find('-') then begin
      FullNames := EmployeeCard."First Name" + ' ' + EmployeeCard."Middle Name" + ' ' + EmployeeCard."Last Name";
    end;

    LeaveRequisition.Init();
    LeaveRequisition."No." := NextLeaveNo;
    LeaveRequisition."Employee No" := username;
    LeaveRequisition.Validate("Employee No");
    LeaveRequisition."Reliever No." := reliever;
    LeaveRequisition.Validate("Reliever No.");
    LeaveRequisition."Starting Date" := startDate;
    LeaveRequisition."End Date" := endDate;
    LeaveRequisition."Return Date" := returnDate;
    LeaveRequisition."Applied Days" := appliedDays;
    LeaveRequisition."Responsibility Center" := resCenter;
    LeaveRequisition."Department Code" := department;
    LeaveRequisition.Purpose := purpose;
    LeaveRequisition."Off Day" := offDay;
    LeaveRequisition."Total Off Days" := totalOffDays;
    LeaveRequisition."User ID" := UserId;
    LeaveRequisition.Date := Today();
    LeaveRequisition."Leave Type" := leaveType;
    LeaveRequisition.Insert();
    Message := NextLeaveNo;
  end;

  procedure OnSendLeaveForApproval(leaveNo: Text)
  var
    LeaveRequisition: Record "HRM-Leave Requisition";
    ApprovalMngnt: Codeunit IntCodeunit2;
  begin
    LeaveRequisition.Reset();
    LeaveRequisition.SetRange("No.", leaveNo);
    if LeaveRequisition.Find('-') then begin
      if ApprovalMngnt.IsLeaveEnabled(LeaveRequisition) = false then Error('No approval workflow enabled');
      ApprovalMngnt.OnSendLeaveforApproval(LeaveRequisition);
    end;
  end;

  procedure OnCancelLeaveForApproval(leaveNo: Text)
  var
    LeaveRequisition: Record "HRM-Leave Requisition";
    ApprovalMngnt: Codeunit IntCodeunit2;
  begin
    LeaveRequisition.Reset();
    LeaveRequisition.SetRange("No.", leaveNo);
    if LeaveRequisition.Find('-') then begin
      ApprovalMngnt.OnCancelLeaveforApproval(LeaveRequisition);
    end;
  end;
}
