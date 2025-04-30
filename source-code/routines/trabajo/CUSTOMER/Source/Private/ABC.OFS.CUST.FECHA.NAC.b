* @ValidationCode : MjoxNzIxMzU0MDc3OkNwMTI1MjoxNzQ1MTAwMTY1ODc0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2025 19:02:45
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
SUBROUTINE ABC.OFS.CUST.FECHA.NAC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
 
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING EB.Interface

    Y.OFS.OPERATION = EB.Interface.getOfsOperation()
    
    IF Y.OFS.OPERATION NE 'VALIDATE' THEN ;*CAMB
        
        GOSUB VALIDA
        
    END

RETURN


VALIDA:

    Y.FECHA.NAC = EB.SystemTables.getComi()
*
    TODAY = EB.SystemTables.getToday()

    Y.NVA.FECHA = TODAY - Y.FECHA.NAC

    IF LEN(Y.NVA.FECHA) GT 5 THEN
        Y.YEARS = Y.NVA.FECHA[1,2]
    END
    ELSE
        Y.YEARS = Y.NVA.FECHA[1,1]
    END

    IF Y.YEARS LT 18 THEN
        ETEXT = "CLIENTE TIENE EDAD INFERIOR A LOS 18"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
END
