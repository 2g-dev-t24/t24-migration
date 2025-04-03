* @ValidationCode : MjoxNDc5NDA2MTk3OkNwMTI1MjoxNzQzNTMyNTg2NDM4OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Apr 2025 12:36:26
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VAL.TRANS.TYPE
*===============================================================================
* Nombre de Programa : ABC.VAL.TRANS.TYPE
* Objetivo           : Validation rtn para validar que el TRANSACTION.TYPE sea
*                      unicamente ACMI
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2021-10-26
* Modificaciones:
*===============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_F.FUNDS.TRANSFER
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING ABC.BP

    GOSUB INICIALIZA
    GOSUB VAL.TRANS.TYPE
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    Y.TRANS.TYPE = ''
    Y.TRANS.TRAS = "ACMI"

*    Y.TRANS.TYPE = COMI
    Y.TRANS.TYPE = EB.SystemTables.getComi()

RETURN

*---------------------------------------------------------------
VAL.TRANS.TYPE:
*---------------------------------------------------------------

    IF Y.TRANS.TYPE NE Y.TRANS.TRAS THEN
        EB.SystemTables.setEtext("TIPO DE TRANSACCION NO PERMITIDA")
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
