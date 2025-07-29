*-----------------------------------------------------------------------------
* <Rating>-29</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE VPM.2BR.V.CCY.TELLER.SBC

*-----------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING AbcTable

    GOSUB INITIALISE
    GOSUB PROCESS

    RETURN
********
PROCESS:
********

    IF EB.SystemTables.getMessage() NE 'VAL' THEN
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)
        RETURN
    END

    YTXN.CDE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
    YTXN.CDE = YTXN.CDE[1,6]
    IF NOT(EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)) AND EB.SystemTables.getMessage() EQ 'VAL' THEN
        TEXT = "DEBE INGRESAR EL IMPORTE"
        EB.Display.Rem();
*        CALL TRANSACTION.ABORT
        EB.SystemTables.setMessage("RET")
        RETURN
    END

    IF (YACCOUNT.CCY NE EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)) AND (YTXN.CDE NE "MASTER") THEN
        ETEXT = "Moneda cta y cheque diferentes"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF EB.SystemTables.getComi() EQ "MXN" THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTransactionCode,YTXN.MXN)
    END ELSE
        EB.SystemTables.setRNew(TT.Contract.Teller.TeCurrMarketOne,"1")
    END
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)
    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyTwo, tmp)

    CALL REBUILD.SCREEN

    RETURN
***********
INITIALISE:
***********

    FN.ABC.PARAMETROS.BANXICO  = "F.ABC.PARAMETROS.BANXICO "
    F.ABC.PARAMETROS.BANXICO   = ""
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.BANXICO ,F.ABC.PARAMETROS.BANXICO )

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT   = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    YREC.ABC.PARAMETROS.BANXICO  = ""
    YF.ERR = ""
    EB.DataAccess.FRead(FN.ABC.PARAMETROS.BANXICO , "SYSTEM", YREC.ABC.PARAMETROS.BANXICO , F.ABC.PARAMETROS.BANXICO , YF.ERR)

    IF YREC.ABC.PARAMETROS.BANXICO  EQ "" THEN
        ETEXT = "Error al leer parametros banxico"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        YTXN.MXN = YREC.ABC.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.TtTxnDepMxn>
        YTXN.USD = YREC.ABC.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.TtTxnDepUsd>
    END

    YREC.ACCOUNT = ""
    YF.ERR = ""

    YACCOUNT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
    EB.DataAccess.FRead(FN.ACCOUNT, YACCOUNT, YREC.ACCOUNT, F.ACCOUNT, YF.ERR)

    YACCOUNT.CCY = YREC.ACCOUNT<AC.AccountOpening.Account.Currency>

    RETURN
**********
END




