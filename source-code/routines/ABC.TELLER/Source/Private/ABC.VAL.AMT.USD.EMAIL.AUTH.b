$PACKAGE AbcTeller

SUBROUTINE ABC.VAL.AMT.USD.EMAIL.AUTH(Y.FLAG)
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.CurrencyConfig
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINAL
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.MONTO = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    Y.ID.GEN.PARAM = 'LIMITE.MONTO.USD'
    Y.LIST.PARAMS  = ''
    Y.LIST.VALUES  = ''
    Y.POS.PARAM    = ''
    Y.VALOR.MAX.USD = ''
    Y.ID.MONEDA = ''
    R.CURRENCY = ''
    ERR.CURRENCY = ''
    Y.MONTO.VAL = ''
    Y.VALOR.USD = ''
    Y.MERCADO.DIVISA = ''
    Y.VALOR.USD.VAL = ''
    Y.FLAG = ''
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    EB.DataAccess.Opf(FN.CURRENCY, F.CURRENCY)
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB GET.GENERAL.PARAM
    EB.DataAccess.FRead(FN.CURRENCY, Y.ID.MONEDA, R.CURRENCY, F.CURRENCY, ERR.CURRENCY)
    IF R.CURRENCY NE '' THEN
        Y.VALOR.USD = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurBuyRate><1,Y.MERCADO.DIVISA>
        Y.VALOR.USD.VAL = 1/Y.VALOR.USD
        Y.MONTO.VAL = Y.MONTO*Y.VALOR.USD.VAL
        IF Y.MONTO.VAL GE Y.VALOR.MAX.USD THEN
            Y.FLAG = 1
        END ELSE
            Y.FLAG = ''
        END
    END
RETURN
*-----------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-----------------------------------------------------------------------------
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    LOCATE 'ID.MONEDA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ID.MONEDA = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'VALOR.MAX.USD' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.VALOR.MAX.USD = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'MERCADO.DIVISA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.MERCADO.DIVISA = Y.LIST.VALUES<Y.POS.PARAM>
    END
RETURN
*-----------------------------------------------------------------------------
FINAL:

RETURN
END 