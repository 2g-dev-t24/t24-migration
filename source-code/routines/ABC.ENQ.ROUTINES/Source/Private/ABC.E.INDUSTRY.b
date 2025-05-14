$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
SUBROUTINE ABC.E.INDUSTRY(ENQ.PARAM)

    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.DataAccess

    LREF.POS = ""
    EB.Updates.MultiGetLocRef('CUSTOMER', 'L.SECTOR.ECO', LREF.POS)
    Y.POS.SECTOR.ECO = LREF.POS<1,1>

    Y.CAMPOS.LOCALES = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.EDO = Y.CAMPOS.LOCALES<1,Y.POS.SECTOR.ECO>  
    
    IF LEN(Y.EDO) < 4 THEN
        Y.EDO = STR("0",4-LEN(Y.EDO)):Y.EDO
    END

    Y.EDO = Y.EDO[1,2]

    ENQ.PARAM<2,1> = 'ID.ALFA'
    ENQ.PARAM<3,1> = 'LK'
    ENQ.PARAM<4,1,1> = Y.EDO:'...'

    RETURN

END
