*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.CUST.YAEXISTE
*================================================================================================================
* Rutina que VALIDA SI YA EXISTE UN CLIENTE
* May 20, 2015 , 01:54:50 PM
*================================================================================================================

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

***********
INITIALIZE:
***********
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
RETURN

*********
PROCESS:
*********
	Y.NUM.CUSTOMER = EB.SystemTables.getComi()

	R.CUSTOMER = ""
    R.CUSTOMER = ST.Customer.Customer.Read(Y.NUM.CUSTOMER,CUST.ERR)
	
	IF R.CUSTOMER NE "" THEN
        Y.ERROR = "CLIENTE " : Y.NUM.CUSTOMER : " YA EXISTE, USE OPCION DE ACTUALIZACION "
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
	END
    CALL REBUILD.SCREEN
    CALL REFRESH.GUI.OBJECTS
RETURN
END
