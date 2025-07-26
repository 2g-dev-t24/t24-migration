* @ValidationCode : Mjo3MzQzOTAxNzpDcDEyNTI6MTc1MzU2OTg1ODgwODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jul 2025 19:44:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcUdis

SUBROUTINE ABC.I.UDIS.CTRL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING TT.Contract
    $USING ST.CurrencyConfig
    $USING AA.Framework
    $USING EB.Interface
    
    GOSUB INITIALIZE
    GOSUB LEER.PARAMETROS
    GOSUB CARGAR.CAMPOS
    GOSUB NIVEL.UDIS
    IF (Y.LIMITE.MENSUAL.PERMITIDO NE '') THEN
        GOSUB OBTENER.LIMITE
        GOSUB VALIDA.ACUMULA.LIMITE
    END

RETURN

***********************
INITIALIZE:
***********************

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
    
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    EB.DataAccess.Opf(FN.TELLER, F.TELLER)

    FN.ABC.UDIS.CONCAT = "F.ABC.UDIS.CONCAT"
    F.ABC.UDIS.CONCAT  = ""
    EB.DataAccess.Opf(FN.ABC.UDIS.CONCAT,F.ABC.UDIS.CONCAT)
    
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    
RETURN
*-----------------------------------------------------------------------------
LEER.PARAMETROS:
*-----------------------------------------------------------------------------

    Y.PARAM.ID = 'ABC.NIVEL.CUENTAS'
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el parámetro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    
RETURN
***********************
CARGAR.CAMPOS:
***********************
        
    APP.GET = EB.SystemTables.getApplication()
    YAPL = FIELD(APP.GET,",",1)
    
    IF (YAPL EQ "FUNDS.TRANSFER") THEN
    
        Y.TRANSACTION.CODE  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
        Y.NUMERO.CUENTA     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
        Y.MONTO.LCY         = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        Y.MONEDA            = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
        Y.PROCESS.DATE      = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ProcessingDate)
    
    END ELSE
        IF (YAPL EQ "TELLER") THEN
            
            Y.TRANSACTION.CODE  = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
            Y.NUMERO.CUENTA     = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
            Y.MONTO.LCY         = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
            Y.MONEDA            = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
            Y.PROCESS.DATE      = EB.SystemTables.getRNew(TT.Contract.Teller.TeValueDateOne)
        END
        
    END
    EB.DataAccess.FRead(FN.ACCOUNT, Y.NUMERO.CUENTA, R.ACCOUNT, F.ACCOUNT, Error)
    
    IF (Error) THEN
        
        ETEXT = Error:'ACCOUNT': '-->':Y.NUMERO.CUENTA
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
        
    END
    
    Y.ACCOUNT.CATEGORY  = R.ACCOUNT<AC.AccountOpening.Account.Category>
    
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
        CHANGE '|' TO @FM IN Y.CATEGORIA
        LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
            Y.NIVEL = Y.PARAM
        END
    NEXT Y.AA

    
RETURN


**********************
NIVEL.UDIS:
**********************

    Y.REGISTRO.LIMITE = AbcTable.AbcNivelCuenta.Read(Y.NIVEL, Error)
    Y.LIMITE.MENSUAL.PERMITIDO =  ''

    Y.LISTA.DE.CODIGOS = Y.REGISTRO.LIMITE<AbcTable.AbcNivelCuenta.TransaccionCr>
    
    IF (Y.LISTA.DE.CODIGOS NE '') THEN
        FINDSTR Y.TRANSACTION.CODE IN Y.LISTA.DE.CODIGOS SETTING Y.POS THEN
            Y.LIMITE.MENSUAL.PERMITIDO =  Y.REGISTRO.LIMITE<AbcTable.AbcNivelCuenta.Limite>
        END
    END
    
RETURN

**********************
OBTENER.LIMITE:
**********************
    
    R.CURRENCY = ST.CurrencyConfig.Currency.Read('UDI', Error)
    
    Y.TASA = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
    
    Y.MONTO.UDIS = Y.MONTO.LCY / Y.TASA
    
RETURN

**********************
VALIDA.ACUMULA.LIMITE:
**********************

    Y.ID.UDI.CONCAT = Y.NUMERO.CUENTA:'.':Y.PROCESS.DATE[1,6]
    
    R.UDIS.CONCAT = AbcTable.AbcUdisConcat.Read(Y.ID.UDI.CONCAT, Error)
    
      
    IF (Y.MONTO.UDIS LE Y.LIMITE.MENSUAL.PERMITIDO) THEN
        
        GOSUB ACUMULAR.LIMITES
        
    END ELSE
                
        Y.MONTO.EX = Y.LIMITE.MENSUAL.PERMITIDO - Y.MONTO.UDIS
        ETEXT = 'el monto excede el limite permitido por un valor de: ':Y.MONTO.EX
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        
        RETURN
        
    END
    
RETURN

**********************
ACUMULAR.LIMITES:
**********************
  
    Y.MONTO.UDIS.CONCAT = R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalUdis>
    
    IF (R.UDIS.CONCAT EQ '') THEN
        
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.Periodo>       = Y.PROCESS.DATE[1,6]
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalUdis>     = Y.MONTO.UDIS
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalLcy>      = Y.MONTO.LCY
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.DDetalleTxn>   = Y.TRANSACTION.CODE:'^':Y.MONTO.UDIS:'^':Y.MONTO.LCY
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.FecUltMov>     = Y.PROCESS.DATE

        EB.DataAccess.FWrite(FN.ABC.UDIS.CONCAT,Y.ID.UDI.CONCAT,R.UDIS.CONCAT)
        
    END ELSE
        
        Y.MONTO.UDIS.ACTUAL = Y.MONTO.UDIS + Y.MONTO.UDIS.CONCAT
        
        IF (Y.MONTO.UDIS.ACTUAL LE Y.LIMITE.MENSUAL.PERMITIDO) THEN
            
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalUdis>     = R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalUdis> + Y.MONTO.UDIS
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalLcy>      = R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalLcy> + Y.MONTO.LCY
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.DDetalleTxn>   = Y.TRANSACTION.CODE:'^':Y.MONTO.UDIS:'^':Y.MONTO.LCY
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.FecUltMov>     = Y.PROCESS.DATE

            EB.DataAccess.FWrite(FN.ABC.UDIS.CONCAT,Y.ID.UDI.CONCAT,R.UDIS.CONCAT)
            
        END ELSE
        
            Y.MONTO.EX = Y.MONTO.UDIS.ACTUAL - Y.LIMITE.MENSUAL.PERMITIDO
            ETEXT = 'el monto excede el limite permitido por un valor de: ':Y.MONTO.EX
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
            

    END


    
RETURN


END
