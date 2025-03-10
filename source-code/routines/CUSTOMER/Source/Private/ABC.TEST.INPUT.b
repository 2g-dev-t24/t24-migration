  $PACKAGE ABC.BP 
    SUBROUTINE ABC.TEST.INPUT

    $USING EB.ErrorProcessing
    $USING EB.SystemTables



    EB.SystemTables.setEtext("PRUEBA INPUT ROUTINE VERSION")
    EB.ErrorProcessing.StoreEndError()
		
	RETURN

END
