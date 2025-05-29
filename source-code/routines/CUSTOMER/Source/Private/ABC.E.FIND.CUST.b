$PACKAGE ABC.BP
SUBROUTINE ABC.E.FIND.CUST(ENQ.PARAM)

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer
    
    Y.ID.CUS = EB.SystemTables.getIdNew()

    ENQ.PARAM<2,1> = "ID.CUSTOMER"
    ENQ.PARAM<3,1> = "EQ"
    ENQ.PARAM<4,1,1> = Y.ID.CUS

RETURN
END