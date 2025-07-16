* @ValidationCode : MjotNDA5MTUxOTIxOkNwMTI1MjoxNzUyNjk1OTY0MDY2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jul 2025 16:59:24
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

    activity.status = AA.Framework.getC_aalocactivitystatus()
    
    IF (activity.status EQ 'AUTH') THEN
        GOSUB CARGAR.CAMPOS
        GOSUB NIVEL.UDIS
    
        IF (Y.CODIGO EQ '') THEN
       
            GOSUB OBTENER.LIMITE
            GOSUB VALIDA.ACUMULA.LIMITE
        
        END
    
    END

RETURN


***********************
CARGAR.CAMPOS:
***********************
        
    FN.ABC.UDIS.CONCAT = "F.ABC.UDIS.CONCAT"
    F.ABC.UDIS.CONCAT  = ""
    EB.DataAccess.Opf(FN.ABC.UDIS.CONCAT,F.ABC.UDIS.CONCAT)
        
    
    R.ARR = AA.Framework.getRArrangementActivity()
    
    Y.NUMERO.CUENTA.AA     = R.ARR<AA.Framework.ArrangementActivity.ArrActArrangement>
    
    
    R.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.NUMERO.CUENTA.AA, Error)
    
    IF (Error) THEN
        
        ETEXT = Error:'ACCOUNT': '-->':Y.NUMERO.CUENTA.AA
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
        
    END
    
    Y.NUMERO.CUENTA = R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedApplId>
    
    R.ACCOUNT           = AC.AccountOpening.Account.Read(Y.NUMERO.CUENTA, Error)
    
    IF (Error) THEN
        
        ETEXT = Error:'ACCOUNT': '-->':Y.NUMERO.CUENTA
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
        
    END
    
    Y.ACCOUNT.CATEGORY  = R.ACCOUNT<AC.AccountOpening.Account.Category>
    
    Y.MONTO.LCY     = R.ARR<AA.Framework.ArrangementActivity.ArrActTxnAmountLcy>
        
*  GOSUB OBTENER.TRANSACTION.CODE
    

    
RETURN

**********************
OBTENER.TRANSACTION.CODE:
**********************

    Y.TXN.CONTRACT.ID = R.ARR<AA.Framework.ArrangementActivity.ArrActTxnContractId>
    
    Y.TXN.CONTRACT.ID = FIELDS(Y.TXN.CONTRACT.ID,"\", 1)
    
    Y.TXN.SYSTEM.ID = R.ARR<AA.Framework.ArrangementActivity.ArrActTxnSystemId>
    
    Y.MONEDA            = R.ARR<AA.Framework.ArrangementActivity.ArrActCurrency>
    
    Y.PROCESS.DATE      = R.ARR<AA.Framework.ArrangementActivity.ArrActOrgSystemDate>
    
    IF (Y.TXN.SYSTEM.ID EQ 'FT') THEN
    
        R.FT = FT.Contract.FundsTransfer.CacheRead(RecId, Error)
        
        IF (Error) THEN
        
            ETEXT = Error:'FT --> ':Y.TXN.CONTRACT.ID:'  --->  ':R.ARR
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        
        END
        Y.TRANSACTION.CODE  = R.FT<FT.Contract.FundsTransfer.TransactionType>
    
    END ELSE
    
        R.TT = TT.Contract.Teller.Read(RecId, Error)
        IF (Error) THEN
        
            ETEXT = Error:'TT'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        
        END
        Y.TRANSACTION.CODE  = R.TT<TT.Contract.Teller.TeTransactionCode>
        
    END
    
RETURN





**********************
NIVEL.UDIS:
**********************

    Y.REGISTRO.LIMITE = AbcTable.AbcNivelCuenta.Read(Y.ACCOUNT.CATEGORY, Error)
    Y.LIMITE.MENSUAL.PERMITIDO =  Y.REGISTRO.LIMITE<AbcTable.AbcNivelCuenta.Limite>
    Y.LISTA.DE.CODIGOS = Y.REGISTRO.LIMITE<AbcTable.AbcNivelCuenta.TransaccionCr>
    
    
    LOCATE Y.TRANSACTION.CODE IN Y.LISTA.DE.CODIGOS SETTING Y.POS.CODE ELSE
    END

    Y.CODIGO = Y.LISTA.DE.CODIGOS<Y.POS.CODE>
    
    ETEXT = '//Y.ACCOUNT.CATEGORY -->':Y.ACCOUNT.CATEGORY:'//Y.CODIGO -->':Y.LIMITE.MENSUAL.PERMITIDO
    EB.SystemTables.setEtext(ETEXT)
    EB.ErrorProcessing.StoreEndError()

    
RETURN

**********************
OBTENER.LIMITE:
**********************
    R.CURRENCY = ST.CurrencyConfig.Currency.Read(Y.MONEDA, Error)
    
    Y.TASA = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
    
    Y.MONTO.UDIS = Y.MONTO.LCY / Y.TASA
    
    
    
RETURN

**********************
VALIDA.ACUMULA.LIMITE:
**********************

    Y.ID.UDI.CONCAT = Y.NUMERO.CUENTA:'.':Y.PROCESS.DATE[1,6]
    
    R.UDIS.CONCAT = AbcTable.AbcUdisConcat.Read(Y.ID.UDI.CONCAT, Error)
    
      
    IF (Y.LIMITE.MENSUAL.PERMITIDO LE Y.MONTO.UDIS) THEN
        
        GOSUB ACUMULAR.LIMITES
        
    END ELSE
                
        Y.MONTO.EX = Y.MONTO.UDIS - Y.LIMITE.MENSUAL.PERMITIDO
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
        
        IF (Y.LIMITE.MENSUAL.PERMITIDO LE Y.MONTO.UDIS.ACTUAL) THEN
            
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
