$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.SEND.REQUEST(Y.CD.SHELL, Y.DATOS.ENVIO, Y.RETURNVAL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    GOSUB INIT.VARS
    GOSUB PROCESS
    RETURN

**********
INIT.VARS:
**********
    Y.SEP = "|"
    YSEP.ORI = ";"
    Y.SEPA3 = "/"
    Y.HOY = TODAY

    Y.CADENA.ENVIO = FIELD(Y.DATOS.ENVIO, Y.SEP, 1)
    Y.RUTA.LOG = FIELD(Y.DATOS.ENVIO, Y.SEP, 2)
    Y.PREF.ARCHIVO.LOG = FIELD(Y.DATOS.ENVIO, Y.SEP, 3)
    Y.ID.FT = FIELD(Y.DATOS.ENVIO, Y.SEP, 4)
    Y.ARCHIVO.LOG = Y.RUTA.LOG : Y.SEPA3 : Y.PREF.ARCHIVO.LOG : Y.HOY : ".": Y.ID.FT: ".log"
    RETURN

********
PROCESS:
********
    Y.SALTO = CHAR(10)
    Y.MENSAJE = Y.SALTO : "--------------------------------------------------------------------------"
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESANDO TRANSACCION ...  " : Y.ID.FT
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    str_path = @PATH
    str_filename = "SPEI":RND(2000000):TIME():".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.CADENA = 'java -jar GenericSOAPClient.jar "' : Y.CADENA.ENVIO : '"' : Y.SALTO

    Y.MENSAJE = "ENVIANDO REQUEST ...  "
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = Y.CADENA
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

* Armo Archivo
    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd " : Y.CD.SHELL : Y.SALTO
    Y.SHELL := Y.CADENA
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "chmod 777 ./" : str_filename CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "./" : str_filename            CAPTURING Y.RETURNVAL
    EXECUTE "rm ./" : str_filename        CAPTURING Y.RESPONSE.RM

    Y.MENSAJE = "RECIBIENDO RESPUESTA...... "
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = Y.RETURNVAL
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESAMIENTO TERMINADO.  TRANSACCION ...  " : Y.ID.FT
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "--------------------------------------------------------------------------" : Y.SALTO
    CALL PBS.INSLOG(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

* PRINT "RETURNVAL  ... " : Y.RETURNVAL
    RETURN
END 