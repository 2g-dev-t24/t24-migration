$PACKAGE AbcAssign
SUBROUTINE ABC.ASSIGN.DAO.CUST
*----------------------------------------------------

    $USING EB.DataAccess
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.Security
    $USING EB.Display
*------------------------------
* Main Program Loop
*------------------------------

    FN.USER = 'F.USER'
    F.USER = ''

    EB.DataAccess.Opf(FN.USER, F.USER)

* El campo para el DAO en CUSTOMER lo voy a llenar con el campo del DAO del registro del USER
    Y.USER.ID = EB.SystemTables.getOperator()
    EB.DataAccess.FRead(FN.USER, Y.USER.ID, R.USER, F.USER, Y.ERR.USER)
    Y.DEPART.MENT.CODE = R.USER<EB.Security.User.UseDepartmentCode>
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusAccountOfficer, Y.DEPART.MENT.CODE)
    EB.Display.RebuildScreen()
 RETURN
    
END
