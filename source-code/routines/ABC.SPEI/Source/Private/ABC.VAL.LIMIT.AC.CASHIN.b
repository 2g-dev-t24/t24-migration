* @ValidationCode : MjotMzgxNTE3NjQyOkNwMTI1MjoxNzUyNzE2OTcyODg2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jul 2025 22:49:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*===============================================================================
* <Rating>-60</Rating>
*===============================================================================
$PACKAGE AbcSpei
SUBROUTINE ABC.VAL.LIMIT.AC.CASHIN
*===============================================================================
*===============================================================================
* Modificaciones:
*===============================================================================

    $USING EB.Updates
    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING ST.CurrencyConfig
    $USING AbcSpei

    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.ADMIN = ''
    Y.ID.COMI  = ''
    Y.ID.ESTAB = ''
    Y.CUENTA.CR = ''
    Y.MONTO.TRANS = ''
    Y.FEC.LIMIT.COMI = ''
    Y.ID.MOVS.AC.COMI = ''

    Y.NOMBRE.APP = ''
    Y.NOMBRE.CAMPO = ''
    R.POS.CAMPO = ''
    Y.NOMBRE.APP = "ACCOUNT":@FM: "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "NIVEL":@FM: "ID.ADMIN":@VM:"ID.COMI":@VM:"ID.ESTAB"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP,Y.NOMBRE.CAMPO,R.POS.CAMPO)

    Y.POS.NIVEL    = R.POS.CAMPO<1,1>
    Y.POS.ID.ADMIN = R.POS.CAMPO<2,1>
    Y.POS.ID.COMI  = R.POS.CAMPO<2,2>
    Y.POS.ID.ESTAB = R.POS.CAMPO<2,3>

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    EB.DataAccess.Opf(FN.CURRENCY, F.CURRENCY)

    FN.ABC.MOVS.CTA.COMISIONISTA = "F.ABC.MOVS.CTA.COMISIONISTA"
    F.ABC.MOVS.CTA.COMISIONISTA  = ""
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.COMISIONISTA,F.ABC.MOVS.CTA.COMISIONISTA)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.LOCAL.REF.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.ID.ADMIN = Y.LOCAL.REF.FT<1,Y.POS.ID.ADMIN>
    Y.ID.COMI  = Y.LOCAL.REF.FT<1,Y.POS.ID.COMI>
    Y.ID.ESTAB = Y.LOCAL.REF.FT<1,Y.POS.ID.ESTAB>
    Y.FEC.LIMIT.COMI = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")

    R.ACCOUNT = ''
    Y.ERR.ACCOUNT = ''
    EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.CR,R.ACC.CUS,F.ACCOUNT,Y.ERR.ACCOUNT)
    IF R.ACC.CUS THEN
        Y.CLIENTE = R.ACC.CUS<AC.AccountOpening.Account.Customer>
* Y.NIVEL.CR = R.ACCOUNT<AC.AccountOpening.Account.LocalRef,Y.POS.NIVEL>
    END

    GOSUB GET.PARAM.LIMIT.CASHIN.COMI

    Y.FNCTION = EB.SystemTables.getVFunction()

    IF Y.FNCTION EQ 'I' THEN
*    IF Y.NIVEL.CR EQ Y.NIVEL.CUENTA.PARAM THEN
        IF Y.ID.COMI MATCHES Y.COMISIONISTA THEN
            Y.ID.MOVS.AC.COMI = Y.CUENTA.CR:"-":Y.FEC.LIMIT.COMI
            AbcSpei.AbcValLimitMovsAcComi(Y.ID.MOVS.AC.COMI,Y.MONTO.TRANS,Y.MONTO.LIMIT.PARAM,ID.NEW,Y.ID.ADMIN,Y.ID.COMI,Y.ID.ESTAB,Y.CLIENTE)
        END
*   END
    END ELSE
        IF Y.FNCTION EQ 'D' OR Y.FNCTION EQ 'R' THEN
            GOSUB BORRA.MOVS.AC.COMI
        END
    END

RETURN

*-------------------------------------------------------------------------------
GET.PARAM.LIMIT.CASHIN.COMI:
*-------------------------------------------------------------------------------

    Y.ID.LIMIT.COMI = 'LIMIT.CASHIN.COMISIONISTAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcSpei.AbcGetGeneralParam(Y.ID.LIMIT.COMI, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'LIMITE.COMI' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.LIMITE.COMI = Y.LIST.VALUES<Y.POS>
    END
    LOCATE 'MONEDA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.MONEDA = Y.LIST.VALUES<Y.POS>
    END
    LOCATE 'VALOR.LIMITE' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.MONTO.LIMIT.PARAM = Y.LIST.VALUES<Y.POS>
    END
    LOCATE 'COMISIONISTA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.COMISIONISTA = Y.LIST.VALUES<Y.POS>
        CHANGE '|' TO @VM IN Y.COMISIONISTA
    END
    LOCATE 'NIVEL.CUENTA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.NIVEL.CUENTA.PARAM = Y.LIST.VALUES<Y.POS>
    END

    IF Y.MONTO.LIMIT.PARAM EQ '' OR Y.MONTO.LIMIT.PARAM EQ 0 THEN
        R.CURRENCY = ''
        Y.ERR.CURRENCY = ''
        EB.DataAccess.FRead(FN.CURRENCY,Y.MONEDA,R.CURRENCY,F.CURRENCY,Y.ERR.CURRENCY)
        IF R.CURRENCY THEN
            Y.VALOR.UDI = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurBuyRate>
            Y.MONTO.LIMIT.PARAM = Y.VALOR.UDI*Y.LIMITE.COMI
        END
    END

RETURN

*-------------------------------------------------------------------------------
BORRA.MOVS.AC.COMI:
*-------------------------------------------------------------------------------

    Y.ID.MOVS.AC.COMI = Y.CUENTA.CR:"-":Y.FEC.LIMIT.COMI
    R.ABC.MOVS.CTA.COMISIONISTA = ''
    Y.ERR.MOVS.AC.COMI = ''
    Y.MOVIMIENTOS.AC.COMI = ''
    Y.ID.OPERACION = ID.NEW
    EB.DataAccess.FRead(FN.ABC.MOVS.CTA.COMISIONISTA, Y.ID.MOVS.AC.COMI, R.ABC.MOVS.CTA.COMISIONISTA, F.ABC.MOVS.CTA.COMISIONISTA, Y.ERR.MOVS.AC.COMI)
    IF R.ABC.MOVS.CTA.COMISIONISTA THEN
        Y.MOVIMIENTOS.AC.COMI = R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.OperacionIn>
        CHANGE @VM TO @FM IN Y.MOVIMIENTOS.AC.COMI
        LOCATE Y.ID.OPERACION IN Y.MOVIMIENTOS.AC.COMI SETTING Y.POS.MOV THEN
            R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.MontoTotalIn> -= R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.MontoIn,Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.OperacionIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.MontoIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.FechaMovIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.AdminComisIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.IdComiIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.ComiEstabIn, Y.POS.MOV>

            EB.DataAccess.FWrite(FN.ABC.MOVS.CTA.COMISIONISTA, Y.ID.MOVS.AC.COMI, R.ABC.MOVS.CTA.COMISIONISTA)
        END

        RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

        RETURN

    END
