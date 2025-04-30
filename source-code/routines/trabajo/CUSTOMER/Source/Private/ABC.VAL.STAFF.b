*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.STAFF
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING ABC.BP
	
    GOSUB PROCESS
	EB.Display.RebuildScreen()
RETURN

********
PROCESS:
********
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "EMPLEADO.ABC"
    ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
