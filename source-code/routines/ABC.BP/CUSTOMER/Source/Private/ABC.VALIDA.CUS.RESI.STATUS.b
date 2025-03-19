*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.CUS.RESI.STATUS
    
    $USING EB.SystemTables
    $USING EB.Display
    $USING ABC.BP

	GOSUB PROCESS
    EB.Display.RebuildScreen()
RETURN

********
PROCESS:
********
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "TIPO.CASA"
	CALL ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
