*------------------------------------------------------------------------------------
* <Rating>188</Rating>
*------------------------------------------------------------------------------------
    SUBROUTINE ABC.ENVIA.NOTIF.ALTERNA(ID.SMS.EMAIL)
*------------------------------------------------------------------------------------
*===============================================================================
* Desarrollador:        César Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:                2021-04-22
* Descripción:          Rutina que envia la notificacion alterna.
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20220907
* Compania:             ABC Capital
* Fecha:                2022-09-07
* Descripción:          Se crea nuevo flujo para tipo EMAIL.SPEI.DEV
* Si Respuesta de galileo es exitosa
* Cambia estatus en ABC.SMS.EMAIL.ENVIAR a OK
* Autoriza FT
* Si Error al autorizar FT
*  Actualiza el registro de ABC.SMS.EMAIL.ENVIAR a E
*  Ingresa nuevo registro en ABC.SMS.EMAIL.ENVIAR con tipo EMAIL.SPEI.DEV
*  Elimina el FT de INAU
*Respuesta de galileo diferente a success
* Delete del FT
* Se agregan milisegundos en el ID.
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20240202
* Compania:             ABC Capital
* Fecha:                2024-02-02
* Descripción:          CORE-2233 Traspaso de intereses. Se agrega respuesta para la notificacion
* EMAIL.NOTIFICA.TASA, de la versión GROUP.CREDIT.INT,VPM
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20241028
* Compania:             ABC Capital
* Fecha:                2024-10-28
* Descripción:          ABCCORE-3098 Modificación al servicio de notificaciones
*===============================================================================


    $INCLUDE ../T24_BP I_COMMON
    $INCLUDE ../T24_BP I_EQUATE
    $INCLUDE ../T24_BP I_TSA.COMMON
    $INCLUDE ../T24_BP I_ENQUIRY.COMMON
    $INCLUDE ../T24_BP I_GTS.COMMON

    $INCLUDE ../T24_BP I_F.STANDARD.SELECTION

    $INCLUDE ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR

    $INCLUDE ABC.BP I_ABC.ENVIA.NOTIF.ALTERNA.COMMON

    GOSUB INICIALIZA
    GOSUB PROCESO

    RETURN

***********
INICIALIZA:
***********

    Y.STR.EMAIL = ''
    R.INFO.SMS.EMAIL = ''
    SEP = ';'
    Y.DATOS = ''
    Y.FLAG.GALILEO = 0

    Y.TIME = TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]

*CAST20220907.I
    ID.SMS.EMAIL.ORI = ''
**CAST20220907.F
    RETURN

************
PROCESO:
************

    CALL F.READU(FN.SMS.EMAIL,ID.SMS.EMAIL,R.INFO.SMS.EMAIL,F.SMS.EMAIL,ERROR.SMS.EMAIL,'')
    IF ERROR.SMS.EMAIL EQ '' THEN
        Y.CANAL = R.INFO.SMS.EMAIL<ABC.EMA.CANAL>
        Y.NOTI.ALTERNO = R.INFO.SMS.EMAIL<ABC.EMA.NOTIFICA.ALTERNA>
        Y.STATUS.ALTERNO = R.INFO.SMS.EMAIL<ABC.EMA.STATUS.ALTERNA>
        Y.NOTI.GALILEO = R.INFO.SMS.EMAIL<ABC.EMA.NOTIFICA.GALILEO>
        Y.STATUS.GALILEO = R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO>
        Y.PRN = R.INFO.SMS.EMAIL<ABC.EMA.PRN>

        IF Y.NOTI.ALTERNO EQ 'SI' AND Y.STATUS.ALTERNO NE 'OK' THEN
            GOSUB LEE.NOTIFICACION
            GOSUB CREA.ARCHIVO.LOG
            GOSUB ENVIO.ALTERNA
            returnVal = Y.RETURNVAL
            Y.RESPUESTA = FIELD(returnVal,'<TzuneServiceRequestResult>',2)
            Y.RESPUESTA = FIELD(Y.RESPUESTA,'</TzuneServiceRequestResult>',1)
            IF Y.RESPUESTA EQ '{"Status":"Received"}' THEN
                R.INFO.SMS.EMAIL<ABC.EMA.STATUS.ALTERNA> = 'OK'
                R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
                MENSAJE = ID.SMS.EMAIL:", RESPUESTA OK: ":returnVal
                GOSUB BITACORA.ALT
            END ELSE
                IF Y.RESPUESTA EQ '{"Status":"AlreadyUsedCode"}' THEN
                    R.INFO.SMS.EMAIL<ABC.EMA.STATUS.ALTERNA> = 'OKAU'
                    R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
                END
*CAST20240202.I
                IF Y.RESPUESTA EQ '{"status":"success","message":"done"}' THEN
                    R.INFO.SMS.EMAIL<ABC.EMA.STATUS.ALTERNA> = 'OK'
                    R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = LEFT(Y.DATE:Y.TIME,10)
                END
**CAST20240202.F
                MENSAJE = ID.SMS.EMAIL:", RESPUESTA: ":returnVal
                GOSUB BITACORA.ALT
            END

            IF Y.NOTI.GALILEO NE 'SI' OR Y.STATUS.GALILEO EQ 'OK' THEN

                CALL F.WRITE(FN.SMS.EMAIL,ID.SMS.EMAIL,R.INFO.SMS.EMAIL)
*       WRITE R.INFO.SMS.EMAIL TO F.SMS.EMAIL,ID.SMS.EMAIL
            END
        END
        IF Y.NOTI.GALILEO EQ 'SI' AND Y.STATUS.GALILEO NE 'OK' THEN
            GOSUB GENERA.GALILEO
        END
    END

    RETURN

**************
GENERA.GALILEO:
**************

    Y.FLAG.GALILEO = 1
    Y.ID.NOT.ALT.PARAM = "NOTIFICACION.ALTERNA.GALILEO"
    Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
    CALL ABC.GET.GENERAL.PARAM(Y.ID.NOT.ALT.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE Y.CANAL IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.CANAL.GALILEO = Y.LIST.VALUES<Y.POS>
    END

    GOSUB LEE.NOTIFICACION
    GOSUB CREA.ARCHIVO.LOG

    IF Y.CANAL.GALILEO NE '' THEN
        CHANGE 'canal=':Y.CANAL TO 'canal=':Y.CANAL.GALILEO IN Y.DATOS
    END
* CHANGE ID.SMS.EMAIL TO ID.SMS.EMAIL:'.1' IN Y.DATOS
    IF Y.PRN NE '' THEN
        GOSUB ENVIO.ALTERNA
        returnVal = Y.RETURNVAL
        Y.RESPUESTA = FIELD(returnVal,'<TzuneServiceRequestResult>',2)
        Y.RESPUESTA = FIELD(Y.RESPUESTA,'</TzuneServiceRequestResult>',1)
*CAST20241028.I
*         IF Y.RESPUESTA EQ '{"status":"success","message":"done"}' THEN
*             R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'OK'
*             R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
*             MENSAJE = ID.SMS.EMAIL:", RESPUESTA OK: ":returnVal
*             GOSUB BITACORA.ALT
*         END ELSE
*             IF Y.RESPUESTA EQ '{"status":"exception","message":"Duplicate transaction"}' THEN
*                 R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'OKDT'
*                 R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
*             END ELSE
*                 IF Y.RESPUESTA EQ '{"status":"exception","message":"Invalid customer account"}' THEN
*                     R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'E'
*                     R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
*                 END
*             END
*             MENSAJE = ID.SMS.EMAIL:", RESPUESTA: ":returnVal
*             GOSUB BITACORA.ALT
*         END
* Ejemplo de mensaje de respuesta '{"status":"success","message":"done"}'

        Y.MSG.RESPUESTA = FIELD(Y.RESPUESTA,',',2)
        Y.MSG.RESPUESTA = FIELD(Y.MSG.RESPUESTA,':',2)
        Y.MSG.RESPUESTA = FIELD(Y.MSG.RESPUESTA,'"',2)
        Y.NO.MSG.PARAM = DCOUNT(Y.PARAM.MENSAJE.RESPUESTA,FM)
        FOR Y.AA =1 TO Y.NO.MSG.PARAM
            Y.MSG.PARAM = Y.PARAM.MENSAJE.RESPUESTA<Y.AA>
            FINDSTR Y.MSG.PARAM IN Y.MSG.RESPUESTA SETTING Y.FM THEN
                Y.STATUS.RESPUESTA = Y.PARAM.STATUS.RESPUESTA<Y.AA>
                R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = Y.STATUS.RESPUESTA
                R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
                MENSAJE = ID.SMS.EMAIL:', RESPUESTA ':Y.STATUS.RESPUESTA: '= ':returnVal
                GOSUB BITACORA.ALT
                FIND Y.STATUS.RESPUESTA IN Y.STATUS.GENERAN.LOG SETTING Y.FM.2 THEN
                    MENSAJE = ID.SMS.EMAIL:', RESPUESTA ':Y.STATUS.RESPUESTA: '= ':returnVal
                    GOSUB GENERA.BITACORA.ERRORES
                END
            END
        NEXT Y.AA
*CAST20241028.F

*CAST20220907.I
        GOSUB VALIDA.AUTORIZACION.FT
*CAST20220907.F
    END ELSE
        R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'NA'
        R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
        MENSAJE = ID.SMS.EMAIL:", NO TIENE PRN."
        GOSUB BITACORA.ALT
    END
    DISPLAY ID.SMS.EMAIL:', ':R.INFO.SMS.EMAIL
*    WRITE R.INFO.SMS.EMAIL TO F.SMS.EMAIL,ID.SMS.EMAIL
    CALL F.WRITE(FN.SMS.EMAIL,ID.SMS.EMAIL,R.INFO.SMS.EMAIL)

    RETURN

**************
OBTIENE.VALOR:
**************

    CALL F.READ(FN.SS,'ABC.SMS.EMAIL.ENVIAR',R.SS,F.SS,ERROR.SS)
    IF ERROR.SS EQ '' THEN
        Y.LIST.CAMPOS = R.SS<SSL.SYS.FIELD.NAME>
        CONVERT VM TO FM IN Y.LIST.CAMPOS
        Y.LIST.NUM.CAMPOS = R.SS<SSL.SYS.FIELD.NO>
        CONVERT VM TO FM IN Y.LIST.NUM.CAMPOS
        LOCATE Y.NOM.CAMPO IN Y.LIST.CAMPOS SETTING POSITION THEN
            Y.NUM.CAMPO = Y.LIST.NUM.CAMPOS<POSITION>
            Y.VALOR.CAMPO = TRIM(R.INFO.SMS.EMAIL<Y.NUM.CAMPO>)
            Y.VALOR.CAMPO = EREPLACE(Y.VALOR.CAMPO,',','')
        END
    END

    RETURN

**************
ENVIO.ALTERNA:
**************

    str_path = @PATH
    str_filename = "ABC.ENVIA.NOT.ALT.":RND(2000000):TIME():".":AGENT.NUMBER:".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.CADENA = 'java -jar ':Y.JAR:' "':Y.METODO:SEP:Y.HEADER:SEP:Y.URL:SEP:Y.PARAMS:SEP:Y.DATOS:'"'
    MENSAJE = ID.SMS.EMAIL:", Y.CADENA: ":Y.CADENA
    GOSUB BITACORA.ALT

* Armo Archivo
    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := Y.CADENA : Y.SALTO
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        GOSUB BITACORA.ALT
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "chmod 777 ./" : str_filename CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "./" : str_filename            CAPTURING Y.RETURNVAL
    EXECUTE "rm ./" : str_filename        CAPTURING Y.RESPONSE.RM


    RETURN

*****************
LEE.NOTIFICACION:
*****************

    GOSUB LIMPIA.VARIABLES

    IF Y.FLAG.GALILEO EQ 0 THEN
        Y.ID.NOT.ALT.PARAM = "NOTIFICACION.ALTERNA.PARAM.CANAL.":Y.CANAL
        Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
        CALL ABC.GET.GENERAL.PARAM(Y.ID.NOT.ALT.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

        IF Y.LIST.PARAMS EQ '' OR Y.LIST.VALUES EQ '' THEN
            Y.ID.NOT.ALT.PARAM = "NOTIFICACION.ALTERNA.PARAM"
            Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
            CALL ABC.GET.GENERAL.PARAM(Y.ID.NOT.ALT.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
        END
    END ELSE
        Y.ID.NOT.ALT.PARAM = "NOTIFICACION.ALTERNA.GALILEO.PARAM"
        Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
        CALL ABC.GET.GENERAL.PARAM(Y.ID.NOT.ALT.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    END

    LOCATE 'JAR' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.JAR = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'METODO' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.METODO = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'HEADER' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.HEADER = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'URL' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.URL = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'PARAMS' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.PARAMS = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'RUTA.LOG.ALTERNA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.RUTA.LOG.ALT = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'NOMBRE.LOG.ALTERNA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.NOMBRE.LOG.ALT = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'ID.NOT.ALT.FIJOS' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.ID.NOT.ALT.FIJOS = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'ID.NOT.ALT.CAMPOS' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.ID.NOT.ALT.CAMPOS = Y.LIST.VALUES<Y.POS>
    END

*CAST20220907.I
    LOCATE 'ID.NOT.ALT.1.AUT' IN Y.LIST.PARAMS SETTING Y.POS THEN
        ID.NOT.ALT.1.AUT = Y.LIST.VALUES<Y.POS>
        Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
        CALL ABC.GET.GENERAL.PARAM(ID.NOT.ALT.1.AUT, Y.LIST.PARAMS, Y.LIST.VALUES)
        LOCATE 'ID.TIPO.EMAIL' IN Y.LIST.PARAMS SETTING Y.POS THEN
            Y.TIPO.EMAIL.1.AUT = Y.LIST.VALUES<Y.POS>
        END
        LOCATE 'TIPO.EMAIL.VERSION' IN Y.LIST.PARAMS SETTING Y.POS THEN
            Y.TIPO.EMAIL.VERSION = Y.LIST.VALUES<Y.POS>
        END
        LOCATE 'OFS.SOURCE' IN Y.LIST.PARAMS SETTING Y.POS THEN
            Y.OFS.SOURCE = Y.LIST.VALUES<Y.POS>
        END
    END
*CAST20220907.F

    IF Y.RUTA.LOG.ALT EQ '' OR Y.NOMBRE.LOG.ALT EQ '' THEN
        Y.LIST.PARAMS.ER = ''
        Y.LIST.VALUES.ER = ''
        CALL ABC.GET.GENERAL.PARAM('EMAIL.ERROR.LOG', Y.LIST.PARAMS.ER, Y.LIST.VALUES.ER)

        IF Y.RUTA.LOG.ALT EQ '' THEN
            LOCATE "RUTA.LOG.ALTERNA" IN Y.LIST.PARAMS.ER SETTING POS THEN
                Y.RUTA.LOG.ALT = Y.LIST.VALUES.ER<POS>
            END
        END

        IF Y.NOMBRE.LOG.ALT EQ '' THEN
            LOCATE "NOMBRE.LOG.ALTERNA" IN Y.LIST.PARAMS.ER SETTING POS THEN
                Y.NOMBRE.LOG.ALT = Y.LIST.VALUES.ER<POS>
            END
        END
    END

    Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
    CALL ABC.GET.GENERAL.PARAM(Y.ID.NOT.ALT.FIJOS, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.NO.FIJOS = DCOUNT(Y.LIST.PARAMS, FM)

    FOR X = 1 TO Y.NO.FIJOS
        Y.DATOS := Y.LIST.PARAMS<X>:'=':Y.LIST.VALUES<X>:','
    NEXT X

    Y.LIST.PARAMS = ''; Y.LIST.VALUES = '';
    CALL ABC.GET.GENERAL.PARAM(Y.ID.NOT.ALT.CAMPOS, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.NO.CAMPOS = DCOUNT(Y.LIST.PARAMS, FM)

    FOR X = 1 TO Y.NO.CAMPOS
        Y.NOM.CAMPO = Y.LIST.VALUES<X>
        IF Y.NOM.CAMPO EQ '@ID' THEN
            Y.VALOR.CAMPO = ID.SMS.EMAIL
        END ELSE
            GOSUB OBTIENE.VALOR
        END
        Y.DATOS := Y.LIST.PARAMS<X>:'=':Y.VALOR.CAMPO:
        IF X NE Y.NO.CAMPOS THEN Y.DATOS := ','
    NEXT X

    RETURN

*********************
LIMPIA.VARIABLES:
*********************

    Y.JAR = ''
    Y.METODO = ''
    Y.HEADER = ''
    Y.URL = ''
    Y.PARAMS = ''
    Y.RUTA.LOG.ALT = ''
    Y.NOMBRE.LOG.ALT = ''
    Y.ID.NOT.ALT.FIJOS = ''
    Y.ID.NOT.ALT.CAMPOS = ''
    Y.NO.FIJOS = 0
    Y.DATOS = ''
    Y.NO.CAMPOS = 0

    RETURN

*********************
CREA.ARCHIVO.LOG:
*********************

    str_filename.ALT = Y.NOMBRE.LOG.ALT:"." : FECHA.FILE : "." : AGENT.NUMBER : ".log"
    SEQ.FILE.NAME.ALT = Y.RUTA.LOG.ALT : "/"

    OPENSEQ SEQ.FILE.NAME.ALT,str_filename.ALT TO FILE.VAR.ALT ELSE
        CREATE FILE.VAR.ALT ELSE
        END
    END

    RETURN

*************
BITACORA.ALT:
*************

    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR.ALT ELSE
    END
    MENSAJE = ''

    RETURN

*CAST20220907.I
*----------------------------------------------------------------------
VALIDA.AUTORIZACION.FT:
*----------------------------------------------------------------------

*Validamos que el tipo de notificación esté configurado
    Y.TIPO.EMAIL = R.INFO.SMS.EMAIL<ABC.EMA.TIPO.EMAIL>:'|'
    Y.FM.POS=''; Y.VM.POS=''
    FINDSTR Y.TIPO.EMAIL IN Y.TIPO.EMAIL.1.AUT SETTING Y.FM.POS, Y.VM.POS THEN
        Y.TIPO.EMAIL.REV = FIELD(Y.TIPO.EMAIL.1.AUT<Y.FM.POS, Y.VM.POS>,'|',2)
*Valida estatus GALILEO
        IF  R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> EQ '' THEN
            IF Y.RESPUESTA EQ '{"status":"exception","message":"Insufficient balance for cascading transaction"}' THEN
                R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'E'
                R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
            END
        END

        IF R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> EQ 'E' THEN
*Elimina FT
            Y.APL.OFSFUNCTION = 'D'
            GOSUB ENVIA.OFS.FT
        END
        IF R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> EQ 'OK' OR R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> EQ 'OKDT' THEN
            Y.ID.FT = R.INFO.SMS.EMAIL<ABC.EMA.REFERENCIA>
            R.FT.NAU = ''
            CALL F.READ(FN.FT.NAU,Y.ID.FT,R.FT.NAU,F.FT.NAU,Y.ERR.FT.NAU)
            IF R.FT.NAU THEN
*Autoriza FT
                Y.APL.OFSFUNCTION = 'A'
                GOSUB ENVIA.OFS.FT
            END ELSE
                R.FT = ''
                CALL F.READ(FN.FT,Y.ID.FT,R.FT,F.FT,Y.ERR.FT)
                IF R.FT THEN
                    MENSAJE = ID.SMS.EMAIL:", ERROR EN AUTORIZACION DE FT " : Y.ID.FT : " YA ESTABA AUTORIZADO"
                    GOSUB BITACORA.ALT
                END ELSE
                    R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'ED'
                    R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
                    MENSAJE = ID.SMS.EMAIL:", ERROR EN AUTORIZACION DE FT " : Y.ID.FT : " NO EXISTE EN INAU NI EN LIVE"
                    GOSUB BITACORA.ALT
                END
            END
        END
    END


    RETURN
*----------------------------------------------------------------------
*----------------------------------------------------------------------
ENVIA.OFS.FT:
*----------------------------------------------------------------------

    Y.APLICACION.OFS = 'FUNDS.TRANSFER'
    Y.PROCESS = 'PROCESS'
    Y.FM.POS=''; Y.VM.POS=''
    FINDSTR Y.TIPO.EMAIL IN Y.TIPO.EMAIL.VERSION SETTING Y.FM.POS, Y.VM.POS THEN
        Y.VERSION = FIELD(Y.TIPO.EMAIL.VERSION<Y.FM.POS, Y.VM.POS>,'|',2)
        Y.VERSION = Y.APLICACION.OFS:',':Y.VERSION
    END
    Y.GTSMODE = ''
    Y.NO.OF.AUTH = 0
    Y.ID.TRANSACTION = R.INFO.SMS.EMAIL<ABC.EMA.REFERENCIA>
    R.FT = ''
    Y.OFS.REQUEST = ''
    CALL OFS.BUILD.RECORD(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.FT,Y.OFS.REQUEST)
    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
    CALL OFS.CALL.BULK.MANAGER(options,Y.OFS.REQUEST,theResponse,txnCommitted)

    Y.ID.SEND.OFS     = ''
    Y.RESPONSE.OFS = ''
    Y.ID.SEND.OFS    =  TRIM(FIELD(theResponse, '/', 1))
    Y.RESPONSE.OFS = TRIM(FIELD(theResponse, '/', 3))
    Y.RESPONSE.OFS = TRIM(FIELD(Y.RESPONSE.OFS,",",1))
    IF Y.RESPONSE.OFS NE 1 THEN
        IF Y.APL.OFSFUNCTION EQ 'A' THEN
            R.INFO.SMS.EMAIL<ABC.EMA.STATUS.GALILEO> = 'E'
            R.INFO.SMS.EMAIL<ABC.EMA.DATE.TIME> = Y.DATE:Y.TIME
            MENSAJE = ID.SMS.EMAIL:", ERROR EN AUTORIZACION DE FT " :theResponse
            GOSUB BITACORA.ALT
            GOSUB CREA.NOTIFICACION.REVERSO
            Y.APL.OFSFUNCTION = 'D'
            GOSUB ENVIA.OFS.FT
        END ELSE
            MENSAJE = ID.SMS.EMAIL:", ERROR EN ELIMINACION DE FT " : theResponse
            GOSUB BITACORA.ALT
        END
    END

    RETURN
*----------------------------------------------------------------------
*----------------------------------------------------------------------
CREA.NOTIFICACION.REVERSO:
*----------------------------------------------------------------------
    ID.SMS.EMAIL.ORI = ID.SMS.EMAIL

    BEGIN CASE
    CASE Y.TIPO.EMAIL.REV EQ 'EMAIL.SPEI.DEV'
        CALL ABC.ENV.EMAIL.SPEI.DEV
    END CASE

    RETURN
*----------------------------------------------------------------------
*CAST20220907.F



*----------------------------------------------------------------------
GENERA.BITACORA.ERRORES:
*----------------------------------------------------------------------
*CAST20241028.I
    str_filename.ALT.ERROR = Y.NOMBRE.LOG.ALT:".ERROR." : FECHA.FILE : "." : AGENT.NUMBER : ".log"
    SEQ.FILE.NAME.ALT.ERROR = Y.RUTA.LOG.ALT : "/"

    OPENSEQ SEQ.FILE.NAME.ALT.ERROR,str_filename.ALT.ERROR TO FILE.VAR.ALT.ERROR ELSE
        CREATE FILE.VAR.ALT.ERROR ELSE
        END
    END


    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR.ALT.ERROR ELSE
    END
    MENSAJE = ''

*CAST20241028.F

    RETURN
*----------------------------------------------------------------------

END
