* @ValidationCode : MjotNzIxMzY4MzU3OkNwMTI1MjoxNzQ0ODM1Mzg3NTE2OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 15:29:47
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
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.SPEI.INTERPRETA.RESPONSE(Y.RESPONSE, Y.MESSAGE.OUT)
*-----------------------------------------------------------------------------
* First Released For: ABC
* First Released:     May/24/2006
* Author:
*----------------------------------------------------------
* COMPONENTIZACION
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*-----------------------------------------------------------------------------

    GOSUB INIT.VARS
    GOSUB PROCESS

RETURN

**********
INIT.VARS:
**********

    Y.MESSAGE.OUT = ""
    Y.DESC.MENSAJE = ""
    Y.SEPARA.MENSAJE = "TRANSACTION "
    Y.SEPARA.NUMBER = " "
    Y.INI.MENSAJE = "("
    Y.FIN.MENSAJE = ")"

RETURN

********
PROCESS:
********

    Y.MENSAJE = FIELD(Y.RESPONSE,Y.SEPARA.MENSAJE,2)
    Y.NUM.MENSAJE = FIELD(Y.MENSAJE, Y.SEPARA.NUMBER,1)
    IF Y.NUM.MENSAJE EQ "OK" THEN
        Y.NUM.MENSAJE = "0"
    END ELSE
        IF Y.NUM.MENSAJE EQ "ERROR" THEN
            Y.NUM.MENSAJE = "-1"
            Y.DESC.MENSAJE = FIELD(Y.MENSAJE, Y.INI.MENSAJE,2)
            Y.DESC.MENSAJE = FIELD(Y.DESC.MENSAJE, Y.FIN.MENSAJE,1)
        END ELSE
            Y.NUM.MENSAJE = ""
        END
    END
    Y.MESSAGE.OUT = Y.NUM.MENSAJE : "/" : Y.DESC.MENSAJE
    IF Y.NUM.MENSAJE EQ '' AND Y.DESC.MENSAJE EQ '' THEN Y.MESSAGE.OUT = '-1/':Y.RESPONSE

RETURN

END
