* @ValidationCode : MjoxMTgzODQ5NzU6Q3AxMjUyOjE3NTIyNDgxNDM3MjQ6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jul 2025 12:35:43
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


    Y.PGM               = EB.SystemTables.getPgmType()
    Y.ACCOUNT.CATEGORY  = AC.AccountOpening.Account.Category

    IF (Y.PGM = 'FUNDS.TRANSFER') THEN
        
        GOSUB CARGAR.CAMPOS.FT
    
    END ELSE
        
        IF (Y.PGM = 'TELLER') THEN
          
            GOSUB CARGAR.CAMPOS.TT
            
        END
    
    END
    
    GOSUB NIVEL.UDIS
    
    IF (Y.CODIGO NE '' )THEN

        GOSUB VALIDAR.LIMITE
        
    END


RETURN


***********************
CARGAR.CAMPOS.FT:
***********************
        
    Y.NUMERO.CUENTA = FT.Contract.FundsTransfer.CreditAcctNo
    Y.TRANSACTION.CODE = FT.Contract.FundsTransfer.TransactionType
    Y.MONTO = FT.Contract.FundsTransfer.CreditAmount
    Y.PROCESS.DATE = FT.Contract.FundsTransfer.ProcessingDate
    
    
RETURN

***********************
CARGAR.CAMPOS.TELLER:
***********************

    Y.NUMERO.CUENTA = TT.Contract.Teller.TeAccountTwo
    Y.TRANSACTION.CODE = TT.Contract.Teller.TeTransactionCode
    Y.MONTO = TT.Contract.Teller.TeAmountFcyTwo
    Y.PROCESS.DATE = TT.Contract.D
    
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
    
    
    
RETURN

**********************
VALIDAR.LIMITE:
**********************
    
    
    
RETURN


END
