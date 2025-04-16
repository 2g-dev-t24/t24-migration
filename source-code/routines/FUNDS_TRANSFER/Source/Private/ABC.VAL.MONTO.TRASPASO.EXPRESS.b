* @ValidationCode : MjoxNDE4ODg4OTYwOkNwMTI1MjoxNzQ0NDE4MDExMjQxOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 19:33:31
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

*===============================================================================
* <Rating>-40</Rating>
*===============================================================================
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.MONTO.TRASPASO.EXPRESS
*===============================================================================
* Nombre de Programa :  ABC.VAL.MONTO.TRASPASO.EXPRESS
* Objetivo           :  Rutina para validar el monto a transferir para SPEI en operaciones express
* Requerimiento      :  Proyecto ABC Digital
* Desarrollador      :  Alexis Almaraz Robles - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  23/Agosto/2022
*===============================================================================
* Modificaciones:
*===============================================================================

*    $INSERT GLOBUS.BP I_COMMON
*    $INSERT GLOBUS.BP I_EQUATE
*    $INSERT GLOBUS.BP I_F.ACCOUNT
*    $INSERT GLOBUS.BP  I_F.FUNDS.TRANSFER

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ABC.BP

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.MONTO = EB.SystemTables.getComi() ;*COMI
    Y.CUENTA.ORDEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo) ;*R.NEW(FT.DEBIT.ACCT.NO)
    R.ACCOUNT = ''
    Y.ERR.ACC = ''
    Y.MONTO.MAX.EXP = ''
    Y.WORKING.BALANCE = ''
    Y.ACCT.LOCKED.AMT = ''
    Y.AMOUNT.AVAIL = ''
    Y.ID.PARAM.LIMIT = 'ABC.LIMITE.MONTOS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

*    FN.ACCOUNT = "F.ACCOUNT"
*    F.ACCOUNT  = ""
*    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    ABC.BP.abcGetGeneralParam(Y.ID.PARAM.LIMIT, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'LIMITE.OPER.TRANSFER.EXPRESS' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.MONTO.MAX.EXP = Y.LIST.VALUES<Y.POS>
    END

    IF Y.MONTO LE 0 THEN
        EB.SystemTables.setEtext("Monto a transferir debe ser mayor a 0") ;*ETEXT = "Monto a transferir debe ser mayor a 0"
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.MONTO.MAX.EXP NE "" THEN
        IF Y.MONTO GT Y.MONTO.MAX.EXP THEN
            EB.SystemTables.setEtext("Solo se permite hasta: ":Y.MONTO.MAX.EXP) ;*ETEXT = "Solo se permite hasta: ":Y.MONTO.MAX.EXP
            EB.ErrorProcessing.StoreEndError()
        END
    END

    ABC.BP.abcMontoBloqueado(Y.CUENTA.ORDEN,Y.ACCT.LOCKED.AMT)

*CALL F.READ(FN.ACCOUNT, Y.CUENTA.ORDEN, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.CUENTA.ORDEN, Y.ERR.ACC)
* Before incorporation : CALL F.READ(FN.ACCOUNT, Y.CUENTA.ORDEN, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)
    IF R.ACCOUNT THEN
        Y.WORKING.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance> ;*R.ACCOUNT<AC.WORKING.BALANCE>
        Y.AMOUNT.AVAIL = Y.WORKING.BALANCE - Y.ACCT.LOCKED.AMT
        IF (Y.WORKING.BALANCE LE 0) OR (Y.MONTO GT Y.WORKING.BALANCE)  OR (Y.MONTO GT Y.AMOUNT.AVAIL) THEN
            EB.SystemTables.setEtext('Saldo insuficiente') ;*ETEXT = 'Saldo insuficiente'
            EB.ErrorProcessing.StoreEndError()
        END
    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
