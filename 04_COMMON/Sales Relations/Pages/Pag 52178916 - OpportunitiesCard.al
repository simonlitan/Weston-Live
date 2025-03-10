page 52178916 "Opportunities Card"
{
    Caption = 'Opportunity Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Opportunity,Quotes,Booking, Invoice,Agreement Form, Agreement/Order Form';
    RefreshOnActivate = true;
    SourceTable = Opportunity;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the opportunity.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = ContactNoEditable;
                    ToolTip = 'Specifies the number of the contact that this opportunity is linked to.';

                    trigger OnValidate()
                    var
                        Contact: Record Contact;
                    begin
                        if Rec."Contact No." <> '' then
                            if Contact.Get(Rec."Contact No.") then
                                Contact.CheckIfPrivacyBlockedGeneric;
                        ContactNoOnAfterValidate();
                    end;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the No. field.';
                }
                field(ContactPhoneNo; GlobalContact."Phone No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Phone No.';
                    Importance = Additional;
                    Editable = false;
                    ExtendedDatatype = PhoneNo;
                    ToolTip = 'Specifies the telephone number of the contact to which this opportunity is linked.';
                }
                field(ContactMobilePhoneNo; GlobalContact."Mobile Phone No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Mobile Phone No.';
                    Importance = Additional;
                    Editable = false;
                    ExtendedDatatype = PhoneNo;
                    ToolTip = 'Specifies the mobile telephone number of the contact to which this opportunity is linked.';
                }
                field(ContactEmail; GlobalContact."E-Mail")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Email';
                    Importance = Additional;
                    Editable = false;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the email address of the contact to which this opportunity is linked.';
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the company of the contact person to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the Contact Company No. field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Editable = SalespersonCodeEditable;
                    ToolTip = 'Specifies the code of the salesperson that is responsible for the opportunity.';
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SalesDocumentTypeEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the type of the sales document (Quote, Order, Posted Invoice). The combination of Sales Document No. and Sales Document Type specifies which sales document is assigned to the opportunity.';
                    ValuesAllowed = " ", Quote, Order;
                }
                field("Sales Document No."; Rec."Sales Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SalesDocumentNoEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales document that has been created for this opportunity.';
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = CampaignNoEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the campaign to which this opportunity is linked.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = PriorityEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the priority of the opportunity. There are three options:';
                }
                field("Sales Cycle Code"; Rec."Sales Cycle Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = SalesCycleCodeEditable;
                    ToolTip = 'Specifies the code of the sales cycle that the opportunity is linked to.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the status of the opportunity. There are four options:';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies that the opportunity is closed.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date that the opportunity was created.';
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the date the opportunity was closed.';
                }
                field("Segment No."; Rec."Segment No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the segment (if any) that is linked to the opportunity.';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = all;
                }

            }

            part(Control25; "Opportunity Subform")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Opportunity No." = FIELD("No.");
            }
            part(Bookings; "Opportunity Booking Schedules")
            {
                Visible = false;
                ApplicationArea = All;
                SubPageLink = Opportunity = field("No.");

            }

        }

    }

    actions
    {
        area(navigation)
        {
            group("Oppo&rtunity")
            {
                Caption = 'Oppo&rtunity';
                Image = Opportunity;

                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Opportunity No." = FIELD("No.");
                    RunPageView = SORTING("Opportunity No.", Date);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                action(Update)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Update';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Update all the actions that are related to your opportunity.';
                    Visible = Started;

                    trigger OnAction()
                    begin
                        Rec.UpdateOpportunity;
                    end;
                }
                action(CloseOpportunity)
                {

                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Close';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Close all the actions that are related to your opportunity.';
                    Visible = Started;

                    trigger OnAction()
                    begin
                        Rec.CloseOpportunity;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Opportunity),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action("Postponed &Interactions")
                {
                    Visible = false;
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Postponed &Interactions';
                    Image = PostponedInteractions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "Opportunity No." = FIELD("No.");
                    RunPageView = SORTING("Opportunity No.", Date);
                    ToolTip = 'View postponed interactions for opportunities.';
                }
                action("T&asks")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'T&asks';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Task List";
                    RunPageLink = "Opportunity No." = FIELD("No."),
                                  "System To-do Type" = FILTER(Organizer);
                    RunPageView = SORTING("Opportunity No.");
                    ToolTip = 'View all marketing tasks that involve the opportunity.';
                }
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Opportunity Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }

                action("Show Sales Quote")
                {
                    Visible = false;
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Show Sales Quote';
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Show the assigned sales quote.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if (Rec."Sales Document Type" <> Rec."Sales Document Type"::Quote) or
                           (Rec."Sales Document No." = '')
                        then
                            Error(Text001);

                        if SalesHeader.Get(SalesHeader."Document Type"::Quote, Rec."Sales Document No.") then
                            PAGE.Run(PAGE::"Sales Quote", SalesHeader)
                        else
                            Error(Text002, Rec."Sales Document No.");
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics 365 Sales';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoOpportunity)
                {
                    ApplicationArea = Suite;
                    Caption = 'Opportunity';
                    Image = CoupledContactPerson;
                    ToolTip = 'Open the coupled Dynamics 365 Sales opportunity.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record" = IM;
                    ApplicationArea = Suite;
                    Caption = 'Synchronize';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Dynamics 365 Sales.';

                    trigger OnAction()
                    var
                        Opportunity: Record Opportunity;
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        OpportunityRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(Opportunity);
                        Opportunity.Next;

                        if Opportunity.Count = 1 then
                            CRMIntegrationManagement.UpdateOneNow(Opportunity.RecordId)
                        else begin
                            OpportunityRecordRef.GetTable(Opportunity);
                            CRMIntegrationManagement.UpdateMultipleNow(OpportunityRecordRef);
                        end
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Business Central record and a Dynamics 365 Sales record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Dynamics 365 Sales opportunity.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(Rec.RecordId);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = D;
                        ApplicationArea = Suite;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Dynamics 365 Sales opportunity.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(Rec.RecordId);
                        end;
                    }
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the opportunity table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(Rec.RecordId);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Activate the First Stage")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Activate First Stage';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Specify if the opportunity is to be activated. The status is set to In Progress.';
                    Visible = NOT Started;

                    trigger OnAction()
                    begin
                        Rec.StartActivateFirstStage;
                    end;
                }

                action(CreateSalesQuote)
                {
                    Visible = false;
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create Sales &Quote';
                    Enabled = OppInProgress;
                    Image = Allocate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create a new sales quote with the opportunity inserted as the customer.';

                    trigger OnAction()
                    begin
                        Rec.CreateQuote;
                    end;
                }
                action("Print Details")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print Details';
                    Image = Print;
                    ToolTip = 'View information about your sales stages, activities and planned tasks for an opportunity.';

                    trigger OnAction()
                    var
                        Opp: Record Opportunity;
                    begin
                        Opp := Rec;
                        Opp.SetRecFilter;
                        REPORT.Run(REPORT::"Opportunity - Details", true, false, Opp);
                    end;
                }
                action("Create &Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create &Interaction';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Create an interaction with a specified opportunity.';

                    trigger OnAction()
                    var
                        TempSegmentLine: Record "Segment Line" temporary;
                    begin
                        TempSegmentLine.CreateInteractionFromOpp(Rec);
                    end;
                }

            }

            group("Quotes")
            {
                action(Quote)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Image = NewSalesQuote;
                    trigger OnAction()
                    begin
                        if Confirm('Create/View Quote ?', true) = false then
                            Error('Cancelled');
                        GetQuote(Rec);
                    end;
                }
            }
            group("Booking Confirmation")
            {
                Visible = false;
                action(Confirm)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category6;
                    Image = Confirm;

                    trigger OnAction()
                    begin
                        //ConfirmBooking(Rec)
                    end;
                }
                group("Invoices")
                {
                    action(Invoice)
                    {
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Category7;
                        Image = NewSalesQuote;
                        trigger OnAction()
                        begin
                            if Confirm('Create/View Invoice ?', true) = false then Error('Cancelled');
                            GetInvoice(Rec);
                        end;
                    }
                }
                group("Agreement Form")
                {
                    action(Form)
                    {
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Category8;
                        Image = NewSalesQuote;
                        trigger OnAction()
                        var
                            opp: Record Opportunity;
                        begin
                            opp.Reset();
                            opp.SetRange("No.", rec."No.");
                            Report.Run(Report::"Events Agreement Form", true, false, opp);
                        end;
                    }
                }

            }
            group("Order Form")
            {
                action(orderForm)
                {
                    Caption = 'Events Order Form';
                    ApplicationArea = All;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Category9;
                    Image = NewSalesQuote;
                    trigger OnAction()
                    var
                        opp: Record Opportunity;
                    begin
                        opp.Reset();
                        opp.SetRange("No.", rec."No.");
                        Report.Run(Report::"Events Order Form", true, false, opp);
                    end;
                }

                action(orderForms)
                {
                    Caption = 'Agreement/Order Form';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category9;
                    Image = NewSalesQuote;
                    trigger OnAction()
                    var
                        opp: Record Opportunity;
                    begin
                        FoodForm(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        Contact: Record Contact;
    begin
        if Rec."Contact No." <> '' then
            if Contact.Get(Rec."Contact No.") then
                Contact.CheckIfPrivacyBlockedGeneric;
        if Rec."Contact Company No." <> '' then
            if Contact.Get(Rec."Contact Company No.") then
                Contact.CheckIfPrivacyBlockedGeneric;
        UpdateEditable;
        OppInProgress := Rec.Status = Rec.Status::"In Progress";
        OppNo := Rec."No.";
    end;

    trigger OnAfterGetRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        if CRMIntegrationEnabled then
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);

        GlobalContact.GetOrClear(Rec."Contact No.");
    end;

    trigger OnInit()
    begin
        ContactNoEditable := true;
        PriorityEditable := true;
        CampaignNoEditable := true;
        SalespersonCodeEditable := true;
        SalesDocumentTypeEditable := true;
        SalesDocumentNoEditable := true;
        SalesCycleCodeEditable := true;
        Started := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Creation Date" := WorkDate;
        if Rec."Segment No." = '' then
            Rec.SetSegmentFromFilter;
        if Rec."Contact No." = '' then
            Rec.SetContactFromFilter;
        if Rec."Campaign No." = '' then
            Rec.SetCampaignFromFilter;
        Rec.SetDefaultSalesCycle;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        OppNo := Rec."No.";
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec.Get(Rec."No.") then
            if (Rec."No." <> OppNo) and (Rec.Status = Rec.Status::"Not Started") then
                Rec.StartActivateFirstStage;
    end;

    var
        GlobalContact: Record Contact;
        Text001: Label 'There is no sales quote assigned to this opportunity.';
        Text002: Label 'Sales quote %1 doesn''t exist.';
        OppNo: Code[20];
        [InDataSet]
        SalesCycleCodeEditable: Boolean;
        [InDataSet]
        SalesDocumentNoEditable: Boolean;
        [InDataSet]
        SalesDocumentTypeEditable: Boolean;
        [InDataSet]
        SalespersonCodeEditable: Boolean;
        [InDataSet]
        CampaignNoEditable: Boolean;
        [InDataSet]
        PriorityEditable: Boolean;
        [InDataSet]
        ContactNoEditable: Boolean;
        Started: Boolean;
        OppInProgress: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;

    local procedure UpdateEditable()
    begin
        Started := (Rec.Status <> "Opportunity Status"::"Not Started");
        SalesCycleCodeEditable := Rec.Status = "Opportunity Status"::"Not Started";
        SalespersonCodeEditable := IsStatusLessThanWon();
        CampaignNoEditable := IsStatusLessThanWon();
        PriorityEditable := IsStatusLessThanWon();
        ContactNoEditable := IsStatusLessThanWon();
        SalesDocumentNoEditable := Rec.Status = "Opportunity Status"::"In Progress";
        SalesDocumentTypeEditable := Rec.Status = "Opportunity Status"::"In Progress";
    end;

    local procedure IsStatusLessThanWon(): Boolean
    begin
        exit(Rec.Status.AsInteger() < "Opportunity Status"::Won.AsInteger());
    end;

    local procedure ContactNoOnAfterValidate()
    begin
        Rec.CalcFields("Contact Name", "Contact Company Name");
    end;

    procedure GetQuote(var Opp: Record Opportunity)
    var
        squote: Record "Sales Quotes";
        noseries: Codeunit NoSeriesManagement;
        setup: Record "Sales & Receivables Setup";
        usr: Record User;

    begin
        squote.Reset();
        squote.SetRange("Opportunity No.", Opp."No.");
        squote.SetRange("Document Type", squote."Document Type"::Quote);
        if not squote.Find('-') then begin
            squote.Init();
            setup.get;
            squote."No." := noseries.GetNextNo(setup."Quote Nos.", 0D, true);
            squote."Contact No." := Opp."Contact No.";
            squote."Opportunity No." := Opp."No.";
            squote.Name := Opp."Contact Company Name";
            squote."Salesperson Code" := Opp."Salesperson Code";
            squote.Username := UserId;
            squote."Document Type" := squote."Document Type"::Quote;
            usr.Reset();
            usr.SetRange("User Name", UserId);
            if usr.Find('-') then
                squote."Reservation Officer" := usr."Full Name";

            squote."Document date" := Today;
            squote.Insert();

            Page.Run(Page::"Sales Quote Card", squote);

        end else begin
            if squote."Document date" = 0D then
                squote."Document date" := Today;

            if squote."Reservation Officer" = '' then begin
                usr.Reset();
                usr.SetRange("User Name", UserId);
                if usr.Find('-') then begin
                    squote.Username := UserId;
                    squote."Reservation Officer" := usr."Full Name";
                end;
            end;
            squote.Modify();
            Page.Run(Page::"Sales Quote Card", squote);
        end;
    end;

    // procedure ConfirmBooking(var Opp: Record Opportunity)
    // var
    //     bschedule: Record "Booking Schedule";
    // begin
    //     if Confirm('Confirm this Booking ?', true) = false then Error('Cancelled');
    //     bschedule.Reset();
    //     bschedule.SetRange(Opportunity, Opp."No.");
    //     if bschedule.Find('-') then begin
    //         repeat
    //             bschedule.TestField("No of days");
    //             bschedule."Booking Confirmed" := true;
    //             bschedule."Booking Status" := bschedule."Booking Status"::Confirmed;
    //             bschedule."Confirmed By" := UserId;
    //             bschedule."Date Confirmed" := System.CurrentDateTime;
    //             bschedule.Modify();
    //         until bschedule.Next() = 0;
    //     end;
    //     Message('%1%2%3%4', 'Booking Confirmed and facility blocked from ', bschedule."Start date", ' to ', bschedule."End date");
    // end;


    procedure GetInvoice(var Opp: Record Opportunity)
    var
        squote: Record "Sales Quotes";
        noseries: Codeunit NoSeriesManagement;
        setup: Record "Sales & Receivables Setup";
        usr: Record User;
    begin
        squote.Reset();
        squote.SetRange("Opportunity No.", Opp."No.");
        squote.SetRange("Document Type", squote."Document Type"::Invoice);
        if not squote.Find('-') then begin
            squote.Init();
            setup.get;
            squote."No." := noseries.GetNextNo(setup."Invoice Nos.", 0D, true);
            squote."Contact No." := Opp."Contact No.";
            squote."Opportunity No." := Opp."No.";
            squote.Name := Opp."Contact Company Name";
            squote."Salesperson Code" := Opp."Salesperson Code";
            squote.Username := UserId;
            squote."Document Type" := squote."Document Type"::Invoice;
            usr.Reset();
            usr.SetRange("User Name", UserId);
            if usr.Find('-') then
                squote."Reservation Officer" := usr."Full Name";

            squote."Document date" := Today;
            squote.Insert();

            Page.Run(Page::"Sales Invoice Card", squote);

        end else begin
            if squote."Document date" = 0D then
                squote."Document date" := Today;
            if squote."Reservation Officer" = '' then begin
                usr.Reset();
                usr.SetRange("User Name", UserId);
                if usr.Find('-') then begin
                    squote.Username := UserId;
                    squote."Reservation Officer" := usr."Full Name";
                end;
            end;
            squote.Modify();
            Page.Run(Page::"Sales Invoice Card", squote);
        end;
    end;

    procedure FoodForm(var Opp: Record Opportunity)
    var
        FoF: Record "Food Order Form";
        noseries: Codeunit NoSeriesManagement;
        setup: Record "Sales & Receivables Setup";
        usr: Record User;
    begin
        FoF.Reset();
        FoF.SetRange("Opportunity No.", Opp."No.");
        if not FoF.Find('-') then begin
            FoF.Init();
            setup.get;
            FoF."No." := noseries.GetNextNo(setup."Invoice Nos.", 0D, true);
            FoF."Contact No." := Opp."Contact No.";
            FoF."Opportunity No." := Opp."No.";
            FoF.Name := Opp."Contact Company Name";
            FoF."Salesperson Code" := Opp."Salesperson Code";
            FoF.Username := UserId;
            FoF."Shortcut Dimension 1 Code" := '10';
            FoF."Shortcut Dimension 2 Code" := '1087';
            usr.Reset();
            usr.SetRange("User Name", UserId);
            if usr.Find('-') then
                FoF."Received By" := usr."Full Name";

            FoF."Document date" := Today;
            FoF.Insert();

            Page.Run(Page::"Food Order Form", FoF);

        end else begin
            if FoF."Document date" = 0D then
                FoF."Document date" := Today;
            if FoF."Received By" = '' then begin
                usr.Reset();
                usr.SetRange("User Name", UserId);
                if usr.Find('-') then begin
                    FoF.Username := UserId;
                    FoF."Received By" := usr."Full Name";
                end;
            end;
            FoF.Modify();
            Page.Run(Page::"Food Order Form", FoF);
        end;
    end;


}

