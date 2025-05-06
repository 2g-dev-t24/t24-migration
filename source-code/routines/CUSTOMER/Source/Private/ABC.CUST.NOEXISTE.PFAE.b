$PACKAGE ABC.BP
    SUBROUTINE ABC.CUST.NOEXISTE.PFAE
*================================================================================================================
* Rutina que VALIDA SI YA EXISTE UN CLIENTE
* 
*================================================================================================================
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Security
    $USING EB.Display
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING ABC.BP

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

***********
INITIALIZE:
***********

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    Y.NUM.CUSTOMER = EB.SystemTables.getComi()
    Y.MENSAJE = ""
    Y.EXISTE.ERROR = 0
    Y.SECTOR = ""
    R.CUSTOMER = ""

    Y.CLASS.COTI.POS = ""
    EB.LocalReferences.GetLocRef("CUSTOMER","CLASS.COTI",Y.CLASS.COTI.POS)

    RETURN

*********
PROCESS:
*********

    EB.DataAccess.FRead(FN.CUSTOMER, Y.NUM.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUST.ERR)

    IF R.CUSTOMER EQ "" THEN
        Y.EXISTE.ERROR = 1
        Y.MENSAJE = "CLIENTE " : Y.NUM.CUSTOMER : " NO EXISTE, USE OPCION DE ALTA "
    END ELSE
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
        Y.CLASS.COTI = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.CLASS.COTI.POS>

        IF Y.SECTOR GE '1300' AND Y.SECTOR LE '1304' THEN 
          Y.SECTOR = Y.CLASS.COTI
        END
        IF Y.SECTOR EQ '2001' THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "UTILICE LA OPCION DE MANTENIMIENTO PARA PERSONA MORAL PARA EL CLIENTE " : Y.NUM.CUSTOMER
        END

        IF Y.SECTOR EQ '1001' THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "UTILICE LA OPCION DE MANTENIMIENTO PARA PERSONA FISICA PARA EL CLIENTE " : Y.NUM.CUSTOMER
        END
    END

    IF Y.EXISTE.ERROR EQ 1 THEN
        EB.SystemTables.setEtext(Y.MENSAJE)
        EB.SystemTables.setE(EB.SystemTables.getEtext())
        EB.ErrorProcessing.StoreEndError()
    END

    EB.Display.RebuildScreen()

    RETURN

END
