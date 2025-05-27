* @ValidationCode : MjoxNjY1MTcwNjE1OkNwMTI1MjoxNzQ4MzA5OTYxNzQ1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 May 2025 22:39:21
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

$PACKAGE ABC.BP
SUBROUTINE ABC.CAL.CAP.CONT
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING MXBASE.CustomerRegulatory



    Y.TOT.ACT = EB.SystemTables.getRNew(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalAssets)
    Y.TOT.PAS = EB.SystemTables.getRNew(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalLiability)

    IF Y.TOT.ACT EQ '' OR NOT(NUM(Y.TOT.ACT)) THEN Y.TOT.ACT = 0
    IF Y.TOT.PAS EQ '' OR NOT(NUM(Y.TOT.PAS)) THEN Y.TOT.PAS = 0

    Y.CAP.CONT = Y.TOT.ACT - Y.TOT.PAS
    EB.SystemTables.setRNew(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.StockHolderEquity, Y.CAP.CONT)

RETURN
END