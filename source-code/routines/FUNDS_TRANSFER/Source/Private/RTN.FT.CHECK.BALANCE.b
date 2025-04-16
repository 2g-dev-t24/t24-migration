* @ValidationCode : MjoxNTYwNDYyOTIyOkNwMTI1MjoxNzQ0MDY5MjY0NjY0OlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2025 18:41:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>94</Rating>
*-----------------------------------------------------------------------------

SUBROUTINE RTN.FT.CHECK.BALANCE

*-----------------------------------------------------------------------------

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_F.ACCOUNT
*    $INSERT ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING ABC.BP

    Y.TXN.AMT = ''
    Y.ACCOUNT = ''
    Y.AVAIL.BAL = ''
    YPOS.LOCKED.AMT = ''
    YACCT.LOCKED.AMT = ''

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

*Y.TXN.AMT = R.NEW(FT.DEBIT.AMOUNT)
    Y.TXN.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)

*Y.ACCOUNT = R.NEW(FT.DEBIT.ACCT.NO)
    Y.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    R.ACCOUNT = ''
    Y.FERROR = ''

*READ R.ACCOUNT FROM F.ACCOUNT,Y.ACCOUNT THEN
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ACCOUNT, Y.FERROR)
    
    IF R.ACCOUNT EQ '' THEN
*AF = FT.DEBIT.ACCT.NO
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
        
*ETEXT = "La cuenta de cargo no existe"
        EB.SystemTables.setEtext("La cuenta de cargo no existe")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    IF R.ACCOUNT NE '' THEN
*Si la cuenta de cargo es cuenta interna, no validamos el saldo
        IF Y.ACCOUNT[1,3] MATCHES "MXN":@VM:"USD" THEN RETURN
        Y.AVAIL.BAL = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
        IF Y.AVAIL.BAL LE 0 THEN
*AF = FT.DEBIT.AMOUNTS
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
*ETEXT = "51|Saldo Insuficiente|"
            EB.SystemTables.setEtext("51|Saldo Insuficiente|")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

*        YPOS.LOCKED.AMT = DCOUNT(R.ACCOUNT<AC.LOCKED.AMOUNT>,VM)

*        IF YPOS.LOCKED.AMT GT 0 THEN
*            YACCT.LOCKED.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,YPOS.LOCKED.AMT>
*        END ELSE
*            YACCT.LOCKED.AMT = 0
*        END
*CALL ABC.MONTO.BLOQUEADO(Y.ACCOUNT,YACCT.LOCKED.AMT)
        ABC.BP.abcMontoBloqueado(Y.ACCOUNT, YACCT.LOCKED.AMT)
        Y.AVAIL.BAL = Y.AVAIL.BAL - YACCT.LOCKED.AMT

        IF Y.AVAIL.BAL LT Y.TXN.AMT THEN
*AF = FT.DEBIT.AMOUNT
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
*ETEXT = "51|Saldo Insuficiente|"
            EB.SystemTables.setEtext("51|Saldo Insuficiente|")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
*CALL ABC.VAL.POST.REST(Y.ACCOUNT)
        ABC.BP.abcValPostRest(Y.ACCOUNT)
    END

RETURN
**********
END

