* @ValidationCode : MjotMTY1MjEyOTk5NDpDcDEyNTI6MTc1MjYyNzkyNTI1NDptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Jul 2025 22:05:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>320</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.HORA.CAPTURA


*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_F.VERSION
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER

*    $INCLUDE ABC.BP I_F.VPM.PARAM.PROCESO

*    IF RUNNING.UNDER.BATCH THEN RETURN

    GOSUB INICIA.TABLAS
    GOSUB DEFINE.AP
    GOSUB INICIA.PROCESO

RETURN
**********
DEFINE.AP:
**********

*    Y.AP = APPLICATION
*    Y.VS = PGM.VERSION
*    Y.AP.VS = APPLICATION : PGM.VERSION

*    READ REC.VERS FROM F.VERSION, Y.AP.VS ELSE NULL
*    IF Y.AP EQ 'FUNDS.TRANSFER' OR Y.AP EQ 'FT' THEN
*        IF REC.VERS NE '' THEN
*            LOCATE 'COMMISSION.TYPE-1' IN REC.VERS<EB.VER.AUTOM.FIELD.NO, 1> SETTING V.P THEN
*                VAL.CSPEI = REC.VERS<EB.VER.AUT.NEW.CONTENT, V.P>
*            END
*        END
*    END

RETURN
***************
INICIA.PROCESO:
***************

*    ID.PP = 'MX0010001'
*    READ REC.PP FROM F.VPM.PARAM.PROCESO, ID.PP ELSE NULL
*    IF REC.PP NE '' THEN
*        VAL.CAT = ''
*        LISTA.APLICACION = REC.PP<VPM.APLICACION>
*        FINDSTR Y.AP IN LISTA.APLICACION SETTING Ap, Vp, Sp THEN
*            ID.AP = REC.PP<VPM.APLICACION,Ap,Vp>
*            ID.CAT = REC.PP<VPM.CATEGORIA,Ap,Vp>
*            H.I = REC.PP<VPM.HORA.INI,Ap,Vp>
*            H.F = REC.PP<VPM.HORA.FIN,Ap,Vp>
*            ID.ST = REC.PP<VPM.ESTATUS,Ap,Vp>

*            H.I.A = ICONV(H.I, 'MTS');          H.I.B = OCONV(H.I.A, 'MTS')
*            H.F.A = ICONV(H.F, 'MTS');          H.F.B = OCONV(H.F.A, 'MTS')

*            IF (ID.AP EQ Y.AP AND ID.ST EQ 'ACTIVA' AND VAL.CAT EQ ID.CAT) OR (ID.AP EQ Y.AP AND ID.ST EQ 'ACTIVA' AND VAL.CSPEI EQ 'FTSPEIR6') THEN
*                H.H = TIMEDATE()[1,8]
*                IF (H.H GE H.I.B) AND (H.H LE H.F.B) ELSE
*                    E = 'HORARIO NO PERMITIDO PARA OPERACION, SOLO DE ':H.I.B:' a ':H.F.B : ' Y SON LAS... ' : H.H
*                    MESSAGE = 'REPEAT'
*                    CALL ERR
*                    RETURN
*                END

*            END
*        END
*    END

RETURN
**************
INICIA.TABLAS:
**************

*    F.VERSION = ''
*    FN.VERSION = 'F.VERSION'
*    CALL OPF(FN.VERSION, F.VERSION)

*    F.VPM.PARAM.PROCESO = ''
*    FN.VPM.PARAM.PROCESO = 'F.VPM.PARAM.PROCESO'
*    CALL OPF(FN.VPM.PARAM.PROCESO, F.VPM.PARAM.PROCESO)

*   F.FUNSDS.TRANSFER = ''
*    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
*    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

RETURN
**********
END
