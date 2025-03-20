* @ValidationCode : MjotMjY4NjQ2NTk3OkNwMTI1MjoxNzQyNTAxNjYyMjIzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Mar 2025 17:14:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
* Version 9 15/11/00  GLOBUS Release No. R06.002 22/08/06
*-----------------------------------------------------------------------------
* <Rating>419</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.EMAIL.SMS.PARAMETER
*---------------------------------------------------------------------------------------


    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING ABC.BP
    $USING EB.Display
    $USING ST.Customer
    $USING EB.TransactionControl
    $USING EB.DataAccess

*************************************************************************

    GOSUB DEFINE.PARAMETERS

    Y.VFUNCTION = EB.SystemTables.getVFunction()
    IF LEN(Y.VFUNCTION) GT 1 THEN
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

            IF Y.VFUNCTION EQ 'E' OR Y.VFUNCTION EQ 'L' THEN
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

            GOSUB CHECK.RECORD          ;* Special Editing of Record

            EB.Display.MatrixAlter()

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

    WHILE NOT(EB.SystemTables.getMessage())

        GOSUB CHECK.FIELDS    ;* Special Field Editing
        Y.A = EB.SystemTables.getA()
        IF EB.SystemTables.getTSequ() NE '' THEN EB.SystemTables.setTSequ(Y.A + 1)

    REPEAT

RETURN

*************************************************************************
PROCESS.MESSAGE:
* Processing after exiting from field input (PF5)

    IF EB.SystemTables.getMessage() EQ 'DEFAULT' THEN
        EB.SystemTables.setMessage('ERROR')     ;* Force the processing back
        IF Y.VFUNCTION NE 'D' AND Y.VFUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF BROWSER.PREVIEW.ON THEN          ;* EN_10002679 - s
* Clear BROWSER.PREVIEW.ON once inside the template so that after preview
* it might exit from the template, otherwise there will be looping within the template.
        EB.SystemTables.setMessage('PREVIEW')
        BROWSER.PREVIEW.ON = 0
    END   ;* EN_10002679 - e


    IF EB.SystemTables.getMessage() EQ 'PREVIEW' THEN
        EB.SystemTables.setMessage('ERROR')     ;* Force the processing back
        IF Y.VFUNCTION NE 'D' AND Y.VFUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
        END
    END

    IF EB.SystemTables.getMessage() EQ 'VAL' THEN
        EB.SystemTables.setMessage('')
        BEGIN CASE
            CASE Y.VFUNCTION EQ 'D'
                GOSUB CHECK.DELETE          ;* Special Deletion checks
            CASE Y.VFUNCTION EQ 'R'
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
* Validation and changes of the ID entered.  Sets V$ERROR to 1 if in error.

    V$ERROR = 0
    EB.SystemTables.setE('')
    IF EB.SystemTables.getE() THEN
        V$ERROR = 1
        EB.ErrorProcessing.Err()
    END

RETURN

*************************************************************************
CHECK.RECORD:
* Validation and changes of the Record.  Set V$ERROR to 1 if in error.
*
* A application runnin in browser will enter CHECK.RECORD multiple
* times during a transaction lifecycle. Any validation that must only
* run when the user first opens the contract must be put in the following
* IF statement
*TO- DO Revisar
*   IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN      ;* BG_100007114

*  END

RETURN

*************************************************************************
CHECK.FIELDS:

REM > CALL XX.CHECK.FIELDS
    EB.SystemTables.setE('')

*  BEGIN CASE
*      CASE EB.SystemTables.getAf() EQ AespBankId
*          IF EB.SystemTables.getComi() NE '' THEN
*              Y.BANCO = ''
*             Y.COMI = EB.SystemTables.getComi()
*             EB.DataAccess.FRead(FN.VPM.BANCOS, Y.COMI, Y.BANCO, F.VPM.BANCOS, VPMB.ERR1)
*             IF VPMB.ERR1 THEN
*                 EB.SystemTables.setE('ERR.1 EL BANCO NO EXISTE')
*                 GOSUB SEND.ERROR
*             END
*            EB.SystemTables.setRNew(ABC.BP.AbcEmailSmsParameter.AEspBankCust, '')
*             EB.SystemTables.setRNew(ABC.BP.AbcEmailSmsParameter.AEspBankName, '')
*         END
*    CASE EB.SystemTables.getAf() EQ AEspBankCust
*        IF EB.SystemTables.getComi() NE '' THEN
*            EB.SystemTables.setRNew(ABC.BP.AbcEmailSmsParameter.AEspBankName, '')
*            EB.SystemTables.setRNew(ABC.BP.AbcEmailSmsParameter.AEspBankId, '')
*        END
*    CASE EB.SystemTables.getAf() EQ AEspBankName
*        IF EB.SystemTables.getComi() NE '' THEN
*            EB.SystemTables.setRNew(ABC.BP.AbcEmailSmsParameter.AEspBankCust, '')
*            EB.SystemTables.setRNew(ABC.BP.AbcEmailSmsParameter.AEspBankId, '')
*        END


*    CASE EB.SystemTables.getAf() EQ AEspEmailAccMin
*        IF NOT(NUM(EB.SystemTables.getComi())) OR EB.SystemTables.getComi() LE 0 THEN
*            EB.SystemTables.setE('EL VALOR DEBE SER NUMERICO MAYOR A CERO')
*           GOSUB SEND.ERROR
*        END


*   CASE EB.SystemTables.getAf() EQ AEspEmailDomMin
*        IF NOT(NUM(EB.SystemTables.getComi())) OR EB.SystemTables.getComi() LE 0  THEN
*            EB.SystemTables.setE('EL VALOR DEBE SER NUMERICO MAYOR A CERO')
**            GOSUB SEND.ERROR
*       END


*   CASE EB.SystemTables.getAf() EQ AEspEmailMaxDot
*       IF NOT(NUM(EB.SystemTables.getComi())) OR EB.SystemTables.getComi() LT 1 THEN
*           EB.SystemTables.setE('EL VALOR DEBE SER NUMERICO MAYOR A CERO')
*           GOSUB SEND.ERROR
*       END



*END CASE


    EB.Display.RebuildScreen()
RETURN

SEND.ERROR:
    IF EB.SystemTables.getE() THEN
        EB.SystemTables.setTSequ("IFLD")
        EB.ErrorProcessing.Err()
    END

RETURN

*************************************************************************
CROSS.VALIDATION:
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
*
REM > CALL XX.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*

    IF EB.SystemTables.getRNew(ABC.BP.AbcEmailSmsParameter.AEspBankId) EQ '' AND EB.SystemTables.getRNew(ABC.BP.AbcEmailSmsParameter.AEspBankCust) EQ '' AND EB.SystemTables.getRNew(ABC.BP.AbcEmailSmsParameter.AEspBankName) EQ ''  THEN
        EB.SystemTables.setAf(AEspBankId)
        Y.ERROR = 'ERR.2 DEBE ESPECIFICAR UN VALOR DE IDENTIFICACION DEL BANCO'
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
        GOSUB SEND.ERROR2
        RETURN
    END

    EB.SystemTables.setAf(AEspTranType)
    EB.Template.Dup()

    EB.SystemTables.setAf(AEspTransaction)
    EB.Template.Dup()

RETURN

SEND.ERROR2:

*    IF END.ERROR THEN
*        EB.SystemTables.setAf(1)
*        Y.A = EB.SystemTables.getAf()
*        LOOP UNTIL T.ETEXT<Y.A> NE "" DO Y.A = Y.A+1 ; REPEAT
*        Y.T.SEQU = "D"
*        Y.T.SEQU<-1> = A
*        EB.SystemTables.setTSequ(Y.T.SEQU)
*       V$ERROR = 1
**       EB.SystemTables.setMessage('ERROR')
*    END

RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************
OVERRIDES:
*
*  Overrides should reside here.
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
REM > CALL XX.OVERRIDE
*

*
    IF TEXT EQ "NO" THEN       ;* Said NO to override
        V$ERROR = 1
        EB.SystemTables.setMessage("ERROR")     ;* Back to field input

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

    IF TEXT EQ "NO" THEN       ;* Said No to override
        EB.TransactionControl.TransactionAbort()          ;* Cancel current transaction
        V$ERROR = 1
        EB.SystemTables.setMessage("ERROR")     ;* Back to field input
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
        CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] EQ "INA"        ;* Record status
REM > CALL XX.AUTHORISATION
        CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] EQ "RNA"        ;* Record status
REM > CALL XX.REVERSAL

    END CASE

RETURN

*************************************************************************
CHECK.FUNCTION:
* Validation of function entered.  Sets V$FUNCTION to null if in error.

    IF INDEX('V',Y.VFUNCTION,1) THEN
        EB.SystemTables.setE('EB.RTN.FUNT.NOT.ALLOWED.APP')
        EB.ErrorProcessing.Err()
        V$FUNCTION = ''
    END


RETURN

*************************************************************************
INITIALISE:

*   BROWSER.PREVIEW.ON = (OFS$MESSAGE='PREVIEW')

    FN.VPM.BANCOS = 'F.VPM.BANCOS'
    F.VPM.BANCOS = ''
    EB.DataAccess.Opf(FN.VPM.BANCOS,F.VPM.BANCOS)

    FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
    F.STANDARD.SELECTION = ''
    EB.DataAccess.Opf(FN.STANDARD.SELECTION, F.STANDARD.SELECTION)

RETURN

*************************************************************************
DEFINE.PARAMETERS:
* SEE 'I_RULES' FOR DESCRIPTIONS *

REM > CALL XX.FIELD.DEFINITIONS
*========================================================================
    EB.SystemTables.setIdT("")
    EB.SystemTables.setIdCheckfile("")
    EB.SystemTables.setIdConcatfile("")
*========================================================================
    
    EB.SystemTables.setIdF("ID")
    EB.SystemTables.setIdN("6.6.C")
    EB.SystemTables.setIdT("A")
    
    Z = 0
    Z+= 1;      EB.SystemTables.setF(Z,"OFS.SOURCE");      EB.SystemTables.setN(Z, "15.3.C");  EB.SystemTables.setT(Z, "A")
    EB.SystemTables.setCheckfile(Z, "OFS.SOURCE":@FM:OFS.SRC.DESCRIPTION:@FM:'A.')
    Z+= 1;      EB.SystemTables.setF(Z,"NUM.MENSAJE");     EB.SystemTables.setN(Z, "4.1"); EB.SystemTables.setT(Z, "")
    Z+= 1;      EB.SystemTables.setF(Z,"SMS.ACTIVO");      EB.SystemTables.setN(Z, "1.1"); EB.SystemTables.setT(Z, "A") ; tmp= EB.SystemTables.getT(Z); tmp<2>= @FM:"N_S" ; EB.SystemTables.setT(Z, tmp)
    Z+= 1;      EB.SystemTables.setF(Z,"BANK.ID");         EB.SystemTables.setN(Z, "3..C"); EB.SystemTables.setT(Z, "")
    Z+= 1;      EB.SystemTables.setF(Z,"BANK.CUST");       EB.SystemTables.setN(Z, "10..C");  EB.SystemTables.setT(Z, "")
    EB.SystemTables.setCheckfile(Z,"CUSTOMER":@FM:EB.CUS.SHORT.NAME:@FM:'A.')
    Z+= 1;      EB.SystemTables.setF(Z,"BANK.NAME");       EB.SystemTables.setN(Z, "100..C");  EB.SystemTables.setT(Z, "A")
    Z+= 1;      EB.SystemTables.setF(Z,"XX<TRAN.TYPE");    EB.SystemTables.setN(Z, "4.2");  EB.SystemTables.setT(Z,"A"); tmp= EB.SystemTables.getT(z); tmp<2>= @FM:"AC_ATM_BIAT_BIAI_BIMT_BIMI_BIBT_BIBI_BIAC_BIMC_BIBC_BIAD_BIMD_BIBD_CUEM_CUMO_POS_SPEI_BACE_BMCE_BBCE"; EB.SystemTables.setT(Z, tmp)
    Z+= 1;      EB.SystemTables.setF(Z,"XX-XX.TRANSACTION");  EB.SystemTables.setN(Z, "4..C");  EB.SystemTables.setT(Z,"A")
    EB.SystemTables.setCheckfile(Z,"FT.TXN.TYPE.CONDITION":@FM:FT6.DESCRIPTION:@FM:'A.')
    Z+= 1;      EB.SystemTables.setF(Z,"XX>SUBJECT");      EB.SystemTables.setN(Z, "150.10");  EB.SystemTables.setT(Z, "A")
    Z+= 1;      EB.SystemTables.setF(Z,"PHONE.1");         EB.SystemTables.setN(Z, "20.3");  EB.SystemTables.setT(Z, "A")
    Z+= 1;      EB.SystemTables.setF(Z,"PHONE.2");         EB.SystemTables.setN(Z, "20..");  EB.SystemTables.setT(Z, "A")
    Z+= 1;      EB.SystemTables.setF(Z,"XX<TRAN.TYPE.2");     EB.SystemTables.setN(Z, "4.2");  EB.SystemTables.setT(Z,"A"); tmp= EB.SystemTables.getT(Z); tmp<2>= @FM:"AC_ATM_BIAT_BIAI_BIMT_BIMI_BIBT_BIBI_BIAC_BIMC_BIBC_BIAD_BIMD_BIBD_CUEM_CUMO_POS_SPEI_BACE_BMCE_BBCE"; EB.SystemTables.setT(Z, tmp)
    Z+= 1;      EB.SystemTables.setF(Z,"XX>ENV.CAMBIO.EST");  EB.SystemTables.setN(Z, "1.1");  EB.SystemTables.setT(Z,"A"); tmp= EB.SystemTables.getT(Z); tmp<2>= @FM:"N_S"; EB.SystemTables.setT(Z, tmp)
    Z+ =1;      EB.SystemTables.setF(Z,"EMAIL.USUARIO");      EB.SystemTables.setN(Z, "80");  EB.SystemTables.setT(Z,"A")
    Z+ =1;      EB.SystemTables.setF(Z,"EMAIL.OPERACION");    EB.SystemTables.setN(Z, "80.7");  EB.SystemTables.setT(Z,"A")
    Z+ =1;      EB.SystemTables.setF(Z,"XX<EMAIL.ACC.MIN");         EB.SystemTables.setN(Z, "2.1.C");  EB.SystemTables.setT(Z,"A"); tmp= EB.SystemTables.getT(Z); tmp<8> = "NOEXPAND"; EB.SystemTables.setT(Z, tmp)
    Z+ =1;      EB.SystemTables.setF(Z,"XX-EMAIL.DOM.MIN");         EB.SystemTables.setN(Z, "2.1.C");  EB.SystemTables.setT(Z,"A")
    Z+ =1;      EB.SystemTables.setF(Z,"XX>EMAIL.MAX.DOT");         EB.SystemTables.setN(Z, "1.1.C");  EB.SystemTables.setT(Z,"A")
    Z+ =1;      EB.SystemTables.setF(Z,"XX.VAL.GEN.DOM");           EB.SystemTables.setN(Z, "5.4");  EB.SystemTables.setT(Z,"A")
    Z+ =1;      EB.SystemTables.setF(Z,"INVALID.CHAR");             EB.SystemTables.setN(Z, "60");   EB.SystemTables.setT(Z,"ANY")


    EB.SystemTables.setV(Z + 9);   EB.Template.setTableEquateprefix("AESP")

    


RETURN

*************************************************************************

END
