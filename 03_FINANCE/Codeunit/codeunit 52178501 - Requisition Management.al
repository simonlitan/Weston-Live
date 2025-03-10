codeunit 52178501 "Requisition Management"
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        InvenSetup: Record "Inventory Setup";
        Err100: Label 'The Requisition Fulfilment Item Journal andTtemplate must be defined in Purchases & Payables Setup';
        Err200: Label 'The No. series for the Item Journal %1 and %2 must be defined!';
        Err300: Label 'The To & From locations must be defined';
        SNText01: Label 'There are no purchase review documents to process.  Please select the appropriate Decision and enter Target No. to process documents.';
        SNText02: Label 'No line were eligible for posting encumbrances - check line statuses.';
        SNText03: Label 'The Purchase Order %1 you are appending to does not exist.';
        SNText04: Label 'You cannot cancel a %1 purchase line.';
        SNText05: Label 'Advanced Budgeting is not licensed or activated in Source Codes.';
        SNText06: Label 'You cannot cancel a submitted for approval purchase line, Document %1 Line %2.';
        SNText07: Label 'Reversed Requisition Fulfillment & Canceled line, Document %1 Line %2.';
        SNText08: Label 'Use Delete instead of Cancel Line for purchase line, Document %1 Line %2.';
        SNText09: Label 'You cannot cancel a new purchase line, Document %1 Line %2 - Delete Line instead.';
        SNText10: Label 'Commitment Posting is not activated.';
        SNText11: Label 'Encumbrance Posting is not activated.';
        SNText12: Label 'There are no lines with status New and an Amount to check.';
        SNText13: Label 'Nothing to Submit.';
        SNText14: Label 'Requisition %1 has submitted lines - cannot be deleted.';
        SNText15: Label 'There is nothing to cancel for Line %1.  Delete line instead.';
        SNText16: Label 'You cannot cancel a Requisition %1 Line %2 that is %3.';
        SNText17: Label 'You cannot cancel a Deposit %1 Line %2 that is %3.';
        SNText18: Label 'There are no lines to check.';
        SNText19: Label 'There are no lines to cancel.';
        SNText20: Label 'There are outstanding Orders that must be fully Invoiced or Canceled first.';
        SNText21: Label 'Should Blanket Order %1, Line No. %2 be re-encumbered?';
        SNText22: Label 'Blanket Order Status %1 is not valid ';
        SNText23: Label 'The line has been submitted for approval.  Confirm cancellation?';
        SNText24: Label 'Cancel Line has been stopped.  Document %1 Line %2.';
        SNText25: Label 'Posting is not allowed for proposed Vendors.  Vendor No.=%1.';
        SNText26: Label 'Processing is not allowed for proposed Vendors.  Vendor No.=%1.';
        SNText27: Label 'No lines were eligible for posting commitments - check line statuses.';
        SNText28: Label 'Purchase tolerance check failed.  Document No.=%1, Line No.=%2.';
        SNText29: Label 'Reclassification not permitted for document %1, line %2.';
        SNText30: Label 'Status must be Approval Pending, Transfer Budget Pending or Disapproved.';
        SNText31: Label 'There are no lines to reset.';
        SNText32: Label 'You cannot cancel a new sales line, Document %1 Line %2 - Delete Line instead.';
        SNText33: Label 'You cannot cancel a %1 sales line.';
        SNText34: Label 'There are %1 failed validations.  Preview Distributions to resolve.';
        SNText36: Label 'The document has been submitted for approval.  Confirm cancellation?';
        SNText37: Label 'Cancel Document has been stopped.  %1 %2.';
        SNText38: Label 'You cannot reset document a %1 %2 that is %3 %4.';
        SNText39: Label 'You cannot cancel a %1 %2 that is %3 %4.';
        CommitmentDescription: Label 'Reserve for Commitments';
        EncumbranceDescription: Label 'Reserve for Encumbrances';
        ConversionDescription: Label 'Conversion of  %1 to %2.';
        Window: Dialog;
        LineNo: Integer;
        Options: Record "Purchases & Payables Setup";
        DimMgt: Codeunit DimensionManagement;
        PurchReleaseDocs: Codeunit "Release Purchase Document";

    //[Scope('Internal')]
    procedure RequisitionReview(var TempRequisitionLine: Record "Purchase Line")
    var
        RequisitionLine: Record "Purchase Line";
        UserSetup: Record "User Setup";
        PurchaseHeader: Record "Purchase Header";
        LineNo: Integer;
        LastVendorProcessed: Code[20];
        DocNo: Code[20];
        LastReqDocNoProcessed: Code[20];
        DocumentType: enum "Purchase Document Type";
    begin
        PurchSetup.GET;
        RequisitionLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
        RequisitionLine.COPYFILTERS(TempRequisitionLine);
        //CALCFIELDS("Requisition Status");
        RequisitionLine.SETRANGE(Select2, TRUE);
        RequisitionLine.SETFILTER("Buy-from Vendor No.", '<>%1', '');
        RequisitionLine.SETFILTER(Decision, '<>%1', RequisitionLine.Decision::Order);
        RequisitionLine.SETFILTER(Quantity, '<>0');

        UserSetup.GET(USERID);
        /*
        IF NOT FINDFIRST() THEN BEGIN
          MESSAGE(SNText01);
          EXIT;
        END;
        //jeffer
        */

        Window.OPEN('#1#################################\\' +
                    'Processing Purchase Doc #2######################\' +
                    'New Vendor No.          #3######################\' +
                    'Detail Line No.         #4######################');

        //Create New Purchase Quote
        LineNo := 0;
        LastVendorProcessed := '';
        LastReqDocNoProcessed := '';
        DocNo := '';
        RequisitionLine.SETRANGE(Decision, RequisitionLine.Decision::Order);
        IF RequisitionLine.FINDSET(TRUE, FALSE) THEN BEGIN
            Window.UPDATE(1, RequisitionLine.Decision);
            REPEAT
                CreateNewPurchaseDocument(RequisitionLine, 1, DocNo, LineNo,
                                          LastVendorProcessed, LastReqDocNoProcessed);
                RequisitionLine.Decision := RequisitionLine.Decision::Order;
                RequisitionLine."Buy-from Vendor No." := '';
                //"Previous Status" := Status;
                //Status := Status::"5";
                RequisitionLine.MODIFY;

            UNTIL RequisitionLine.NEXT = 0;
        END;

        Window.CLOSE;

    end;

    //[Scope('Internal')]
    procedure CreateNewPurchaseDocument(var RequisitionLine: Record "Purchase Line"; DocumentType: Option Quote,"Order",,,"Blanket Order"; var DocumentNo: Code[20]; var LineNo: Integer; var LastVendorProcessed: Code[20]; var LastReqDocNoProcessed: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        RequisitionHeader: Record "Purchase Header";
        Vendor: Record Vendor;
    begin
        IF LastVendorProcessed = RequisitionLine."Buy-from Vendor No." THEN BEGIN
            LineNo := LineNo + 10000;
            PurchaseHeader.GET(DocumentType, DocumentNo);

        END ELSE BEGIN
            IF Vendor.GET(RequisitionLine."Buy-from Vendor No.") THEN
                PurchSetup.GET;
            PurchaseHeader.INIT;
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
            PurchaseHeader."PO Type" := RequisitionLine."PO Type";
            PurchaseHeader."Vendor Order No." := RequisitionLine."Document No.";
            PurchaseHeader."Quote No." := RequisitionLine."Document No.";
            // PurchaseHeader."No." := RequisitionLine."No.";
            //PurchaseHeader."VAT Registration No." := RequisitionLine.PIN;
            // PurchaseHeader."Job No." := RequisitionLine."Job No.";
            //VALIDATE("Job No.");
            PurchaseHeader."Assigned User ID 2" := UserId;

            PurchaseHeader.INSERT(TRUE);
            PurchaseHeader.VALIDATE("No.");
            PurchaseHeader.VALIDATE("Buy-from Vendor No.", RequisitionLine."Buy-from Vendor No.");
            //VALIDATE("Purchaser Code",RequisitionLine."Purchaser Code");
            PurchaseHeader.VALIDATE(PurchaseHeader."Posting Date", TODAY);
            PurchaseHeader.VALIDATE(PurchaseHeader."Document Date", TODAY);
            //RequisitionHeader.GET(RequisitionLine."Document No.");
            PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", RequisitionLine."Shortcut Dimension 1 Code");
            PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code", RequisitionLine."Shortcut Dimension 2 Code");
            //VALIDATE("Shortcut Dimension 3 Code", RequisitionLine."Shortcut Dimension Code");
            //Do the Other Dimensions
            //Other Dimensions
            PurchaseHeader.VALIDATE(PurchaseHeader."Dimension Set ID", RequisitionLine."Dimension Set ID");
            IF RequisitionHeader."Sell-to Customer No." <> '' THEN BEGIN
                PurchaseHeader.VALIDATE("Sell-to Customer No.", RequisitionHeader."Sell-to Customer No.");
                PurchaseHeader.VALIDATE("Ship-to Code", RequisitionHeader."Ship-to Code");
            END;
            IF RequisitionLine."Location Code" <> '' THEN
                PurchaseHeader.VALIDATE("Location Code", RequisitionLine."Location Code");
            PurchaseHeader."Prices Including VAT" := RequisitionHeader."Prices Including VAT";
            PurchaseHeader.VALIDATE(PurchaseHeader."Currency Code", RequisitionLine."Currency Code");

            PurchaseHeader."Assigned User ID 2" := UserId;
            PurchaseHeader.MODIFY;

            Window.UPDATE(2, STRSUBSTNO('%1 %2', PurchaseHeader."Document Type", PurchaseHeader."No."));
            Window.UPDATE(3, FORMAT(RequisitionLine."Buy-from Vendor No."));
            LastVendorProcessed := RequisitionLine."Buy-from Vendor No.";
            LineNo := 10000;
        END;

        PurchaseLine.INIT;
        PurchaseLine.VALIDATE(PurchaseLine."Document Type", PurchaseHeader."Document Type");
        PurchaseLine.VALIDATE(PurchaseLine."Document No.", PurchaseHeader."No.");
        PurchaseLine.VALIDATE(PurchaseLine.Type, RequisitionLine.Type);

        DocumentNo := PurchaseHeader."No.";
        RequisitionLineTOPurchaseLine(PurchaseLine, RequisitionLine, LineNo, FALSE);
        PurchaseLine.VALIDATE("Direct Unit Cost", RequisitionLine."Direct Unit Cost");
        IF LastReqDocNoProcessed <> RequisitionLine."Document No." THEN BEGIN
            //RequisitionCommentCopy(RequisitionLine."Document No.",DocumentType,DocumentNo);
#pragma warning disable AL0667
            IF ISSERVICETIER THEN BEGIN
#pragma warning restore AL0667
                PurchaseHeader.COPYLINKS(RequisitionHeader);
            END;
            LastReqDocNoProcessed := RequisitionLine."Document No.";
        END;

        Window.UPDATE(4, PurchaseLine."Line No.");
        PurchaseLine.INSERT(TRUE);
        //RequisitionLine."Document No." := PurchaseLine."Document No.";
        //RequisitionLine."Line No." := PurchaseLine."Line No.";
        //RequisitionLine.Processed:=TRUE;
        //RequisitionLine."Action Date" := WORKDATE;
        //RequisitionLine.MODIFY;
    end;

    // [Scope('Internal')]
    procedure RequisitionLineTOPurchaseLine(var PurchaseLine: Record "Purchase Line"; RequisitionLine: Record "Purchase Line"; LineNo: Integer; AppendToOrder: Boolean)
    var
        PurchaseHeader: Record "Purchase Header";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");

        PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := LineNo;
        IF NOT AppendToOrder THEN
            PurchaseLine.VALIDATE("Buy-from Vendor No.", RequisitionLine."Buy-from Vendor No.");
        //**
        PurchaseLine.VALIDATE(Type, RequisitionLine.Type);
        PurchaseLine.VALIDATE("No.", RequisitionLine."No.");
        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN
            PurchaseLine.VALIDATE("Location Code", RequisitionLine."Location Code");
        PurchaseLine."Expected Receipt Date" := RequisitionLine."Expected Receipt Date";
        PurchaseLine.Description := RequisitionLine.Description;
        PurchaseLine."Description 2" := RequisitionLine."Description 2";
        //"Last Issued By":=RequisitionLine.Narration;
        PurchaseLine.VALIDATE("Unit of Measure Code", RequisitionLine."Unit of Measure Code");
        PurchaseLine.VALIDATE("Direct Unit Cost", RequisitionLine."Direct Unit Cost");
        PurchaseLine.VALIDATE(Quantity, RequisitionLine.Quantity);
        //IF PurchaseHeader."Currency Code" = RequisitionLine."Currency Code" THEN
        BEGIN
            PurchaseLine.VALIDATE("Direct Unit Cost", RequisitionLine."Direct Unit Cost");
            PurchaseLine.VALIDATE("Line Discount %", RequisitionLine."Line Discount %");
            PurchaseLine.VALIDATE("Currency Code", RequisitionLine."Currency Code");
        END;
        //ELSE BEGIN
        //VALIDATE("Currency Code",PurchaseHeader."Currency Code");
        //PurchaseLine.VALIDATE("Direct Unit Cost",
        // CurrExchRate.ExchangeAmtFCYToFCY(PurchaseHeader."Posting Date",RequisitionLine."Currency Code",
        //PurchaseHeader."Currency Code",RequisitionLine."Direct Unit Cost"));
        //VALIDATE("Line Discount %",RequisitionLine."Line Discount %");
        //END;
        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", RequisitionLine."Shortcut Dimension 2 Code");
        //VALIDATE("Job No.",RequisitionLine."Job No.");
        PurchaseLine.VALIDATE("Transaction Type", RequisitionLine."Transaction Type");
        PurchaseLine.VALIDATE("Tax Group Code", RequisitionLine."Tax Group Code");
        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN PurchaseLine.VALIDATE("Variant Code", RequisitionLine."Variant Code");
        PurchaseLine."Unit of Measure Code" := RequisitionLine."Unit of Measure";
        PurchaseLine."Gen. Bus. Posting Group" := RequisitionLine."Gen. Bus. Posting Group";
        PurchaseLine."Gen. Prod. Posting Group" := RequisitionLine."Gen. Prod. Posting Group";
    end;
    // [Scope('Internal')]
    procedure CreateDim(DocLine: Record "Purchase Line"; Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        /*
        Options.GET;
        Options.TESTFIELD(Options."Journal Source Code");
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        DocLine."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,Options."Journal Source Code",DocLine."Shortcut Dimension 1 Code",DocLine."Shortcut Dimension 2 Code",0,0);
        //jeffer
        */


    end;

    //[Scope('Internal')]
    procedure ChangeDocHeaderStatus(DocHeaderNo: Code[20])
    var
        DocHeader: Record "Purchase Header";
        DocLines: Record "Purchase Line";
        DocFullyProcessed: Boolean;
    begin
        //DocFullyProcessed := TRUE;

        DocLines.RESET;
        DocLines.SETRANGE(DocLines.Select2, TRUE);
        DocLines.SETRANGE(DocLines."Document No.", DocHeaderNo);
        IF DocLines.FIND('-') THEN BEGIN
            REPEAT
                MESSAGE('%1', DocHeaderNo);
                DocLines."Ordered by" := USERID;
                DocLines."Order Creation date" := TODAY;
                DocLines."Order Creation Time" := TIME;
                DocLines.Ordered := TRUE;
                DocLines.Select2 := FALSE;
            UNTIL DocLines.NEXT = 0;
        END;
    end;
}

