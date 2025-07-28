*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.V.FT.TODAY


    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Security
    $USING FT.Contract

    IF LEN(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)) = 0 THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitValueDate, EB.SystemTables.getToday())
    END

    IF LEN(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)) = 0 THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditValueDate, EB.SystemTables.getToday())
    END

    RETURN

END
