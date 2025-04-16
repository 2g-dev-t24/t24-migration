* @ValidationCode : MjotMTg1MDQyMTQ0NDpDcDEyNTI6MTc0NDgzNzQ5NTM3NzptYXJjbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:04:55
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
* <Rating>85</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------
SUBROUTINE VPM.CLEAR.CTA.EXTERNA.SPEI


* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_F.FUNDS.TRANSFER  ;* Not Used anymore
    
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables

    Y.ID.ACCT = EB.SystemTables.getComi()
    ABC.BP.abcValPostRest(Y.ID.ACCT)

* Main Program Loop

***************************
*VARIABLES USADAS
***************************

    IF EB.SystemTables.getMessage()<> "VAL" THEN
        YPOS.CTA.EXT.TRANSF = 0
*        EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","CTA.EXT.TRANSF",YPOS.CTA.EXT.TRANSF) - Deprecated
        YPOS.RFC.BENEF.SPEI = 0
*        EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","RFC.BENEF.SPEI",YPOS.RFC.BENEF.SPEI) - Deprecated
        applications     = ""
        fields           = ""
        applications<1>  = "FUNDS.TRANSFER"
        fields<1,1>      = "CTA.EXT.TRANSF"
        fields<1,2>      = "RFC.BENEF.SPEI"
        field_Positions  = ""
        EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
        YPOS.CTA.EXT.TRANSF = field_Positions<1,1>
        YPOS.RFC.BENEF.SPEI = field_Positions<1,2>

****************************************************
* FGV  Mar/17/2005
*      Valida que la version no sea la de OFS para no
*      borrar ningun campo
****************************************************
*       IF R.NEW(FT.LOCAL.REF)<1,YPOS.CTA.EXT.TRANSF> THEN
*          R.NEW(FT.LOCAL.REF)<1,YPOS.CTA.EXT.TRANSF> = ""
*          R.NEW(FT.LOCAL.REF)<1,YPOS.RFC.BENEF.SPEI> = ""
*          R.NEW(FT.PAYMENT.DETAILS) = ""
*       END
        IF (EB.SystemTables.getPgmVersion()<> ",SPEI.T.T.OFS") AND (EB.SystemTables.getPgmVersion()<> ",VPM.2FX.OFS.SPEI") AND (EB.SystemTables.getPgmVersion()<> ",VPM.2BR.OFS.SPEI.DISP") THEN
            IF EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,YPOS.CTA.EXT.TRANSF> THEN
                tmp=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                tmp<1,YPOS.CTA.EXT.TRANSF>=""
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, tmp)
;*-------
                tmp=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                tmp<1,YPOS.RFC.BENEF.SPEI>=""
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, tmp)
;*-------
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, "")
            END
        END
*****************************************************
* FGV  Mar/17/2005
*      Termina Modificacion
*****************************************************
    END

* PIF - CEHV - 22 MAY 2004
* ESTE BLOQUE SE UTILIZA PARA CUANDO LA LLAMADA DE ESTA RUTINA SE HACE
* DESDE EL VALIDATION.FLD DE LA VERSION FT,SPEUA Y SIRVE PARA HACER UNA
* SEGUNDA VALIDACION, LA CUAL SE EJECUTA SOLO SI LA VERSION CORRESPONDE
* A UNA VERSION DE CALL CENTER
    IF EB.SystemTables.getApplication() EQ "FUNDS.TRANSFER" AND EB.SystemTables.getPgmVersion()[1,8] EQ ",VPM.CC." THEN
        ABC.BP.vpmCcCheckCustnoDr()
        IF EB.SystemTables.getE() THEN EB.SystemTables.setComi("")
    END

    ABC.BP.vFtGicDbAcct()
    ABC.BP.vpmVFtToday()
RETURN

