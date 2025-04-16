* @ValidationCode : MjoyMDgxMzQ5MTE4OkNwMTI1MjoxNzQ0NzM1MTIxMzAwOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Apr 2025 11:38:41
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
*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CALL.RTNS.GEN.FT
*===============================================================================
* Desarrollador:        Luis Cruz - FyG Solutions
* Compania:             ABC Capital
* Fecha:                2022-12-20
* Descripci�n:          Rutina de proposito general para ejecutar rutinas parametrizadas
*                       sobre versiones de FT
* Componente T24     : FUNDS.TRANSFER,ABC.COMISIONISTA.CASH.IN
*===============================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.API
*-----------------------------------------------------------------------------
    
    GOSUB INICIO
    GOSUB OBTEN.RTNS.PARAM
    GOSUB EJECUTA.RTNS

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

*    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
*    FV.ABC.GENERAL.PARAM = ""
*    CALL OPF(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)

    Y.NOMB.VERSION = ""
    Y.CUENTA.DEBIT = ""
    Y.CUENTA.CREDIT = ""
    Y.MONTO.OPERACION = ""
    Y.TRANSAC.TYPE = ""
    Y.EXT.TRANS.ID = ""
    Y.RTNS.EJECUTABLES = ""

RETURN
*-----------------------------------------------------------------------------
OBTEN.RTNS.PARAM:
*-----------------------------------------------------------------------------

    Y.PARAM.RTNS = 'FT.RTNS.PARAM'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
*    CALL ABC.GET.GENERAL.PARAM(Y.PARAM.RTNS, Y.LIST.PARAMS, Y.LIST.VALUES)
    ABC.BP.abcGetGeneralParam(Y.PARAM.RTNS, Y.LIST.PARAMS, Y.LIST.VALUES)
    Y.RTNS.EJECUTABLES = Y.LIST.VALUES

RETURN
*-----------------------------------------------------------------------------
EJECUTA.RTNS:
*-----------------------------------------------------------------------------

    Y.ID.FT = EB.SystemTables.getIdNew()  ;*ID.NEW
    Y.CUENTA.DEBIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo) ;*R.NEW(FT.DEBIT.ACCT.NO)
    Y.CUENTA.CREDIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo);*R.NEW(FT.CREDIT.ACCT.NO)

    Y.RTNS.TOTALES = DCOUNT(Y.RTNS.EJECUTABLES, FM)

;*FOR Y.IT.RTN = 1 TO Y.RTNS.TOTALES
    Y.IT.RTN = 1
    LOOP
    WHILE Y.IT.RTN LE Y.RTNS.TOTALES
        Y.NOMBRE.RTN = Y.LIST.VALUES<Y.IT.RTN>
        RoutineName = Y.NOMBRE.RTN
        Arguments = ""
        Delim = ""
        EB.SystemTables.CallBasicRoutine(RoutineName, Arguments, Delim)
*        CALL @Y.NOMBRE.RTN
        Y.IT.RTN++
    REPEAT
;*NEXT Y.IT.RTN

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN

SET.RTN:
    BEGIN CASE
        CASE Y.NOMBRE.RTN EQ ""
*                ABC.BP.rutinaComponentizada
        CASE 1
    END CASE
RETURN
END
*-----------------------------------------------------------------------------
