$PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.FMT.CURP.CLIENTE
*===============================================================================
* Nombre de Programa : ABC.VAL.FMT.CURP.CLIENTE
* Objetivo           : 
*                      
* Desarrollador      : 
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences

    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

*    CALL GET.LOC.REF("CUSTOMER", "CLASSIFICATION", POS.CLASSIFICATION)

    Y.TIPO.PERSONA = ''
    Y.CURP.CLIENTE = ''


    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

*    Y.TIPO.PERSONA = R.NEW(EB.CUS.LOCAL.REF)<1, POS.CLASSIFICATION>
    Y.TIPO.PERSONA = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    Y.CURP.CLIENTE = EB.SystemTables.getComi()

    IF Y.CURP.CLIENTE NE '' THEN

        ABC.BP.AbcValidaRfcCurp('', Y.CURP.CLIENTE, Y.TIPO.PERSONA, Y.ERR)
        IF Y.ERR NE '' THEN
*            AF = EB.CUS.EXTERN.CUS.ID ; AV = 1; AS = 0
*            E = Y.ERR
*            CALL ERR
             ETEXT= "EB.CUS.EXTERN.CUS.ID"
             EB.SystemTables.setEtext(ETEXT)
             EB.ErrorProcessing.StoreEndError()
        END
    END

    RETURN
