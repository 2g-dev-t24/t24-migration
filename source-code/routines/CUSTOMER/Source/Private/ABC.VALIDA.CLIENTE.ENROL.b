$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VALIDA.CLIENTE.ENROL(Y.ID.CUST, Y.ESTATUS)
*===============================================================================
* Nombre de Programa : ABC.VALIDA.CLIENTE.ENROL
* Objetivo           : Rutina para validar que el cliente este enrolado en ABC.BIOMETRICOS
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.LocalReferences

    GOSUB INICIALIZA
    GOSUB VALIDA.CLIENTE
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ABC.BIOMETRICOS = 'F.ABC.BIOMETRICOS'
    F.ABC.BIOMETRICOS   = ''
    EB.DataAccess.Opf(FN.ABC.BIOMETRICOS,F.ABC.BIOMETRICOS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    EB.LocalReferences.GetLocRef('CUSTOMER', 'IUB', POS.IUB)
    EB.LocalReferences.GetLocRef("CUSTOMER", "CLASSIFICATION", POS.CLASSIFICATION)

    Y.IUB.CUS = ''
    REC.CUSTOMER = ''


    RETURN
*---------------------------------------------------------------
VALIDA.CLIENTE:
*---------------------------------------------------------------

    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUST, REC.CUSTOMER, F.CUSTOMER, ERR.CUST)

    IF REC.CUSTOMER THEN
        Y.CLASS.CUST = REC.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, POS.CLASSIFICATION>
    END

    IF (Y.CLASS.CUST EQ 1) OR (Y.CLASS.CUST EQ 2) THEN
        IF REC.CUSTOMER THEN
            Y.IUB.CUS = REC.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, POS.IUB>
            IF Y.IUB.CUS THEN
                EB.DataAccess.FRead(FN.ABC.BIOMETRICOS, Y.IUB.CUS, R.BIO.CUS, F.ABC.BIOMETRICOS, ERR.BIO)
                IF R.BIO.CUS THEN
                    Y.ESTATUS = 'ENCONTRADO'
                    Y.ID.CUST<-1> = Y.IUB.CUS
                END ELSE
                    Y.ESTATUS = 'IUB NO ENCONTRADO EN BIOMETRICOS'
                END
            END ELSE
                Y.ESTATUS = "CLIENTE NO ENROLADO"
            END
        END ELSE
            Y.ESTATUS = "CLIENTE NO ENCONTRADO"
        END
    END

    RETURN

END
