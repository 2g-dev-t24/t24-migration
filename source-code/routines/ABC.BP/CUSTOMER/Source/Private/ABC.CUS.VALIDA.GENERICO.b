*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*   Fecha: Mayo 2015
*   Autor: Omar Basabe.
*
*-----------------------------------------------------------------------------
 $PACKAGE ABC.BP   
    SUBROUTINE ABC.CUS.VALIDA.GENERICO

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
	
    GOSUB PROCESS
	CALL REBUILD.SCREEN
RETURN

****************
PROCESS:
****************
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "GENERICO"
	CALL ABC.CUST.VALIDA.TODO(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
