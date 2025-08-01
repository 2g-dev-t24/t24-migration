* @ValidationCode : MjoxMjI0NDA0MTMzOkNwMTI1MjoxNzUzOTMxODk1MjE2Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Jul 2025 00:18:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcTeller

SUBROUTINE ABC.VAL.AMT.USD.OPERA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING EB.OverrideProcessing

    $USING TT.Contract
    $USING ST.CurrencyConfig
    $USING EB.Versions
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
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
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB GET.GENERAL.PARAM
    
    R.CURRENCY = ST.CurrencyConfig.Currency.Read(Y.ID.MONEDA, ERR.CURRENCY)

    IF R.CURRENCY THEN
        Y.VALOR.USD = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurBuyRate><1,Y.MERCADO.DIVISA>
        Y.VALOR.USD.VAL = 1/Y.VALOR.USD
        Y.MONTO.VAL = Y.MONTO*Y.VALOR.USD.VAL

        IF Y.MONTO.VAL GE Y.VALOR.MAX.USD THEN
            EB.SystemTables.setRVersion(EB.Versions.Version.VerNoOfAuth, "1")
            TEXT="La transaccion excede el monto de " :Y.VALOR.MAX.USD:" ":Y.ID.MONEDA:", la operacion requiere autorizacion del gerente, subgerente o director de sucursal."
            EB.SystemTables.setText(TEXT)
            EB.OverrideProcessing.StoreOverride(1)
        END
    END

RETURN
*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------
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
END