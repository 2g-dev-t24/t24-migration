*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.NIVEL.LIM.MONTO.AUT
*===============================================================================
*===============================================================================
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    
    $USING AbcTable
    $USING AbcSpei

    GOSUB INICIALIZA
    GOSUB APERTURA.FILES
    GOSUB VALIDA.FUNCTION

    RETURN

*-----------------------------------------------------------------------------
INICIALIZA:
*-----------------------------------------------------------------------------

    Y.CUENTA.CR = ''
    Y.CUENTA.DR = ''
    Y.CUENTA = ''
    Y.MONTO.TRANS = 0
    Y.TRANS.TYPE = ''
    Y.NIVEL.CR = ''
    R.ACCOUNT = ''
    YERR.ACCOUNT = ''
    R.NIVEL = ''
    YERR.NIVEL = ''
    Y.CLIENTE = ''
    Y.ID.LIMITE = ''
    Y.FEC.LIMITE = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R")

    RETURN
*-----------------------------------------------------------------------------
APERTURA.FILES:
*-----------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    EB.DataAccess.Opf(FN.FT.NAU, F.FT.NAU)

    FN.ABC.NIVEL.CUENTA = 'F.ABC.NIVEL.CUENTA'
    F.ABC.NIVEL.CUENTA = ''
    EB.DataAccess.Opf(FN.ABC.NIVEL.CUENTA,F.ABC.NIVEL.CUENTA)

    FN.ABC.MOVS.CTA.NIVEL2 = 'F.ABC.MOVS.CTA.NIVEL2'
    F.ABC.MOVS.CTA.NIVEL2 = ''
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.NIVEL2,F.ABC.MOVS.CTA.NIVEL2)

    NOM.CAMPOS     = 'NIVEL'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef('ACCOUNT',NOM.CAMPOS,POS.CAMP.LOCAL)

    YPOS.NIVEL = POS.CAMP.LOCAL<1,1>

    RETURN

*-----------------------------------------------------------------------------
VALIDA.FUNCTION:
*-----------------------------------------------------------------------------
    Y.FNCTION = EB.SystemTables.getVFunction()

    BEGIN CASE

    CASE Y.FNCTION EQ "I"
        GOSUB REGISTRA.OPERACION

    CASE Y.FNCTION EQ "D"
        GOSUB BORRA.OPERACION

    CASE Y.FNCTION EQ "A"
        RETURN

    END CASE

    RETURN
*-----------------------------------------------------------------------------
REGISTRA.OPERACION:
*-----------------------------------------------------------------------------

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.CUENTA.DR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    IF Y.MONTO.TRANS EQ '' THEN
        Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    END
    Y.TRANS.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)

    EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.CR,R.ACCOUNT,F.ACCOUNT,YERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CLIENTE = R.ACC.CUS<AC.AccountOpening.Account.Customer>
        Y.NIVEL.CR = R.ACC.CUS<AC.AccountOpening.Account.LocalRef, YPOS.NIVEL>
    END

    EB.DataAccess.FRead(FN.ABC.NIVEL.CUENTA,Y.NIVEL.CR,R.NIVEL,F.ABC.NIVEL.CUENTA,YERR.NIVEL)
    IF R.NIVEL THEN
        Y.MONTO.LIMITE = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite>
        Y.APP = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite.Aplicacion>
        Y.APP = RAISE(Y.APP)

        LOCATE APPLICATION IN Y.APP SETTING YPOS.APP THEN
            Y.TRANS.CR = R.NIVEL<AbcTable.AbcNivelCuenta.TransaccionCr, YPOS.APP>
            CHANGE SM TO FM IN Y.TRANS.CR
            LOCATE Y.TRANS.TYPE IN Y.TRANS.CR SETTING YPOS.TRANS.CR THEN
                Y.ID.LIMITE = Y.CUENTA.CR:"-":Y.FEC.LIMITE
                AbcSpei.AbcValidaLimiteMonto(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,ID.NEW,Y.CLIENTE)
            END
        END
    END

    RETURN
*-----------------------------------------------------------------------------
BORRA.OPERACION:
*-----------------------------------------------------------------------------

    Y.ID.OPERACION = ''
    Y.ID.OPERACION = EB.SystemTables.getIdNew()

    REG.OPERACION = ""
    EB.DataAccess.FRead(FN.FT.NAU, Y.ID.OPERACION, REG.OPERACION, F.FT.NAU, FT.ERR)

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.ID.LIMITE = Y.CUENTA.CR:"-":Y.FEC.LIMITE
    R.MOV.CTA = '' ; Y.LISTA.OPERACIONES = ''

    EB.DataAccess.FRead(FN.ABC.MOVS.CTA.NIVEL2,Y.ID.LIMITE,R.MOV.CTA,F.ABC.MOVS.CTA.NIVEL2,YMOV.CTA)
    Y.LISTA.OPERACIONES = R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.IdOperacion>
    CHANGE VM TO FM IN Y.LISTA.OPERACIONES
    LOCATE Y.ID.OPERACION IN Y.LISTA.OPERACIONES SETTING POS.OPER THEN
        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoTotal> = R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoTotal> - R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoMov, POS.OPER>
        DEL R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.IdOperacion, POS.OPER>
        DEL R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.FechaMov, POS.OPER>
        DEL R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoMov, POS.OPER>
    END

    EB.DataAccess.FWrite(FN.ABC.MOVS.CTA.NIVEL2,Y.ID.LIMITE,R.MOV.CTA) 
    RETURN

END
