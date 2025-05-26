
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