* @ValidationCode : MjoxOTU3OTk1ODA0OkNwMTI1MjoxNzQ0ODM2NTIyNTY4Om1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 15:48:42
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
* <Rating>320</Rating>
*-----------------------------------------------------------------------------

SUBROUTINE VPM.HORA.CAPTURA
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------

* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_F.VERSION  ;* Not Used anymore
* $INSERT I_F.FUNDS.TRANSFER  ;* Not Used anymore
* $INSERT I_F.VPM.PARAM.PROCESO - Not Used anymore;
    
    $USING EB.Versions
    $USING EB.SystemTables
*    $USING EB.DataAccess - Not Used anymore;
    $USING EB.ErrorProcessing
    $USING ABC.BP
    
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
    Y.AP.VS = EB.SystemTables.getApplication() : EB.SystemTables.getPgmVersion()

*    READ REC.VERS FROM F.VERSION, Y.AP.VS ELSE NULL
    REC.VERS = EB.Versions.Version.Read(Y.AP.VS, Error)
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
*    READ REC.PP FROM F.VPM.PARAM.PROCESO, ID.PP ELSE NULL
    REC.PP = ''
    YERR = ''
*    EB.DataAccess.FRead(FN.VPM.PARAM.PROCESO,ID.PP,REC.PP,F.VPM.PARAM.PROCESO,YERR)
    REC.PP = ABC.BP.VpmParamProceso.Read(ID.PP, YERR)
 
    IF REC.PP NE '' THEN
        VAL.CAT = ''
        LISTA.APLICACION = REC.PP<ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion>
        FINDSTR Y.AP IN LISTA.APLICACION SETTING Ap, Vp, Sp THEN
            ID.AP = REC.PP<ABC.BP.VpmParamProceso.VpmParamProcesoAplicacion,Ap,Vp>
            ID.CAT = REC.PP<ABC.BP.VpmParamProceso.VpmParamProcesoCategoria,Ap,Vp>
            H.I = REC.PP<ABC.BP.VpmParamProceso.VpmParamProcesoHoraIni,Ap,Vp>
            H.F = REC.PP<ABC.BP.VpmParamProceso.VpmParamProcesoHoraFin,Ap,Vp>
            ID.ST = REC.PP<ABC.BP.VpmParamProceso.VpmParamProcesoEstatus,Ap,Vp>

            H.I.A = ICONV(H.I, 'MTS');          H.I.B = OCONV(H.I.A, 'MTS')
            H.F.A = ICONV(H.F, 'MTS');          H.F.B = OCONV(H.F.A, 'MTS')

            IF (ID.AP EQ Y.AP AND ID.ST EQ 'ACTIVA' AND VAL.CAT EQ ID.CAT) OR (ID.AP EQ Y.AP AND ID.ST EQ 'ACTIVA' AND VAL.CSPEI EQ 'FTSPEIR6') THEN
                H.H = TIMEDATE()[1,8]
                IF (H.H GE H.I.B) AND (H.H LE H.F.B) ELSE
                    EB.SystemTables.setE('HORARIO NO PERMITIDO PARA OPERACION, SOLO DE ':H.I.B:' a ':H.F.B : ' Y SON LAS... ' : H.H)
                    EB.SystemTables.setMessage('REPEAT')
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

*    F.VERSION = ''
*    FN.VERSION = 'F.VERSION'
*    EB.DataAccess.Opf(FN.VERSION, F.VERSION)
*
*    F.VPM.PARAM.PROCESO = ''
*    FN.VPM.PARAM.PROCESO = 'F.VPM.PARAM.PROCESO'
*    EB.DataAccess.Opf(FN.VPM.PARAM.PROCESO, F.VPM.PARAM.PROCESO)
*
*    F.FUNSDS.TRANSFER = ''
*    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
*    EB.DataAccess.Opf(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

RETURN
**********
END
