* @ValidationCode : MjotMTM0MDU2MTY2ODpDcDEyNTI6MTc0ODg3NDI1MDg0MDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jun 2025 11:24:10
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

$PACKAGE AbcSpei
SUBROUTINE ABC.VALIDA.AUT.SPEI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING FT.Contract
    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.ErrorProcessing
***************************
*VARIABLES USADAS
***************************

    NOM.CAMPOS     = 'CTA.BENEF.SPEUA':@VM:'CTA.EXT.TRANSF'
    POS.CAMP.LOCAL = ""
    
    
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)

    YPOS.CTA.BENEF.SPEUA     = POS.CAMP.LOCAL<1,1>
    YPOS.CTA.EXT.TRANSF      = POS.CAMP.LOCAL<1,2>
    


    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.CTA.EXT.TRANSF = Y.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF>
    Y.CTA.BENEF.SPEUA = Y.LOCAL.REF<1,YPOS.CTA.BENEF.SPEUA>

    IF (Y.CTA.EXT.TRANSF = "") AND (Y.CTA.BENEF.SPEUA = "") THEN
*AF = FT.LOCAL.REF ; AV = YPOS.CTA.EXT.TRANSF
        ETEXT = "Debe capturar una cuenta beneficiaria"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF (Y.CTA.EXT.TRANSF = "") AND (Y.CTA.BENEF.SPEUA = "") THEN
*AF = FT.LOCAL.REF ; AV = YPOS.CTA.EXT.TRANSF
        ETEXT = "Solo debe capturar una cuenta"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN
END
