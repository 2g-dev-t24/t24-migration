* @ValidationCode : MjotMzUyNzMyMDY3OkNwMTI1MjoxNzQ2NDkyMzk1MDMzOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 May 2025 21:46:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcValidaLongCelular
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VALIDA.LONG.CELULAR
*===============================================================================
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer

    GOSUB INICIO
    GOSUB VALIDA.CELULAR

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    Y.NUM.CELULAR = ""
    Y.LONG.CELULAR = ""

RETURN
*-----------------------------------------------------------------------------
VALIDA.CELULAR:
*-----------------------------------------------------------------------------

    Y.NUM.CELULAR = EB.SystemTables.getComi()
    Y.LONG.CELULAR  = LEN(Y.NUM.CELULAR)

    IF Y.LONG.CELULAR NE 10 THEN
        Y.ERR = "INGRESAR CELULAR A 10 DIGITOS"
        EB.SystemTables.setEtext(Y.ERR)
        RETURN
    END

    IF ISDIGIT(Y.NUM.CELULAR) THEN
    END ELSE
        Y.ERR = "SOLO SE PERMITEN NUMEROS"
        EB.SystemTables.setEtext(Y.ERR)
    END

RETURN
END
*-----------------------------------------------------------------------------
