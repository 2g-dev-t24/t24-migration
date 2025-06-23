$PACKAGE AbcSpei

SUBROUTINE ABC.CALL.RTNS.GEN.FT

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING AbcTable
    $USING AbcGetGeneralParam

    GOSUB INICIO
    GOSUB OBTEN.RTNS.PARAM
    GOSUB EJECUTA.RTNS

RETURN

INICIO:

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

    Y.NOMB.VERSION = ""
    Y.CUENTA.DEBIT = ""
    Y.CUENTA.CREDIT = ""
    Y.MONTO.OPERACION = ""
    Y.TRANSAC.TYPE = ""
    Y.EXT.TRANS.ID = ""
    Y.RTNS.EJECUTABLES = ""

RETURN

OBTEN.RTNS.PARAM:

    Y.PARAM.RTNS = 'FT.RTNS.PARAM'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.PARAM.RTNS, Y.LIST.PARAMS, Y.LIST.VALUES)
    Y.RTNS.EJECUTABLES = Y.LIST.VALUES

RETURN

EJECUTA.RTNS:

    Y.ID.FT = EB.SystemTables.getIdNew()
    Y.CUENTA.DEBIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.CUENTA.CREDIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

    Y.RTNS.TOTALES = DCOUNT(Y.RTNS.EJECUTABLES, FM)

    FOR Y.IT.RTN = 1 TO Y.RTNS.TOTALES
        Y.NOMBRE.RTN = Y.LIST.VALUES<Y.IT.RTN>
        
        EB.SystemTables.CallBasicRoutine(Y.NOMBRE.RTN, '', '')
    NEXT Y.IT.RTN

RETURN

FINAL:

RETURN

END 