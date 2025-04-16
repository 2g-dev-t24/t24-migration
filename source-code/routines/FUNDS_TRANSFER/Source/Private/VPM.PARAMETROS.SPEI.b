* @ValidationCode : MjotOTI0MDUyNTIxOkNwMTI1MjoxNzQ0NjQ4OTk2MTkyOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Apr 2025 11:43:16
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
*-----------------------------------------------------------------------------
* <Rating>650</Rating>
*-----------------------------------------------------------------------------
*
*
$PACKAGE ABC.BP
SUBROUTINE VPM.PARAMETROS.SPEI
*
*
*    First Release :
*    Developed for :
*    Developed by  :
*
* $INSERT I_COMMON
* $INSERT I_EQUATE
*
*$INSERT I_F.POSTING.RESTRICT
*$INSERT I_F.OFS.SOURCE
*$INSERT I_F.ACCOUNT
**$INSERT I_F.VPM.MOTIVO.DEV.CECOBAN
*$INSERT I_F.FT.COMMISSION.TYPE
*$INSERT I_F.TRANSACTION
*$INSERT I_F.CATEGORY
*$INSERT I_F.VERSION
*$INSERT I_F.FT.TXN.TYPE.CONDITION
*$INSERT I_F.VPM.PARAMETROS.SPEI
*
*
*
*************************************************************************
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.TransactionControl
    $USING EB.Display
    $USING EB.Template
    $USING EB.ErrorProcessing
    $USING CG.ChargeConfig
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
        sGetMessage = EB.SystemTables.getMessage()
    UNTIL sGetMessage EQ 'RET' DO

        V$ERROR = ''        ;*falta comp V$ERROR
        IF sGetMessage EQ 'NEW FUNCTION' THEN

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


            IF sGetMessage EQ 'REPEAT' THEN
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
            WHILE sGetMessage EQ 'ERROR' DO REPEAT

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
        A = ""      ;*EAGUILAR - SE INICIALIZA PARA SU USO
    UNTIL sGetMessage NE "" DO

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

    IF sGetMessage EQ 'VAL' THEN
        sGetMessage = ""
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
            IF sGetMessage NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END
    END

    IF sGetMessage EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

*            CALL AUTH.RECORD.WRITE
            EB.TransactionControl.AuthRecordWrite()

            IF sGetMessage NE "ERROR" THEN
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
    Z += 1 ; F(Z) = "SPEI.MONTO.MIN"      ; N(Z) = "20" ; T(Z) = ""
    Z += 1 ; F(Z) = "SPEI.MONTO.MAX"      ; N(Z) = "20" ; T(Z) = ""
    Z += 1 ; F(Z) = "TXN.TIPO.ENV"        ; N(Z) = "4"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "TXN.TIPO.MEN"        ; N(Z) = "4"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "TXN.TIPO.REC"        ; N(Z) = "4"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "TXN.TIPO.DEV"        ; N(Z) = "4"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEI.DEVOL.REC"      ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEI.ORD.REC"        ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEI.ORD.REC.DEVOL"  ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEI.CTA.MENORES"    ; N(Z) = "11" ; T(Z) = "A"
    Z += 1 ; F(Z) = "SPEI.CTA.BANXICO"    ; N(Z) = "11" ; T(Z) = "A"
*    Z += 1 ; F(Z) = "OFS.SOURCE"          ; N(Z) = "20" ; T(Z) = "A"
    EB.Template.TableAddfielddefinition("OFS.SOURCE", '20', 'A', '')
*    CHECKFILE(Z)="OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:"A."
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:"A.")
    Z += 1 ; F(Z) = "OFS.FX.VERSION"      ; N(Z) = "39" ; T(Z) = "A"
*    CHECKFILE(Z)="VERSION":FM:EB.VER.DESCRIPTION:FM:"A."
    EB.Template.FieldSetcheckfile("VERSION":FM:EB.VER.DESCRIPTION:FM:"A.")
    Z += 1 ; F(Z) = "DISP.PATH"           ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "DISP.ERR.PATH"       ; N(Z) = "60" ; T(Z) = "A"
    Z += 1 ; F(Z) = "DISP.AMT"            ; N(Z) = "20" ; T(Z) = "AMT"
    Z += 1 ; F(Z) = "NUM.DIAS.DISP"       ; N(Z) = "2"  ; T(Z) = ""
    Z += 1 ; F(Z) = "OFS.SOURCE.DISP"     ; N(Z) = "20" ; T(Z) = "A"
*    CHECKFILE(Z)="OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:"A."
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:"A.")
    Z += 1 ; F(Z) = "OFS.DISP.VERSION"    ; N(Z) = "39" ; T(Z) = "A"
*    CHECKFILE(Z)="VERSION":FM:EB.VER.DESCRIPTION:FM:"A."
    EB.Template.FieldSetcheckfile("VERSION":FM:EB.VER.DESCRIPTION:FM:"A.")
    Z += 1 ; F(Z) = "OFS.DISP.INT.VER"    ; N(Z) = "39" ; T(Z) = "A"
*    CHECKFILE(Z)="VERSION":FM:EB.VER.DESCRIPTION:FM:"A."
    EB.Template.FieldSetcheckfile("VERSION":FM:EB.VER.DESCRIPTION:FM:"A.")
    Z += 1 ; F(Z) = "DISP.INT.TXN"        ; N(Z) = "4"  ; T(Z) = "A"
*    CHECKFILE(Z)="FT.TXN.TYPE.CONDITION":FM:FT6.SHORT.DESCR:FM:"A."
    EB.Template.FieldSetcheckfile("FT.TXN.TYPE.CONDITION":FM:FT6.SHORT.DESCR:FM:"A.")
    Z += 1 ; F(Z) = "TIPO.TERC.TERC"      ; N(Z) = "1.1.C"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "TIPO.BCO.TERCERO"    ; N(Z) = "1.1.C"  ; T(Z) = "A"
    Z += 1 ; F(Z) = "COMM.FT.MASIV"       ; N(Z) = "11.1.C" ; T(Z) = "A"
*    CHECKFILE(Z)="FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.'
    EB.Template.FieldSetcheckfile("FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:"A.")
    Z += 1 ; F(Z) = "DAYS.TO.HIS"         ; N(Z) = "3.1.C"  ; T(Z) = ""
    Z += 1 ; F(Z) = "DAYS.TO.DEL"         ; N(Z) = "3.1.C"  ; T(Z) = ""
*Z+=1 ; F(Z)="RESERVED.3"             ; N(Z)="9"        ; T(Z)<3>="NOINPUT"
*Z+=1 ; F(Z)="RESERVED.2"             ; N(Z)="9"        ; T(Z)<3>="NOINPUT"
*Z+=1 ; F(Z)="RESERVED.1"             ; N(Z)="9"        ; T(Z)<3>="NOINPUT"
    V = Z+9 ; PREFIX = "VPM.SPEI"

*
RETURN
**********************************************************************
INITIALISE:
*
    YCONST.TIPO.TERC.TERC   = "1"
    YCONST.TIPO.BCO.TERCERO = "5"
      
    YCONST.CALC.BASIS1      = "UNIT"

*    FN.FT.COMMISSION.TYPE = "F.FT.COMMISSION.TYPE"
*    F.FT.COMMISSION.TYPE = ""
*    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
      
RETURN
*********************************************************************
CHECK.FUNCTION:
*
RETURN
*******************************************************************
CHECK.ID:
*
* Validation and changes of the ID entered. Set ERROR to 1 if in error.

    EB.SystemTables.setE("")
    IF EB.SystemTables.getIdNew() NE "SYSTEM" THEN
        EB.SystemTables.setE("ID IS NOT VALID")
    END
    IF EB.SystemTables.getE() THEN
        V$ERROR = 1
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
    EB.SystemTables.setE("")
    sGetComi = EB.SystemTables.getComi()
    nGetAf = EB.SystemTables.getAf()
*    IF AF = VPM.SPEI.COMM.FT.MASIV THEN
    IF nGetAf EQ ABC.BP.VpmParametrosSpei.CommFtMasiv THEN
*        CALL F.READ(FN.FT.COMMISSION.TYPE,COMI,YREC.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,YF.ERR)
        YREC.FT.COMMISSION.TYPE = CG.ChargeConfig.FtCommissionType.Read(GET.COMI, YF.ERR)
        IF YREC.FT.COMMISSION.TYPE THEN
*            IF (YREC.FT.COMMISSION.TYPE<FT4.CALCULATION.BASIS> <> YCONST.CALC.BASIS1) AND (YREC.FT.COMMISSION.TYPE<FT4.CALCULATION.BASIS,1,1> <> "") THEN
            IF (YREC.FT.COMMISSION.TYPE<CG.ChargeConfig.FtCommissionType.FtFouCalculationBasis> NE YCONST.CALC.BASIS1) AND (YREC.FT.COMMISSION.TYPE<CG.ChargeConfig.FtCommissionType.FtFouCalculationBasis,1,1> NE "") THEN
                EB.SystemTables.setE("Base de Calculo debe ser ":YCONST.CALC.BASIS1:" o nulo")
            END
        END
    END

*    IF (AF EQ VPM.SPEI.TIPO.BCO.TERCERO) OR (AF EQ VPM.SPEI.TIPO.TERC.TERC) THEN
    IF (nGetAf EQ ABC.BP.VpmParametrosSpei.TipoBcoTercero) OR (nGetAf EQ ABC.BP.VpmParametrosSpei.TipoTercTerc) THEN
*        IF (COMI NE YCONST.TIPO.TERC.TERC) AND (COMI NE YCONST.TIPO.BCO.TERCERO) THEN
        IF (sGetComi NE ABC.BP.VpmParametrosSpei.TipoTercTerc) AND (sGetComi NE ABC.BP.VpmParametrosSpei.TipoBcoTercero) THEN
            EB.SystemTables.setE("Valor del campo debe ser (":YCONST.TIPO.TERC.TERC:" o ":YCONST.TIPO.BCO.TERCERO:")")
        END
    END
*IF (AF = VPM.SPEI.DAYS.TO.HIS) AND (R.NEW(VPM.SPEI.DAYS.TO.DEL)) THEN
    IF (nGetAf EQ ABC.BP.VpmParametrosSpei.DaysToHis) AND (EB.SystemTables.getRNew(ABC.BP.VpmParametrosSpei.DaysToDel)) THEN
        IF sGetComi GE EB.SystemTables.getRNew(26) THEN
            EB.SystemTables.setE("Valor debe ser menor que dias para eliminar")
        END
    END
      
*    IF (AF EQ VPM.SPEI.DAYS.TO.DEL) AND (R.NEW(VPM.SPEI.DAYS.TO.HIS)) THEN
    IF (nGetAf EQ ABC.BP.VpmParametrosSpei.DaysToDel) AND (EB.SystemTables.getRNew(ABC.BP.VpmParametrosSpei.DaysToDel)) THEN
*        IF COMI <= R.NEW(VPM.SPEI.DAYS.TO.HIS) THEN
        IF sGetComi LE EB.SystemTables.getRNew(ABC.BP.VpmParametrosSpei.DaysToHis) THEN
            EB.SystemTables.setE("Valor debe ser mayor que dias para historia")
        END
    END

    IF EB.SystemTables.getE() THEN
        V$ERROR = 1
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
    nGetAf = 1                             ; REM AF = 1 : DESCRIPTION
*

    IF EB.SystemTables.getRNew(nGetAf) EQ '' THEN
        EB.SystemTables.setEtext('Please Enter Description')
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
