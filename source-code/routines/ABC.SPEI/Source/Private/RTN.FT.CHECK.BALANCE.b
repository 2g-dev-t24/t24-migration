* @ValidationCode : MjotMTEyNTUyODUyOkNwMTI1MjoxNzQ5NDM0NzgyNDE2Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jun 2025 23:06:22
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
$PACKAGE AbcSpei

SUBROUTINE RTN.FT.CHECK.BALANCE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    
    $USING AbcSpei
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.TXN.AMT = ''
    Y.ACCOUNT = ''
    Y.AVAIL.BAL = ''
    YPOS.LOCKED.AMT = ''
    YACCT.LOCKED.AMT = ''

*    FN.ACCOUNT = "F.ACCOUNT"
*    F.ACCOUNT  = ""
*    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    Y.TXN.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)

    Y.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

    R.ACCOUNT = ''
    Y.FERROR = ''
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ACCOUNT, Y.AC.ERR)
   
    IF R.ACCOUNT EQ '' THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
        EB.SystemTables.setEtext("La cuenta de cargo no existe")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    

*Si la cuenta de cargo es cuenta interna, no validamos el saldo
    IF Y.ACCOUNT[1,3] MATCHES "MXN":@VM:"USD" THEN RETURN

    Y.AVAIL.BAL = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    IF Y.AVAIL.BAL LE 0 THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
        EB.SystemTables.setEtext("51|Saldo Insuficiente|")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    AbcSpei.AbcMontoBloqueado(Y.ACCOUNT,YACCT.LOCKED.AMT)
    Y.AVAIL.BAL = Y.AVAIL.BAL - YACCT.LOCKED.AMT

    IF Y.AVAIL.BAL LT Y.TXN.AMT THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
        EB.SystemTables.setEtext("51|Saldo Insuficiente|")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    AbcSpei.AbcValPostRest(Y.ACCOUNT)

RETURN
*-----------------------------------------------------------------------------
END
