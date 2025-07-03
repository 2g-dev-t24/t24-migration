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
    
	Y.INPUTTER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusInputter)
	Y.INPUTTER = FIELD(Y.INPUTTER, '_', 2)
    Y.USER.ID  = EB.SystemTables.getOperator()

    IF Y.INPUTTER EQ Y.USER.ID THEN
        ETEXT = 'Usuario autorizador igual a usuario de ingreso'
        EB.SystemTables.setE(ETEXT)
    END
RETURN
END
