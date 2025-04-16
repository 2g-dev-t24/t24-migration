* @ValidationCode : Mjo0MjgxNzA5Mzc6Q3AxMjUyOjE3NDQ2NjUwNjExMzk6VXNpYXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Apr 2025 16:11:01
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
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.CUENTAS.FT
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.VALIDA.CUENTAS.FT
* Objetivo:             Rutina que valida que el la cuenta de cr�dito y d�bito
*                       sean diferentes
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC CAPITAL
* Fecha Creacion:       29 - Marzo - 2022
* Modificaciones:
*-----------------------------------------------------------------------------
*CARGADA A VERSIONES:
*-------------------------------------------------------------------------------
*FUNDS.TRANSFER,ABC.TRASPASO.PRN
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN
*FUNDS.TRANSFER,ABC.TRASPASO.DIGITAL
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN.2
*===============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.ErrorProcessing

    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

RETURN

***********
INICIALIZA:
***********

    Y.DEBIT = ''
    Y.CREDIT = ''
    Y.ERROR = ''

RETURN

***************
VALIDA.USUARIO:
***************

    Y.DEBIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo) ;*R.NEW(FT.DEBIT.ACCT.NO)
    Y.CREDIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo) ;*R.NEW(FT.CREDIT.ACCT.NO)

    IF Y.DEBIT EQ Y.CREDIT THEN
        EB.SystemTables.setEtext("LA CUENTA DE RETIRO Y LA CUENTA DE DEPOSITO NO PUEDEN SER IGUALES") ;*ETEXT = "LA CUENTA DE RETIRO Y LA CUENTA DE DEPOSITO NO PUEDEN SER IGUALES"
        EB.SystemTables.setE("") ;*E = ''
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

END
