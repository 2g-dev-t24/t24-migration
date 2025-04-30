* @ValidationCode : MjotMzA5MzU3OTg5OkNwMTI1MjoxNzQ1NTE0NDc2ODcwOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2025 14:07:56
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
$PACKAGE BaValListaCol
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BA.VAL.LISTA.COL(ENQ.PARAM)

    Y.COL = ENQ.PARAM<4,1>
    ENQ.PARAM<2,1> = "@ID"
    IF Y.COL THEN
        ENQ.PARAM<3,1> = "LK"
        ENQ.PARAM<4,1> = Y.COL:"..."
    END

END
