*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.GET.BEN.RFC.SPEI
*---------------------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcTable
    $USING AbcSpei
    $USING EB.Updates
    $USING EB.Display

    GOSUB INIT

    Y.COMI = EB.SystemTables.getComi()

    IF Y.COMI = "" THEN
        Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.LOCAL.REF<1,Y.POS.RFC.BEN> = ""
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, "")
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
        EB.Display.RebuildScreen()
        RETURN
    END


    GOSUB PROCESS

    RETURN
***************************
INIT:
***************************
    APP.NAME = "FUNDS.TRANSFER"
    FIELD.NAME = "RFC.BENEF.SPEI"
    FIELD.POS = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    Y.POS.RFC.BEN        = FIELD.POS<1,1>

    Y.CTA.BEN = EB.SystemTables.getComi()

    F.BAN.INT = ""
    FN.BAN.INT = "F.ABC.CUENTAS.DESTINO"
    EB.DataAccess.Opf(FN.BAN.INT, F.BAN.INT)

    F.ACC = ""
    FN.ACC = "F.ACCOUNT"
    EB.DataAccess.Opf(FN.ACC, F.ACC)

    RETURN

PROCESS:

*La validacion solo se manda llamar cuando son cuentas CLABE
    IF LEN(Y.CTA.BEN) EQ 18 THEN
        AbcSpei.AbcValidaCccSpei()
    END

    Y.ACC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

    REC.ACC = ""
    EB.DataAccess.FRead(FN.ACC, Y.ACC, REC.ACC, F.ACC, Y.ERR.ACC)

    Y.CTE = REC.ACC<AC.AccountOpening.Account.Customer>
    Y.ID.BAN.INT = Y.CTE:'.':Y.CTA.BEN
    EB.DataAccess.FRead(FN.BAN.INT, Y.ID.BAN.INT, REC.BAN.INT, F.BAN.INT, Y.ERR.PARAM)
    IF REC.BAN.INT THEN
        Y.STATUS = REC.BAN.INT<AbcTable.AbcCuentasDestino.Status>
        IF Y.STATUS EQ 'ACTIVA' THEN
            Y.NOM.BEN = REC.BAN.INT<AbcTable.AbcCuentasDestino.Beneficiario>
            Y.RFC.BEN = REC.BAN.INT<AbcTable.AbcCuentasDestino.Rfc>
        END ELSE
            EB.SystemTables.setEtext('La Cuenta Destino esta Inactiva')
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END ELSE
        REC.BAN.INT = ""
        Y.NOM.BEN = ""
        Y.RFC.BEN = ""
        EB.SystemTables.setEtext('El Cliente no tiene Cuentas Destino Activas')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LOCAL.REF<1,Y.POS.RFC.BEN> = Y.RFC.BEN
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.NOM.BEN)
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)

    EB.Display.RebuildScreen()

    RETURN

END
