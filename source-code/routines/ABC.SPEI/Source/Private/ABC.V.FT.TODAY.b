$PACKAGE AbcSpei
SUBROUTINE ABC.V.FT.TODAY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING FT.Contract

    Y.TODAY = EB.SystemTables.getToday()

    Y.DEBIT.VALUE.DATE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)
    IF LEN(Y.DEBIT.VALUE.DATE) EQ 0 THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitValueDate, Y.TODAY)
    END

    Y.CREDIT.VALUE.DATE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)
    IF LEN(Y.CREDIT.VALUE.DATE) EQ 0 THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditValueDate, Y.TODAY)
    END

    RETURN

END 