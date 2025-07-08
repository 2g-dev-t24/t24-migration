*-----------------------------------------------------------------------------
* <Rating>-74</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.REGISTRA.OPER.CASHIN
*===============================================================================
*===============================================================================

    $USING EB.SystemTables
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.DataAccess
    $using AC.AccountOpening

    $USING AbcTable

    GOSUB INICIO
    GOSUB LEE.PARAM

    IF Y.BANDERA.DEPO.BONIFICA EQ 'SI' THEN
        GOSUB PROCESO
    END
    GOSUB FINAL

    RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.BONIF.CASHIN = "F.ABC.BONIFICACION.CASH.IN"
    F.BONIF.CASHIN = ""
    EB.DataAccess.Opf(FN.BONIF.CASHIN, F.BONIF.CASHIN)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    NOM.CAMPOS     = 'ID.COMI'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER',NOM.CAMPOS,POS.CAMP.LOCAL)

    Y.POS.ID.COMI = POS.CAMP.LOCAL<1,1>

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)

    Y.ID.COMISIONISTA = ''
    Y.BANDERA.DEPO.BONIFICA = 'SI'
    Y.ID.COMISIONISTA = Y.LOCAL.REF<1,Y.POS.ID.COMI>          

    Y.CTA.CLIENTE = ""
    Y.ID.BONIFICACION = ""
    Y.TOTAL.OPERACIONES = 0
    Y.LIST.OPER.BONIF = ""
    Y.TOTAL.OPE.BONIF = 0
    Y.MONTO.TOTAL = 0
    Y.NUM.OPER.BONIFICAN = 0
    Y.MONTO.A.BONIFICAR = 0
    Y.OPER.SIGUIENTE = 0
    Y.ID.FT.OPER = ""
    Y.MONTO.OPER = ""
    Y.FECHA.OPER = ""

    Y.FECHA.LIMIT = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"), "2'0'R")

    RETURN
*-----------------------------------------------------------------------------
LEE.PARAM:
*-----------------------------------------------------------------------------

    Y.ID.PARAM.CASHIN = "CASHIN.BONIFICACION.PARAM"
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID.PARAM.CASHIN,R.PARAMETROS,F.ABC.GENERAL.PARAM,Y.GRL.ERR)

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''

    Y.LIST.PARAMS = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro>)

    Y.MONTO.MIN = "" ; Y.MONTO.BON = "" ; Y.NUM.OPERACIONES = ""

    LOCATE "MONTO.MIN" IN Y.LIST.PARAMS SETTING POS THEN
        Y.MONTO.MIN = Y.LIST.VALUES<POS>
    END

    LOCATE "MONTO.BON" IN Y.LIST.PARAMS SETTING POS THEN
        Y.MONTO.BON = Y.LIST.VALUES<POS>
    END

    LOCATE "NUM.OPERACIONES" IN Y.LIST.PARAMS SETTING POS THEN
        Y.NUM.OPERACIONES = Y.LIST.VALUES<POS>
    END

    LOCATE 'COMI.NO.BONIFICA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.COMISIONISTAS = Y.LIST.VALUES<Y.POS>
        CHANGE '|' TO VM IN Y.COMISIONISTAS
    END

    IF Y.ID.COMISIONISTA MATCHES Y.COMISIONISTAS THEN
        Y.BANDERA.DEPO.BONIFICA = 'NO'
    END  

    RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    Y.CTA.CLIENTE = EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    GOSUB OBTENER.CLIENTE
    Y.ID.FT.OPER = EB.SystemTables.getIdNew()
    Y.MONTO.OPER = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.FECHA.OPER = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")

    Y.ID.BONIFICACION = Y.CTA.CLIENTE:".":Y.FECHA.LIMIT
    REG.BONIFICACION = ""

    CALL F.READ(FN.BONIF.CASHIN, Y.ID.BONIFICACION, REG.BONIFICACION, F.BONIF.CASHIN, ERR.BONIF)

    IF REG.BONIFICACION NE "" THEN
        Y.TOTAL.OPERACIONES =  REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.NumOperaciones>
        Y.LIST.OPER.BONIF = REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.IdOperacion>
        Y.TOTAL.OPE.BONIF = DCOUNT(Y.LIST.OPER.BONIF, @VM)
        Y.OPER.SIGUIENTE = Y.TOTAL.OPE.BONIF + 1
        IF REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoTotal> NE '' THEN
            Y.MONTO.TOTAL = REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoTotal>
        END
        Y.NUM.OPER.BONIFICAN = REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.NumOperBonifican>
        Y.MONTO.A.BONIFICAR = REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoABonificar>
    END

    IF V$FUNCTION EQ "R" THEN
        CHANGE VM TO FM IN Y.LIST.OPER.BONIF
        Y.MONTO.OPER = Y.MONTO.OPER * -1
        GOSUB OBTEN.DECREMENTO.MONTOS
        Y.TOTAL.OPERACIONES = Y.TOTAL.OPERACIONES- 1
    END ELSE
        GOSUB OBTEN.INCREMENTO.MONTOS
        Y.TOTAL.OPERACIONES = Y.TOTAL.OPERACIONES + 1
    END
    Y.MONTO.TOTAL = Y.MONTO.TOTAL + Y.MONTO.OPER

    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.Customer> = Y.CLIENTE
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.IdOperacion, Y.OPER.SIGUIENTE> = Y.ID.FT.OPER
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoMov, Y.OPER.SIGUIENTE> = Y.MONTO.OPER
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.FechaMov, Y.OPER.SIGUIENTE> = Y.FECHA.OPER
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.NumOperaciones> = Y.TOTAL.OPERACIONES
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoTotal> = Y.MONTO.TOTAL
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.NumOperBonifican> = Y.NUM.OPER.BONIFICAN
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoABonificar> = Y.MONTO.A.BONIFICAR

    EB.DataAccess.FWrite(FN.BONIF.CASHIN,Y.ID.BONIFICACION,REG.BONIFICACION)

    RETURN
*-----------------------------------------------------------------------------
OBTENER.CLIENTE:
*-----------------------------------------------------------------------------

    R.ACCOUNT = ""
    EB.DataAccess.FRead(FN.ACCOUNT, Y.CTA.CLIENTE, R.ACCOUNT, F.ACCOUNT, YERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    END

    RETURN
*-----------------------------------------------------------------------------
OBTEN.INCREMENTO.MONTOS:
*-----------------------------------------------------------------------------

    IF (Y.MONTO.OPER GE Y.MONTO.MIN) AND (Y.NUM.OPER.BONIFICAN LT Y.NUM.OPERACIONES) THEN
        Y.NUM.OPER.BONIFICAN = Y.NUM.OPER.BONIFICAN + 1
        Y.MONTO.A.BONIFICAR = Y.MONTO.A.BONIFICAR + Y.MONTO.BON
    END

    RETURN
*-----------------------------------------------------------------------------
OBTEN.DECREMENTO.MONTOS:
*-----------------------------------------------------------------------------

    IF (ABS(Y.MONTO.OPER) GE Y.MONTO.MIN) AND (Y.NUM.OPER.BONIFICAN GE 1) THEN
        Y.NUM.OPER.BONIFICAN = Y.NUM.OPER.BONIFICAN - 1
        Y.MONTO.A.BONIFICAR = Y.MONTO.A.BONIFICAR - Y.MONTO.BON
    END

    RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


    RETURN

END
*-----------------------------------------------------------------------------
