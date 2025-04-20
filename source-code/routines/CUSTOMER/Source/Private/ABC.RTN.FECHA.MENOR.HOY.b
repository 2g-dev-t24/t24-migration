* @ValidationCode : MjoxNzY1NDYwMTY4OkNwMTI1MjoxNzQ1MDk5ODc0NjAxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2025 18:57:54
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
$PACKAGE ABC.BP
SUBROUTINE ABC.RTN.FECHA.MENOR.HOY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Display

    GOSUB PROCESS

RETURN
*
*-------
*-------
PROCESS:
*-------
*-------
*
    FECHA = EB.SystemTables.getComi()
*
    TODAY = EB.SystemTables.getToday()
    
    IF FECHA > TODAY THEN
        ETEXT = "ERROR EN FECHA MAYOR A FECHA DEL SISTEMA"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    EB.Display.RebuildScreen()
*
RETURN
*
* --------------------This is the final End Statement ------------------
END
