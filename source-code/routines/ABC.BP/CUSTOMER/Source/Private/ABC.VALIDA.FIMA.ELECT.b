*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.FIMA.ELECT(Y.TIENE.FIRMA)
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer

    GOSUB PROCESS
    CALL REBUILD.SCREEN
    RETURN

********
PROCESS:
********
    IF Y.TIENE.FIRMA EQ 'NO' THEN
*        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId)<1,2> = ''
         EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId,'')
*        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusTaxId)
*        tmp<3>=""
        T(ST.Customer.Customer.EbCusTaxId)<3> = ""
    END ELSE
*        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusTaxId)
*        tmp<3>=""
        T(ST.Customer.Customer.EbCusTaxId)<3> = ""
    END
    RETURN
END
