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

    EB.LocalReferences.GetLocRef("CUSTOMER","T.VIVIENDA.OTRO",Y.POS)


    Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.LOCAL.REF<1,Y.POS> = ""
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)  
    IF Y.VALOR EQ 6 OR Y.VALOR EQ "OTRA" THEN
    	tmp=EB.SystemTables.getTLocref()
        tmp<Y.POS,7>=""
        EB.SystemTables.setTLocref(tmp)
    END ELSE

    	IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS> NE "" THEN    
    		
            Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.LOCAL.REF<1,Y.POS> = ''
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
    	END ELSE
            Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.LOCAL.REF<1,Y.POS> = 'NO APLICA'
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
    		
    	END
    	
        tmp=EB.SystemTables.getTLocref()
        tmp<Y.POS,7>="NOINPUT"
        EB.SystemTables.setTLocref(tmp)
    END
    EB.Display.RebuildScreen()
    CALL REFRESH.GUI.OBJECTS
RETURN
END
