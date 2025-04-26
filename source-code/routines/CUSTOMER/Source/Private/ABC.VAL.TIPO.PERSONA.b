$PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.TIPO.PERSONA
*===============================================================================
* Nombre de Programa : ABC.VAL.TIPO.PERSONA
* Objetivo           : ID RTN para validar que el registro de CUSTOMER sea de
*                      persona fisica o fisica con actividad empresarial
* Desarrollador      : 
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Display
    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

*   CALL GET.LOC.REF("CUSTOMER", "CLASSIFICATION", POS.CLASSIFICATION)

    Y.TIPO.PERSONA = ''

    Y.NUM.CUSTOMER = EB.SystemTables.getComi()
    Y.MENSAJE = ""
    Y.EXISTE.ERROR = 0
    Y.CLASSIFICATION = ""
    R.CUSTOMER = ""

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

    EB.DataAccess.FRead(FN.CUSTOMER, Y.NUM.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUST.ERR)
    IF R.CUSTOMER EQ "" THEN
        Y.EXISTE.ERROR = 1
        Y.MENSAJE = " USE OPCION DE ALTA "
    END ELSE

*        Y.CLASSIFICATION = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.CLASSIFICATION>
        Y.CLASSIFICATION = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
        IF (Y.CLASSIFICATION NE 1) AND (Y.CLASSIFICATION NE 2) THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "SOLO PERSONA FISICA Y PERSONA FISICA CON ACTIVIDAD EMPRESARIAL"
        END
    END

    IF Y.EXISTE.ERROR EQ 1 THEN
        ETEXT = Y.MENSAJE
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    EB.Display.RebuildScreen()
*    CALL REFRESH.GUI.OBJECTS

    RETURN
