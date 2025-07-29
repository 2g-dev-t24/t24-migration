*-----------------------------------------------------------------------------
* <Rating>584</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.CHK.LIMAMT

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING AC.AccountOpening
    $USING LI.Config
    $USING FT.Contract
    $USING TT.Config
    $USING TT.Contract
    $USING EB.OverrideProcessing

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*****
INIT:
*****

    FN.ACCOUNT = "F.ACCOUNT"
    FV.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT,FV.ACCOUNT)
    FN.LIMIT = 'F.LIMIT'
    FV.LIMIT = ''
    EB.DataAccess.Opf(FN.LIMIT,FV.LIMIT)
    FN.TELLER = 'F.TELLER'
    FV.TELLER = ''
    EB.DataAccess.Opf(FN.TELLER,FV.TELLER)
    FN.TELLER.TRANS = 'F.TELLER.TRANSACTION'
    FV.TELLER.TRANS = ''
    EB.DataAccess.Opf(FN.TELLER.TRANS,FV.TELLER.TRANS)
    ACCOUNT.ID = ''
    ST.FLAG = ''

    RETURN
********
PROCESS:
********

    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        TRANS.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeNetAmount)
        TRANS.CODE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
        TRANS.IND = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker)
        IF TRANS.IND EQ 'CREDIT' THEN
            IF NUM(EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
            END
        END
        IF TRANS.IND EQ 'DEBIT' THEN
            IF NUM(EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
            END
        END
    END

    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        TRANS.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        ACCOUNT.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    END

    IF ACCOUNT.ID NE '' THEN
        EB.DataAccess.FRead(FN.ACCOUNT,ACCOUNT.ID,ACCOUNT.REC,FV.ACCOUNT,ACC.ERR)
        LIMIT.REFERENCE = ACCOUNT.REC<AC.AccountOpening.Account.LimitRef>
        AC.WRK.BAL.START.OF.TOD = ACCOUNT.REC<AC.AccountOpening.Account.ValueDatedBal>
        IF AC.WRK.BAL.START.OF.TOD = '' THEN AC.WRK.BAL.START.OF.TOD = 0
        LOCATE EB.SystemTables.getToday() IN ACCOUNT.REC<AC.AccountOpening.Account.AvailableDate,1> SETTING TOD.POS THEN
            TOD.AVAIL.BAL = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthCrMvmt,TOD.POS> + AC.WRK.BAL.START.OF.TOD
            SUM.OF.DEBIT.TRANS.TOD = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthDbMvmt,TOD.POS> + ACCOUNT.REC<AC.AccountOpening.Account.AvNauDbMvmt,TOD.POS>
            DIFF.IN.ACBAL = TOD.AVAIL.BAL + SUM.OF.DEBIT.TRANS.TOD
        END
        IF LIMIT.REFERENCE NE '' AND DIFF.IN.ACBAL < 0 THEN
            CUSTOMER.ID = ACCOUNT.REC<AC.AccountOpening.Account.Customer>
            LIM.REF.VAR = FIELD(LIMIT.REFERENCE,".",1)
            LIM.REF.SEQ = FIELD(LIMIT.REFERENCE,".",2)
            LIMIT.REF.VAR1 = FMT(LIM.REF.VAR,"7'0'R")
            LIMIT.ID = CUSTOMER.ID:".":LIMIT.REF.VAR1:".":LIM.REF.SEQ
            EB.DataAccess.FRead(FN.LIMIT,LIMIT.ID,LIMIT.REC,FV.LIMIT,LIMIT.ERR)
            IF LIMIT.REC<LI.Config.LiExpiryDate> GE EB.SystemTables.getToday() THEN
                AVAIL.AMT = LIMIT.REC<LI.Config.Limit.OnlineLimit,1>
                IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne)
                END ELSE
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
                END
                IF TRANS.AMT GT AVAIL.AMT THEN
                    ETEXT = 'TRANSACTION AMOUNT GREATER THAN THE AVAILABLE AMOUNT'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END ELSE
                AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
                IF TRANS.AMT GT AVAIL.AMT AND ST.FLAG EQ '' THEN
                    TEXT = "CUENTA NO TIENE SALDO SUFICIENTE"
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),VM) + 1
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    TEXT = "CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA"
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),VM) + 1
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),VM) + 1
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    ST.FLAG = 'Y'
                    RETURN
                END
            END

        END ELSE
            AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
            IF DIFF.IN.ACBAL LT 0 AND ST.FLAG EQ '' THEN
                TEXT = "EXCESS AMOUNT"
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),VM) + 1
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                TEXT = "CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA"
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),VM) + 1
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),VM) + 1
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                ST.FLAG = 'Y'
                RETURN
            END
        END
    END

    RETURN
**********
END

