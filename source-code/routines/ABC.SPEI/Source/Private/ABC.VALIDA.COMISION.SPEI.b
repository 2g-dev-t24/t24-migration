$PACKAGE AbcSpei

SUBROUTINE ABC.VALIDA.COMISION.SPEI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AbcTable
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Updates

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------
    NOM.CAMPOS     = 'CTA.BENEF.SPEUA':@VM:'CTA.EXT.TRANSF'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)
    YPOS.CTA.BENEF.SPEUA = POS.CAMP.LOCAL<1,1>
    YPOS.CTA.EXT.TRANSF = POS.CAMP.LOCAL<1,2>
    FN.ABC.PARAMETROS.SPEI = "F.ABC.PARAMETROS.SPEI"
    F.ABC.PARAMETROS.SPEI = ""
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.SPEI, F.ABC.PARAMETROS.SPEI)
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.MESSAGE = EB.SystemTables.getMessage()
    Y.COMI = EB.SystemTables.getComi()
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.DEBIT.AMOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.DEBIT.ACCT.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.DEBIT.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
    EB.DataAccess.FRead(FN.ABC.PARAMETROS.SPEI, "SYSTEM", R.ABC.PARAMETROS.SPEI, F.ABC.PARAMETROS.SPEI, Y.ERR.PARAM)
    IF R.ABC.PARAMETROS.SPEI THEN
        YCONST.TXN.TYPE.TRANSF = R.ABC.PARAMETROS.SPEI<AbcTable.AbcParametrosSpei.TxnTipoMen>
        YCONST.TXN.TYPE.SPEUA = R.ABC.PARAMETROS.SPEI<AbcTable.AbcParametrosSpei.TxnTipoEnv>
        YMONTO.MINIMO = R.ABC.PARAMETROS.SPEI<AbcTable.AbcParametrosSpei.SpeiMontoMin>
    END
    YCONST.FT.COMMISSION.TYPE.SPEUA = "FTSPEI"
    YCONST.FT.COMMISSION.TYPE.MENOR = "FTMENOR"
    IF Y.PGM.VERSION NE ",BAM.SPEI.T.T.TESO" THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CommissionType, YCONST.FT.COMMISSION.TYPE.SPEUA)
    END
    IF Y.MESSAGE NE "VAL" THEN
        IF Y.COMI NE "" THEN
            IF (Y.DEBIT.AMOUNT EQ "") OR (Y.DEBIT.AMOUNT EQ 0) THEN
                V.ERROR.MSG = "Debe primero capturar el monto"
                EB.SystemTables.setComi("")
                EB.SystemTables.setE(V.ERROR.MSG)
                EB.ErrorProcessing.Err()
                RETURN
            END ELSE
                GOSUB VALIDATE.BALANCE
            END
        END
    END ELSE
        GOSUB VALIDATE.BALANCE
    END
    RETURN

*---------------------------------------------------------------
VALIDATE.BALANCE:
*---------------------------------------------------------------
    GOSUB CALCULATE.COMMISSION
    GOSUB GET.AVAILABLE.BALANCE
    IF Y.AVAILABLE.BALANCE < Y.MONTO.TOTAL THEN
        V.ERROR.MSG = "...Saldo insuficiente: "
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAmount, "")
        EB.SystemTables.setE(V.ERROR.MSG)
        EB.ErrorProcessing.Err()
        RETURN
    END
    RETURN

*---------------------------------------------------------------
CALCULATE.COMMISSION:
*---------------------------------------------------------------

    Y.ACCOUNT = Y.DEBIT.ACCT.NO
    Y.MONTO.SPEI = Y.DEBIT.AMOUNT
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, YF.ERROR)
    Y.FT.COMMISSION.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CommissionType)
    IF NOT(Y.FT.COMMISSION.TYPE) THEN
        Y.MONTO.TOTAL = Y.MONTO.SPEI
        RETURN
    END
    Y.SPEI.CURRENCY = Y.DEBIT.CURRENCY
    Y.TXN.CCY.MKT = 2
    Y.CUST.NO   = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    T.DATA      = Y.FT.COMMISSION.TYPE
    T.DATA<2>   = "COM"
    Y.CUST.COND = ""
    ETEXT       = ""
    * Aquí deberías llamar a la función migrada de cálculo de comisión, por ejemplo:
    * AbcSpei.AbcCalculateCharge(Y.CUST.NO, Y.MONTO.SPEI, Y.SPEI.CURRENCY, Y.TXN.CCY.MKT, T.DATA, Y.CUST.COND, ETEXT)
    * Simulación de resultado:
    Y.COMMISSION.AMT = 0
    Y.TAX.AMT = 0
    Y.MONTO.TOTAL = Y.MONTO.SPEI + Y.COMMISSION.AMT + Y.TAX.AMT
    RETURN

*---------------------------------------------------------------
GET.AVAILABLE.BALANCE:
*---------------------------------------------------------------

    IF NOT(R.ACCOUNT) THEN
        Y.AVAILABLE.BALANCE = 0
        RETURN
    END
    Y.AVAILABLE.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    RETURN

END