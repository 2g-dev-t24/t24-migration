* @ValidationCode : MjoxNjgxNjcxOTI5OkNwMTI1MjoxNzQ0NzQ4MTI0MjgxOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Apr 2025 15:15:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
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
* <Rating>1420</Rating>
*-----------------------------------------------------------------------------
*
*
SUBROUTINE VPM.PARAMETROS.BANXICO
*
*
*    First Release :
*    Developed for :
*    Developed by  :
*
*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*
*    $INSERT I_F.POSTING.RESTRICT
*    $INSERT I_F.OFS.SOURCE
*    $INSERT I_F.ACCOUNT
*    $INSERT I_F.CATEGORY
*    $INSERT I_F.VPM.MOTIVO.DEV.CECOBAN
*    $INSERT I_F.FT.COMMISSION.TYPE
*    $INSERT I_F.TRANSACTION
*    $INSERT I_F.VPM.PARAMETROS.BANXICO
*    $INSERT I_F.TELLER.TRANSACTION
*    $INSERT I_F.VPM.2BR.CTLG.OP.REMESAS
**
*
*
*************************************************************************
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.TransactionControl
    $USING EB.Display
    $USING EB.Template
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    GOSUB DEFINE.PARAMETERS

    IF LEN(EB.SystemTables.getTFunction()) GT 1 THEN
        GOTO V$EXIT
    END

*    CALL MATRIX.UPDATE
    EB.Display.MatrixUpdate()


    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

*        CALL RECORDID.INPUT
        EB.TransactionControl.RecordidInput()

        sGetMessasge = EB.SystemTables.getMessage()
    UNTIL sGetMessasge = 'RET' DO

        V$ERROR = ''        ;*falta comp V$ERROR
        IF sGetMessasge EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF EB.SystemTables.getTFunction() EQ 'E' OR EB.SystemTables.getTFunction() EQ 'L' THEN
*                CALL FUNCTION.DISPLAY
                EB.Display.FunctionDisplay()
                EB.SystemTables.setTFunction("")
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
;*falta comp V$ERROR
            IF V$ERROR THEN GOTO MAIN.REPEAT

*            CALL RECORD.READ
            EB.TransactionControl.RecordRead()


            IF sGetMessasge EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END


            GOSUB CHECK.RECORD          ;* Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT
;*falta comp V$ERROR
*            CALL MATRIX.ALTER
            EB.Display.MatrixAlter()

            GOSUB PROCESS.DISPLAY       ;* For Display applications

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE sGetMessasge EQ 'ERROR' DO REPEAT

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
*                CALL FIELD.MULTI.INPUT
                EB.Display.FieldMultiInput()
            END ELSE
*                CALL FIELD.MULTI.DISPLAY
                EB.Display.FieldMultiDisplay()
            END
        END ELSE
            IF EB.SystemTables.getFileType() EQ 'I' THEN
*                CALL FIELD.INPUT
                EB.Display.FieldInput()
            END ELSE
*                CALL FIELD.DISPLAY
                EB.Display.FieldDisplay()
            END
        END
        A = "0"      ;*EAGUILAR - SE INICIALIZA PARA SU USO
    UNTIL sGetMessasge NE "" DO

        GOSUB CHECK.FIELDS    ;* Special Field Editing
        
;*EAGUILAR - SE CAMBIA LA FOMRA DE EJECUTAR LA SENTENCIA IF
        VT.SEQU = EB.SystemTables.getTSequ()
        IF VT.SEQU NE '' THEN
            VT.SEQU<-1> = A + 1
            EB.SystemTables.setTSequ(VT.SEQU)
            
        END
;*EAGUILAR - SE CAMBIA LA FOMRA DE EJECUTAR LA SENTENCIA IF
    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF sGetMessasge EQ 'VAL' THEN
        sGetMessasge = ''
        BEGIN CASE
            CASE EB.SystemTables.getTFunction() EQ 'D'
REM >          GOSUB CHECK.DELETE              ;* Special Deletion checks
            CASE EB.SystemTables.getTFunction() EQ 'R'
                GOSUB CHECK.REVERSAL        ;* Special Reversal checks
            CASE 1
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
*            CALL UNAUTH.RECORD.WRITE
            EB.TransactionControl.UnauthRecordWrite()
            IF sGetMessasge NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END
    END

    IF sGetMessasge EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

*            CALL AUTH.RECORD.WRITE
            EB.TransactionControl.AuthRecordWrite()

            IF sGetMessasge NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

RETURN

*************************************************************************
DEFINE.PARAMETERS:
*========================================================================
    MAT F = "" ; MAT N = "" ; MAT T = "" ; ID.T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
*========================================================================
REM "DEFINE PARAMETERS - SEE 'I_RULES'-DESCRIPTION:
*
    ID.F = "ID" ; ID.N = "6.6" ; ID.T = "A"
*ID.CONCATFILE = "AR"
*ID.T<4>= ""
    Z = 0
    Z += 1 ; F(Z) = "BANXICO.NUM.BANCO"   ; N(Z) = "3"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "CTA.NOSTRO"          ; N(Z) = "13..C" ; T(Z) = "ACC"
*    CHECKFILE(Z)="ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.'
    EB.Template.FieldSetcheckfile("ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.')
    Z += 1 ; F(Z) = "CTA.NOSTRO.USD"      ; N(Z) = "13..C" ; T(Z) = "ACC"
*    CHECKFILE(Z)="ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.'
    EB.Template.FieldSetcheckfile("CTA.NOSTRO.USD")
    Z += 1 ; F(Z) = "BANXICO.PLAZA"       ; N(Z) = "3.3"; T(Z) = ""
    Z += 1 ; F(Z) = "BANXICO.ACCOUNT"     ; N(Z) = "20" ; T(Z) = "A"
    Z += 1 ; F(Z) = "BANXICO.NOMBRE.BANCO"; N(Z) = "35" ; T(Z) = "A"
    Z += 1 ; F(Z) = "PLAZA.SPEUA"         ; N(Z) = "5"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "TIPO.CTA.SPEUA"      ; N(Z) = "3"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "MIN.AMOUNT.SPEUA"    ; N(Z) = "20" ; T(Z) = ""
    Z += 1 ; F(Z) = "MAX.AMOUNT.SPEUA.AUT"; N(Z) = "20" ; T(Z) = ""
    Z += 1 ; F(Z) = "IMAGES.PATH"         ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "FILES.PATH"          ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEUA.DEVOL.REC"     ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEUA.ORD.REC"       ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEUA.ORD.REC.DEVOL" ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "CECOBAN.REC"         ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "CECOBAN.REC.DEV"     ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX<ACCT.REST"        ; N(Z) = "2"  ; T(Z) = ""
*    CHECKFILE(Z)="POSTING.RESTRICT":FM:AC.POS.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("POSTING.RESTRICT":FM:AC.POS.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "XX>REJ.CODE"         ; N(Z) = "2"  ; T(Z) = "A"
*    CHECKFILE(Z)="VPM.MOTIVO.DEV.CECOBAN":FM:VPM.MDEV.DESCRIPCION:FM:'A.'
    EB.Template.FieldSetcheckfile("VPM.MOTIVO.DEV.CECOBAN":FM:VPM.MDEV.DESCRIPCION:FM:'A.')
    Z += 1 ; F(Z) = "OFS.SRCE.PAGADOS"    ; N(Z) = "20" ; T(Z) = "A"
*    CHECKFILE(Z)="OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "COMM.TYPE.CHQ.DEV"   ; N(Z) = "11" ; T(Z) = "A"
*    CHECKFILE(Z)="FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "CUST.DR.CHQ.DEV"     ; N(Z) = "3"  ; T(Z) = "A"
*    CHECKFILE(Z)="TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.'
    EB.Template.FieldSetcheckfile("TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.')
    Z += 1 ; F(Z) = "CUST.CR.CHQ.DEV"     ; N(Z) = "3"  ; T(Z) = "A"
*    CHECKFILE(Z)="TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.'
    EB.Template.FieldSetcheckfile("TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.')
    Z += 1 ; F(Z) = "IMAGE.TYPE"          ; N(Z) =" 2"  ; T(Z)=""
    Z += 1 ; F(Z) = "IMAGE.OFS.VERSION"   ; N(Z) = "40" ; T(Z)="A"
*    CHECKFILE(Z)="VERSION":FM:0:FM:'A.'
    EB.Template.FieldSetcheckfile("VERSION")
    Z += 1 ; F(Z) = "IMAGE.OFS.SOURCE"    ; N(Z) = "40" ; T(Z)="A"
*    CHECKFILE(Z)="OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "IMAGE.POST.MAINT"    ; N(Z) = "3"  ; T(Z)=""
    Z += 1 ; F(Z) = "IMAGE.REC.PATH"      ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "AMT.IMG.MXN"         ; N(Z) = "20" ; T(Z) = "AMT"
    Z += 1 ; F(Z) = "AMT.IMG.USD"         ; N(Z) = "20" ; T(Z) = "AMT"
    Z += 1 ; F(Z) = "TT.TXN.DEP.MXN"      ; N(Z) = "3"  ; T(Z)=""
*    CHECKFILE(Z)="TELLER.TRANSACTION":FM:TT.TR.DESC:FM:'A.'
    EB.Template.FieldSetcheckfile("TELLER.TRANSACTION")
    Z += 1 ; F(Z) = "TT.TXN.DEP.USD"      ; N(Z) = "3"  ; T(Z)=""
*    CHECKFILE(Z)="TELLER.TRANSACTION":FM:TT.TR.DESC:FM:'A.'
    EB.Template.FieldSetcheckfile("TELLER.TRANSACTION")
    Z += 1 ; F(Z) = "CTA.BNK.DEP.USD"     ; N(Z) = "13..C" ; T(Z) = "ACC"
*    CHECKFILE(Z)="ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.'
    EB.Template.FieldSetcheckfile("ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.')
    Z += 1 ; F(Z) = "COMM.TYPE.REMESA"    ; N(Z) = "11" ; T(Z) = "A"
*    CHECKFILE(Z)="FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "COMM.TYPE.REM.DEV"   ; N(Z) = "11" ; T(Z) = "A"
*    CHECKFILE(Z)="FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "CATEG.REMESA"        ; N(Z) = "5"  ; T(Z) = ""
*    CHECKFILE(Z)="CATEGORY":FM:EB.CAT.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("CATEGORY":FM:EB.CAT.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "CATEG.DOCTOS"        ; N(Z) = "5"  ; T(Z) = ""
*    CHECKFILE(Z)="CATEGORY":FM:EB.CAT.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("CATEGORY":FM:EB.CAT.DESCRIPTION:FM:'A.')
    Z += 1 ; F(Z) = "REM.CHK.PAID"        ; N(Z) = "2"  ; T(Z) = "A"
*    CHECKFILE(Z)="VPM.2BR.CTLG.OP.REMESAS":FM:VPM.OP.REM.DESCRIPCION:FM:'A.'
    EB.Template.FieldSetcheckfile("VPM.2BR.CTLG.OP.REMESAS":FM:VPM.OP.REM.DESCRIPCION:FM:'A.')
    Z += 1 ; F(Z) = "TXN.CDE.REMESAS"     ; N(Z) = "3"  ; T(Z) = "A"
*    CHECKFILE(Z)="TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.'
    EB.Template.FieldSetcheckfile("TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.')
    Z += 1 ; F(Z) = "TXN.CDE.REM.REJ"     ; N(Z) = "3"  ; T(Z) = "A"
*    CHECKFILE(Z)="TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.'
    EB.Template.FieldSetcheckfile("TRANSACTION":FM:AC.TRA.NARRATIVE:FM:'A.')
    Z += 1 ; F(Z) = "CTA.NOSTRO.REM"      ; N(Z) = "13..C" ; T(Z) = "ACC"
*    CHECKFILE(Z)="ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.'
    EB.Template.FieldSetcheckfile("ACCOUNT":FM:AC.SHORT.TITLE:FM:'A.')

*Z+=1 ; F(Z)="RESERVED.3"             ; N(Z)="9"    ; T(Z)<3>="NOINPUT"
*Z+=1 ; F(Z)="RESERVED.2"             ; N(Z)="9"    ; T(Z)<3>="NOINPUT"
*Z+=1 ; F(Z)="RESERVED.1"             ; N(Z)="9"    ; T(Z)<3>="NOINPUT"
*    V = Z+9 ; PREFIX = "VPM.PARAMETROS.BANXICO"
    EB.Template.setTableEquateprefix('VPM.PARAMETROS.BANXICO')     ;* Use to create I_F.EB.LOG.PARAMETER
    EB.Template.TableSetauditposition()         ;* Populate audit information

*
RETURN
**********************************************************************
INITIALISE:
*
RETURN
*********************************************************************
CHECK.FUNCTION:
*
RETURN
*******************************************************************
CHECK.ID:
*
* Validation and changes of the ID entered. Set ERROR to 1 if in error.

    sError = EB.SystemTables.setE("")
    IF EB.SystemTables.getIdNew() NE "SYSTEM" THEN
        EB.SystemTables.setE("ID IS NOT VALID")
    END
    IF EB.SystemTables.getE() THEN
        V$ERROR = 1
*        CALL ERR
        EB.ErrorProcessing.Err()
    END

RETURN
*******************************************************************
CHECK.RECORD:
*
RETURN
*******************************************************************
PROCESS.DISPLAY:
*
RETURN
*******************************************************************
CHECK.FIELDS:
*
    sGetAF = EB.SystemTables.getAf()
    sGetCOMI = EB.SystemTables.getComi()
*    IF (sGetAF = VPM.CTA.NOSTRO.USD) OR (sGetAF = VPM.CTA.NOSTRO) OR (sGetAF = VPM.CTA.BNK.DEP.USD) OR (sGetAF = VPM.CTA.NOSTRO.REM) THEN
    IF (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroUsd) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostro) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaBnkDepUsd) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroRem) THEN
        F.ACCOUNT  = ""
        FN.ACCOUNT = "F.ACCOUNT"
        CALL OPF(FN.ACCOUNT,F.ACCOUNT)
        YF.ERR = ""
        YREC.ACCOUNT = ""
*        CALL F.READ(FN.ACCOUNT,COMI,YREC.ACCOUNT,F.ACCOUNT,YF.ERR)
        YREC.ACCOUNT = AC.AccountOpening.Account.Read(sGetCOMI, YF.ERR)
        YACCOUNT.CCY = YREC.ACCOUNT<AC.AccountOpening.Account.Currency>     ;*<AC.CURRENCY>
        YACCOUNT.CATEGORY = YREC.ACCOUNT<AC.AccountOpening.Account.Category>        ;*<AC.CATEGORY>
    END
*    IF (sGetAF = VPM.CTA.NOSTRO.USD) OR (sGetAF = VPM.CTA.NOSTRO) OR (sGetAF = VPM.CTA.NOSTRO.REM) THEN
    IF (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroUsd) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostro) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroRem) THEN
        IF YACCOUNT.CATEGORY NE "5001" THEN
            EB.SystemTables.setE('Cuenta debe tener categoria 5-001 (Nostro)')
            GOTO CHECK.FIELDS.ERROR
        END
    END
*    IF (sGetAF = VPM.CTA.NOSTRO) AND (YACCOUNT.CCY <> "MXN") THEN
    IF (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostro) AND (YACCOUNT.CCY NE "MXN") THEN
        EB.SystemTables.setE("Cuenta debe ser moneda MXN")
        GOTO CHECK.FIELDS.ERROR
    END
*    IF ((sGetAF = VPM.CTA.NOSTRO.USD) OR (sGetAF = VPM.CTA.BNK.DEP.USD) OR (sGetAF = VPM.CTA.NOSTRO.REM)) AND (YACCOUNT.CCY <> "USD") THEN
    IF ((sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroUsd) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroRem) OR (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroRem)) AND (YACCOUNT.CCY NE "USD") THEN
        EB.SystemTables.setE("Cuenta debe ser moneda USD")
        GOTO CHECK.FIELDS.ERROR
    END
*IF (sGetAF = VPM.CTA.BNK.DEP.USD) AND (COMI = R.NEW(VPM.CTA.NOSTRO.USD)) THEN
    IF (sGetAF EQ ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaBnkDepUsd) AND (sGetCOMI EQ EB.SystemTables.getRNew(ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoCtaNostroUsd)) THEN
        EB.SystemTables.setE("Cuenta debe ser diferente a nostro USD")
        GOTO CHECK.FIELDS.ERROR
    END

CHECK.FIELDS.ERROR:

    IF EB.SystemTables.getE() THEN
        V$ERROR = 1
*        CALL ERR
        EB.ErrorProcessing.Err()
    END

RETURN
******************************************************************
CHECK.DELETE:
*
RETURN
*******************************************************************
CHECK.REVERSAL:
*
RETURN
********************************************************************
CROSS.VALIDATION:
*
REM TO CHECK WHETHER THE DESCRIPTION IS BLANK
*
    sGetAF = 1          ;REM AF = 1 : DESCRIPTION
*

    IF EB.SystemTables.getRNew(sGetAF) EQ "" THEN
        EB.SystemTables.setEtext('Please Enter Description')
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END
*
RETURN
********************************************************************
BEFORE.UNAU.WRITE:
*
RETURN
********************************************************************
AFTER.UNAU.WRITE:
*
RETURN
********************************************************************
AUTH.CROSS.VALIDATION:
*
RETURN
********************************************************************
BEFORE.AUTH.WRITE:
*
RETURN
********************************************************************
AFTER.AUTH.WRITE:
*
RETURN
*********************************************************************
END
