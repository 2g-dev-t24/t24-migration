* @ValidationCode : Mjo0MzczOTk3Mzc6Q3AxMjUyOjE3NDQ3NTc2MzYwOTU6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Apr 2025 17:53:56
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
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE VPM.VALIDA.AUT.SPEI
* Componente T24     : FUNDS.TRANSFER,ABC.SPEI.EXPRESS.PRN.2

*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*    $INSERT I_F.FUNDS.TRANSFER

**    $INSERT I_F.VPM.PARAMETROS.BANXICO
*    $INSERT I_F.VPM.PARAMETROS.SPEI

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ABC.BP I_F.VPM.PARAMETROS.SPEI
*-----------------------------------------------------------------------------
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------

* Main Program Loop

***************************
*VARIABLES USADAS
***************************

*    YPOS.CTA.BENEF.SPEUA = 0
*    CALL GET.LOC.REF("FUNDS.TRANSFER","CTA.BENEF.SPEUA",YPOS.CTA.BENEF.SPEUA)
*
*    YPOS.CTA.EXT.TRANSF = 0
*    CALL GET.LOC.REF("FUNDS.TRANSFER","CTA.EXT.TRANSF",YPOS.CTA.EXT.TRANSF)

    YPOS.CTA.BENEF.SPEUA = 0
    YPOS.CTA.EXT.TRANSF = 0
    
    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = "CTA.BENEF.SPEUA"
    fields<1,1>      = "CTA.EXT.TRANSF"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    YPOS.CTA.BENEF.SPEUA     = field_Positions<1,1>
    YPOS.CTA.EXT.TRANSF     = field_Positions<1,2>
*    IF (R.NEW(FT.LOCAL.REF)<1,YPOS.CTA.EXT.TRANSF>="") AND (R.NEW(FT.LOCAL.REF)<1,YPOS.CTA.BENEF.SPEUA>="") THEN
    GET.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    IF (GET.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF> EQ "") AND (GET.LOCAL.REF<1,YPOS.CTA.BENEF.SPEUA> EQ "") THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef) ; EB.SystemTables.setAv(YPOS.CTA.EXT.TRANSF)
        EB.SystemTables.setEtext("Debe capturar una cuenta beneficiaria")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF (GET.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF> NE "") AND (GET.LOCAL.REF<1,YPOS.CTA.BENEF.SPEUA> NE "") THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)  ; EB.SystemTables.setAv(YPOS.CTA.EXT.TRANSF)
        EB.SystemTables.setEtext("Solo debe capturar una cuenta")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END


*    YCONST.TABLA.PARAMETROS = "F.VPM.PARAMETROS.SPEI" ; F.TABLA.PARAM = '' ; CALL OPF(YCONST.TABLA.PARAMETROS, F.TABLA.PARAM)
    YCONST.ID.TABLA.PARAMETROS = "SYSTEM"

    YMONTO.MAXIMO.AUTORIZACION = ""
*ITSS - NYADAV - START / END
*    CALL DBR(YCONST.TABLA.PARAMETROS:FM:VPM.SPEI.MONTO.S.AUT,YCONST.ID.TABLA.PARAMETROS,YMONTO.MAXIMO.AUTORIZACION)
*    CALL CACHE.READ(YCONST.TABLA.PARAMETROS,"SYSTEM",R.REC.VAL,YERR)
    R.REC.VAL = ABC.BP.VpmParametrosSpei.CacheRead(YCONST.ID.TABLA.PARAMETROS, YERR)
    YMONTO.MAXIMO.AUTORIZACION = R.REC.VAL<ABC.BP.VpmParametrosSpei.MontoSAut> ;*<VPM.SPEI.MONTO.S.AUT>
*ITSS - NYADAV - START / END

*... quitar validacion, no es necesario enviar mensaje,
*... ya que al momento de autorizar el spei,
*... solo requiere una autorizacion
*
*    IF PGM.VERSION <> ",VPM.2BR.OFS.SPEI.DISP" THEN
*       IF R.NEW(FT.DEBIT.AMOUNT) > YMONTO.MAXIMO.AUTORIZACION THEN
*            TEXT = "Monto SPEI requiere doble autorizacion"
*            CALL STORE.OVERRIDE(1)
*            IF TEXT = 'NO' THEN
*               V$ERROR = 1
*               RETURN
*            END
*       END
*    END

RETURN
