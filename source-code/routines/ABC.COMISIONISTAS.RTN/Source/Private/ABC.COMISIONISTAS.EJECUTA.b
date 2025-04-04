* @ValidationCode : MjoxNTU5MDU0MTM6Q3AxMjUyOjE3NDM3OTAxNDE3Mjg6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 15:09:01
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
SUBROUTINE ABC.COMISIONISTAS.EJECUTA(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
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

    BEGIN CASE
        CASE PROCESO.EJECTUA EQ "CARGA"

            Y.ARR.MENSAJES <1>= 'Ejecutando  proceso de Validacion '
            CALL ABC.COMISIONISTAS.CARGA(Y.MESNAJE.RESP)
        CASE PROCESO.EJECTUA EQ "CLIENTES"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga de Clientes '
            CALL ABC.COMISIONISTAS.CARGA.CTES(Y.MESNAJE.RESP)
        CASE PROCESO.EJECTUA EQ "CUENTAS"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga de Cuentas'
            CALL ABC.COMISIONISTAS.CARGA.CTAS(Y.MESNAJE.RESP)
        CASE PROCESO.EJECTUA EQ "TRASPASO"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga Fondeo'
            CALL ABC.COMISIONISTAS.CARGA.FTES(Y.MESNAJE.RESP)
        CASE PROCESO.EJECTUA EQ "INVERSION"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga Inversiones'
            CALL ABC.COMISIONISTAS.CARGA.INVS(Y.MESNAJE.RESP)


    END CASE



    IF Y.MESNAJE.RESP NE '' THEN
        Y.ARR.MENSAJES <-1>= Y.MESNAJE.RESP
    END ELSE
        Y.ARR.MENSAJES <-1>= "Sin Registros por Procesar..."
    END
    Y.ARR.MENSAJES <-1>= 'Proceso concluido'
    R.DATA = Y.ARR.MENSAJES
RETURN
END

