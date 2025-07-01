$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
SUBROUTINE ABC.UPD.CUST.STATUS
*-------------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING AA.Framework

    GOSUB INICIO
    GOSUB OPEN.FILES
    GOSUB PROCESA

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    Y.ID.CUSTOMER = EB.SystemTables.getRNew(AA.Framework.ArrangementActivity.ArrActCustomer)
    Y.ERR.CUSTOMER = ''
    Y.ERR.CUSTOMER.NAU = ''
    Y.STATUS = ''
    R.CUSTOMER = ''
    R.CUSTOMER.NAU = ''
RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.CUSTOMER.NAU = 'F.CUSTOMER$NAU'
    F.CUSTOMER.NAU  = ''
    EB.DataAccess.Opf(FN.CUSTOMER.NAU, F.CUSTOMER.NAU)
RETURN

*-----------------------------------------------------------------------------
PROCESA:
*-----------------------------------------------------------------------------

    EB.DataAccess.FRead(FN.CUSTOMER.NAU, Y.ID.CUSTOMER, R.CUSTOMER.NAU, F.CUSTOMER.NAU, Y.ERR.CUSTOMER.NAU)
    IF R.CUSTOMER.NAU EQ '' THEN

        EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
        IF Y.ERR.CUSTOMER EQ '' THEN
            Y.STATUS = R.CUSTOMER<ST.Customer.Customer.EbCusCustomerStatus>
            IF Y.STATUS NE "1" THEN
                R.CUSTOMER<ST.Customer.Customer.EbCusCustomerStatus> = "1"
                EB.DataAccess.FLiveWrite(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER)
            END
        END ELSE
            ETEXT = 'No se puede actualizar el cliente'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END ELSE
        ETEXT = 'El cliente tiene cambio o autorizacion pendiente por aplicar'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN

END 