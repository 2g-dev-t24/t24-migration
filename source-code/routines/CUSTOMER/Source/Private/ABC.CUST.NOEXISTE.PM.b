$PACKAGE ABC.BP

SUBROUTINE ABC.CUST.NOEXISTE.PM
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Display

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

	Y.MENSAJE = ""
	Y.EXISTE.ERROR = 0
	R.CUSTOMER = ""

    RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.NUM.CUSTOMER = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.CUSTOMER, Y.NUM.CUSTOMER, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)

    IF R.CUSTOMER EQ "" THEN
		Y.EXISTE.ERROR = 1
		Y.MENSAJE = "CLIENTE " : Y.NUM.CUSTOMER : " NO EXISTE, USE OPCION DE ALTA PBS"
	END ELSE
		Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
	    		    
	    IF Y.SECTOR EQ 1001 THEN
	    	Y.EXISTE.ERROR = 1
	    	Y.MENSAJE = "UTILICE LA OPCION DE MANTENIMIENTO PARA PERSONA FISICA PARA EL CLIENTE " : Y.NUM.CUSTOMER
	    END
	    
	    IF Y.SECTOR EQ 1100 THEN
	    	Y.EXISTE.ERROR = 1
	    	Y.MENSAJE = "UTILICE LA OPCION DE MANTENIMIENTO PARA PERSONA FISICA CON ACTIVIDAD EMPRESARIAL PARA EL CLIENTE " : Y.NUM.CUSTOMER
	    END
	END

	IF Y.EXISTE.ERROR EQ 1 THEN
        EB.SystemTables.setEtext(Y.MENSAJE)
        EB.SystemTables.setE(Y.MENSAJE)
        EB.ErrorProcessing.StoreEndError()
	END

    EB.Display.RebuildScreen()

    RETURN
END