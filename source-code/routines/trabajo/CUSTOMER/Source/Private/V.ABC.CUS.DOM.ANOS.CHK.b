*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*   Fecha: Mayo 2015
*   Autor: Omar Basabe.
*
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE V.ABC.CUS.DOM.ANOS.CHK

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
	$USING EB.Display

    GOSUB PROCESS
	EB.Display.RebuildScreen()
RETURN

********
PROCESS:
********
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "NUM.ANIOS"
	ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
