$PACKAGE ABC.BP
SUBROUTINE ABC.E.FIND.CUST(ENQ.PARAM)

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports

    DEFFUN System.getVariable()
    Y.ID.CUS = System.getVariable('CURRENT.ID.CUS')
    ENQ.PARAM<2,1> = "ID.CUSTOMER"
    ENQ.PARAM<3,1> = "EQ"
    ENQ.PARAM<4,1,1> = Y.ID.CUS
    EB.Display.RebuildScreen()

RETURN
END