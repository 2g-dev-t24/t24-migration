* @ValidationCode : MjotMTk3NTQzNDQ1MjpDcDEyNTI6MTc0NDA1Nzc5MTczMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2025 17:29:51
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
            AbcComisionistasRtn.AbcComisionistasCarga(Y.MESNAJE.RESP)
            
        CASE PROCESO.EJECTUA EQ "CLIENTES"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga de Clientes '
            AbcComisionistasRtn.AbcComisionistasCargaCtes(Y.MESNAJE.RESP)
       
        CASE PROCESO.EJECTUA EQ "CUENTAS"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga de Cuentas'
            AbcComisionistasRtn.AbcComisionistasCargaCtas(Y.MESNAJE.RESP)
        CASE PROCESO.EJECTUA EQ "TRASPASO"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga Fondeo'
            AbcComisionistasRtn.AbcComisionistasCargaFtes(Y.MESNAJE.RESP)
        CASE PROCESO.EJECTUA EQ "INVERSION"

            Y.ARR.MENSAJES <-1>= 'Ejecutando  proceso de Carga Inversiones'
            AbcComisionistasRtn.AbcComisionistasCargaInvs(Y.MESNAJE.RESP)


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

