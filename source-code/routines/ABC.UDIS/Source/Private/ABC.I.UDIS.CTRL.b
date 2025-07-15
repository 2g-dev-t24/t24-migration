* @ValidationCode : MjotMTI5NjEyOTYzMzpDcDEyNTI6MTc1MjQxNjE3MjQ3MjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2025 11:16:12
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


    GOSUB CARGAR.CAMPOS
    GOSUB NIVEL.UDIS
    
    IF (Y.CODIGO NE '') THEN
       
        GOSUB OBTENER.LIMITE
        GOSUB VALIDA.ACUMULA.LIMITE
        
    END
    


RETURN


***********************
CARGAR.CAMPOS:
***********************
        
    FN.ABC.UDIS.CONCAT = "F.ABC.UDIS.CONCAT"
    F.ABC.UDIS.CONCAT  = ""
    EB.DataAccess.Opf(FN.ABC.UDIS.CONCAT,F.ABC.UDIS.CONCAT)
        
        
*    R.ARR = AA.Framework.getC_aalocarrangementrec()
    R.ARR = AA.Framework.getC_aaloctxnreference()
    
    Y.NUMERO.CUENTA     = R.ARR<AA.Framework.ArrangementActivity.ArrActArrangement>

    R.ACCOUNT           = AC.AccountOpening.Account.Read(Y.NUMERO.CUENTA, Error)
    
    Y.ACCOUNT.CATEGORY  = R.ACCOUNT<AC.AccountOpening.Account.Category>
        
* Y.TRANSACTION.CODE  = R.ARR<
    Y.MONTO             = R.ARR<AA.Framework.ArrangementActivity.ArrActOrigTxnAmt>
    Y.MONTO.LCY         = R.ARR<AA.Framework.ArrangementActivity.ArrActTxnAmountLcy>
    Y.PROCESS.DATE      = R.ARR<AA.Framework.ArrangementActivity.ArrActOrgSystemDate>
    Y.MONEDA            = R.ARR<AA.Framework.ArrangementActivity.ArrActCurrency>
    
    
    
RETURN

**********************
NIVEL.UDIS:
**********************

    Y.REGISTRO.LIMITE = AbcTable.AbcNivelCuenta.Read(Y.ACCOUNT.CATEGORY, Error)
    Y.LIMITE.MENSUAL.PERMITIDO =  Y.REGISTRO.LIMITE<AbcTable.AbcNivelCuenta.Limite>
    Y.LISTA.DE.CODIGOS = Y.REGISTRO.LIMITE<AbcTable.AbcNivelCuenta.TransaccionCr>
    
    Y.TRANSACTION.CODE = 0
    LOCATE Y.TRANSACTION.CODE IN Y.LISTA.DE.CODIGOS SETTING Y.POS.CODE ELSE
    END

    Y.CODIGO = Y.LISTA.DE.CODIGOS<Y.POS.CODE>
    
    
    
RETURN

**********************
OBTENER.LIMITE:
**********************
    R.CURRENCY = ST.CurrencyConfig.Currency.Read(Y.MONEDA, Error)
    
    Y.TASA = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
    
    Y.MONTO.UDIS = Y.MONTO / Y.TASA
    
    
    
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
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.DDetalleTxn>   = 'txn.code^':Y.MONTO.UDIS:'^':Y.MONTO
        R.UDIS.CONCAT<AbcTable.AbcUdisConcat.FecUltMov>     = Y.PROCESS.DATE

        EB.DataAccess.FWrite(FN.ABC.UDIS.CONCAT,Y.ID.UDI.CONCAT,R.UDIS.CONCAT)
        
    END ELSE
        
        Y.MONTO.UDIS.ACTUAL = Y.MONTO.UDIS + Y.MONTO.UDIS.CONCAT
        
        IF (Y.LIMITE.MENSUAL.PERMITIDO LE Y.MONTO.UDIS.ACTUAL) THEN
            
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalUdis>     = R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalUdis> + Y.MONTO.UDIS
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalLcy>      = R.UDIS.CONCAT<AbcTable.AbcUdisConcat.TotalLcy> + Y.MONTO.LCY
            R.UDIS.CONCAT<AbcTable.AbcUdisConcat.DDetalleTxn>   = 'txn.code^':Y.MONTO.UDIS:'^':Y.MONTO
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
