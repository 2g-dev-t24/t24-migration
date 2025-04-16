* @ValidationCode : MjotMTc2NDM4Mjg0NTpDcDEyNTI6MTc0NDg0MzkzMDU3NzptYXJjbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 17:52:10
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
* <Rating>525</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.PARAM.PROCESO

* $INSERT I_COMMON - Not Used anymore;N
* $INSERT I_EQUATE - Not Used anymore;E
* $INSERT I_SCREEN.VARIABLES - Not Used anymore;S
* $INSERT I_GTS.COMMON - Not Used anymore;
* $INSERT I_F.OFS.STATUS.FLAG - Not Used anymore;
* $INSERT I_F.PGM.FILE - Not Used anymore;
* $INSERT I_F.CATEGORY - Not Used anymore;
* $INSERT I_F.VPM.PARAM.PROCESO - Not Used anymore;
    
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING ST.Customer
    $USING ST.Config
    $USING EB.SystemTables
    $USING EB.TransactionControl
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Interface
    $USING ABC.BP

*************************************************************************

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
        IF EB.SystemTables.getScreenMode()EQ 'MULTI' THEN
            IF EB.SystemTables.getFileType()EQ 'I' THEN
                EB.Display.FieldMultiInput()
            END ELSE
                EB.Display.FieldMultiDisplay()
            END
        END ELSE
            IF EB.SystemTables.getFileType()EQ 'I' THEN
                EB.Display.FieldInput()
            END ELSE
                EB.Display.FieldDisplay()
            END
        END

        tmp.MESSAGE = EB.SystemTables.getMessage()
    WHILE NOT(tmp.MESSAGE)
        EB.SystemTables.setMessage(tmp.MESSAGE)

        GOSUB CHECK.FIELDS    ;* Special Field Editing

        IF EB.SystemTables.getTSequ()NE '' THEN tmp = ''; tmp=EB.SystemTables.getTSequ(); tmp<-1>=EB.SystemTables.getA() + 1; EB.SystemTables.setTSequ(tmp)

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

    IF BROWSER.PREVIEW.ON THEN          ;* EN_10002679 - s
* Clear BROWSER.PREVIEW.ON once inside the template so that after preview
* it might exit from the template, otherwise there will be looping within the template.
        EB.SystemTables.setMessage('PREVIEW')
        BROWSER.PREVIEW.ON = 0
    END   ;* EN_10002679 - e


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
    IF EB.SystemTables.getIdNew()NE "MX0010001" THEN
        EB.SystemTables.setE("ID DEBE SER MX0010001")
    END

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
*
    IF EB.Interface.getOfsStatus()<EB.Interface.OfsStatusFlag.StatFlagFirstTime> THEN      ;* BG_100007114

    END

RETURN

*************************************************************************
CHECK.FIELDS:

REM > CALL XX.CHECK.FIELDS

    BEGIN CASE
        CASE EB.SystemTables.getAf() = ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni
            GOSUB VAL.H
        CASE EB.SystemTables.getAf() = ABC.BP.VpmParamProceso.VpmParamProcesoHoraFin
            GOSUB VAL.H
    END CASE

    GOSUB Y.ERROR
RETURN


VAL.H:
    tmp.COMI = EB.SystemTables.getComi()
    IF NOT(LEN(TRIM(tmp.COMI)) EQ 6) THEN
        EB.SystemTables.setE("E!= LONGITUD DE HORA INCORRECTA")
        RETURN
    END
    IF NOT(tmp.COMI[1,2] >= 0 AND tmp.COMI[1,2] <= 23) THEN
        EB.SystemTables.setE("E!= HORA NO PERMITIDA")
        RETURN
    END
    IF NOT(tmp.COMI[3,2] >= 0 AND tmp.COMI[3,2] <= 59) THEN
        EB.SystemTables.setE("E!= MINUTOS NO PERMITIDOS")
        RETURN
    END
    IF NOT(tmp.COMI[5,2] >= 0 AND tmp.COMI[5,2] <= 59) THEN
        EB.SystemTables.setE("E!= SEGUNDOS NO PERMITIDOS")
        RETURN
    END
RETURN


Y.ERROR:
    IF EB.SystemTables.getE() THEN
        EB.SystemTables.setTSequ("IFLD")
        EB.ErrorProcessing.Err()
    END

RETURN


*************************************************************************
CROSS.VALIDATION:
*
    V$ERROR = ''
    EB.SystemTables.setEtext('')
    EB.SystemTables.setText('')
*

    REC.AP = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion)
    NO.CAT = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)
    NO.AP = DCOUNT(REC.AP, @VM)
    FOR I.P = 1 TO NO.AP
        P.P = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion)<1, I.P>
        C.P = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)<1, I.P>
        IF P.P EQ 'LD.LOANS.AND.DEPOSITS' THEN
            IF C.P EQ '' THEN
                EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)
                EB.SystemTables.setAv(I.P)
                EB.SystemTables.setEtext("E!= DEBE ESPECIFICAR PARA LD")
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
            IF NOT(C.P >= 21000 AND C.P <= 21100) THEN
                EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)
                EB.SystemTables.setAv(I.P)
                EB.SystemTables.setEtext("E!= CATEGORIA NO PERMITIDA PARA LD")
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
        END
        IF P.P EQ 'FUNDS.TRANSFER' THEN
            IF C.P NE '' THEN
                EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)
                EB.SystemTables.setAv(I.P)
                EB.SystemTables.setEtext("E!= NO DEBE ESPECIFICAR CATEGORIA")
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
        END
    NEXT I.P


    REC.FT = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion)
    NO.FT = DCOUNT(REC.FT, @VM)
    Y.FT = ''
    FOR I.F = 1 TO NO.FT
        Y.FT.V = 0
        Y.FT = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion)<1, I.F>
        IF Y.FT EQ 'FUNDS.TRANSFER' THEN
            Y.FT.V = COUNT(REC.FT, Y.FT)
            IF Y.FT.V GT 1 THEN
                EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion)
                EB.SystemTables.setAv(I.F)
                EB.SystemTables.setEtext("E!= ESPECIFICAR FT UNA SOLA VEZ")
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
        END
    NEXT I.F


    REC.CAT = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)
    NO.CAT = DCOUNT(REC.CAT, @VM)
    Y.CAT = ''
    FOR I.C = 1 TO NO.CAT
        Y.CAT.V = 0
        Y.CAT = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)<1, I.C>
        IF Y.CAT NE '' THEN
            Y.CAT.V = COUNT(REC.CAT, Y.CAT)
            IF Y.CAT.V GT 1 THEN
                EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoCategoria)
                EB.SystemTables.setAv(I.C)
                EB.SystemTables.setEtext("E!= CATEGORIA REPETIDA")
                EB.ErrorProcessing.StoreEndError()
                BREAK

            END
        END
        Y.CAT = ''
    NEXT I.C


    REC.HI = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni)
    REC.HF = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoHoraFin)
    N.HI = ''
    N.HF = ''
    FOR I.H = 1 TO DCOUNT(REC.HI, @VM)
        N.HI = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni)<1, I.H>
        N.HF = EB.SystemTables.getRNew(ABC.BP.VpmParamProceso.VpmParamProcesoHoraFin)<1, I.H>

        IF (N.HI[1,2] > N.HF[1,2]) THEN
            EB.SystemTables.setEtext("E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN")
            EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni)
            EB.SystemTables.setAv(I.H)
            EB.ErrorProcessing.StoreEndError()
            BREAK
        END ELSE
            IF (N.HI[1,2] = N.HF[1,2]) AND (N.HI[3,2] > N.HF[3,2]) THEN
                EB.SystemTables.setEtext("E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN")
                EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni)
                EB.SystemTables.setAv(I.H)
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END ELSE
                IF (N.HI[1,2] = N.HF[1,2]) AND (N.HI[3,2] = N.HF[3,2]) AND (N.HI[5,2] > N.HF[5,2]) THEN
                    EB.SystemTables.setEtext("E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN")
                    EB.SystemTables.setAf(ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni)
                    EB.SystemTables.setAv(I.H)
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                END
            END
        END
    NEXT I.H



REM > CALL XX.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF EB.SystemTables.getEndError()THEN
        EB.SystemTables.setA(1)
        LOOP UNTIL EB.SystemTables.getTEtext()<EB.SystemTables.getA()> <> "" DO EB.SystemTables.setA(EB.SystemTables.getA()+1); REPEAT
        EB.SystemTables.setTSequ("D")
        tmp = ''; tmp=EB.SystemTables.getTSequ(); tmp<-1>=EB.SystemTables.getA(); EB.SystemTables.setTSequ(tmp)
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
* Validation of function entered.  Sets V$FUNCTION to null if in error.

    tmp.V$FUNCTION = EB.SystemTables.getVFunction()
    IF INDEX('V',tmp.V$FUNCTION,1) THEN
        EB.SystemTables.setVFunction(tmp.V$FUNCTION)
        EB.SystemTables.setE('EB.RTN.FUNT.NOT.ALLOWED.APP')
        EB.ErrorProcessing.Err()
        EB.SystemTables.setVFunction('')
    END

RETURN

*************************************************************************
INITIALISE:

    BROWSER.PREVIEW.ON = (EB.Interface.getOfsMessage()='PREVIEW')  ;*EN_10002679 - S/E


RETURN

*************************************************************************
DEFINE.PARAMETERS:
* SEE 'I_RULES' FOR DESCRIPTIONS *

REM > CALL XX.FIELD.DEFINITIONS
*========================================================================
    EB.SystemTables.clearF() ; EB.SystemTables.clearN() ; EB.SystemTables.clearT() ; EB.SystemTables.setIdT("")
    EB.SystemTables.clearCheckfile() ; EB.SystemTables.clearConcatfile()
    EB.SystemTables.setIdCheckfile(""); EB.SystemTables.setIdConcatfile("")
*========================================================================

    EB.SystemTables.setIdF("ID");       EB.SystemTables.setIdN("9.9");       EB.SystemTables.setIdT("A")
    Z = 0
    Z+=1;        EB.SystemTables.setF(Z, "XX<APLICACION");   EB.SystemTables.setN(Z, "35.5.C");     EB.SystemTables.setT(Z, "");       tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<2>="ABC.AA.PRE.PROCESS_FUNDS.TRANSFER"; EB.SystemTables.setT(Z, tmp)
*    CHECKFILE(Z) = 'PGM.FILE':FM:EB.PGM.SCREEN.TITLE:FM:'L'

    Z+=1;        EB.SystemTables.setF(Z, "XX-CATEGORIA");    EB.SystemTables.setN(Z, "6");          EB.SystemTables.setT(Z, "A")
    EB.SystemTables.setCheckfile(Z, 'CATEGORY':@FM:ST.Config.Category.EbCatShortName:@FM:'L')
    Z+=1;        EB.SystemTables.setF(Z, "XX-HORA.INI");     EB.SystemTables.setN(Z, "8.1.C");      EB.SystemTables.setT(Z, "A");      tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<4>="##:##:##"; EB.SystemTables.setT(Z, tmp);
    Z+=1;        EB.SystemTables.setF(Z, "XX-HORA.FIN");     EB.SystemTables.setN(Z, "8.1.C");      EB.SystemTables.setT(Z, "A");      tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<4>="##:##:##"; EB.SystemTables.setT(Z, tmp);
    Z+=1;        EB.SystemTables.setF(Z , "XX-NARRATIVA");    EB.SystemTables.setN(Z, "35.5.C");     EB.SystemTables.setT(Z, "A");
    Z+=1;        EB.SystemTables.setF(Z, "XX>ESTATUS");      EB.SystemTables.setN(Z, "6.6.C");      EB.SystemTables.setT(Z, "");       tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<2>="ACTIVA_INACTIVA"; EB.SystemTables.setT(Z, tmp)
    Z+=1;        EB.SystemTables.setF(Z, "RESERVED.5");      EB.SystemTables.setN(Z, "35");         tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<1>="A"; EB.SystemTables.setT(Z, tmp);   tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<3>="NOINPUT"; EB.SystemTables.setT(Z, tmp)
    Z+=1;        EB.SystemTables.setF(Z, "RESERVED.4");      EB.SystemTables.setN(Z, "35");         tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<1>="A"; EB.SystemTables.setT(Z, tmp);   tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<3>="NOINPUT"; EB.SystemTables.setT(Z, tmp)
    Z+=1;        EB.SystemTables.setF(Z, "RESERVED.3");      EB.SystemTables.setN(Z, "35");         tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<1>="A"; EB.SystemTables.setT(Z, tmp);   tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<3>="NOINPUT"; EB.SystemTables.setT(Z, tmp)
    Z+=1;        EB.SystemTables.setF(Z, "RESERVED.2");      EB.SystemTables.setN(Z, "35");         tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<1>="A"; EB.SystemTables.setT(Z, tmp);   tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<3>="NOINPUT"; EB.SystemTables.setT(Z, tmp)
    Z+=1;        EB.SystemTables.setF(Z, "RESERVED.1");      EB.SystemTables.setN(Z, "35");         tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<1>="A"; EB.SystemTables.setT(Z, tmp);   tmp = ''; tmp=EB.SystemTables.getT(Z); tmp<3>="NOINPUT"; EB.SystemTables.setT(Z, tmp)
    EB.SystemTables.setV(Z + 9);   EB.SystemTables.setPrefix("VPM")

RETURN

*************************************************************************

END
