$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.CUST.NOEXISTE.COT
*------------------------------------------------------------------------------------
* DESCRIPCION: Valida que el cliente exista y que sea cotitular
* FECHA:       
* AUTOR:      
*
*------------------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display

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

    RETURN

*********
PROCESS:
*********

    R.CUSTOMER = ST.Customer.Customer.Read(Y.NUM.CUSTOMER,Y.ERROR)

    IF R.CUSTOMER EQ "" THEN
        Y.EXISTE.ERROR = 1
        Y.MENSAJE = " USE OPCION DE ALTA "
    END ELSE
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>


        IF Y.SECTOR GE "1300" AND Y.SECTOR LE "1304" THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "LA PERSONA INGRESADA NO ES COTITULAR, UTILICE LA OPCION CORRECTA"
        END
    END

    IF Y.EXISTE.ERROR EQ 1 THEN
 
        EB.SystemTables.setE(Y.MENSAJE)
        EB.ErrorProcessing.Err()
    END

    EB.Display.RebuildScreen()
 

    RETURN

END
