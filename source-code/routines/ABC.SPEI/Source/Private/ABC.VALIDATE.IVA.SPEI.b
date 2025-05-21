* @ValidationCode : MjotMjg0MTI4NjI3OkNwMTI1MjoxNzQ3ODY4MDk5MTMyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 May 2025 19:54:59
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

SUBROUTINE ABC.VALIDATE.IVA.SPEI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.ErrorProcessing


    YIVA.RATE = .15

    YIVA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount) * YIVA.RATE

    Y.COMI = EB.SystemTables.getComi()
    IF Y.COMI >  YIVA THEN
        ETEXT = "Monto de IVA es incorrecto"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

END
