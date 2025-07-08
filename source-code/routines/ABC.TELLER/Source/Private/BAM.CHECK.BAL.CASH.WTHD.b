* @ValidationCode : MjoxNDAwNzM1ODE4OkNwMTI1MjoxNzUxOTQwMzMzNzQyOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 07 Jul 2025 23:05:33
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

SUBROUTINE BAM.CHECK.BAL.CASH.WTHD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING AbcSpei
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.AVAIL.BAL     = ''
    Y.AMOUNT.LOCKED = ''
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.TXN.AMT = EB.SystemTables.getComi()
    Y.ACCOUNT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
    IF NOT(Y.ACCOUNT) THEN
        ETEXT = "Debe indicar primero la cuenta"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ACCOUNT, Y.FERROR)
    Y.AVAIL.BAL     = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    
    AbcSpei.AbcMontoBloqueado(Y.ACCOUNT,Y.AMOUNT.LOCKED)
    Y.AVAIL.BAL = Y.AVAIL.BAL - Y.AMOUNT.LOCKED

    IF Y.AVAIL.BAL LT Y.TXN.AMT THEN
        ETEXT = "Fondos insuficientes en la cuenta"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
END