*-----------------------------------------------------------------------------
* <Rating>-49</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.VALIDA.DIGITO.TARJETA

*-------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.ErrorProcessing
    
    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN
********
PROCESS:
********

    IF EB.SystemTables.getComi() NE '' THEN
        IF NUM(Y.TARJETA) THEN
            IF NOT(LEN(Y.TARJETA) EQ '13' OR LEN(Y.TARJETA) EQ '15' OR LEN(Y.TARJETA) EQ '16') THEN
                ETEXT = "Longitud de tarjeta no vda"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                EB.SystemTables.setComi('')
                RETURN
            END ELSE
                GOSUB VALIDATION
            END
        END ELSE
            ETEXT = "La narrativa debe ser nmerica"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            EB.SystemTables.setComi('')
            RETURN
        END
    END

    RETURN
***********
VALIDATION:
***********

    FOR YIND =1 TO Y.LEN
        YVALOR = Y.TARJETA[YIND,1]
        YVAL2  = YVALOR*2
        YRES = YIND - (YIND/2)
        IF LEN(YRES) EQ 1 THEN
            YTOTAL += YVALOR
        END ELSE
            IF YVAL2 GT 9 THEN
                YVAL2 = YVAL2-9
            END
            YTOTAL += YVAL2
        END
    NEXT YIND

    YLIST = YTOTAL
    YRESULTADO = MOD(YLIST, 10)
    IF (YRESULTADO EQ 0) AND (YLIST LT 150) THEN
        MENSAJE = "NO. TARJETA ACEPTADA"
    END ELSE
        ETEXT = "No. de Tarjeta no vdo"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        EB.SystemTables.setComi('')
        RETURN
    END

    RETURN
***********
INITIALIZE:
***********

    Y.TARJETA = ""
    Y.LEN = ""
    YARRAY = ""

    Y.TARJETA = EB.SystemTables.getComi()          
    Y.LEN = LEN(Y.TARJETA)    
    YCONST.SEP  = "____"
    YSEP = "_"
    YTOTAL = ""
    MENSAJE = ""
    YLIST = ""

    RETURN
**********
END




