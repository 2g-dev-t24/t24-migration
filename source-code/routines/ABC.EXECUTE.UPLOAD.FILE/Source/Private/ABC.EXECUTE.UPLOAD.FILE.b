* @ValidationCode : MjotOTQ0MTE0NDYzOkNwMTI1MjoxNzQzMTA0MTg2Nzk3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Mar 2025 16:36:26
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
$PACKAGE ABC.EXECUTE.UPLOAD.FILE
SUBROUTINE ABC.EXECUTE.UPLOAD.FILE(R.DATA)
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Reports
    


    
    GOSUB INICIO.PROCESO
    GOSUB PROCESO.SELECT
    GOSUB EJECUTA.PROCESO

RETURN

*=================
INICIO.PROCESO:
*=================

    PROCESO.EJECTUA = ''
    Y.ARR.MENSAJES  = ''
    R.DATA          = ''
    Y.MESNAJE.RESP  = ''

RETURN


*=================
PROCESO.SELECT:
*=================
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "PROCESO" IN SEL.FIELDS<1> SETTING YPOS THEN
        PROCESO.EJECTUA   = SEL.VALUES<YPOS>
    END
RETURN

*=================
EJECUTA.PROCESO:
*=================

    Y.ARR.MENSAJES     = 'Ejecutando Carga a T24'
*   CALL ABC.PARAM.FILE.UPLOAD.LOAD(PROCESO.EJECTUA,Y.MESNAJE.RESP)

    Y.ARR.MENSAJES <-1>= "Procesando...."

    IF Y.MESNAJE.RESP NE '' THEN
        Y.ARR.MENSAJES <-1>= Y.MESNAJE.RESP
    END ELSE
        Y.ARR.MENSAJES <-1>= "Sin Registros por Procesar..."
    END
    Y.ARR.MENSAJES <-1>= 'Proceso Concluido'
    R.DATA = Y.ARR.MENSAJES
RETURN
END



