$PACKAGE ABC.BP
********************************************
    SUBROUTINE ABC.V.CUST.FECHA.NAC

********************************************
* RUTINA : 
* AUTOR  :
* FECHA  : 
*
* VALIDA FECHA DE NACIMIENTO:
*    SI ES MENOR A 18 AS ENVIA UN MENSAJE
*
*
* NOTAS:
*     DEBE CREAR UN REGISTRO EN PGM.FILE
*     PARA PODERLO USAR EN UNA VERSION
********************************************
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer


    IF EB.SystemTables.getMessage() NE 'VAL' THEN
        GOSUB VALIDA
    END

    RETURN


VALIDA:

    Y.FECHA.NAC = EB.SystemTables.getComi()

    Y.NVA.FECHA = EB.SystemTables.getToday() - Y.FECHA.NAC

    IF LEN(Y.NVA.FECHA) GT 5 THEN
      Y.YEARS = Y.NVA.FECHA[1,2]
    END
    ELSE
      Y.YEARS = Y.NVA.FECHA[1,1]
    END

    IF Y.YEARS LT 18 THEN
        ETEXT = "CLIENTE TIENE EDAD INFERIOR A LOS 18"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
END
