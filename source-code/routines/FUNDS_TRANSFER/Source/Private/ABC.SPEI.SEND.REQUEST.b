* @ValidationCode : MjotMjQwNDA0NDQ0OkNwMTI1MjoxNzQ0ODM1ODgyMTkzOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 15:38:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.SPEI.SEND.REQUEST(Y.CD.SHELL, Y.DATOS.ENVIO, Y.RETURNVAL)
*-----------------------------------------------------------------------------
* First Released For: ABC
* First Released:
* Author:             LBASS
*----------------------------------------------------------
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
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
    sGetTODAY = EB.SystemTables.getToday()
    Y.HOY = sGetTODAY

    Y.CADENA.ENVIO = FIELD(Y.DATOS.ENVIO, Y.SEP, 1)
    Y.RUTA.LOG = FIELD(Y.DATOS.ENVIO, Y.SEP, 2)
    Y.PREF.ARCHIVO.LOG = FIELD(Y.DATOS.ENVIO, Y.SEP, 3)
    Y.ID.FT = FIELD(Y.DATOS.ENVIO, Y.SEP, 4)
    Y.ARCHIVO.LOG = Y.RUTA.LOG : Y.SEPA3 : Y.PREF.ARCHIVO.LOG : Y.HOY :".": Y.ID.FT: ".log"
RETURN

********
PROCESS:
********
    Y.SALTO = CHAR(10)
    Y.MENSAJE = Y.SALTO : "--------------------------------------------------------------------------"
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESANDO TRANSACCION ...  " : Y.ID.FT
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    str_path = @PATH
    str_filename = "SPEI":RND(2000000):TIME():".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.CADENA = 'java -jar GenericSOAPClient.jar "' : Y.CADENA.ENVIO : '"' : Y.SALTO

    Y.MENSAJE = "ENVIANDO REQUEST ...  "
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = Y.CADENA
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

* Armo Archivo
    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd " : Y.CD.SHELL : Y.SALTO
    Y.SHELL := Y.CADENA
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "chmod 777 ./" : str_filename CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "./" : str_filename            CAPTURING Y.RETURNVAL
    EXECUTE "rm ./" : str_filename        CAPTURING Y.RESPONSE.RM

    Y.MENSAJE = "RECIBIENDO RESPUESTA...... "
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = Y.RETURNVAL
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESAMIENTO TERMINADO.  TRANSACCION ...  " : Y.ID.FT
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "--------------------------------------------------------------------------" : Y.SALTO
    ABC.BP.pbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

* PRINT "RETURNVAL  ... " : Y.RETURNVAL
RETURN
END
