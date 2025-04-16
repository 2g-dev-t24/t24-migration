* @ValidationCode : Mjo0MDQ1Mzc1MTpDcDEyNTI6MTc0NDQxNjY2ODE4ODpVc2lhcmlvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 19:11:08
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
.
*-----------------------------------------------------------------------------
* <Rating>584</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE VPM.2BR.CHK.LIMAMT
*===============================================================================
*CARGADA A VERSIONES:
*-------------------------------------------------------------------------------
*FUNDS.TRANSFER,ABC.DISPERSION.EXPRESS.MASIVO
*FUNDS.TRANSFER,DOMICILIACION.DIGITAL
*FUNDS.TRANSFER,VPM.CC
*FUNDS.TRANSFER,VPM.CC.ESPECIAL
*FUNDS.TRANSFER,ABC.TRASPASO.CASHIN
*FUNDS.TRANSFER,ABC.ABONO.CRED
*FUNDS.TRANSFER,ABC.LIQUIDA.ACCIONES
*FUNDS.TRANSFER,BE.FT.CTAS.INTERNAS.ABANK
*FUNDS.TRANSFER,ABC.TRAS.SERVICIOS.OTROS
*FUNDS.TRANSFER,TRASPASO.RECURRENTE
*FUNDS.TRANSFER,ABC.BONIFICA.MKT
*FUNDS.TRANSFER,ABC.FT.CTAS.INT.AUT.BE
*FUNDS.TRANSFER,ABC.REMANENTE.VIVIENDA
*FUNDS.TRANSFER,ABC.APL.ABONOS
*FUNDS.TRANSFER,ABC.FT.CTAS.INT.BE
*FUNDS.TRANSFER,DISPERSION.DIGITAL
*FUNDS.TRANSFER,ABC.DISPERSION.MASIVO
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.DIGITAL
*FUNDS.TRANSFER,VPM.2BR.CONC.MOD.IAL
*FUNDS.TRANSFER,BE.FT.CTAS.INTERNAS
*FUNDS.TRANSFER,ABC.COMPRA.ACCIONES
*FUNDS.TRANSFER,ABC.TRASPASO.BENEFICIOS
*FUNDS.TRANSFER,ABC.TRASPASO.PRN
*FUNDS.TRANSFER,ABC.PAGO.TDC
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN
*FUNDS.TRANSFER,VPM.CC.SINCAJA
*FUNDS.TRANSFER,BONIFICACION.CASH.IN
*FUNDS.TRANSFER,ABC.REMESAS
*FUNDS.TRANSFER,ABC.TRASPASO.SERVICIOS
*FUNDS.TRANSFER,ABC.BONIFICACION
*FUNDS.TRANSFER,ABC.TRASPASO.DIGITAL
*FUNDS.TRANSFER,ABC.PAGO.TDC.2
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN.2
*===============================================================================
*-----------------------------------------------------------------------------

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.LIMIT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ../T24_BP I_F.TELLER.TRANSACTION
*    $INCLUDE ../T24_BP I_F.TELLER

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.OverrideProcessing
    $USING AC.Config
    $USING LI.Config
    $USING EB.Updates
    $USING EB.ErrorProcessing

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

    Y.APPLICATION = EB.SystemTables.getApplication()
    IF Y.APPLICATION EQ 'TELLER' THEN
        TRANS.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeNetAmount) ;*R.NEW(TT.TE.NET.AMOUNT)
        TRANS.CODE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode) ;*R.NEW(TT.TE.TRANSACTION.CODE)
        TRANS.IND = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker) ;*R.NEW(TT.TE.DR.CR.MARKER)
        IF TRANS.IND EQ 'CREDIT' THEN
*IF NUM(R.NEW(TT.TE.ACCOUNT.2)) THEN
            IF NUM(EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo) ;*R.NEW(TT.TE.ACCOUNT.2)
            END
        END
        IF TRANS.IND EQ 'DEBIT' THEN
*IF NUM(R.NEW(TT.TE.ACCOUNT.1)) THEN
            IF NUM(EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne) ;*R.NEW(TT.TE.ACCOUNT.1)
            END
        END
    END

    IF Y.APPLICATION EQ 'FUNDS.TRANSFER' THEN
        TRANS.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount) ;*R.NEW(FT.DEBIT.AMOUNT)
        ACCOUNT.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo) ;*R.NEW(FT.DEBIT.ACCT.NO)
    END

    IF ACCOUNT.ID NE '' THEN
        Y.TODAY = EB.SystemTables.getToday()
        ACCOUNT.REC = AC.AccountOpening.Account.Read(ACCOUNT.ID, ACC.ERR)
* Before incorporation : CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,ACCOUNT.REC,FV.ACCOUNT,ACC.ERR)
        LIMIT.REFERENCE = ACCOUNT.REC<AC.AccountOpening.Account.LimitRef> ;*<AC.LIMIT.REF>
        AC.WRK.BAL.START.OF.TOD = ACCOUNT.REC<AC.AccountOpening.Account.OpenValDatedBal> ;*<AC.OPEN.VAL.DATED.BAL>
        IF AC.WRK.BAL.START.OF.TOD = '' THEN AC.WRK.BAL.START.OF.TOD = 0
*LOCATE TODAY IN ACCOUNT.REC<AC.AVAILABLE.DATE,1> SETTING TOD.POS THEN
        LOCATE Y.TODAY IN ACCOUNT.REC<AC.AccountOpening.Account.AvailableDate,1> SETTING TOD.POS THEN
*TOD.AVAIL.BAL = ACCOUNT.REC<AC.AV.AUTH.CR.MVMT,TOD.POS> + AC.WRK.BAL.START.OF.TOD
            TOD.AVAIL.BAL = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthCrMvmt , TOD.POS> + AC.WRK.BAL.START.OF.TOD
*            SUM.OF.DEBIT.TRANS.TOD = ACCOUNT.REC<AC.AV.AUTH.DB.MVMT,TOD.POS> + ACCOUNT.REC<AC.AV.NAU.DB.MVMT,TOD.POS>
            SUM.OF.DEBIT.TRANS.TOD = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthDbMvmt,TOD.POS> + ACCOUNT.REC<AC.AccountOpening.Account.AvNauDbMvmt,TOD.POS>
            DIFF.IN.ACBAL = TOD.AVAIL.BAL + SUM.OF.DEBIT.TRANS.TOD
        END
        IF LIMIT.REFERENCE NE '' AND DIFF.IN.ACBAL < 0 THEN
            CUSTOMER.ID = ACCOUNT.REC<AC.AccountOpening.Account.Customer> ;*<AC.CUSTOMER>
            LIM.REF.VAR = FIELD(LIMIT.REFERENCE,".",1)
            LIM.REF.SEQ = FIELD(LIMIT.REFERENCE,".",2)
            LIMIT.REF.VAR1 = FMT(LIM.REF.VAR,"7'0'R")
            LIMIT.ID = CUSTOMER.ID:".":LIMIT.REF.VAR1:".":LIM.REF.SEQ
            EB.DataAccess.FRead(FN.LIMIT,LIMIT.ID,LIMIT.REC,FV.LIMIT,LIMIT.ERR)
*IF LIMIT.REC<LI.EXPIRY.DATE> GE Y.TODAY THEN
            IF LIMIT.REC<LI.Config.Limit.ExpiryDate> GE Y.TODAY THEN
                AVAIL.AMT = LIMIT.REC<LI.Config.Limit.OnlineLimit,1> ;*<LI.ONLINE.LIMIT,1>
                IF Y.APPLICATION EQ 'TELLER' THEN
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne) ;*AF = TT.TE.ACCOUNT.1
                END ELSE
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount) ;*AF = FT.DEBIT.AMOUNT
                END
                IF TRANS.AMT > AVAIL.AMT THEN
                    EB.SystemTables.setEtext('TRANSACTION AMOUNT GREATER THAN THE AVAILABLE AMOUNT') ;*ETEXT = 'TRANSACTION AMOUNT GREATER THAN THE AVAILABLE AMOUNT'
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END ELSE
                AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance> ;*<AC.WORKING.BALANCE>
                IF TRANS.AMT > AVAIL.AMT AND ST.FLAG = '' THEN
                    EB.SystemTables.setText("CUENTA NO TIENE SALDO SUFICIENTE") ;*TEXT = "CUENTA NO TIENE SALDO SUFICIENTE"
*CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
*CALL STORE.OVERRIDE(CURR.NO)
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    EB.SystemTables.setText("CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA") ;*TEXT = "CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA"
*CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
*CALL STORE.OVERRIDE(CURR.NO)
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    EB.SystemTables.setText("TRANSACCION REQUIERE AUTORIZACION ESPECIAL") ;*TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
*CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
*CALL STORE.OVERRIDE(CURR.NO)
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    ST.FLAG = 'Y'
                    RETURN
                END
            END

        END ELSE
            AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance> ;*<AC.WORKING.BALANCE>
            IF DIFF.IN.ACBAL < 0 AND ST.FLAG = '' THEN
*                TEXT = "CUENTA NO TIENE SALDO SUFICIENTE"
                EB.SystemTables.setText("EXCESS AMOUNT") ;*TEXT = "EXCESS AMOUNT"
*CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
*CALL STORE.OVERRIDE(CURR.NO)
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                EB.SystemTables.setText("CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA") ;*TEXT = "CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA"
*CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
*CALL STORE.OVERRIDE(CURR.NO)
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                EB.SystemTables.setText("TRANSACCION REQUIERE AUTORIZACION ESPECIAL") ;*TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
*CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
*CALL STORE.OVERRIDE(CURR.NO)
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                ST.FLAG = 'Y'
                RETURN
            END
        END
    END

RETURN
**********
END

