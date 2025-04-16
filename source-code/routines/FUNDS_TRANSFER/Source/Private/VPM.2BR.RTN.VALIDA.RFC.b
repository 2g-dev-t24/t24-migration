* @ValidationCode : Mjo4MjQwNjI2Mzc6Q3AxMjUyOjE3NDQ0MDAyODUyMTQ6VXNpYXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2025 14:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
.
*-----------------------------------------------------------------------------
* <Rating>1439</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE VPM.2BR.RTN.VALIDA.RFC

*------------------------------------------------
* Subroutine:         VPM.2BR.RTN.VALIDA.RFC
* Objective:          Validates the RFC in versions
*                     FUNDS.TRANSFER,VPM.CHQCAJA and
*                     FUNDS.TRANSFER,SPEI.T.T
* First Released For: Banco Autofin Mexico, S.A.
* First Release:      Apr/11/2006
* Author:             Fabian Gamboa
*------------------------------------------------
*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*    $INSERT I_F.CUSTOMER

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.CUSTOMER
    $USING EB.API
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DatInterface
    $USING ABC.BP

    GOSUB VALIDA
RETURN

VALIDA:

    Y.RFC = EB.SystemTables.getComi() ;*COMI

    IF LEN(Y.RFC) = 0 THEN
        RETURN
    END

    IF LEN(Y.RFC) = 12 THEN
        Y.TIPO.CTE = 3
    END ELSE
        Y.TIPO.CTE = 1
    END
*TIPO CLIENTE 1 Y 2 SON FISICAS 3 Y 4 MORALES

    IF (Y.TIPO.CTE LT 3) THEN
*FISICAS/ACTIVIDAD EMPRESARIAL
        IF (LEN(Y.RFC) NE 13) AND (LEN(Y.RFC) NE 10) THEN
            EB.SystemTables.setE("LONGITUD DE RFC INVALIDO") ;*E = "LONGITUD DE RFC INVALIDO"
            EB.SystemTables.setComi("") ;*COMI=""
            EB.ErrorProcessing.Err()
            RETURN
        END
        Y.ALF = Y.RFC[1,4]
        Y.FECHA = Y.RFC[5,6]
        IF NOT(Y.FECHA  MATCH '6N') THEN
            EB.SystemTables.setE("ERROR EN FECHA") ;*E = "ERROR EN FECHA"
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
        
*Se reemplaza SEQX por SEQ
        YASCII.ALF.1 = SEQ(Y.ALF.1) ;*SEQX(Y.ALF.1)
        YASCII.ALF.2 = SEQ(Y.ALF.2) ;*SEQX(Y.ALF.2)
        YASCII.ALF.3 = SEQ(Y.ALF.3) ;*SEQX(Y.ALF.3)
        YASCII.ALF.4 = SEQ(Y.ALF.4) ;*SEQX(Y.ALF.4)

        YASCII.ALF.1.OK = 1
        YASCII.ALF.2.OK = 1
        YASCII.ALF.3.OK = 1
        YASCII.ALF.4.OK = 1
        IF NOT((YASCII.ALF.1 GE 65 AND YASCII.ALF.1 LE 90) OR (YASCII.ALF.1 EQ 209)) THEN YASCII.ALF.1.OK = 0
        IF NOT((YASCII.ALF.2 GE 65 AND YASCII.ALF.2 LE 90) OR (YASCII.ALF.2 EQ 209)) THEN YASCII.ALF.2.OK = 0
        IF NOT((YASCII.ALF.3 GE 65 AND YASCII.ALF.3 LE 90) OR (YASCII.ALF.3 EQ 209)) THEN YASCII.ALF.3.OK = 0
        IF NOT((YASCII.ALF.4 GE 65 AND YASCII.ALF.4 LE 90) OR (YASCII.ALF.4 EQ 209)) THEN YASCII.ALF.4.OK = 0

        IF NOT(YASCII.ALF.1.OK AND YASCII.ALF.2.OK AND YASCII.ALF.3.OK AND YASCII.ALF.4.OK) THEN
            EB.SystemTables.setE("PRIMEROS 4 CARACTERES DEBEN SER LETRAS") ;*E = "PRIMEROS 4 CARACTERES DEBEN SER LETRAS"
            EB.ErrorProcessing.Err()
            RETURN
        END

    END ELSE
*MORALES/FIDEICOMISO
        IF (LEN(Y.RFC) NE 12) THEN
            EB.SystemTables.setE("LONGITUD DE RFC INVALIDO") ;*E = "LONGITUD DE RFC INVALIDO"
            EB.ErrorProcessing.Err()
            RETURN
        END
        Y.ALF = Y.RFC[1,3]
        Y.FECHA = Y.RFC[4,6]
        IF NOT(Y.FECHA  MATCH '6N') THEN
            EB.SystemTables.setE("ERROR EN FECHA") ;*E = "ERROR EN FECHA"
            EB.ErrorProcessing.Err()
            RETURN
        END

        Y.ALF.1 = Y.ALF[1,1]
        Y.ALF.2 = Y.ALF[2,1]
        Y.ALF.3 = Y.ALF[3,1]

        YASCII.ALF.1.OK = 1
        YASCII.ALF.2.OK = 1
        YASCII.ALF.3.OK = 1

        YASCII.ALF.1 = SEQ(Y.ALF.1) ;*SEQX(Y.ALF.1)
        YASCII.ALF.2 = SEQ(Y.ALF.2) ;*SEQX(Y.ALF.2)
        YASCII.ALF.3 = SEQ(Y.ALF.3) ;*SEQX(Y.ALF.3)

        IF NOT((YASCII.ALF.1 GE 65 AND YASCII.ALF.1 LE 90) OR (YASCII.ALF.1 EQ 209)) THEN YASCII.ALF.1.OK = 0
        IF NOT((YASCII.ALF.2 GE 65 AND YASCII.ALF.2 LE 90) OR (YASCII.ALF.2 EQ 209)) THEN YASCII.ALF.2.OK = 0
        IF NOT((YASCII.ALF.3 GE 65 AND YASCII.ALF.3 LE 90) OR (YASCII.ALF.3 EQ 209)) THEN YASCII.ALF.3.OK = 0

        IF NOT(YASCII.ALF.1.OK AND YASCII.ALF.2.OK AND YASCII.ALF.3.OK) THEN
            EB.SystemTables.setE("PRIMEROS 3 CARACTERES DEBEN SER LETRAS") ;*E = "PRIMEROS 3 CARACTERES DEBEN SER LETRAS"
            EB.ErrorProcessing.Err()
            RETURN
        END

        Y.AA = Y.RFC[4,2]
        Y.MM = Y.RFC[6,2]
        Y.DD = Y.RFC[8,2]
    END

    IF Y.AA < 20 THEN
        Y.AAAA = 2000 + Y.AA
    END ELSE
        Y.AAAA = 1900 + Y.AA
    END

    IF (Y.MM < 1) OR (Y.MM > 12) THEN
        EB.SystemTables.setE("MES INVALIDO EN RFC") ;*E = "MES INVALIDO EN RFC"
        EB.ErrorProcessing.Err()
        RETURN
    END

    IF Y.DD < 1 THEN
        EB.SystemTables.setE("DIA INVALIDO EN RFC") ;*E = "DIA INVALIDO EN RFC"
        EB.ErrorProcessing.Err()
        RETURN
    END

    BEGIN CASE
        CASE Y.MM = 1 OR Y.MM = 3 OR Y.MM = 5 OR Y.MM = 7 OR Y.MM = 8 OR Y.MM = 10 OR Y.MM = 12
            IF Y.DD > 31 THEN
                EB.SystemTables.setE("DIA INVALIDO EN RFC") ;*E = "DIA INVALIDO EN RFC"
                EB.ErrorProcessing.Err()
                RETURN
            END
        CASE Y.MM = 4 OR Y.MM = 6 OR Y.MM = 9 OR Y.MM = 11
            IF Y.DD > 30 THEN
                EB.SystemTables.setE("DIA INVALIDO EN RFC") ;*E = "DIA INVALIDO EN RFC"
                EB.ErrorProcessing.Err()
                RETURN
            END
        CASE 1
            IF MOD(Y.AAAA,4) = 0 THEN
                IF Y.DD > 29 THEN
                    EB.SystemTables.setE("DIA INVALIDO EN RFC") ;*E = "DIA INVALIDO EN RFC"
                    EB.ErrorProcessing.Err()
                    RETURN
                END
            END ELSE
                IF Y.DD > 28 THEN
                    EB.SystemTables.setE("DIA INVALIDO EN RFC") ;*E = "DIA INVALIDO EN RFC"
                    EB.ErrorProcessing.Err()
                    RETURN
                END
            END
    END CASE

    Y.TODAY = EB.SystemTables.getToday()
    Y.F.RFC = Y.AAAA:Y.MM:Y.DD
*IF Y.F.RFC > TODAY THEN
    IF Y.F.RFC > Y.TODAY THEN
        EB.SystemTables.setE("FECHA NO PUEDE SER MAYOR A HOY") ;*E = "FECHA NO PUEDE SER MAYOR A HOY"
        EB.ErrorProcessing.Err()
        RETURN
    END

    GOSUB VALIDA.HOMOCLAVE
RETURN

VALIDA.HOMOCLAVE:

    IF (Y.TIPO.CTE LT 3) THEN
*FISICAS/ACTIVIDAD EMPRESARIAL
        IF LEN(Y.RFC) = 13 THEN
            YHOMOCVE.1 = Y.RFC[11,1]
            YHOMOCVE.2 = Y.RFC[12,1]
            YHOMOCVE.3 = Y.RFC[13,1]
            YASCII.1 = SEQ(YHOMOCVE.1) ;*SEQX(YHOMOCVE.1)
            YASCII.2 = SEQ(YHOMOCVE.2) ;*SEQX(YHOMOCVE.2)
            YASCII.3 = SEQ(YHOMOCVE.3) ;*SEQX(YHOMOCVE.3)
            YASCII.1.OK = 0
            YASCII.2.OK = 0
            YASCII.3.OK = 0
            IF (YASCII.1 GE 48 AND YASCII.1 LE 57) OR (YASCII.1 GE 65 AND YASCII.1 LE 90) OR (YASCII.1 GE 97 AND YASCII.1 LE 122) THEN YASCII.1.OK = 1
            IF (YASCII.2 GE 48 AND YASCII.2 LE 57) OR (YASCII.2 GE 65 AND YASCII.2 LE 90) OR (YASCII.2 GE 97 AND YASCII.2 LE 122) THEN YASCII.2.OK = 1
            IF (YASCII.3 GE 48 AND YASCII.3 LE 57) OR (YASCII.3 GE 65 AND YASCII.3 LE 90) OR (YASCII.3 GE 97 AND YASCII.3 LE 122) THEN YASCII.3.OK = 1
            IF NOT(YASCII.1.OK) OR NOT(YASCII.2.OK) OR NOT(YASCII.3.OK) THEN
                EB.SystemTables.setE("CARACTER INVALIDO EN HOMOCLAVE") ;*E = "CARACTER INVALIDO EN HOMOCLAVE"
                EB.ErrorProcessing.Err()
                RETURN
            END
        END
    END ELSE
*MORALES/FIDEICOMISO

        YHOMOCVE.1 = Y.RFC[10,1]
        YHOMOCVE.2 = Y.RFC[11,1]
        YHOMOCVE.3 = Y.RFC[12,1]
        YASCII.1 = SEQ(YHOMOCVE.1) ;*SEQX(YHOMOCVE.1)
        YASCII.2 = SEQ(YHOMOCVE.2) ;*SEQX(YHOMOCVE.2)
        YASCII.3 = SEQ(YHOMOCVE.3) ;*SEQX(YHOMOCVE.3)
        YASCII.1.OK = 0
        YASCII.2.OK = 0
        YASCII.3.OK = 0
        IF (YASCII.1 GE 48 AND YASCII.1 LE 57) OR (YASCII.1 GE 65 AND YASCII.1 LE 90) OR (YASCII.1 GE 97 AND YASCII.1 LE 122) THEN YASCII.1.OK = 1
        IF (YASCII.2 GE 48 AND YASCII.2 LE 57) OR (YASCII.2 GE 65 AND YASCII.2 LE 90) OR (YASCII.2 GE 97 AND YASCII.2 LE 122) THEN YASCII.2.OK = 1
        IF (YASCII.3 GE 48 AND YASCII.3 LE 57) OR (YASCII.3 GE 65 AND YASCII.3 LE 90) OR (YASCII.3 GE 97 AND YASCII.3 LE 122) THEN YASCII.3.OK = 1
        IF NOT(YASCII.1.OK) OR NOT(YASCII.2.OK) OR NOT(YASCII.3.OK) THEN
            EB.SystemTables.setE("CARACTER INVALIDO EN HOMOCLAVE") ;*E = "CARACTER INVALIDO EN HOMOCLAVE"
            EB.ErrorProcessing.Err()
            RETURN
        END
    END
RETURN

END
