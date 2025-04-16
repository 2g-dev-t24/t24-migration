* @ValidationCode : MjotMjAyMzQyMDg2NDpDcDEyNTI6MTc0NDgzOTAxNDE3MjptYXJjbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:30:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>1012</Rating>
*-----------------------------------------------------------------------------
* Version 9 15/11/00  GLOBUS Release No. G13.2.00 02/03/03

SUBROUTINE VPM.2BR.CC.MORAL
*
*
*    First Release : Banco Ve por Mas
*    Developed for : Banco Ve por Mas
*    Developed by  : Mohsin Ali A
*    Date          : Feb/10/2005
*
*************************************************************************
* Program Template for a GLOBUS Application with $HIS & $NAU files
*------------------------------------------------------------------------
* Modification History
*
* 02/09/02 - GLOBUS_EN_10001055
*            Conversion Of all Error Messages to Error Codes
*
* 07/11/02 - GLOBUS_BG_100002664
*            Display problem with errors returned by CROSSVAL

* Template for Call Center Moral
******************************************************************
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------
* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_F.ACCOUNT  ;* Not Used anymore
* $INSERT I_F.CUSTOMER  ;* Not Used anymore
* $INSERT I_F.VPM.2BR.CC.MORAL - Not Used anymore;
*    $INSERT I_F.VPM.2BR.CC.MNEMONIC
* $INSERT I_F.MNEMONIC.CUSTOMER  ;* Not Used anymore
    
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.TransactionControl
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING ABC.BP

    GOSUB DEFINE.PARAMETERS

    tmp.V$FUNCTION = EB.SystemTables.getVFunction()
    IF LEN(tmp.V$FUNCTION) GT 1 THEN
        EB.SystemTables.setVFunction(tmp.V$FUNCTION)
        GOTO V$EXIT
    END

    EB.Display.MatrixUpdate()

    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

        EB.TransactionControl.RecordidInput()

    UNTIL (EB.SystemTables.getMessage() EQ 'RET')

        V$ERROR = ''

        IF EB.SystemTables.getMessage() EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF EB.SystemTables.getVFunction() EQ 'E' OR EB.SystemTables.getVFunction() EQ 'L' THEN
                EB.Display.FunctionDisplay()
                EB.SystemTables.setVFunction('')
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            EB.TransactionControl.RecordRead()

            IF EB.SystemTables.getMessage() EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            EB.Display.MatrixAlter()

            GOSUB CHECK.RECORD          ;* Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE (EB.SystemTables.getMessage() EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:

    REPEAT

V$EXIT:

RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************

PROCESS.FIELDS:

* Input or display the record fields.

    LOOP

        IF EB.SystemTables.getScreenMode() EQ 'MULTI' THEN
            IF EB.SystemTables.getFileType() EQ 'I' THEN
                EB.Display.FieldMultiInput()
            END ELSE
                EB.Display.FieldMultiDisplay()
            END
        END ELSE
            IF EB.SystemTables.getFileType() EQ 'I' THEN
                EB.Display.FieldInput()
            END ELSE
                EB.Display.FieldDisplay()
            END
        END

        tmp.MESSAGE = EB.SystemTables.getMessage()
    WHILE NOT(tmp.MESSAGE)
        EB.SystemTables.setMessage(tmp.MESSAGE)

        GOSUB CHECK.FIELDS    ;* Special Field Editing

        IF EB.SystemTables.getTSequ() NE '' THEN tmp=EB.SystemTables.getTSequ(); tmp<-1>=EB.SystemTables.getA() + 1; EB.SystemTables.setTSequ(tmp)

    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF EB.SystemTables.getMessage() = 'DEFAULT' THEN
        EB.SystemTables.setMessage('ERROR');* Force the processing back
        IF EB.SystemTables.getVFunction()<> 'D' AND EB.SystemTables.getVFunction()<> 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF EB.SystemTables.getMessage() = 'PREVIEW' THEN
        EB.SystemTables.setMessage('ERROR');* Force the processing back
        IF EB.SystemTables.getVFunction()<> 'D' AND EB.SystemTables.getVFunction()<> 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
        END
    END

    IF EB.SystemTables.getMessage() EQ 'VAL' THEN
        EB.SystemTables.setMessage('')
        BEGIN CASE
            CASE EB.SystemTables.getVFunction() EQ 'D'
                GOSUB CHECK.DELETE          ;* Special Deletion checks
            CASE EB.SystemTables.getVFunction() EQ 'R'
                GOSUB CHECK.REVERSAL        ;* Special Reversal checks
            CASE 1
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
                IF NOT(V$ERROR) THEN
                    GOSUB OVERRIDES
                END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
            EB.TransactionControl.UnauthRecordWrite()
            IF EB.SystemTables.getMessage() NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END

    END

    IF EB.SystemTables.getMessage() EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN
******************************************************************
*  Y.RFC = FIELD(ID.NEW,".",2)

            Y.MNEMONIC = EB.SystemTables.getRNew(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralMnemonic)

            Y.MNE.REC = '' ; Y.MNE.ERR = ''
            EB.DataAccess.FRead(FN.VPM.2BR.CC.MNEMONIC,Y.MNEMONIC,Y.MNE.REC,FV.VPM.2BR.CC.MNEMONIC,Y.MNE.ERR)
            IF EB.SystemTables.getRNew(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralRecordStatus) EQ 'INAU' OR EB.SystemTables.getVFunction() EQ 'I' THEN
                Y.MNE.REC<CC.MNE.CUST.RFC> = EB.SystemTables.getIdNew()

                EB.DataAccess.FWrite(FN.VPM.2BR.CC.MNEMONIC,Y.MNEMONIC,Y.MNE.REC)
                
            END ELSE
                IF EB.SystemTables.getRNew(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralRecordStatus) EQ 'RNAU' OR EB.SystemTables.getVFunction() EQ 'R' THEN
                    EB.DataAccess.FDelete(FN.VPM.2BR.CC.MNEMONIC,Y.MNEMONIC)

                END
            END
***************************************************************************
            EB.TransactionControl.AuthRecordWrite()

            IF EB.SystemTables.getMessage() NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************

CHECK.ID:

* Validation and changes of the ID entered.  Set ERROR to 1 if in error.

* CALL EB.FORMAT.ID("")
    tmp.ID.NEW = EB.SystemTables.getIdNew()
    IF LEN(tmp.ID.NEW) GT 24 THEN
        EB.SystemTables.setIdNew(tmp.ID.NEW)
        EB.SystemTables.setEtext("ID no valido")
        EB.SystemTables.setE(EB.SystemTables.getEtext())
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END

    Y.FIRST.ID = ''
    Y.FIRST.ID = EB.SystemTables.getIdNew()[1,1]
    IF NOT(NUM(Y.FIRST.ID)) THEN
        Y.MNE.REC = '' ; Y.MNE.ERR = ''
        tmp.ID.NEW = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.VPM.2BR.CC.MNEMONIC,tmp.ID.NEW,Y.MNE.REC,FV.VPM.2BR.CC.MNEMONIC,Y.MNE.ERR)
        EB.SystemTables.setIdNew(tmp.ID.NEW)
        IF Y.MNE.ERR THEN
            EB.SystemTables.setEtext("ID no valido")
            EB.SystemTables.setE(EB.SystemTables.getEtext())
            V$ERROR = 1
            EB.SystemTables.setMessage("REPEAT")
            EB.ErrorProcessing.Err()
            RETURN
        END ELSE
            EB.SystemTables.setIdNew(Y.MNE.REC<CC.MNE.CUST.RFC>)
            EB.Display.RebuildScreen()
        END

    END

    IF EB.SystemTables.getIdNew()[11,1] NE "." THEN
        EB.SystemTables.setEtext("Formato de ID no valido")
        EB.SystemTables.setE(EB.SystemTables.getEtext())
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END

    Y.CUS.ID = ''
    tmp.ID.NEW = EB.SystemTables.getIdNew()
    Y.CUS.ID = FIELD(tmp.ID.NEW,".",1)
    EB.SystemTables.setIdNew(tmp.ID.NEW)
    Y.CUS.REC = '' ; Y.CUS.ERR = ''
    Y.CUS.REC = ST.Customer.Customer.Read(Y.CUS.ID, Y.CUS.ERR)
* Before incorporation : CALL F.READ(FN.CUSTOMER,Y.CUS.ID,Y.CUS.REC,FV.CUSTOMER,Y.CUS.ERR)
    IF Y.CUS.ERR THEN
        EB.SystemTables.setEtext("No. cliente no valido")
        EB.SystemTables.setE(EB.SystemTables.getEtext())
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END ELSE
*        CALL GET.LOC.REF("CUSTOMER","CLASSIFICATION",Y.POS)
        applications     = ""
        fields           = ""
        applications<1>  = "CUSTOMER"
        fields<1,1>      = "CLASSIFICATION"
        field_Positions  = ""
        EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
        Y.POS = field_Positions<1,1>
        
        Y.CUST.CLASS = Y.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.POS>
        IF Y.CUST.CLASS NE 3 THEN
            EB.SystemTables.setEtext("Cliente no es persona moral")
            EB.SystemTables.setE(EB.SystemTables.getEtext())
            V$ERROR = 1
            EB.SystemTables.setMessage("REPEAT")
            EB.ErrorProcessing.Err()
            RETURN
        END
    END

    Y.RFC = ''
    Y.ERR = ''
    tmp.ID.NEW = EB.SystemTables.getIdNew()
    Y.RFC = FIELD(tmp.ID.NEW,".",2)
    EB.SystemTables.setIdNew(tmp.ID.NEW)
    ABC.BP.vpmValidaRfc(Y.RFC,Y.ERR)
    IF Y.ERR EQ 1 THEN
        EB.SystemTables.setEtext("Numero de RFC no es valido")
        EB.SystemTables.setE(EB.SystemTables.getEtext())
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END

************************

    Y.CUS.ACC.REC= '' ; Y.CUS.ACC.ERR = ''
    Y.CUS.ACC.REC = AC.AccountOpening.CustomerAccount.Read(Y.CUS.ID, Y.CUS.ACC.ERR)
* Before incorporation : CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUS.ID,Y.CUS.ACC.REC,FV.CUSTOMER.ACCOUNT,Y.CUS.ACC.ERR)
    IF Y.CUS.ACC.REC THEN
        NO.OF.AC = ''
        NO.OF.AC = DCOUNT(Y.CUS.ACC.REC,@FM)
        FOR Y.AC.LIST = 1 TO NO.OF.AC
            Y.AC.ID = ''
            Y.AC.ID = Y.CUS.ACC.REC<Y.AC.LIST>
            Y.ACCT.REC = '' ; Y.ACCT.ERR = ''
            Y.ACCT.REC = AC.AccountOpening.Account.Read(Y.AC.ID, Y.ACCT.ERR)
* Before incorporation : CALL F.READ(FN.ACCOUNT,Y.AC.ID,Y.ACCT.REC,FV.ACCOUNT,Y.ACCT.ERR)
            IF Y.ACCT.REC THEN
                Y.AC.RFC = ''
*                CALL GET.LOC.REF("ACCOUNT","PER.AUT.RFC",Y.POS1)
                
                applications     = ""
                fields           = ""
                applications<1>  = "ACCOUNT"
                fields<1,1>      = "PER.AUT.RFC"
                fields<1,2>      = "PER.AUT.NOMBRE"
                fields<1,3>      = "PER.AUT.APE.PAT"
                fields<1,4>      = "PER.AUT.APE.MAT"
                field_Positions  = ""
                EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
                Y.POS1 = field_Positions<1,1>
                Y.POS2 = field_Positions<1,2>
                Y.POS3 = field_Positions<1,3>
                Y.POS4 = field_Positions<1,4>
                
                Y.AC.RFC = RAISE(Y.ACCT.REC<AC.AccountOpening.Account.LocalRef,Y.POS1>)
                tmp.ID.NEW = EB.SystemTables.getIdNew()
                Y.RFC = FIELD(tmp.ID.NEW,".",2)
                EB.SystemTables.setIdNew(tmp.ID.NEW)
                LOCATE Y.RFC IN Y.AC.RFC<1,1> SETTING P2  THEN
*                    CALL GET.LOC.REF("ACCOUNT","PER.AUT.NOMBRE",Y.POS1)
*                    NOMRE1 = Y.ACCT.REC<AC.AccountOpening.Account.LocalRef,Y.POS1,P2>
*                    CALL GET.LOC.REF("ACCOUNT","PER.AUT.NOMBRE",Y.POS1)
                    NOMRE1 = Y.ACCT.REC<AC.AccountOpening.Account.LocalRef,Y.POS2,P2>
*                    CALL GET.LOC.REF("ACCOUNT","PER.AUT.APE.PAT",Y.POS1)
                    NOMRE2 = Y.ACCT.REC<AC.AccountOpening.Account.LocalRef,Y.POS3,P2>
*                    CALL GET.LOC.REF("ACCOUNT","PER.AUT.APE.MAT",Y.POS1)
                    NOMRE3 = Y.ACCT.REC<AC.AccountOpening.Account.LocalRef,Y.POS4,P2>
                    EB.SystemTables.setIdEnri(NOMRE1:" ":NOMRE2:" ":NOMRE3)
                    EB.Display.RebuildScreen()
                    Y.AC.LIST = NO.OF.AC + 1
                END
            END
        NEXT Y.AC.LIST
        IF EB.SystemTables.getIdEnri() EQ "" THEN
            EB.SystemTables.setEtext("RFC no esta asignado a ninguna cuenta del cliente")
            EB.SystemTables.setE(EB.SystemTables.getEtext())
            V$ERROR = 1
            EB.SystemTables.setMessage("REPEAT")
            EB.ErrorProcessing.Err()
            RETURN
        END
    END

************************

    IF EB.SystemTables.getE() THEN V$ERROR = 1

RETURN

*************************************************************************

CHECK.RECORD:

* Validation and changes of the Record.  Set ERROR to 1 if in error.


RETURN

*************************************************************************

CHECK.FIELDS:

    BEGIN CASE
        CASE EB.SystemTables.getAf() = ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralMnemonic
            IF EB.SystemTables.getROld(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralMnemonic) NE EB.SystemTables.getComi() THEN
                Y.MNEMONIC =  ''
                Y.MNEMONIC = EB.SystemTables.getComi()

                Y.MNE.REC = '' ; Y.MNE.ERR = ''
                EB.DataAccess.FRead(FN.VPM.2BR.CC.MNEMONIC,Y.MNEMONIC,Y.MNE.REC,FV.VPM.2BR.CC.MNEMONIC,Y.MNE.ERR)
                IF Y.MNE.REC THEN
                    EB.SystemTables.setE("MNEMONICO ya existe")
                    EB.SystemTables.setTSequ("IFLD")
                    EB.ErrorProcessing.Err()
                    RETURN

                END ELSE

                    MNE.CUST.REC = '' ; MNE.CUS.ERR = ''
                    MNE.CUST.REC = ST.Customer.MnemonicCustomer.Read(Y.MNEMONIC, MNE.CUS.ERR)
* Before incorporation : CALL F.READ(FN.MNEMONIC.CUSTOMER,Y.MNEMONIC,MNE.CUST.REC,FV.MNEMONIC.CUSTOMER,MNE.CUS.ERR)
                    IF MNE.CUST.REC THEN
                        EB.SystemTables.setE("MNEMONICO ya existe")
                        EB.SystemTables.setTSequ("IFLD")
                        EB.ErrorProcessing.Err()
                        RETURN
                    END
                END
            END

        CASE EB.SystemTables.getAf() = ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralAccount
            Y.ACCT = EB.SystemTables.getComi()

            Y.ACCT.REC = '' ; Y.ACCT.ERR = ''
            Y.ACCT.REC = AC.AccountOpening.Account.Read(Y.ACCT, Y.ACCT.ERR)
* Before incorporation : CALL F.READ(FN.ACCOUNT,Y.ACCT,Y.ACCT.REC,FV.ACCOUNT,Y.ACCT.ERR)
            IF Y.ACCT.REC THEN
                Y.ACCT.CUST = Y.ACCT.REC<AC.AccountOpening.Account.Customer>
                tmp.ID.NEW = EB.SystemTables.getIdNew()
                Y.CUS.ID = FIELD(tmp.ID.NEW,".",1)
                EB.SystemTables.setIdNew(tmp.ID.NEW)
                IF Y.ACCT.CUST NE Y.CUS.ID THEN
                    EB.SystemTables.setE("No. cuenta no corresponde al cliente")
                    EB.SystemTables.setTSequ("IFLD")
                    EB.ErrorProcessing.Err()
                    RETURN
                END

                Y.AC.RFC = ''
*            CALL GET.LOC.REF("ACCOUNT","PER.AUT.RFC",Y.POS1)
            
                applications     = ""
                fields           = ""
                applications<1>  = "ACCOUNT"
                fields<1,1>      = "PER.AUT.RFC"
                field_Positions  = ""
                EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
                Y.POS1 = field_Positions<1,1>
            
                Y.AC.RFC = RAISE(Y.ACCT.REC<AC.AccountOpening.Account.LocalRef,Y.POS1>)
                tmp.ID.NEW = EB.SystemTables.getIdNew()
                Y.RFC = FIELD(tmp.ID.NEW,".",2)
                EB.SystemTables.setIdNew(tmp.ID.NEW)
                LOCATE Y.RFC IN Y.AC.RFC<1,1> SETTING P1  ELSE
                    EB.SystemTables.setE("RFC de persona autorizada no corresponde a la cuenta")
                    EB.SystemTables.setTSequ("IFLD")
                    EB.ErrorProcessing.Err()
                    RETURN
                END


            END


    END CASE

REM > CALL XX.CHECK.FIELDS
    IF EB.SystemTables.getE() THEN
        EB.SystemTables.setTSequ("IFLD")
        EB.ErrorProcessing.Err()
    END

RETURN

*************************************************************************

CROSS.VALIDATION:

    IF EB.SystemTables.getROld(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralMnemonic) NE EB.SystemTables.getRNew(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralMnemonic) THEN
        Y.MNEMONIC = ''
        Y.MNEMONIC = EB.SystemTables.getROld(ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralMnemonic)
        Y.MNE.REC = '' ; Y.MNE.ERR = ''
        EB.DataAccess.FRead(FN.VPM.2BR.CC.MNEMONIC,Y.MNEMONIC,Y.MNE.REC,FV.VPM.2BR.CC.MNEMONIC,Y.MNE.ERR)
        IF Y.MNE.REC THEN
            EB.DataAccess.FDelete(FN.VPM.2BR.CC.MNEMONIC,Y.MNEMONIC)
        END

    END
*
    V$ERROR = ''
    EB.SystemTables.setEtext('')
    EB.SystemTables.setText('')
*

    IF EB.SystemTables.getEtext() THEN
        EB.ErrorProcessing.StoreEndError()
    END



*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF EB.SystemTables.getEndError() THEN
        EB.SystemTables.setA(1)
        LOOP UNTIL EB.SystemTables.getTEtext()<EB.SystemTables.getA()> <> "" DO
            EB.SystemTables.setA(EB.SystemTables.getA()+1)
        REPEAT
        
        EB.SystemTables.setTSequ("D");* BG_100002664 s
        
        tmp=EB.SystemTables.getTSequ()
        tmp<-1>=EB.SystemTables.getA()
        EB.SystemTables.setTSequ(tmp);* BG_100002664 e
        V$ERROR = 1
        EB.SystemTables.setMessage('ERROR')
    END

RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************

OVERRIDES:
*
*  Overrides should reside here.
*
    V$ERROR = ''
    EB.SystemTables.setEtext('')
    EB.SystemTables.setText('')
REM > CALL XX.OVERRIDE
*
    IF EB.SystemTables.getText() = "NO" THEN       ;* Said NO to override
        V$ERROR = 1
        EB.SystemTables.setMessage("ERROR");* Back to field input

    END

RETURN

*************************************************************************

AUTH.CROSS.VALIDATION:

RETURN

*************************************************************************

CHECK.DELETE:

RETURN

*************************************************************************

CHECK.REVERSAL:

RETURN

*************************************************************************
DELIVERY.PREVIEW:

RETURN

*************************************************************************

BEFORE.UNAU.WRITE:
*
*  Contract processing code should reside here.
*
REM > CALL XX.         ;* Accounting, Schedule processing etc etc

    YFUNCTION = EB.SystemTables.getVFunction()
    YMESSAGE  = EB.SystemTables.getMessage()

    IF EB.SystemTables.getText() = "NO" THEN       ;* Said No to override
        EB.TransactionControl.TransactionAbort()          ;* Cancel current transaction
        V$ERROR = 1
        EB.SystemTables.setMessage("ERROR");* Back to field input
        RETURN
    END
*
* Additional updates should be performed here
*
REM > CALL XX...

RETURN

*************************************************************************

AFTER.UNAU.WRITE:

RETURN

*************************************************************************

AFTER.AUTH.WRITE:

RETURN

*************************************************************************

BEFORE.AUTH.WRITE:
    tmp.V = EB.SystemTables.getV()
    BEGIN CASE
        CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] = "INA"        ;* Record status
REM > CALL XX.AUTHORISATION
        CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] = "RNA"        ;* Record status
REM > CALL XX.REVERSAL
    END CASE
    EB.SystemTables.setV(tmp.V)
RETURN

*************************************************************************

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

*****************************************************
* Sep/3/2004
* Added Reverse to the restricted functions for this
* template
*****************************************************
*      IF INDEX('V',V$FUNCTION,1) THEN
    YFUNCTION = EB.SystemTables.getVFunction()
    YMESSAGE = EB.SystemTables.getMessage()

    tmp.V$FUNCTION = EB.SystemTables.getVFunction()
    IF INDEX('V',tmp.V$FUNCTION,1) OR INDEX('R',tmp.V$FUNCTION,1) THEN
        EB.SystemTables.setE('EB.RTN.FUNT.NOT.ALLOWED.APP.17')
        EB.ErrorProcessing.Err()
        EB.SystemTables.setVFunction('')
    END

RETURN

*************************************************************************

INITIALISE:

    FN.CUSTOMER = 'F.CUSTOMER'
    FV.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,FV.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,FV.ACCOUNT)

    FN.VPM.2BR.CC.MNEMONIC = 'F.VPM.2BR.CC.MNEMONIC'
    FV.VPM.2BR.CC.MNEMONIC = ''
    EB.DataAccess.Opf(FN.VPM.2BR.CC.MNEMONIC,FV.VPM.2BR.CC.MNEMONIC)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    FV.CUSTOMER.ACCOUNT = ''
    EB.DataAccess.Opf(FN.CUSTOMER.ACCOUNT,FV.CUSTOMER.ACCOUNT)

    FN.MNEMONIC.CUSTOMER = 'F.MNEMONIC.CUSTOMER'
    FV.MNEMONIC.CUSTOMER = ''
    EB.DataAccess.Opf(FN.MNEMONIC.CUSTOMER,FV.MNEMONIC.CUSTOMER)
RETURN

*************************************************************************

DEFINE.PARAMETERS:
*========================================================================
    EB.SystemTables.clearF() ; EB.SystemTables.clearN() ; EB.SystemTables.clearT() ; EB.SystemTables.setIdT("")
    EB.SystemTables.clearCheckfile() ; EB.SystemTables.clearConcatfile()
    EB.SystemTables.setIdCheckfile(""); EB.SystemTables.setIdConcatfile("")
*========================================================================
REM "DEFINE PARAMETERS - SEE 'I_RULES'-DESCRIPTION:
*
    EB.SystemTables.setIdF("ID"); EB.SystemTables.setIdN("24.1"); tmp=EB.SystemTables.getIdT(); tmp<1>="A"; EB.SystemTables.setIdT(tmp); tmp=EB.SystemTables.getIdT(); tmp<4>=""; EB.SystemTables.setIdT(tmp)
    Z = 0
    Z += 1 ; EB.SystemTables.setF(Z, "MNEMONIC"); EB.SystemTables.setN(Z, "10.3.C"); EB.SystemTables.setT(Z, "MNE")
    Z += 1 ; EB.SystemTables.setF(Z, "XX<ACCOUNT"); EB.SystemTables.setN(Z, "11.1.C"); EB.SystemTables.setT(Z, "ACC")
    EB.SystemTables.setCheckfile(Z, "ACCOUNT":@FM:AC.AccountOpening.Account.AccountTitleOne:@FM:'A.')
    Z += 1 ; EB.SystemTables.setF(Z, "XX>TRANSACTION"); EB.SystemTables.setN(Z, "1.1"); tmp=EB.SystemTables.getT(Z); tmp<2>="Y_N"; EB.SystemTables.setT(Z, tmp)

    EB.SystemTables.setV(Z+9); EB.SystemTables.setPrefix("CC.MORAL")

RETURN

*************************************************************************
END
