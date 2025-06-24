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

    Y.USER.ID = EB.SystemTables.getOperator()
    Y.INPUTTER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusInputter)
    
    IF Y.INPUTTER MATCHES '...': Y.USER.ID : '...' THEN
        ETEXT = "Usuario Autorizador es igual a usuario de ingreso"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
END
