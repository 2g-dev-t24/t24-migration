*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
 $PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.CUS.RELCODE(Y.RELCODE)
    
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
    IF Y.RELCODE EQ 8 OR Y.RELCODE EQ "" THEN
    	EB.SystemTables.setRNew(ST.Customer.Customer.EbCusRelCustomer, '')
        
        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusRelCustomer)
        tmp<3>="NOINPUT"
    END ELSE
        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusRelCustomer)
        tmp<3>="NOINPUT"
    END
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusRelationCode, '')
RETURN
END
