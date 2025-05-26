
    $PACKAGE ABC.BP
    SUBROUTINE ABC.ING.SHORT.NAME
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING ST.Customer

    Y.NAME = EB.SystemTables.getComi()
    IF LEN(Y.NAME) GT 35 THEN
        Y.NAME = Y.NAME[1,35]
    END

    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusShortName, Y.NAME)
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusNameOne, Y.NAME)

    RETURN
END