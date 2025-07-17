* @ValidationCode : MjoxNTk3OTg4MzgzOkNwMTI1MjoxNzUyNjM5MDMwNjQxOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jul 2025 01:10:30
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

    $USING EB.SystemTables
    $USING EB.Versions
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.ErrorProcessing

    IF EB.SystemTables.getRunningUnderBatch() THEN RETURN

    GOSUB INICIA.TABLAS
    GOSUB DEFINE.AP
    GOSUB INICIA.PROCESO

RETURN
**********
DEFINE.AP:
**********

    Y.AP = EB.SystemTables.getApplication()
    Y.VS = EB.SystemTables.getPgmVersion()
    Y.AP.VS = Y.AP : Y.VS

    EB.DataAccess.FRead(FN.VERSION, Y.AP.VS, REC.VERS, F.VERSION, Y.ERR.VERS)

    IF Y.AP EQ 'FUNDS.TRANSFER' OR Y.AP EQ 'FT' THEN
        IF REC.VERS NE '' THEN
            LOCATE 'COMMISSION.TYPE-1' IN REC.VERS<EB.Versions.Version.VerAutomFieldNo, 1> SETTING V.P THEN
                VAL.CSPEI = REC.VERS<EB.Versions.Version.VerAutNewContent, V.P>
            END
        END
    END

RETURN
***************
INICIA.PROCESO:
***************

    ID.PP = 'MX0010001'
    EB.DataAccess.FRead(FN.VPM.PARAM.PROCESO, ID.PP, REC.PP, F.VPM.PARAM.PROCESO, Y.ERR.PARAM.PROC)
    IF REC.PP NE '' THEN
        VAL.CAT = ''
        LISTA.APLICACION = REC.PP<AbcTable.AbcParamProceso.Aplicacion>
        FINDSTR Y.AP IN LISTA.APLICACION SETTING Ap, Vp, Sp THEN
            ID.AP = REC.PP<AbcTable.AbcParamProceso.Aplicacion,Ap,Vp>
            ID.CAT = REC.PP<AbcTable.AbcParamProceso.Categoria,Ap,Vp>
            H.I = REC.PP<AbcTable.AbcParamProceso.HoraIni,Ap,Vp>
            H.F = REC.PP<AbcTable.AbcParamProceso.HoraFin,Ap,Vp>
            ID.ST = REC.PP<AbcTable.AbcParamProceso.Estatus,Ap,Vp>

            H.I.A = ICONV(H.I, 'MTS');          H.I.B = OCONV(H.I.A, 'MTS')
            H.F.A = ICONV(H.F, 'MTS');          H.F.B = OCONV(H.F.A, 'MTS')

            IF (ID.AP EQ Y.AP AND ID.ST EQ 'ACTIVA' AND VAL.CAT EQ ID.CAT) OR (ID.AP EQ Y.AP AND ID.ST EQ 'ACTIVA' AND VAL.CSPEI EQ 'FTSPEIR6') THEN
                H.H = TIMEDATE()[1,8]
                IF (H.H GE H.I.B) AND (H.H LE H.F.B) ELSE
                    E = 'HORARIO NO PERMITIDO PARA OPERACION, SOLO DE ':H.I.B:' a ':H.F.B : ' Y SON LAS... ' : H.H
                    MESSAGE = 'REPEAT'
                    EB.SystemTables.setMessage(MESSAGE)
                    EB.SystemTables.setE(E)
                    EB.ErrorProcessing.Err()
                    RETURN
                END

            END
        END
    END

RETURN
**************
INICIA.TABLAS:
**************

    F.VERSION = ''
    FN.VERSION = 'F.VERSION'
    EB.DataAccess.Opf(FN.VERSION, F.VERSION)

    F.VPM.PARAM.PROCESO = ''
    FN.VPM.PARAM.PROCESO = 'F.ABC.PARAM.PROCESO'
    EB.DataAccess.Opf(FN.VPM.PARAM.PROCESO, F.VPM.PARAM.PROCESO)

    F.FUNSDS.TRANSFER = ''
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

RETURN
**********
END
