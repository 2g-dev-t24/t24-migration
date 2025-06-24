$PACKAGE AbcSpei

SUBROUTINE ABC.2BR.RTN.VALIDA.RFC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------
    
    Y.RFC = EB.SystemTables.getComi()

    Y.TODAY = EB.SystemTables.getToday()

    IF LEN(Y.RFC) EQ 0 THEN
      RETURN
    END

    IF LEN(Y.RFC) EQ 12 THEN
        Y.TIPO.CTE = 3
    END ELSE
        Y.TIPO.CTE = 1
    END

    IF (Y.TIPO.CTE LT 3) THEN
        IF (LEN(Y.RFC) NE 13) AND (LEN(Y.RFC) NE 10) THEN
            V.ERROR.MSG = "LONGITUD DE RFC INVALIDO"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
            RETURN
        END

        Y.ALF = Y.RFC[1,4]
        Y.FECHA = Y.RFC[5,6]
        IF NOT(Y.FECHA  MATCH '6N') THEN
            V.ERROR.MSG = "ERROR EN FECHA"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END

        Y.AA = Y.RFC[5,2]
        Y.MM = Y.RFC[7,2]
        Y.DD = Y.RFC[9,2]

        Y.ALF.1 = Y.ALF[1,1]
        Y.ALF.2 = Y.ALF[2,1]
        Y.ALF.3 = Y.ALF[3,1]
        Y.ALF.4 = Y.ALF[4,1]

        YASCII.ALF.1 = SEQ(Y.ALF.1)
        YASCII.ALF.2 = SEQ(Y.ALF.2)
        YASCII.ALF.3 = SEQ(Y.ALF.3)
        YASCII.ALF.4 = SEQ(Y.ALF.4)

        YASCII.ALF.1.OK = 1
        YASCII.ALF.2.OK = 1
        YASCII.ALF.3.OK = 1
        YASCII.ALF.4.OK = 1

        IF NOT((YASCII.ALF.1 GE 65 AND YASCII.ALF.1 LE 90) OR (YASCII.ALF.1 EQ 209)) THEN YASCII.ALF.1.OK = 0
        IF NOT((YASCII.ALF.2 GE 65 AND YASCII.ALF.2 LE 90) OR (YASCII.ALF.2 EQ 209)) THEN YASCII.ALF.2.OK = 0
        IF NOT((YASCII.ALF.3 GE 65 AND YASCII.ALF.3 LE 90) OR (YASCII.ALF.3 EQ 209)) THEN YASCII.ALF.3.OK = 0
        IF NOT((YASCII.ALF.4 GE 65 AND YASCII.ALF.4 LE 90) OR (YASCII.ALF.4 EQ 209)) THEN YASCII.ALF.4.OK = 0

        IF NOT(YASCII.ALF.1.OK AND YASCII.ALF.2.OK AND YASCII.ALF.3.OK AND YASCII.ALF.4.OK) THEN

            V.ERROR.MSG = "PRIMEROS 4 CARACTERES DEBEN SER LETRAS"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END

    END
    ELSE

        IF (LEN(Y.RFC) NE 12) THEN
            V.ERROR.MSG = "LONGITUD DE RFC INVALIDO"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END

        Y.ALF = Y.RFC[1,3]
        Y.FECHA = Y.RFC[4,6]
        IF NOT(Y.FECHA MATCH '6N') THEN
            V.ERROR.MSG = "ERROR EN FECHA"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END

        Y.ALF.1 = Y.ALF[1,1]
        Y.ALF.2 = Y.ALF[2,1]
        Y.ALF.3 = Y.ALF[3,1]

        YASCII.ALF.1.OK = 1
        YASCII.ALF.2.OK = 1
        YASCII.ALF.3.OK = 1

        YASCII.ALF.1 = SEQ(Y.ALF.1)
        YASCII.ALF.2 = SEQ(Y.ALF.2)
        YASCII.ALF.3 = SEQ(Y.ALF.3)

        IF NOT((YASCII.ALF.1 GE 65 AND YASCII.ALF.1 LE 90) OR (YASCII.ALF.1 EQ 209)) THEN YASCII.ALF.1.OK = 0
        IF NOT((YASCII.ALF.2 GE 65 AND YASCII.ALF.2 LE 90) OR (YASCII.ALF.2 EQ 209)) THEN YASCII.ALF.2.OK = 0
        IF NOT((YASCII.ALF.3 GE 65 AND YASCII.ALF.3 LE 90) OR (YASCII.ALF.3 EQ 209)) THEN YASCII.ALF.3.OK = 0

        IF NOT(YASCII.ALF.1.OK AND YASCII.ALF.2.OK AND YASCII.ALF.3.OK) THEN
            V.ERROR.MSG = "PRIMEROS 3 CARACTERES DEBEN SER LETRAS"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END

        Y.AA = Y.RFC[4,2]
        Y.MM = Y.RFC[6,2]
        Y.DD = Y.RFC[8,2]
    END

    GOSUB VALIDA.FECHA.RFC
    GOSUB VALIDA.HOMOCLAVE

    RETURN

*---------------------------------------------------------------
VALIDA.FECHA.RFC:
*---------------------------------------------------------------

    IF Y.AA LT 20 THEN
        Y.AAAA = 2000 + Y.AA
    END ELSE
        Y.AAAA = 1900 + Y.AA
    END

    IF (Y.MM LT 1) OR (Y.MM GT 12) THEN
        V.ERROR.MSG = "MES INVALIDO EN RFC"
        EB.SystemTables.setE(V.ERROR.MSG)
        EB.ErrorProcessing.Err()
        RETURN
    END

    IF Y.DD LT 1 THEN
        V.ERROR.MSG = "DIA INVALIDO EN RFC"
        EB.SystemTables.setE(V.ERROR.MSG)
        EB.ErrorProcessing.Err()
        RETURN
    END

    BEGIN CASE
    CASE Y.MM EQ 1 OR Y.MM EQ 3 OR Y.MM EQ 5 OR Y.MM EQ 7 OR Y.MM EQ 8 OR Y.MM EQ 10 OR Y.MM EQ 12
        IF Y.DD GT 31 THEN
            V.ERROR.MSG = "DIA INVALIDO EN RFC"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END
    CASE Y.MM EQ 4 OR Y.MM EQ 6 OR Y.MM EQ 9 OR Y.MM EQ 11
        IF Y.DD GT 30 THEN
            V.ERROR.MSG = "DIA INVALIDO EN RFC"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END
    CASE Y.MM EQ 2
        IF MOD(Y.AAAA,4) EQ 0 THEN
            IF Y.DD GT 29 THEN
                V.ERROR.MSG = "DIA INVALIDO EN RFC"
                EB.SystemTables.setE(V.ERROR.MSG)
                EB.ErrorProcessing.Err()
                RETURN
            END
        END ELSE
            IF Y.DD GT 28 THEN
                V.ERROR.MSG = "DIA INVALIDO EN RFC"
                EB.SystemTables.setE(V.ERROR.MSG)
                EB.ErrorProcessing.Err()
                RETURN
            END
        END
    END CASE

    Y.F.RFC = Y.AAAA:Y.MM:Y.DD
    IF Y.F.RFC GT Y.TODAY THEN
        V.ERROR.MSG = "FECHA NO PUEDE SER MAYOR A HOY"
        EB.SystemTables.setE(V.ERROR.MSG)
        EB.ErrorProcessing.Err()
        RETURN
    END

    RETURN

    RETURN

*---------------------------------------------------------------
VALIDA.HOMOCLAVE:
*---------------------------------------------------------------

    IF (Y.TIPO.CTE LT 3) THEN
        IF LEN(Y.RFC) EQ 13 THEN
            YHOMOCVE.1 = Y.RFC[11,1]
            YHOMOCVE.2 = Y.RFC[12,1]
            YHOMOCVE.3 = Y.RFC[13,1]

            YASCII.1 = SEQ(YHOMOCVE.1)
            YASCII.2 = SEQ(YHOMOCVE.2)
            YASCII.3 = SEQ(YHOMOCVE.3)

            YASCII.1.OK = 0
            YASCII.2.OK = 0
            YASCII.3.OK = 0

            IF (YASCII.1 GE 48 AND YASCII.1 LE 57) OR (YASCII.1 GE 65 AND YASCII.1 LE 90) OR (YASCII.1 GE 97 AND YASCII.1 LE 122) THEN YASCII.1.OK = 1
            IF (YASCII.2 GE 48 AND YASCII.2 LE 57) OR (YASCII.2 GE 65 AND YASCII.2 LE 90) OR (YASCII.2 GE 97 AND YASCII.2 LE 122) THEN YASCII.2.OK = 1
            IF (YASCII.3 GE 48 AND YASCII.3 LE 57) OR (YASCII.3 GE 65 AND YASCII.3 LE 90) OR (YASCII.3 GE 97 AND YASCII.3 LE 122) THEN YASCII.3.OK = 1
            
            IF NOT(YASCII.1.OK) OR NOT(YASCII.2.OK) OR NOT(YASCII.3.OK) THEN
                V.ERROR.MSG = "CARACTER INVALIDO EN HOMOCLAVE"
                EB.SystemTables.setE(V.ERROR.MSG)
                EB.ErrorProcessing.Err()
                RETURN
            END
        END
    END
    ELSE
        YHOMOCVE.1 = Y.RFC[10,1]
        YHOMOCVE.2 = Y.RFC[11,1]
        YHOMOCVE.3 = Y.RFC[12,1]

        YASCII.1 = SEQ(YHOMOCVE.1)
        YASCII.2 = SEQ(YHOMOCVE.2)
        YASCII.3 = SEQ(YHOMOCVE.3)

        YASCII.1.OK = 0
        YASCII.2.OK = 0
        YASCII.3.OK = 0

        IF (YASCII.1 GE 48 AND YASCII.1 LE 57) OR (YASCII.1 GE 65 AND YASCII.1 LE 90) OR (YASCII.1 GE 97 AND YASCII.1 LE 122) THEN YASCII.1.OK = 1
        IF (YASCII.2 GE 48 AND YASCII.2 LE 57) OR (YASCII.2 GE 65 AND YASCII.2 LE 90) OR (YASCII.2 GE 97 AND YASCII.2 LE 122) THEN YASCII.2.OK = 1
        IF (YASCII.3 GE 48 AND YASCII.3 LE 57) OR (YASCII.3 GE 65 AND YASCII.3 LE 90) OR (YASCII.3 GE 97 AND YASCII.3 LE 122) THEN YASCII.3.OK = 1
       
        IF NOT(YASCII.1.OK) OR NOT(YASCII.2.OK) OR NOT(YASCII.3.OK) THEN
            V.ERROR.MSG = "CARACTER INVALIDO EN HOMOCLAVE"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END
    END

    RETURN
END