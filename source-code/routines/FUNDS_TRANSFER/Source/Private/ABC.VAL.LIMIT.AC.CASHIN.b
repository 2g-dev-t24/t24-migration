* @ValidationCode : MjotMjg2NzM5ODk6Q3AxMjUyOjE3NDQzOTI0MTEwOTE6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2025 12:26:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*===============================================================================
* <Rating>-60</Rating>
*===============================================================================
SUBROUTINE ABC.VAL.LIMIT.AC.CASHIN
*===============================================================================
* Nombre de Programa :  ABC.VAL.LIMIT.AC.CASHIN
* Objetivo           :  Rutina para validar el limit sobre operaciones CashIn
* Requerimiento      :  Servicios Cashin - Limite Comisionistas
* Desarrollador      :  Alexis Almaraz Robles - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  10/Abril/2023
*===============================================================================
* Modificaciones:
*===============================================================================

*    $INSERT GLOBUS.BP I_COMMON
*    $INSERT GLOBUS.BP I_EQUATE
*    $INSERT ../T24_BP I_F.CURRENCY
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INSERT ABC.BP I_F.ABC.MOVS.CTA.COMISIONISTA

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.CurrencyConfig
    
    GOSUB INITIALIZE
*    GOSUB OPEN.FILES
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

*    Y.NOMBRE.APP = ''
*    Y.NOMBRE.CAMPO = ''
*    R.POS.CAMPO = ''
*    Y.NOMBRE.APP<-1> = "ACCOUNT"
*    Y.NOMBRE.APP<-1> = "FUNDS.TRANSFER"
*    Y.NOMBRE.CAMPO<1,1> = "NIVEL"
*    Y.NOMBRE.CAMPO<2,1> = "ID.ADMIN"
*    Y.NOMBRE.CAMPO<2,2> = "ID.COMI"
*    Y.NOMBRE.CAMPO<2,3> = "ID.ESTAB"
*    CALL MULTI.GET.LOC.REF(Y.NOMBRE.APP,Y.NOMBRE.CAMPO,R.POS.CAMPO)
*    Y.POS.NIVEL    = R.POS.CAMPO<1,1>
*    Y.POS.ID.ADMIN = R.POS.CAMPO<2,1>
*    Y.POS.ID.COMI  = R.POS.CAMPO<2,2>
*    Y.POS.ID.ESTAB = R.POS.CAMPO<2,3>
    
    applications     = ""
    fields           = ""
    applications<1>  = "ACCOUNT"
    applications<2>  = "FUNDS.TRANSFER"
    fields<1,1>      = "NIVEL"
    fields<2,1>      = "LT.CUSTOMER.TYP"
    fields<2,2>      = "ID.COMI"
    fields<2,3>      = "ID.ESTAB"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    Y.POS.NIVEL     = field_Positions<1,1>
    Y.POS.ID.ADMIN  = field_Positions<2,1>
    Y.POS.ID.COMI   = field_Positions<2,2>
    Y.POS.ID.ESTAB  = field_Positions<2,3>

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

*    FN.ACCOUNT = 'F.ACCOUNT'
*    F.ACCOUNT = ''
*    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
*
*    FN.CURRENCY = 'F.CURRENCY'
*    F.CURRENCY = ''
*    EB.DataAccess.Opf(FN.CURRENCY, F.CURRENCY)
*
*    FN.ABC.MOVS.CTA.COMISIONISTA = "F.ABC.MOVS.CTA.COMISIONISTA"
*    F.ABC.MOVS.CTA.COMISIONISTA  = ""
*    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.COMISIONISTA,F.ABC.MOVS.CTA.COMISIONISTA)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)      ;* R.NEW(FT.CREDIT.ACCT.NO)
    Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)      ;* R.NEW(FT.DEBIT.AMOUNT)
    Y.ID.ADMIN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.ID.ADMIN>    ;* R.NEW(FT.LOCAL.REF)<1,Y.POS.ID.ADMIN>
    Y.ID.COMI  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.ID.COMI>      ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.ID.COMI>
    Y.ID.ESTAB = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.ID.ESTAB>       ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.ID.ESTAB>
    Y.FEC.LIMIT.COMI = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")

    R.ACCOUNT = ''
    Y.ERR.ACCOUNT = ''
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.CUENTA.CR, Y.ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>   ;*R.ACCOUNT<AC.CUSTOMER>
        Y.NIVEL.CR = R.ACCOUNT<AC.AccountOpening.Account.LocalRef,Y.POS.NIVEL>      ;*R.ACCOUNT<AC.LOCAL.REF,Y.POS.NIVEL>
    END

    GOSUB GET.PARAM.LIMIT.CASHIN.COMI

    IF EB.SystemTables.getTFunction() EQ 'I' THEN
        IF Y.NIVEL.CR EQ Y.NIVEL.CUENTA.PARAM THEN
            IF Y.ID.COMI MATCHES Y.COMISIONISTA THEN
                Y.ID.MOVS.AC.COMI = Y.CUENTA.CR:"-":Y.FEC.LIMIT.COMI
*                CALL ABC.VAL.LIMIT.MOVS.AC.COMI(Y.ID.MOVS.AC.COMI,Y.MONTO.TRANS,Y.MONTO.LIMIT.PARAM,ID.NEW,Y.ID.ADMIN,Y.ID.COMI,Y.ID.ESTAB,Y.CLIENTE)
                ABC.BP.abcValLimitMovsAcComi(Y.ID.MOVS.AC.COMI,Y.MONTO.TRANS,Y.MONTO.LIMIT.PARAM,ID.NEW,Y.ID.ADMIN,Y.ID.COMI,Y.ID.ESTAB,Y.CLIENTE)
            END
        END
    END ELSE
        IF EB.SystemTables.getTFunction() EQ 'D' OR EB.SystemTables.getTFunction() EQ 'R' THEN
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
    ABC.BP.abcGetGeneralParam(Y.ID.LIMIT.COMI, Y.LIST.PARAMS, Y.LIST.VALUES)

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
*        EB.DataAccess.FRead(FN.CURRENCY,Y.MONEDA,R.CURRENCY,F.CURRENCY,Y.ERR.CURRENCY)
        R.CURRENCY = ST.CurrencyConfig.Currency.Read(Y.MONEDA, Y.ERR.CURRENCY)
        IF R.CURRENCY THEN
            Y.VALOR.UDI = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurBuyRate>        ;*<EB.CUR.BUY.RATE,1>
            Y.MONTO.LIMIT.PARAM = Y.VALOR.UDI * Y.LIMITE.COMI
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
        Y.MOVIMIENTOS.AC.COMI = R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaOperacionIn>     ;*<MOVS.AC.COMI.OPERACION.IN>
        CHANGE @VM TO @FM IN Y.MOVIMIENTOS.AC.COMI
        LOCATE Y.ID.OPERACION IN Y.MOVIMIENTOS.AC.COMI SETTING Y.POS.MOV THEN
*            R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.MONTO.TOTAL.IN> -= R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.MONTO.IN,Y.POS.MOV>
*            DEL R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.OPERACION.IN, Y.POS.MOV>
*            DEL R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.MONTO.IN, Y.POS.MOV>
*            DEL R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.FECHA.MOV.IN, Y.POS.MOV>
*            DEL R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.ADMIN.COMIS.IN, Y.POS.MOV>
*            DEL R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.ID.COMI.IN, Y.POS.MOV>
*            DEL R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.COMI.ESTAB.IN, Y.POS.MOV>
*            WRITE R.ABC.MOVS.CTA.COMISIONISTA TO F.ABC.MOVS.CTA.COMISIONISTA, Y.ID.MOVS.AC.COMI
            R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaMontoTotalIn> -= R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaMontoIn,Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaOperacionIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaMontoIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaFechaMovIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaAdminComisIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaIdComiIn, Y.POS.MOV>
            DEL R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaComiEstabIn, Y.POS.MOV>
            ABC.BP.AbcMovsCtaComisionista.Write(Y.ID.MOVS.AC.COMI, R.ABC.MOVS.CTA.COMISIONISTA)
        END
    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END

