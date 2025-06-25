*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.INPUTTER.DIST
*----------------------------------------------------------------
* Descripcion  : Rutina que valida que el usuario que ingreso no sea
* igual al actual
*----------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer

    FN.CUSTOMER = 'F.CUSTOMER$NAU'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)   

    Y.CUSTOMER.ID = EB.SystemTables.getComi()

    EB.DataAccess.FRead(FN.CUSTOMER, Y.CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)
    
	Y.INPUTTER = R.CUSTOMER<ST.Customer.Customer.EbCusInputter>
	Y.INPUTTER = FIELD(Y.INPUTTER, '_', 2)
    Y.USER.ID  = EB.SystemTables.getOperator()

    IF Y.INPUTTER EQ Y.USER.ID THEN
        ETEXT = 'Usuario autorizador igual a usuario de ingreso'
        EB.SystemTables.setE(ETEXT)
    END
RETURN
END
