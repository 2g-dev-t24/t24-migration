* @ValidationCode : MjotMTI4NDkzODIxMDpDcDEyNTI6MTc0MzYyODU5NjkyMDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Apr 2025 18:16:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcComisionistasRtn
SUBROUTINE ABC.COMISIONISTAS.VAL.PLAZO(Y.VALOR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.API
    


    TODAY = EB.SystemTables.getToday()
    Y.VALOR        = Y.VALOR * 1
    Y.FECHA.ACTUAL = TODAY
    Y.DIAS         = "+":Y.VALOR:"C"
    EB.API.Cdt('',Y.FECHA.ACTUAL,Y.DIAS)
    Y.VALOR = Y.FECHA.ACTUAL

RETURN

END