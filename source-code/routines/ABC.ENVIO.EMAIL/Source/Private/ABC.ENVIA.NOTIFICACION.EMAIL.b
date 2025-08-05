* @ValidationCode : MjoyMTI3Mzk5MzYwOkNwMTI1MjoxNzU0MzYwNTg5MDE0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Aug 2025 23:23:09
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
$PACKAGE AbcEnvioEmail

SUBROUTINE ABC.ENVIA.NOTIFICACION.EMAIL(ID.SMS.EMAIL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING ABC.BP
    $USING EB.Service

    GOSUB INICIALIZA
    GOSUB PROCESO

RETURN
***********
INICIALIZA:
***********

    Y.STR.EMAIL = ''
    R.INFO.SMS.EMAIL = ''

    Y.TIME = TIMEDATE()[1,2]:TIMEDATE()[4,2]
    
    FN.SMS.EMAIL    = AbcEnvioEmail.getFnSmsEmail()
    F.SMS.EMAIL     = AbcEnvioEmail.getFSmsEmail()
    Y.DATE          = AbcEnvioEmail.getYDate()
    FN.SS           = AbcEnvioEmail.getFnSs()
    F.SS            = AbcEnvioEmail.getFSs()
    FECHA.FILE      = AbcEnvioEmail.getFechaFile()
    Y.RUTA.HTML     = AbcEnvioEmail.getYRutaHtml()
    AGENT.NUMBER    = EB.Service.getAgentNumber()
RETURN

************
PROCESO:
************

    EB.DataAccess.FRead(FN.SMS.EMAIL,ID.SMS.EMAIL,R.INFO.SMS.EMAIL,F.SMS.EMAIL,ERROR.SMS.EMAIL)
    IF ERROR.SMS.EMAIL EQ '' THEN
        ID.CLIENTE = R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.Customer>
        Y.ID.PARAM = R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.TipoEmail>
        Y.SUBJECT = R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>
        Y.TIPO.MOVIMIENTO = FIELD(Y.ID.PARAM, ".", 2)
        Y.CUST.EMAIL = R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.Email>
        Y.NOTI.EMAIL = R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.NotificaEmail>
        Y.NOTI.ALTERNO = R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.NotificaAlterna>

        IF Y.NOTI.EMAIL EQ 'SI' THEN GOSUB LEE.CORREO

    END

RETURN

************
LEE.CORREO:
************

*Si el cliente no tiene correo, no se hace el proceso
    IF Y.CUST.EMAIL EQ '' THEN
        R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.StatusEmail> = 'E'
        R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.DateTime> = Y.DATE:Y.TIME
        EB.DataAccess.FWrite(FN.SMS.EMAIL,ID.SMS.EMAIL,R.INFO.SMS.EMAIL)
*        WRITE R.INFO.SMS.EMAIL TO F.SMS.EMAIL,ID.SMS.EMAIL
        RETURN
    END ELSE
        Y.LIST.PARAMS = ''
        Y.LIST.VALUES = ''
        Y.EMAIL.HTML = ''     ;* LFCR_20231222_HTML S - E

        AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
        NUM.LINEAS = DCOUNT(Y.LIST.PARAMS,@FM)

        LOCATE 'HTML.FILE' IN Y.LIST.PARAMS SETTING POSITION THEN     ;* LFCR_20231222_HTML S
            Y.EMAIL.HTML = 1
            Y.HTML.FILE.NAME = Y.LIST.VALUES<POSITION>
            GOSUB LEER.HTML.FILE
        END         ;* LFCR_20231222_HTML E

        FOR YNO=1 TO NUM.LINEAS

            IF Y.EMAIL.HTML NE 1 AND Y.LIST.PARAMS<YNO> EQ 'EMAIL' THEN
                Y.STR.EMAIL := Y.LIST.VALUES<YNO>
            END

            IF Y.LIST.PARAMS<YNO> EQ 'PARAM' THEN
                Y.PARAM = Y.LIST.VALUES<YNO>
                Y.TABLA = FIELD(Y.PARAM,'*',2)
                Y.CAMPO = FIELD(Y.PARAM,'*',3)
                EB.DataAccess.FRead(FN.SS,Y.TABLA,R.SS,F.SS,ERROR.SS)
                IF ERROR.SS EQ '' THEN
                    Y.LIST.CAMPOS = R.SS<EB.SystemTables.StandardSelection.SslSysFieldName>
                    CONVERT @VM TO @FM IN Y.LIST.CAMPOS
                    Y.LIST.NUM.CAMPOS = R.SS<EB.SystemTables.StandardSelection.SslSysFieldNo>
                    CONVERT @VM TO @FM IN Y.LIST.NUM.CAMPOS
                    LOCATE Y.CAMPO IN Y.LIST.CAMPOS SETTING POSITION THEN
                        Y.NUM.CAMPO = Y.LIST.NUM.CAMPOS<POSITION>
                        GOSUB OBTIENE.VALOR
                        IF Y.CAMPO EQ 'CUENTA' OR Y.CAMPO EQ 'CUENTA.CLIENTE' THEN Y.VALOR = RIGHT(Y.VALOR,4)
                    END
                END
                Y.ETIQUETA = FIELD(Y.PARAM,'*',1)
                Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,Y.ETIQUETA,Y.VALOR)
            END
            IF Y.LIST.PARAMS<YNO> EQ 'RUTA.LOG' THEN
                Y.RUTA.LOG = Y.LIST.VALUES<YNO>
            END
            IF Y.LIST.PARAMS<YNO> EQ 'NOMBRE.LOG' THEN
                Y.NOMBRE.LOG = Y.LIST.VALUES<YNO>
            END
        NEXT YNO

        GOSUB CREA.ARCHIVO
        GOSUB FORMATO.EMAIL

    END

    Y.EMAIL = Y.CUST.EMAIL
    Y.STR.EMAIL = Y.EMAIL:"*":Y.SUBJECT:"*":Y.STR.EMAIL
*    DISPLAY Y.STR.EMAIL

    GOSUB ENVIO.EMAIL

RETURN

*************
CREA.ARCHIVO:
*************

    str_filename2 = Y.NOMBRE.LOG:"." : FECHA.FILE : "." : AGENT.NUMBER : ".log"
    SEQ.FILE.NAME = Y.RUTA.LOG : "/"

    OPENSEQ SEQ.FILE.NAME,str_filename2 TO FILE.VAR2 ELSE
        CREATE FILE.VAR2 ELSE
        END
    END

RETURN

**************
OBTIENE.VALOR:
**************

    Y.VALOR = R.INFO.SMS.EMAIL<Y.NUM.CAMPO>

RETURN

************
ENVIO.EMAIL:
************

    argumentoEntrada = Y.STR.EMAIL
*str_path = @PATH
    str_path = '/shares/log'
    str_filename = "ABC.ENVIA.MAIL.":RND(2000000):TIME():".":AGENT.NUMBER:".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.SALTO = CHAR(10)

    Y.CADENA = 'java -jar T24EmailSender.jar "' : argumentoEntrada :'"'

    Y.MENSAJE = Y.CADENA

* Armo Archivo
    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd jars" : Y.SALTO
    Y.SHELL := Y.CADENA : Y.SALTO
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        GOSUB BITACORA
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "chmod 777 ./" : str_filename CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "./" : str_filename            CAPTURING Y.RETURNVAL
    EXECUTE "rm ./" : str_filename        CAPTURING Y.RESPONSE.RM

    returnVal = Y.RETURNVAL
    IF FIELD(returnVal,'*',1) EQ '0' THEN
        R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.StatusEmail> = 'OK'
        R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.DateTime> = Y.DATE:Y.TIME
        MENSAJE = "EMAIL ENVIADO: ":ID.SMS.EMAIL:", ":Y.ID.PARAM
        GOSUB BITACORA
    END ELSE
        R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.StatusEmail> = 'E'
        R.INFO.SMS.EMAIL<AbcTable.AbcSmsEmailEnviar.DateTime> = Y.DATE:Y.TIME
        MENSAJE = "EMAIL NO ENVIADO: ":ID.SMS.EMAIL:", ":Y.ID.PARAM
        GOSUB BITACORA
    END

    EB.DataAccess.FWrite(FN.SMS.EMAIL,ID.SMS.EMAIL,R.INFO.SMS.EMAIL)


RETURN
**************;* LFCR_20231222_HTML S
LEER.HTML.FILE:
**************

    Y.FILE.PATH = Y.RUTA.HTML
    Y.HTML.TEMPLATE = Y.HTML.FILE.NAME
    OPENSEQ Y.FILE.PATH:"/" :Y.HTML.TEMPLATE READONLY TO FILE.RECORD THEN
        LOOP
            READSEQ Y.LINE FROM FILE.RECORD THEN STATE = STATUS() ELSE EXIT
        UNTIL STATE = 1
            Y.STR.EMAIL := Y.LINE : CHAR(10)
        REPEAT
    END

RETURN          ;* LFCR_20231222_HTML E
**************
FORMATO.EMAIL:
**************

    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL, 'razonSocialFull',Y.RAZON.SOCIAL)       ;* 20241029_RZN.SCL S - E
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,'"','\"')  ;* LFCR_20231222_HTML S
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&iexcl;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&aacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&eacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&iacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&oacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&uacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&ntilde;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&Aacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&Eacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&Iacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&Oacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&Uacute;')
    Y.STR.EMAIL = EREPLACE(Y.STR.EMAIL,UTF8('�'),'&Ntilde;')          ;* LFCR_20231222_HTML E


RETURN

*********
BITACORA:
*********

    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR2 ELSE
    END
    MENSAJE = ''
RETURN

END

