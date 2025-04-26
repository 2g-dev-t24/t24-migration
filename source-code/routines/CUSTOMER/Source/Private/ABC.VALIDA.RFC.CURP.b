$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.RFC.CURP(Y.RFC,Y.CURP,TIPO.PERSONA,Y.ERR)
*===============================================================================
* Desarrollador:        
* Compania:             
* Fecha:                
* Descripción:          Rutina que valida el formato de RFC o CURP según el tipo
*                       de persona.
*Parámetros:            Entrada:
*                       Y.RFC - Contiene el valor del RFC
*                       Y.CURP - Contiene el valor del CURP
*                       TIPO.PERSONA - Contiene el valor del tipo de persona.
*                       Salida:
*                       Y.ERR - Indica el error si es que existe.
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.Interface
    $USING AbcTable

    GOSUB INICIALIZA
    GOSUB OBTIENE.DATO.VAL


    RETURN

***********
INICIALIZA:
***********

    Y.ERR = ''
    FN.ABC.ESTADO  = 'F.ABC.ESTADO'
    F.ABC.ESTADO   = ''
    EB.DataAccess.Opf(FN.ABC.ESTADO,F.ABC.ESTADO)

    RETURN

*****************
OBTIENE.DATO.VAL:
*****************

    IF Y.RFC NE '' AND Y.ERR EQ '' THEN
        GOSUB VALIDA.RFC
    END
    IF Y.CURP NE '' AND Y.ERR EQ '' THEN
        GOSUB VALIDA.CURP
    END

    RETURN

***********
VALIDA.RFC:
***********

    IF TIPO.PERSONA LE 2 THEN
        IF (LEN(Y.RFC) EQ 13) THEN

            Y.INI.RFC = Y.RFC[1,4]
            Y.FECHA.RFC = Y.RFC[5,6]
            Y.MM.RFC = Y.FECHA.RFC[3,2]
            Y.DD.RFC = Y.FECHA.RFC[5,2]
            Y.HOMOCLAVE = Y.RFC[11,3]

            GOSUB VALIDA.DATOS.RFC

        END ELSE
            Y.ERR = 'EL RFC NO TIENE LA LONGITUD CORRECTA'
            RETURN
        END
    END ELSE
        IF (LEN(Y.RFC) EQ 12) THEN
            Y.INI.RFC = Y.RFC[1,3]
            Y.FECHA.RFC = Y.RFC[4,6]
            Y.MM.RFC = Y.FECHA.RFC[3,2]
            Y.DD.RFC = Y.FECHA.RFC[5,2]
            Y.HOMOCLAVE = Y.RFC[10,3]

            GOSUB VALIDA.DATOS.RFC

        END ELSE
            Y.ERR = 'EL RFC NO TIENE LA LONGITUD CORRECTA'
            RETURN
        END
    END

    RETURN

************
VALIDA.CURP:
************

    IF TIPO.PERSONA LE 2 THEN
        IF (LEN(Y.CURP) EQ 18) THEN

            Y.INI = Y.CURP[1,4]
            Y.FECHA = Y.CURP[5,6]
            Y.MM = Y.FECHA[3,2]
            Y.DD = Y.FECHA[5,2]
            Y.SEXO = Y.CURP[11,1]
            Y.ENTIDAD = Y.CURP[12,2]
            Y.CONS.INT = Y.CURP[14,3]
            Y.DIFERENCIADOR = Y.CURP[17,1]
            Y.DIG.VERIFICADOR = Y.CURP[18,1]

            GOSUB VALIDA.DATOS.CURP

        END ELSE
            Y.ERR = 'EL CURP NO TIENE LA LONGITUD CORRECTA'
            RETURN
        END
    END ELSE
        Y.ERR = 'ESTE TIPO DE PERSONA NO TIENE CURP'
        RETURN
    END

    RETURN

*****************
VALIDA.DATOS.RFC:
*****************

    Y.INI.RFC.LEN = LEN(Y.INI.RFC)

    FOR X = 1 TO Y.INI.RFC.LEN
        Y.CHAR = ''
        Y.VAL = '0'
        Y.CHAR = Y.INI.RFC[X,1]
        Y.CHAR.NUM = SEQ(Y.CHAR)
        GOSUB VALIDA.LETRAS.ASCII
        GOSUB VALIDA.209.ASCII
        GOSUB VALIDA.CARACTERES.ASCII
        IF Y.VAL EQ '0' THEN Y.ERR = '1'
    NEXT X

    IF NOT(NUM(Y.FECHA.RFC)) THEN
        Y.ERR = '1'
    END ELSE
        IF (Y.MM.RFC < 1) OR (Y.MM.RFC > 12) THEN
            Y.ERR = '1'
        END ELSE
            IF Y.MM.RFC = 1 OR Y.MM.RFC = 3 OR Y.MM.RFC = 5 OR Y.MM.RFC = 7 OR Y.MM.RFC = 8 OR Y.MM.RFC = 10 OR Y.MM.RFC = 12 THEN
                IF (Y.DD.RFC < 1) OR (Y.DD.RFC > 31) THEN
                    Y.ERR = '1'
                END
            END ELSE
                IF Y.MM.RFC = 4 OR Y.MM.RFC = 6 OR Y.MM.RFC = 9 OR Y.MM.RFC = 11 THEN
                    IF (Y.DD.RFC < 1) OR (Y.DD.RFC > 30) THEN
                        Y.ERR = '1'
                    END
                END ELSE
                    IF (Y.DD.RFC < 1) OR (Y.DD.RFC > 29) THEN
                        Y.ERR = '1'
                    END
                END
            END
        END
    END

    Y.HOMOCLAVE.LEN = LEN(Y.HOMOCLAVE)

    FOR X = 1 TO Y.HOMOCLAVE.LEN
        Y.CHAR = ''
        Y.VAL = '0'
        Y.CHAR = Y.HOMOCLAVE[X,1]
        Y.CHAR.NUM = SEQ(Y.CHAR)
        GOSUB VALIDA.LETRAS.ASCII
        GOSUB VALIDA.NUMEROS.ASCII
        IF Y.VAL EQ '0' THEN Y.ERR = '1'
    NEXT X

    IF Y.ERR EQ '1' THEN
        Y.ERR = 'EL RFC NO TIENE EL FORMATO CORRECTO'
        RETURN
    END

    RETURN

******************
VALIDA.DATOS.CURP:
******************

    Y.INI.LEN = LEN(Y.INI)

    FOR X = 1 TO Y.INI.LEN
        Y.CHAR = ''
        Y.VAL = '0'
        Y.CHAR = Y.INI[X,1]
        Y.CHAR.NUM = SEQ(Y.CHAR)
        GOSUB VALIDA.LETRAS.ASCII
        GOSUB VALIDA.209.ASCII
        IF Y.VAL EQ '0' THEN Y.ERR = '1'
    NEXT X

    IF NOT(NUM(Y.FECHA)) THEN
        Y.ERR = '1'
    END ELSE
        IF (Y.MM < 1) OR (Y.MM > 12) THEN
            Y.ERR = '1'
        END ELSE
            IF Y.MM = 1 OR Y.MM = 3 OR Y.MM = 5 OR Y.MM = 7 OR Y.MM = 8 OR Y.MM = 10 OR Y.MM = 12 THEN
                IF (Y.DD < 1) OR (Y.DD > 31) THEN
                    Y.ERR = '1'
                END
            END ELSE
                IF Y.MM = 4 OR Y.MM = 6 OR Y.MM = 9 OR Y.MM = 11 THEN
                    IF (Y.DD < 1) OR (Y.DD > 30) THEN
                        Y.ERR = '1'
                    END
                END ELSE
                    IF (Y.DD < 1) OR (Y.DD > 29) THEN
                        Y.ERR = '1'
                    END
                END
            END
        END
    END

    IF Y.SEXO EQ 'H' OR Y.SEXO EQ 'M' ELSE
        Y.ERR = '1'
    END

    SELECT.CMD = "SELECT ":FN.ABC.ESTADO:" WITH CLAVE EQ ":DQUOTE(Y.ENTIDAD)  ; * ITSS - SUBDRAM - Added DQUOTE
    EB.DataAccess.Readlist(SELECT.CMD, EDO.LIST, '', EDO.NO, '')
    IF EDO.NO LE 0 THEN
        Y.ERR = '1'
    END

    Y.CONS.INT.LEN = LEN(Y.CONS.INT)

    FOR X = 1 TO Y.CONS.INT.LEN
        Y.CHAR = ''
        Y.VAL = '0'
        Y.CHAR = Y.CONS.INT[X,1]
        Y.CHAR.NUM = SEQ(Y.CHAR)
        GOSUB VALIDA.LETRAS.ASCII
        IF Y.VAL EQ '0' THEN Y.ERR = '1'
    NEXT X


    Y.VAL = '0'
    Y.CHAR.NUM = SEQ(Y.DIFERENCIADOR)
    GOSUB VALIDA.LETRAS.ASCII
    GOSUB VALIDA.209.ASCII
    GOSUB VALIDA.NUMEROS.ASCII
    IF Y.VAL EQ '0' THEN Y.ERR = '1'

    Y.VAL = '0'
    Y.CHAR.NUM = SEQ(Y.DIG.VERIFICADOR)
    GOSUB VALIDA.LETRAS.ASCII
    GOSUB VALIDA.209.ASCII
    GOSUB VALIDA.NUMEROS.ASCII
    IF Y.VAL EQ '0' THEN Y.ERR = '1'

    IF Y.ERR EQ '1' THEN
        Y.ERR = 'EL CURP NO TIENE EL FORMATO CORRECTO'
        RETURN
    END

    RETURN

********************
VALIDA.LETRAS.ASCII:
********************

    IF Y.CHAR.NUM GE 65 AND Y.CHAR.NUM LE 90 THEN Y.VAL = '1'

    RETURN

*********************
VALIDA.NUMEROS.ASCII:
*********************

    IF Y.CHAR.NUM GE 48 AND Y.CHAR.NUM LE 57 THEN Y.VAL = '1'

    RETURN

****************
VALIDA.209.ASCII:
****************

    IF Y.CHAR.NUM EQ 209 THEN Y.VAL = '1'

    RETURN

************************
VALIDA.CARACTERES.ASCII:
************************

    IF Y.CHAR.NUM EQ 38 THEN Y.VAL = '1'

    RETURN

END
