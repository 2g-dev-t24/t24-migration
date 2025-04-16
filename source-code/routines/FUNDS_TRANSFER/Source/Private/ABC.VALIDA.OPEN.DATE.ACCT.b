* @ValidationCode : Mjo5OTg5MDMzNDQ6Q3AxMjUyOjE3NDQyMzAyOTkzMDY6VXNpYXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2025 15:24:59
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
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VALIDA.OPEN.DATE.ACCT
*===============================================================================
* Nombre de Programa : ABC.VALIDA.OPEN.DATE.ACCT
* Objetivo           : Check Rec Rtn que valida que la fecha de apertura de cuenta
*                      no sea menor al parametrizado
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2022-SEPT-07
* Modificaciones:
*===============================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.API
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ABC.BP

    GOSUB INICIALIZA
    GOSUB CHECK.OPEN.DATE
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUENTA = 'F.ACCOUNT'
    FV.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, FV.CUENTA)

    Y.ID.GEN.PARAM = 'SPEI.DIAS.APERTURA.CTA'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    ABC.BP.abcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    NUM.DIAS.MINIMOS = ''
    LOCATE 'NUM.DIAS' IN Y.LIST.PARAMS SETTING POS.NUM.DIAS THEN
        NUM.DIAS.MINIMOS = Y.LIST.VALUES<POS.NUM.DIAS>
    END

    Y.ID.CUENTA = ''
    Y.FECHA.APERT.CTA = ''
    Y.FECHA.ACTUAL = EB.SystemTables.getToday() ;*TODAY
    DAYS = "C"

RETURN
*---------------------------------------------------------------
CHECK.OPEN.DATE:
*---------------------------------------------------------------

    Y.ID.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo) ;*R.NEW(FT.DEBIT.ACCT.NO)
    REG.CUENTA = ""

    REG.CUENTA = AC.AccountOpening.Account.Read(Y.ID.CUENTA, ERR.CTA)
    IF REG.CUENTA NE '' THEN
        Y.FECHA.APERT.CTA = REG.CUENTA<AC.AccountOpening.Account.OpeningDate> ;*REG.CUENTA<AC.OPENING.DATE>

*CALL CDD('', Y.FECHA.APERT.CTA, Y.FECHA.ACTUAL, DAYS)
        EB.API.Cdd('', Y.FECHA.APERT.CTA, Y.FECHA.ACTUAL, DAYS)
        IF DAYS LT NUM.DIAS.MINIMOS THEN
*E = "CUENTA AUN NO CUMPLE PLAZO MINIMO PARA ESTA OPERACION"
            EB.SystemTables.setE("CUENTA AUN NO CUMPLE PLAZO MINIMO PARA ESTA OPERACION")
            EB.ErrorProcessing.Err()
        END
    END

RETURN

