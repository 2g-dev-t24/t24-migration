$PACKAGE AbcSpei
SUBROUTINE ABC.FT.GIC.DB.ACCT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB PROCESS
    RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() EQ 'VAL' THEN RETURN

    Y.ACCOUNT = EB.SystemTables.getComi()
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ACCOUNT, Y.ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        Y.COMI = Y.CUSTOMER
        Y.NOMBRE = ''
        AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.OrderingCust, Y.NOMBRE)
        EB.Display.RebuildScreen()
    END
    RETURN

END 