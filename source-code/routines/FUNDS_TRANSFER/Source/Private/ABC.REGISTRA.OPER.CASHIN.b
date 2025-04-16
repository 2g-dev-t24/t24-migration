* @ValidationCode : MjotNjcyNTI3NTYxOkNwMTI1MjoxNzQ0NTU2MTQ1OTQwOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2025 09:55:45
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
*
**-----------------------------------------------------------------------------
** <Rating>-74</Rating>
**-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.REGISTRA.OPER.CASHIN
**===============================================================================
** Desarrollador:        Luis Cruz - FyG Solutions
** Compania:             ABC Capital
** Fecha:                2022-08-04
** Descripcion:          Rutina para registrar en template: ABC.BONIFICACION.CASH.IN
**                       las operaciones CASH IN de cuenta
** Fecha Modificacion : LFCR_20230420_NO_BBVA
** Modificaciones     : Se agrega validacion de comisionista para excluir depositos de BBVA
**                      de emitir bonificaciones
**===============================================================================
**
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ABC.BP I_F.ABC.BONIFICACION.CASH.IN
*    $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM
*-----------------------------------------------------------------------------
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.SystemTables
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
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

*    FN.BONIF.CASHIN = "F.ABC.BONIFICACION.CASH.IN"
*    F.BONIF.CASHIN = ""
*    CALL OPF(FN.BONIF.CASHIN, F.BONIF.CASHIN)
*
*    FN.ACCOUNT = 'F.ACCOUNT'
*    F.ACCOUNT = ''
*    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*    CALL GET.LOC.REF("FUNDS.TRANSFER","ID.COMI",Y.POS.ID.COMI)        ;* LFCR_20230420_NO_BBVA - S
*    Y.ID.COMISIONISTA = ''
*    Y.BANDERA.DEPO.BONIFICA = 'SI'
*    Y.ID.COMISIONISTA = R.NEW(FT.LOCAL.REF)<1,Y.POS.ID.COMI>          ;* LFCR_20230420_NO_BBVA - E

    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = "ID.COMI"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    Y.POS.ID.COMI     = field_Positions<1,1>
    Y.ID.COMISIONISTA = ''
    Y.ID.COMISIONISTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.ID.COMI>
    
    Y.BANDERA.DEPO.BONIFICA = 'SI'
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
    Y.LIST.PARAMS = "" ; Y.LIST.VALUES = ""
*    CALL ABC.GET.GENERAL.PARAM(Y.ID.PARAM.CASHIN, Y.LIST.PARAMS, Y.LIST.VALUES)
    ABC.BP.abcGetGeneralParam(Y.ID.PARAM.CASHIN, Y.LIST.PARAMS, Y.LIST.VALUES)
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

    LOCATE 'COMI.NO.BONIFICA' IN Y.LIST.PARAMS SETTING Y.POS THEN     ;* LFCR_20230420_NO_BBVA - S
        Y.COMISIONISTAS = Y.LIST.VALUES<Y.POS>
        CHANGE '|' TO @VM IN Y.COMISIONISTAS
    END

    IF Y.ID.COMISIONISTA MATCHES Y.COMISIONISTAS THEN
        Y.BANDERA.DEPO.BONIFICA = 'NO'
    END   ;* LFCR_20230420_NO_BBVA - E

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    Y.CTA.CLIENTE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo) ;*R.NEW(FT.CREDIT.ACCT.NO)
    GOSUB OBTENER.CLIENTE
    Y.ID.FT.OPER = EB.SystemTables.getIdNew()
    Y.MONTO.OPER = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount) ;*R.NEW(FT.DEBIT.AMOUNT)
    Y.FECHA.OPER = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")

    Y.ID.BONIFICACION = Y.CTA.CLIENTE:".":Y.FECHA.LIMIT
    REG.BONIFICACION = ""

*    CALL F.READ(FN.BONIF.CASHIN, Y.ID.BONIFICACION, REG.BONIFICACION, F.BONIF.CASHIN, ERR.BONIF)
    REG.BONIFICACION = ABC.BP.AbcBonificacionCashIn.Read(Y.ID.BONIFICACION, ERR.BONIF)
    IF REG.BONIFICACION NE "" THEN
        Y.TOTAL.OPERACIONES =  REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInNumOperaciones>;*<CASH.IN.NUM.OPERACIONES>
        Y.LIST.OPER.BONIF = REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInIdOperacion>;*<CASH.IN.ID.OPERACION>
        Y.TOTAL.OPE.BONIF = DCOUNT(Y.LIST.OPER.BONIF, @VM)
        Y.OPER.SIGUIENTE = Y.TOTAL.OPE.BONIF + 1
*        IF REG.BONIFICACION<CASH.IN.MONTO.TOTAL> NE '' THEN
        IF REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoTotal> NE '' THEN
            Y.MONTO.TOTAL = REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoTotal>;*<CASH.IN.MONTO.TOTAL>
        END
        Y.NUM.OPER.BONIFICAN = REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInNumOperBonifican>;*<CASH.IN.NUM.OPER.BONIFICAN>
        Y.MONTO.A.BONIFICAR = REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoABonificar>;*<CASH.IN.MONTO.A.BONIFICAR>
    END

    IF EB.SystemTables.getTFunction() EQ "R" THEN
        CHANGE @VM TO @FM IN Y.LIST.OPER.BONIF
        Y.MONTO.OPER *= -1
        GOSUB OBTEN.DECREMENTO.MONTOS
        Y.TOTAL.OPERACIONES -= 1
    END ELSE
        GOSUB OBTEN.INCREMENTO.MONTOS
        Y.TOTAL.OPERACIONES += 1
    END
    Y.MONTO.TOTAL += Y.MONTO.OPER

*    REG.BONIFICACION<CASH.IN.CUSTOMER> = Y.CLIENTE
*    REG.BONIFICACION<CASH.IN.ID.OPERACION, Y.OPER.SIGUIENTE> = Y.ID.FT.OPER
*    REG.BONIFICACION<CASH.IN.MONTO.MOV, Y.OPER.SIGUIENTE> = Y.MONTO.OPER
*    REG.BONIFICACION<CASH.IN.FECHA.MOV, Y.OPER.SIGUIENTE> = Y.FECHA.OPER
*    REG.BONIFICACION<CASH.IN.NUM.OPERACIONES> = Y.TOTAL.OPERACIONES
*    REG.BONIFICACION<CASH.IN.MONTO.TOTAL> = Y.MONTO.TOTAL
*    REG.BONIFICACION<CASH.IN.NUM.OPER.BONIFICAN> = Y.NUM.OPER.BONIFICAN
*    REG.BONIFICACION<CASH.IN.MONTO.A.BONIFICAR> = Y.MONTO.A.BONIFICAR
*    WRITE REG.BONIFICACION TO F.BONIF.CASHIN, Y.ID.BONIFICACION

    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInCustomer> = Y.CLIENTE
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInIdOperacion,Y.OPER.SIGUIENTE> = Y.ID.FT.OPER
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoMov,Y.OPER.SIGUIENTE> = Y.MONTO.OPER
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInFechaMov,Y.OPER.SIGUIENTE> = Y.FECHA.OPER
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInNumOperaciones> = Y.TOTAL.OPERACIONES
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoTotal> = Y.MONTO.TOTAL
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInNumOperBonifican> = Y.NUM.OPER.BONIFICAN
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoABonificar> = Y.MONTO.A.BONIFICAR

    ABC.BP.AbcBiometricos.Write(Y.ID.BONIFICACION, REG.BONIFICACION)

RETURN
*-----------------------------------------------------------------------------
OBTENER.CLIENTE:
*-----------------------------------------------------------------------------

    R.ACCOUNT = ""
*    CALL F.READ(FN.ACCOUNT, Y.CTA.CLIENTE, R.ACCOUNT, F.ACCOUNT, YERR.ACCOUNT)
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.CTA.CLIENTE, YERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>       ;*<AC.CUSTOMER>
    END

RETURN
*-----------------------------------------------------------------------------
OBTEN.INCREMENTO.MONTOS:
*-----------------------------------------------------------------------------

    IF (Y.MONTO.OPER GE Y.MONTO.MIN) AND (Y.NUM.OPER.BONIFICAN LT Y.NUM.OPERACIONES) THEN
        Y.NUM.OPER.BONIFICAN += 1
        Y.MONTO.A.BONIFICAR += Y.MONTO.BON
    END

RETURN
*-----------------------------------------------------------------------------
OBTEN.DECREMENTO.MONTOS:
*-----------------------------------------------------------------------------

    IF (ABS(Y.MONTO.OPER) GE Y.MONTO.MIN) AND (Y.NUM.OPER.BONIFICAN GE 1) THEN
        Y.NUM.OPER.BONIFICAN -= 1
        Y.MONTO.A.BONIFICAR -= Y.MONTO.BON
    END

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN

END
**-----------------------------------------------------------------------------
