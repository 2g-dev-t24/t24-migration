*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.HABILITA.OTRA.VIVIENDA(Y.VALOR)
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Display


    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusResidenceType,'')  

    IF Y.VALOR EQ 6 OR Y.VALOR EQ "OTRA" THEN
    	tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusResidenceType)
        tmp<3>=""
        EB.SystemTables.setT(ST.Customer.Customer.EbCusResidenceType, tmp)
    END ELSE

    	IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusResidenceType) NE "" THEN    
    		EB.SystemTables.setRNew(ST.Customer.Customer.EbCusResidenceType,'') 
    	END ELSE
       
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusResidenceType,'NO APLICA')
    		
    	END
    	
        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusResidenceType)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(ST.Customer.Customer.EbCusResidenceType, tmp)
    END
*    EB.Display.RebuildScreen()
*    CALL REFRESH.GUI.OBJECTS
RETURN
END
