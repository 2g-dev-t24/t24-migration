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
    $USING EB.Security
    $USING EB.Display
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING ABC.BP
    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

***********
INITIALIZE:
***********
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

*    Y.NUM.CUSTOMER = EB.SystemTables.getComi()
    Y.NUM.CUSTOMER = EB.SystemTables.getIdNew()
    Y.MENSAJE = ""
    Y.EXISTE.ERROR = 0
    Y.SECTOR = ""
    R.CUSTOMER = ""

    RETURN

*********
PROCESS:
*********
    EB.DataAccess.FRead(FN.CUSTOMER, Y.NUM.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUST.ERR)

    IF R.CUSTOMER EQ "" THEN
        Y.EXISTE.ERROR = 1
        Y.MENSAJE = " USE OPCION DE ALTA "
    END ELSE
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>


        IF Y.SECTOR NE '1300' THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "LA PERSONA INGRESADA NO ES COTITULAR, UTILICE LA OPCION CORRECTA"
        END
    END

    IF Y.EXISTE.ERROR EQ 1 THEN
        ETEXT = Y.MENSAJE
        E = ETEXT
        EB.SystemTables.setEtext(E)
        EB.ErrorProcessing.StoreEndError()
    END

    EB.Display.RebuildScreen()
 

    RETURN

END
