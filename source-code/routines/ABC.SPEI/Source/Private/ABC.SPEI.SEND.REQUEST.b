$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.SEND.REQUEST(Y.CD.SHELL, Y.DATOS.ENVIO, Y.RETURNVAL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    GOSUB INIT.VARS
    GOSUB PROCESS
    RETURN

**********
INIT.VARS:
**********
    Y.SEP = "|"
    YSEP.ORI = ";"
    Y.SEPA3 = "/"
    Y.HOY = EB.SystemTables.getToday()

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
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESANDO TRANSACCION ...  " : Y.ID.FT
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    str_path = @PATH
    str_filename = "SPEI":RND(2000000):TIME():".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.CADENA = 'java -jar generic-soap-client-1.0-SNAPSHOT-jar-with-dependencies.jar "' : Y.CADENA.ENVIO : '"' : Y.SALTO

    Y.MENSAJE = "ENVIANDO REQUEST ...  "
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = Y.CADENA
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

* Armo Archivo, comentada primera linea no necesaria
*    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd " : Y.CD.SHELL : Y.SALTO
    Y.SHELL := Y.CADENA
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    Y.EXECUTE.CHMOD = "SH -c chmod 777 " : TEMP.FILE
    EXECUTE Y.EXECUTE.CHMOD

    Y.EXECUTE.SCRIPT = "SH -c " : TEMP.FILE
    EXECUTE Y.EXECUTE.SCRIPT CAPTURING Y.RETURNVAL
    EXECUTE "SH -c rm " : TEMP.FILE

    Y.MENSAJE = "RECIBIENDO RESPUESTA...... "
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "RESPUESTA : " : Y.RETURNVAL
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESAMIENTO TERMINADO.  TRANSACCION ...  " : Y.ID.FT
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "--------------------------------------------------------------------------" : Y.SALTO
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    RETURN
END 