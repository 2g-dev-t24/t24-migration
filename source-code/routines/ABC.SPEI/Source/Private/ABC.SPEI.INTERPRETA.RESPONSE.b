$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.INTERPRETA.RESPONSE(Y.RESPONSE, Y.MESSAGE.OUT)
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
    Y.MESSAGE.OUT = ""
    Y.DESC.MENSAJE = ""
    Y.SEPARA.MENSAJE = "TRANSACTION "
    Y.SEPARA.NUMBER = " "
    Y.INI.MENSAJE = "("
    Y.FIN.MENSAJE = ")"
    RETURN

********
PROCESS:
********
    Y.MENSAJE = FIELD(Y.RESPONSE,Y.SEPARA.MENSAJE,2)
    Y.NUM.MENSAJE = FIELD(Y.MENSAJE, Y.SEPARA.NUMBER,1)
    IF Y.NUM.MENSAJE EQ "OK" THEN
        Y.NUM.MENSAJE = "0"
    END ELSE
        IF Y.NUM.MENSAJE EQ "ERROR" THEN
            Y.NUM.MENSAJE = "-1"
            Y.DESC.MENSAJE = FIELD(Y.MENSAJE, Y.INI.MENSAJE,2)
            Y.DESC.MENSAJE = FIELD(Y.DESC.MENSAJE, Y.FIN.MENSAJE,1)
        END ELSE
            Y.NUM.MENSAJE = ""
        END
    END
    Y.MESSAGE.OUT = Y.NUM.MENSAJE : "/" : Y.DESC.MENSAJE
    IF Y.NUM.MENSAJE EQ '' AND Y.DESC.MENSAJE EQ '' THEN Y.MESSAGE.OUT = '-1/':Y.RESPONSE
    RETURN
END 