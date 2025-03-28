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

         Y.POS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)
*        Y.POS<1,2> = ""
         Y.POS = ""
         EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId,Y.POS)

    END 
        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusTaxId)
        tmp<3>=""
        EB.SystemTables.setT(ST.Customer.Customer.EbCusTaxId, tmp)
    
    RETURN
END
