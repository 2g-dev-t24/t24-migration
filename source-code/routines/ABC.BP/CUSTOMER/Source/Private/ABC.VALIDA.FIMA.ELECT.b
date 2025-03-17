*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.FIMA.ELECT(Y.TIENE.FIRMA)

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
    IF Y.TIENE.FIRMA EQ 'NO' THEN
         EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId,'')
        T(ST.Customer.Customer.EbCusTaxId)<3> = ""
    END ELSE
        T(ST.Customer.Customer.EbCusTaxId)<3> = ""
    END
    RETURN
END
