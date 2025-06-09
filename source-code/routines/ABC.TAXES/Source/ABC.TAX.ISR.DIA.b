$PACKAGE AbcTaxes

SUBROUTINE ABC.TAX.ISR.DIA(PASS.CUSTOMER,PASS.DEAL.AMOUNT,PASS.DEAL.CCY,PASS.CCY.MKT,PASS.CROSS.RATE,PASS.CROSS.CCY,PASS.DWN.CCY,PASS.DATA,PASS.CUST.CDN,R.TAX,CHARGE.AMOUNT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING AC.AccountOpening
    $USING CG.ChargeConfig
    $USING AbcGetGeneralParam
    $USING IC.Config
    $USING AC.EntryCreation

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.STMT = 'F.STMT.ENTRY'
    F.STMT = ''
    EB.DataAccess.Opf(FN.STMT, F.STMT)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    EB.DataAccess.Opf(FN.GROUP.CREDIT.INT, F.GROUP.CREDIT.INT)

    V.APP      = 'ACCOUNT'
    V.FLD.NAME = 'EXENTO.IMPUESTO' : @VM
    YPOS.EXENTO.IMPUESTO  = ''

    EB.LocalReferences.GetLocRef(V.APP, V.FLD.NAME, YPOS.EXENTO.IMPUESTO)

    Y.PASS.DATA.ACCT = FIELD(PASS.DATA,FM,38)
    CHARGE.AMOUNT = 0

    TODAY = EB.SystemTables.getToday()
    Y.ID.GEN.PARAM = 'ISR.VALOR.EXENTO.':TODAY[1,4]
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'VALOR' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        ISR.VALOR.EXENTO = Y.LIST.VALUES<YPOS.PARAM>
    END

    RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.FIELD.EXENTO = ''
    YERROR = ''
    Y.REC.ACCT = ''

    EB.DataAccess.FRead(FN.ACCOUNT, Y.PASS.DATA.ACCT, R.ACCOUNT, F.ACCOUNT, YERROR)

    IF NOT(YERROR) THEN
        Y.LOCAL.REF = R.ACCOUNT<AC.AccountOpening.Account.LocalRef>
        Y.FIELD.EXENTO = Y.LOCAL.REF<1, YPOS.EXENTO.IMPUESTO>
        Y.CONDITION.GROUP = R.ACCOUNT<AC.AccountOpening.Account.ConditionGroup>
    END


    Y.SELECT = "SELECT ": FN.GROUP.CREDIT.INT : " WITH @ID LIKE ": Y.CONDITION.GROUP : "MXN... BY-DSND @ID"
    Y.LIST        = "" 
    IVA.GRUPO     = ""
    R.INFO.IVA    = ""
    MNT.IVA.GRUPO = ""
    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)
    IF Y.LIST THEN
        Y.GROUP.CREDIT.INT = Y.LIST<1>
        EB.DataAccess.FRead(FN.GROUP.CREDIT.INT,Y.GROUP.CREDIT.INT,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,Y.ERR.INT)

        IF R.GROUP.CREDIT.INT THEN
            Y.INT.RATE = R.GROUP.CREDIT.INT<IC.Config.GroupCreditInt.GciCrIntRate>
            Y.LIMIT.AMT = R.GROUP.CREDIT.INT<IC.Config.GroupCreditInt.GciCrIntLimitAmt>
            Y.INT.RATE = RAISE(Y.INT.RATE)
            Y.LIMIT.AMT = RAISE(Y.LIMIT.AMT)
            Y.NO.VAL = DCOUNT(Y.INT.RATE,VM)

            Y.INT.RATE.LIMITE = Y.INT.RATE<Y.NO.VAL>
            IF Y.INT.RATE.LIMITE GT 0 THEN
                Y.LIMITE.MONTO = Y.LIMIT.AMT<Y.NO.VAL>
            END ELSE
                Y.POS = Y.NO.VAL - 1
                Y.LIMITE.MONTO = Y.LIMIT.AMT<Y.POS>
            END
        END
    END


    LISTA.STMT = ''
    D.FIELDS = 'ACCOUNT':FM:'BOOKING.DATE'
    D.RANGE.AND.VALUE  = Y.PASS.DATA.ACCT:FM:TODAY
    D.LOGICAL.OPERANDS = '1':FM:'1'
    //TODO : Revisar call enq y como setear los drangeandvalue y demas
    CALL E.STMT.ENQ.BY.CONCAT(LISTA.STMT)
    TOTAL.STMT = ''
    TOTAL.STMT = DCOUNT(LISTA.STMT,FM)
    SALDO.INICIAL = 0
    IF TOTAL.STMT GE 1 THEN
        LINEA.STMT = LISTA.STMT<1>
        SALDO.INICIAL = FIELD(LINEA.STMT,'*',3)
    END


    Y.SALDO = SALDO.INICIAL
    FOR J = 1 TO TOTAL.STMT
        LINEA.STMT = ''
        LINEA.STMT = LISTA.STMT<J>
        ID.STMT = FIELD(LINEA.STMT,'*',2)
        ERROR.STMT = ''
        FECHA.STMT = ''
        IMPORTE.STMT = ''
        EB.DataAccess.FRead(FN.STMT,ID.STMT,R.INFO.STMT,F.STMT,ERROR.STMT)
        IF ERROR.STMT EQ '' THEN
            IMPORTE.STMT = R.INFO.STMT<AC.STE.AMOUNT.LCY>
            Y.SALDO += IMPORTE.STMT
        END
    NEXT J


    IF Y.FIELD.EXENTO EQ 'S' THEN
        CHARGE.AMOUNT = 0
    END ELSE
        GOSUB CALCULATE.ISR.TAX
        IF CHARGE.AMOUNT GE PASS.DEAL.AMOUNT THEN
            CHARGE.AMOUNT = PASS.DEAL.AMOUNT
        END
    END

    RETURN

*---------------------------------------------------------------
CALCULATE.ISR.TAX:
*---------------------------------------------------------------

    IF Y.LIMITE.MONTO EQ '' THEN
        Y.SALDO.CALCULO = Y.SALDO
    END ELSE
        IF Y.SALDO LE Y.LIMITE.MONTO THEN
            Y.SALDO.CALCULO = Y.SALDO
        END ELSE
            Y.SALDO.CALCULO = Y.LIMITE.MONTO
        END
    END

    Y.CURRENCY = R.ACCOUNT<AC.AccountOpening.Account.Currency>
    //TODO : Revisar LCCY si es getLccy o que
    IF Y.CURRENCY = LCCY THEN
        YPOS = ''
        LOCATE LCCY IN R.TAX<CG.ChargeConfig.Tax.EbTaxCurrency,1> SETTING YPOS THEN
            IF NOT(YERROR) THEN
                YTAX.RATE = ''
                Y.TAX.FACTOR = ''
                YTAX.RATE = RAISE(R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate>)
                Y.TAX.FACTOR = YTAX.RATE / 100
                MONTO.INTERES = ''
                YTAX.ISR = 0
                YTAX.ISR = (Y.SALDO.CALCULO * Y.TAX.FACTOR)
                CHARGE.AMOUNT = YTAX.ISR
                //TODO : Revisar call OCOMO
                CALL OCOMO("CUENTA: ":Y.PASS.DATA.ACCT:", Y.SALDO: ":Y.SALDO:", Y.SALDO.CALCULO: ":Y.SALDO.CALCULO:", PASS.DEAL.AMOUNT: ":PASS.DEAL.AMOUNT:", CHARGE.AMOUNT: ":CHARGE.AMOUNT:", Y.LIMITE.MONTO: ":Y.LIMITE.MONTO:", Y.INT.RATE: ":Y.INT.RATE:", Y.LIMIT.AMT: ":Y.LIMIT.AMT)
            END
            ELSE
                CHARGE.AMOUNT = 0
            END
        END
    END

    RETURN
END