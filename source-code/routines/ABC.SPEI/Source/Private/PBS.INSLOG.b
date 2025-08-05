$PACKAGE AbcSpei
SUBROUTINE PBS.INSLOG(Y.ARCHIVO.GUARDAR, Y.MENSAJE, Y.INICIANDO)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    
    Y.HORA.LOG = OCONV(TIME(), "MTS")
    Y.HOY = EB.SystemTables.getToday()

    Y.LT = "<"
    Y.TAB = CHAR(9)
    Y.ENTER = CHAR(13)
    Y.SEP3 = "/"
    Y.PATH.ARCH.LOG = Y.ARCHIVO.GUARDAR
    Y.RUTA = ""
    Y.NUM.SLASHS = DCOUNT(Y.ARCHIVO.GUARDAR, Y.SEP3)
    FOR Y.I = 1 TO Y.NUM.SLASHS - 1
        Y.RUTA := FIELDS(Y.ARCHIVO.GUARDAR, Y.SEP3, Y.I) : Y.SEP3
    NEXT Y.I

    IF Y.INICIANDO EQ 1 THEN
        DELETESEQ Y.PATH.ARCH.LOG ELSE NULL
    END

    OPENSEQ Y.PATH.ARCH.LOG TO F.ARCHIVO.LOG ELSE
        EXECUTE "mkdir -p " : Y.RUTA
        CREATE F.ARCHIVO.LOG ELSE
            ETEXT = "Ruta o archivo inexistente" : Y.PATH.ARCH.LOG
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

    Y.MENSAJE = Y.HOY : " - " : Y.HORA.LOG : " - " : Y.MENSAJE
    WRITESEQ Y.MENSAJE APPEND TO F.ARCHIVO.LOG ELSE
        ETEXT = "No se logro crear el archivo"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    CLOSESEQ F.ARCHIVO.LOG
    RETURN
END 