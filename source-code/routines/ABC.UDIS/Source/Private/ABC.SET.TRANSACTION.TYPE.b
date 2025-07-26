* @ValidationCode : MjotOTI5NzY1NDY1OkNwMTI1MjoxNzUzNTY1MTc1MzY2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Jul 2025 18:26:15
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
SUBROUTINE ABC.SET.TRANSACTION.TYPE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING FT.Contract
    $USING EB.SystemTables
    $USING TT.Contract
    $USING AA.ActivityHook
    
    Y.PGM = EB.SystemTables.getApplication()
    
    IF (Y.PGM EQ 'FT') THEN
    
        Y.TRANSACTION.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
    
    END ELSE
        IF (Y.PGM EQ 'TT') THEN
            
            Y.TRANSACTION.TYPE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
        END
        
    END
    DEFFUN System.setVariable()
    System.setVariable('TRANSACTION.TYPE',Y.TRANSACTION.TYPE)
    
    
END
