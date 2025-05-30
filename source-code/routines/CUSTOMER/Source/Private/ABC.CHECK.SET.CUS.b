$PACKAGE ABC.BP
SUBROUTINE ABC.CHECK.SET.CUS
*-----------------------------------------------------------------------------

    $USING EB.SystemTables

    Y.ID.NEW = EB.SystemTables.getIdNew()
    DEFFUN System.setVariable()	
	System.setVariable('CURRENT.ID.CUS',Y.ID.NEW)	

    RETURN
END