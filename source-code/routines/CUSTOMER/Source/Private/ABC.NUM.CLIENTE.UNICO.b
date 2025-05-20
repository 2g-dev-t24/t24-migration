* @ValidationCode : MjotNzcwMDYxNzE3OkNwMTI1MjoxNzQ1MjcwNDI4NTk0Om1hdXViOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2025 18:20:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 
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
* <Rating>1035</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.NUM.CLIENTE.UNICO
*-----------------------------------------------------------------------------

*===============================================================================



    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Security
    $USING EB.Display
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING ABC.BP
    $USING AbcTable

    MESSAGE = EB.SystemTables.getMessage()
    
    IF MESSAGE EQ 'VAL' THEN
     RETURN
    END


    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId,"")
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusExternCusId,"")



    GOSUB ABRE.TABLAS
    GOSUB MANTEN.REGISTRO
    GOSUB GENERA.RFC.CURP
*    GOSUB CLIENTE.DUPLICADO
    EB.Display.RebuildScreen()
RETURN


GENERA.RFC.CURP:
*.. INDICA EL TIPO DE INFORMACION 1 PARA LA INF. INCORRECTA Y 0 PARA LA INF. CORRECTA
    ETEINC = 1
    ETEOK = 0
*.. INICIALIZA VARIABLES
    Y.MAYUS  = CHAR(165)
    CLIENTE.UNICO = ''
    CLIENTE.UNICO.RFC = ''
    CLIENTE.UNICO.CURP = ''
    RES = ETEOK
    MENSAJE = ''
    CLAVE.ALFA = ''


    IF ( EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector) EQ "1001") OR ( EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector) EQ "1100") THEN
        GOSUB VALIDA.DATOS
        IF (RES EQ 0) AND (MENSAJE EQ "") THEN
            GOSUB CALCULA.NUM.CTE

            V.RFC = ""
            *ABC.BP.AbcGeneraRfc('', '', '' )

            CLIENTE.UNICO.RFC = CLIENTE.UNICO.CURP[1,10]
            GOSUB SET.HOMONIMIA
            GOSUB SET.DIGITO.VER
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, CLIENTE.UNICO.RFC)

            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusExternCusId,CLIENTE.UNICO.CURP)
            
            EB.Display.RebuildScreen()
            RETURN
        END ELSE
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusGender,"")
            COMI = ""
            EB.Display.RebuildScreen()
            EB.SystemTables.setEtext(MENSAJE)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector) EQ "2001" THEN
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusGender,'')
        GOSUB VALIDA.DATOS.M
        IF (RES EQ 0) AND (MENSAJE EQ '') THEN
            GOSUB CALCULA.NUM.CTE.M

            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId,CLIENTE.UNICO)
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusExternCusId,"")
            EB.Display.RebuildScreen()
            RETURN
        END ELSE
            EB.SystemTables.setEtext(MENSAJE)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
RETURN
SET.DIGITO.VER:

    A.SUM.DIG = 0
    A.FACTOR = 13

    AUX.RFC = CLIENTE.UNICO.RFC

    IF LEN(AUX.RFC) EQ 11 THEN AUX.RFC = ' ' : AUX.RFC

    FOR A.I.NOM = 1 TO 12

        Y.CAR = AUX.RFC[A.I.NOM, 1]
        GOSUB GET.LISTA.ANEXO.3
        A.SUM.DIG = A.SUM.DIG + Y.VAL * A.FACTOR
        A.FACTOR = A.FACTOR - 1
    NEXT A.I.NOM

    A.RES.DIG = MOD(A.SUM.DIG, 11)

    IF A.RES.DIG GT 0 THEN
        A.RES.DIG = 11 - A.RES.DIG
        IF A.RES.DIG EQ 10 THEN A.RES.DIG = 'A'
    END

    CLIENTE.UNICO.RFC := A.RES.DIG
RETURN
SET.HOMONIMIA:

    A.NUM.NOMBRE = ''
    A.CLIENTE = APE.PATERNO : APE.MATERNO : NOMBRE
    A.CLIENTE = UPCASE(A.CLIENTE)
    A.CLIENTE = TRIM(A.CLIENTE)

    A.NOM.CLIENTE.ORIG = A.CLIENTE
    FOR A.I.NOM = 1 TO LEN(A.NOM.CLIENTE.ORIG)
        Y.CAR = A.NOM.CLIENTE.ORIG[A.I.NOM, 1]
        GOSUB GET.LISTA.ANEXO.1
        A.NUM.NOMBRE := Y.VAL

    NEXT A.I.NOM

    A.SUM.HOM = 0

    FOR A.I.NUM.NOM = 1 TO LEN(A.NUM.NOMBRE)

        A.NUM.1 = A.NUM.NOMBRE[A.I.NUM.NOM, 2]
        A.NUM.2 = A.NUM.NOMBRE[(A.I.NUM.NOM+1), 1]

        A.SUM.HOM = A.SUM.HOM + A.NUM.1 * A.NUM.2

    NEXT A.I.NUM.NOM

    A.SUM.HOM = MOD(A.SUM.HOM, 1000)

    A.RES.HOM = MOD(A.SUM.HOM, 34)

    A.COC.HOM = (A.SUM.HOM-A.RES.HOM) / 34

    Y.CAR = A.COC.HOM
    GOSUB GET.LISTA.ANEXO.2
    A.COC.HOM = Y.VAL

    Y.CAR = A.RES.HOM
    GOSUB GET.LISTA.ANEXO.2
    A.RES.HOM = Y.VAL


    CLIENTE.UNICO.RFC := A.COC.HOM : A.RES.HOM

RETURN
GET.LISTA.ANEXO.1:
    IF NOT(Y.CAR) THEN
        Y.VAL = '00'
    END 
    IF Y.CAR EQ '0' THEN
        Y.VAL = '00'
    END
    IF Y.CAR EQ '1' THEN
        Y.VAL = '01'
    END
    IF Y.CAR EQ '2' THEN
        Y.VAL = '02'
    END
    IF Y.CAR EQ '3' THEN
        Y.VAL = '03'
    END
    IF Y.CAR EQ '4' THEN
        Y.VAL = '04'
    END
    IF Y.CAR EQ '5' THEN
        Y.VAL = '05'
    END
    IF Y.CAR EQ '6' THEN
        Y.VAL = '06'
    END
    IF Y.CAR EQ '7' THEN
        Y.VAL = '07'
    END
    IF Y.CAR EQ '8' THEN
        Y.VAL = '08'
    END
    IF Y.CAR EQ '9' THEN
        Y.VAL = '09'
    END
    IF Y.CAR EQ '&' THEN
        Y.VAL = '10'
    END
    IF Y.CAR EQ 'A' THEN
        Y.VAL = '11'
    END
    IF Y.CAR EQ 'B' THEN
        Y.VAL = '12'
    END
    IF Y.CAR EQ 'C' THEN
        Y.VAL = '13'
    END
    IF Y.CAR EQ 'D' THEN
        Y.VAL = '14'
    END
    IF Y.CAR EQ 'E' THEN
        Y.VAL = '15'
    END
    IF Y.CAR EQ 'F' THEN
        Y.VAL = '16'
    END
    IF Y.CAR EQ 'G' THEN
        Y.VAL = '17'
    END
    IF Y.CAR EQ 'H' THEN
        Y.VAL = '18'
    END
    IF Y.CAR EQ 'I' THEN
        Y.VAL = '19'
    END
    IF Y.CAR EQ 'J' THEN
        Y.VAL = '21'
    END
    IF Y.CAR EQ 'K' THEN
        Y.VAL = '22'
    END
    IF Y.CAR EQ 'L' THEN
        Y.VAL = '23'
    END
    IF Y.CAR EQ 'M' THEN
        Y.VAL = '24'
    END
    IF Y.CAR EQ 'N' THEN
        Y.VAL = '25'
    END
    IF Y.CAR EQ 'O' THEN
        Y.VAL = '26'
    END
    IF Y.CAR EQ 'P' THEN
        Y.VAL = '27'
    END
    IF Y.CAR EQ 'Q' THEN
        Y.VAL = '28'
    END
    IF Y.CAR EQ 'R' THEN
        Y.VAL = '29'
    END
    IF Y.CAR EQ 'S' THEN
        Y.VAL = '32'
    END
    IF Y.CAR EQ 'T' THEN
        Y.VAL = '33'
    END
    IF Y.CAR EQ 'U' THEN
        Y.VAL = '34'
    END
    IF Y.CAR EQ 'V' THEN
        Y.VAL = '35'
    END
    IF Y.CAR EQ 'W' THEN
        Y.VAL = '36'
    END
    IF Y.CAR EQ 'X' THEN
        Y.VAL = '37'
    END
    IF Y.CAR EQ 'Y' THEN
        Y.VAL = '38'
    END
    IF Y.CAR EQ 'Z' THEN
        Y.VAL = '39'
    END
    IF Y.CAR EQ Y.MAYUS THEN
        Y.VAL = '40'
    END

RETURN
GET.LISTA.ANEXO.2:
    IF Y.CAR EQ 0 THEN
        Y.VAL = '1'
    END
    IF Y.CAR EQ 1 THEN
        Y.VAL = '2'
    END
    IF Y.CAR EQ 2 THEN
        Y.VAL = '3'
    END
    IF Y.CAR EQ 3 THEN
        Y.VAL = '4'
    END
    IF Y.CAR EQ 4 THEN
        Y.VAL = '5'
    END
    IF Y.CAR EQ 5 THEN
        Y.VAL = '6'
    END
    IF Y.CAR EQ 6 THEN
        Y.VAL = '7'
    END
    IF Y.CAR EQ 7 THEN
        Y.VAL = '8'
    END
    IF Y.CAR EQ 8 THEN
        Y.VAL = '9'
    END
    IF Y.CAR EQ 9 THEN
        Y.VAL = 'A'
    END
    IF Y.CAR EQ 10 THEN
        Y.VAL = 'B'
    END
    IF Y.CAR EQ 11 THEN
        Y.VAL = 'C'
    END
    IF Y.CAR EQ 12 THEN
        Y.VAL = 'D'
    END
    IF Y.CAR EQ 13 THEN
        Y.VAL = 'E'
    END
    IF Y.CAR EQ 14 THEN
        Y.VAL = 'F'
    END
    IF Y.CAR EQ 15 THEN
        Y.VAL = 'G'
    END
    IF Y.CAR EQ 16 THEN
        Y.VAL = 'H'
    END
    IF Y.CAR EQ 17 THEN
        Y.VAL = 'I'
    END
    IF Y.CAR EQ 18 THEN
        Y.VAL = 'J'
    END
    IF Y.CAR EQ 19 THEN
        Y.VAL = 'K'
    END
    IF Y.CAR EQ 20 THEN
        Y.VAL = 'L'
    END
    IF Y.CAR EQ 21 THEN
        Y.VAL = 'M'
    END
    IF Y.CAR EQ 22 THEN
        Y.VAL = 'N'
    END
    IF Y.CAR EQ 23 THEN
        Y.VAL = 'P'
    END
    IF Y.CAR EQ 24 THEN
        Y.VAL = 'Q'
    END
    IF Y.CAR EQ 25 THEN
        Y.VAL = 'R'
    END
    IF Y.CAR EQ 26 THEN
        Y.VAL = 'S'
    END
    IF Y.CAR EQ 27 THEN
        Y.VAL = 'T'
    END
    IF Y.CAR EQ 28 THEN
        Y.VAL = 'U'
    END
    IF Y.CAR EQ 29 THEN
        Y.VAL = 'V'
    END
    IF Y.CAR EQ 30 THEN
        Y.VAL = 'W'
    END
    IF Y.CAR EQ 31 THEN
        Y.VAL = 'X'
    END
    IF Y.CAR EQ 32 THEN
        Y.VAL = 'Y'
    END
    IF Y.CAR EQ 33 THEN
        Y.VAL = 'Z'
    END


RETURN
GET.LISTA.ANEXO.3:
     
    IF Y.CAR EQ '0' THEN
        Y.VAL = '00'
    END
    IF Y.CAR EQ '1' THEN
        Y.VAL = '01'
    END
    IF Y.CAR EQ '2' THEN
        Y.VAL = '02'
    END
    IF Y.CAR EQ '3' THEN
        Y.VAL = '03'
    END
    IF Y.CAR EQ '4' THEN
        Y.VAL = '04'
    END
    IF Y.CAR EQ '5' THEN
        Y.VAL = '05'
    END
    IF Y.CAR EQ '6' THEN
        Y.VAL = '06'
    END
    IF Y.CAR EQ '7' THEN
        Y.VAL = '07'
    END
    IF Y.CAR EQ '8' THEN
        Y.VAL = '08'
    END
    IF Y.CAR EQ '9' THEN
        Y.VAL = '09'
    END
    IF Y.CAR EQ 'A' THEN
        Y.VAL = '10'
    END
    IF Y.CAR EQ 'B' THEN
        Y.VAL = '11'
    END
    IF Y.CAR EQ 'C' THEN
        Y.VAL = '12'
    END
    IF Y.CAR EQ 'D' THEN
        Y.VAL = '13'
    END
    IF Y.CAR EQ 'E' THEN
        Y.VAL = '14'
    END
    IF Y.CAR EQ 'F' THEN
        Y.VAL = '15'
    END
    IF Y.CAR EQ 'G' THEN
        Y.VAL = '16'
    END
    IF Y.CAR EQ 'H' THEN
        Y.VAL = '17'
    END
    IF Y.CAR EQ 'I' THEN
        Y.VAL = '18'
    END
    IF Y.CAR EQ 'J' THEN
        Y.VAL = '19'
    END
    IF Y.CAR EQ 'K' THEN
        Y.VAL = '20'
    END
    IF Y.CAR EQ 'L' THEN
        Y.VAL = '21'
    END
    IF Y.CAR EQ 'M' THEN
        Y.VAL = '22'
    END
    IF Y.CAR EQ 'N' THEN
        Y.VAL = '23'
    END
    IF Y.CAR EQ '&' THEN
        Y.VAL = '24'
    END
    IF Y.CAR EQ 'O' THEN
        Y.VAL = '25'
    END
    IF Y.CAR EQ 'P' THEN
        Y.VAL = '26'
    END
    IF Y.CAR EQ 'Q' THEN
        Y.VAL = '27'
    END
    IF Y.CAR EQ 'R' THEN
        Y.VAL = '28'
    END
    IF Y.CAR EQ 'S' THEN
        Y.VAL = '29'
    END
    IF Y.CAR EQ 'T' THEN
        Y.VAL = '30'
    END
    IF Y.CAR EQ 'U' THEN
        Y.VAL = '31'
    END
    IF Y.CAR EQ 'V' THEN
        Y.VAL = '32'
    END
    IF Y.CAR EQ 'W' THEN
        Y.VAL = '33'
    END
    IF Y.CAR EQ 'X' THEN
        Y.VAL = '34'
    END
    IF Y.CAR EQ 'Y' THEN
        Y.VAL = '35'
    END
    IF Y.CAR EQ 'Z' THEN
        Y.VAL = '36'
    END
    IF NOT(Y.CAR) THEN
        Y.VAL = '37'
    END
    IF Y.CAR EQ Y.MAYUS THEN
        Y.VAL = '38'
    END

RETURN
***************************************
*     CALCULA A PERSONA FISICA        *
***************************************
CALCULA.NUM.CTE:

    CLIENTE.UNICO.RFC = "XXXXXXXXXX";  CLIENTE.UNICO.CURP = "XXXXXXXXXXXXXXXXXX"
    IDX = 0; BAND = 0

    APE.PATERNO  = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName)
    APE.MATERNO  = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)

******************************************************************************************************************
* Elimino los campos locales para el nombre 2 y el nombre 3
    Y.CUS.NAME.2 = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)

    Y.NUM.VM = DCOUNT(Y.CUS.NAME.2, @VM)
    NOM.COMPLETO = ""
    FOR I = 1 TO Y.NUM.VM
        Y.NOM.TURNO   = FIELD(Y.CUS.NAME.2, @VM,I)
        NOM.COMPLETO := Y.NOM.TURNO : " "
    NEXT I

    NOM.COMPLETO = TRIM(NOM.COMPLETO)

******************************************************************************************************************

    Y.APE.PAT  = DCOUNT(APE.PATERNO, ' ')
    IF Y.APE.PAT GT 1 THEN
     GOSUB VALIDA.APE
    END

    Y.APE.MAT = DCOUNT(APE.MATERNO, ' ')
    IF Y.APE.MAT GT 1 THEN
     GOSUB VALIDA.APE.2
    END

    LONG.NOM  = LEN(NOM.COMPLETO)
    FOR POS.CARACTER = 1 TO LONG.NOM
        IF NOM.COMPLETO[LONG.NOM,1] EQ ' ' THEN
            NOM.COMPLETO[LONG.NOM,1] = ''
            POS.CARACTER = LONG.NOM - 1
        END
    NEXT

    Y.APELLIDO.1 = TRIM(APE.PATERNO); LONG.APE.1 = LEN(Y.APELLIDO.1)
    Y.APELLIDO.2 = TRIM(APE.MATERNO)

    IF (Y.APELLIDO.1[1,3] EQ 'XXX') OR (Y.APELLIDO.1 EQ 'XX') OR (Y.APELLIDO.1 EQ 'X') OR (Y.APELLIDO.1 EQ 'X ') OR (Y.APELLIDO.1 EQ 'XX ') THEN
        Y.APELLIDO.1 = 0
    END
    IF (Y.APELLIDO.2[1,3] EQ 'XXX') OR (Y.APELLIDO.2 EQ 'XX') OR (Y.APELLIDO.2 EQ 'X') OR (Y.APELLIDO.2 EQ 'X ') OR (Y.APELLIDO.2 EQ 'XX ') THEN
        Y.APELLIDO.2 = 0
    END

    IF (Y.APELLIDO.1 EQ 0) THEN
        CLIENTE.UNICO.RFC[1,2] = Y.APELLIDO.2[1,2]; CLIENTE.UNICO.CURP[1,2] = Y.APELLIDO.2[1,2]; BAND = 1
    END ELSE
        IF (Y.APELLIDO.2 EQ 0) THEN
            CLIENTE.UNICO.RFC[1,2] = Y.APELLIDO.1[1,2]; CLIENTE.UNICO.CURP[1,2] = Y.APELLIDO.1[1,2]; BAND = 1
        END ELSE
*..MUEVE PRIMER LETRA DE PRIMER APELLIDO
            IF NOT((LONG.APE.1 EQ 1) OR (LONG.APE.1 EQ 2)) THEN
                CLIENTE.UNICO.RFC[1,1] = Y.APELLIDO.1[1,1]; CLIENTE.UNICO.CURP[1,1] = Y.APELLIDO.1[1,1]
*..BUSCA PRIMERA VOCAL DEL PRIMER APELLIDO
                V1 = 1
                LOOP
                    V1 = V1 + 1
                UNTIL (((Y.APELLIDO.1[V1,1] EQ 'A') OR (Y.APELLIDO.1[V1,1] EQ "E") OR (Y.APELLIDO.1[V1,1] EQ "I") OR (Y.APELLIDO.1[V1,1] EQ "O") OR (Y.APELLIDO.1[V1,1] EQ "U")) OR (V1 GT LEN(Y.APELLIDO.1)))
                REPEAT

                IF (V1 LE LEN(Y.APELLIDO.1) ) THEN
*..MUEVE PRIMER VOCAL DEL PRIMER APELLIDO
                    CLIENTE.UNICO.RFC[2,1] = Y.APELLIDO.1[V1,1]; CLIENTE.UNICO.CURP[2,1] = Y.APELLIDO.1[V1,1]
                END ELSE
                    CLIENTE.UNICO.RFC[2,1] = "X"; CLIENTE.UNICO.CURP[2,1] = "X"
                END

*..MUEVE PRIMER LETRA DE SEGUNDO APELLIDO
                IF ( LEN(Y.APELLIDO.2 ) GT 0) THEN
                    CLIENTE.UNICO.RFC[3,1] = Y.APELLIDO.2[1,1]; CLIENTE.UNICO.CURP[3,1] = Y.APELLIDO.2[1,1]
                END ELSE
                    CLIENTE.UNICO.RFC[3,1] = "X"; CLIENTE.UNICO.CURP[3,1] = "X"
                END
            END ELSE
                CLIENTE.UNICO.RFC[1,1] = Y.APELLIDO.1[1,1]; CLIENTE.UNICO.CURP[1,1] = Y.APELLIDO.1[1,1]
                CLIENTE.UNICO.RFC[2,1] = Y.APELLIDO.2[1,1]; CLIENTE.UNICO.CURP[2,1] = Y.APELLIDO.2[1,1]; BAND = 1
            END
        END
    END

************************************************************************************************************************************
    Y.NOMBRE = NOM.COMPLETO
************************************************************************************************************************************
    NOMBRE = DCOUNT(NOM.COMPLETO, ' ')
    IF NOMBRE GT 1 THEN
        GOSUB NOMBRE.INVALIDO
    END ELSE
        CLIENTE.UNICO.RFC[4,1] = Y.NOMBRE[1,1]; CLIENTE.UNICO.CURP[4,1] = Y.NOMBRE[1,1]
    END

    IF (BAND EQ 1) THEN
        CLIENTE.UNICO.RFC[3,2] = Y.NOMBRE[1,2]; CLIENTE.UNICO.CURP[3,2] = Y.NOMBRE[1,2]
    END

*..VALIDANDO QUE LAS PRIMERAS 4 POSICIONES
    GOSUB LISTA
    POS.RFC = ""

    FINDSTR CLIENTE.UNICO.RFC[1,4] IN LIST.C SETTING POS.RFC THEN
        IF POS.RFC NE '' THEN
            POS.RFC = FIELD(LIST.C, @FM, POS.RFC)
            IF CLIENTE.UNICO.RFC[1,4] EQ POS.RFC[1,4] THEN
                CAMBIO.RFC = FIELD(POS.RFC, '*', 2)
                CAMBIO.CURP = FIELD(POS.RFC, '*', 3)
                CLIENTE.UNICO.RFC[1,4] = CAMBIO.RFC; CLIENTE.UNICO.CURP[1,4] = CAMBIO.CURP
            END
        END
    END

*..MUEVA FECHA DE NACIMIENTO
    CLIENTE.UNICO.RFC[5,6]  = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)[3,6]
    CLIENTE.UNICO.CURP[5,6] = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)[3,6]
*..MUEVE GENERO


    SEXO = EB.SystemTables.getComi()
    SEXO = UPCASE(SEXO)
 
    IF (SEXO EQ "MASCULINO") THEN
        CLIENTE.UNICO.CURP[11,1] = "H"
    END ELSE
        CLIENTE.UNICO.CURP[11,1] = "M"
    END

*..MUEVE LUGAR DE NACIMIENTO


    LUG.NAC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDistrictName); REC.LUGNAC = ''
    
    EB.DataAccess.FRead(FN.ABC.ESTADO, LUG.NAC, R.ABC.ESTADO, F.ABC.ESTADO, CUST.ERR)
    IF R.ABC.ESTADO NE '' THEN
        CLAVE.ALFA = R.ABC.ESTADO<AbcTable.AbcEstado.Clave>
    END
    
   
    CLIENTE.UNICO.CURP[12,2] = CLAVE.ALFA

*..MUEVE PRIMERA CONSONANTE DE PRIMER APELLIDO
    V1 = 1
    LOOP
        V1 = V1 + 1
    UNTIL (((Y.APELLIDO.1[V1,1] NE 'A') AND (Y.APELLIDO.1[V1,1] NE 'E') AND (Y.APELLIDO.1[V1,1] NE 'I') AND (Y.APELLIDO.1[V1,1] NE 'O') AND (Y.APELLIDO.1[V1,1] NE 'U')) OR (V1 GT LEN(Y.APELLIDO.1)))
    REPEAT
    CLIENTE.UNICO.CURP[14,1] = Y.APELLIDO.1[V1,1]

*..MUEVE PRIMERA CONSONANTE DE SEGUNDO APELLIDO
    V1 = 1
    LOOP
        V1 = V1 + 1
    UNTIL (((Y.APELLIDO.2[V1,1] NE 'A') AND (Y.APELLIDO.2[V1,1] NE "E") AND (Y.APELLIDO.2[V1,1] NE "I") AND (Y.APELLIDO.2[V1,1] NE "O") AND (Y.APELLIDO.2[V1,1] NE "U")) OR (V1 GT LEN(Y.APELLIDO.2)))
    REPEAT
    CLIENTE.UNICO.CURP[15,1] = Y.APELLIDO.2[V1,1]

*..MUEVE PRIMERA CONSONANTE DE PRIMER NOMBRE
    V1 = 1
    LOOP
        V1 = V1 + 1
    UNTIL ((Y.NOMBRE[V1,1] NE 'A') AND (Y.NOMBRE[V1,1] NE "E") AND (Y.NOMBRE[V1,1] NE "I") AND (Y.NOMBRE[V1,1] NE "O") AND (Y.NOMBRE[V1,1] NE "U")) OR (V1 GT LEN(Y.NOMBRE))
    REPEAT
    CLIENTE.UNICO.CURP[16,1] = Y.NOMBRE[V1,1]

    FOR CON.POS = 1 TO 16
        Y.MAYUS = CHAR(165)
        IF (CLIENTE.UNICO.CURP[CON.POS,1] EQ Y.MAYUS) OR (CLIENTE.UNICO.CURP[CON.POS,1] EQ ' ') OR (CLIENTE.UNICO.CURP[CON.POS,1] EQ '') THEN
            CLIENTE.UNICO.CURP[CON.POS,1] = 'X'
        END
    NEXT CON.POS

    FOR CON.POS = 1 TO 10
        IF (CLIENTE.UNICO.RFC[CON.POS,1] EQ Y.MAYUS) OR (CLIENTE.UNICO.RFC[CON.POS,1] EQ ' ') THEN
            CLIENTE.UNICO.RFC[CON.POS,1] = 'X'
        END
    NEXT CON.POS

*..PONE CONSECUTIVO INCIA EN 00
    CLIENTE.UNICO.CURP[17,2] = "00"
RETURN


****************************************
*        CALCULA RFC DE PERSONA MORAL
****************************************
CALCULA.NUM.CTE.M:

    CLIENTE.UNICO = "XXXXXXXXX"

    NOMBRE.EMP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)
    Y.VAL.EMP  = DCOUNT(NOMBRE.EMP, " ")
    IF Y.VAL.EMP GT 1 THEN
        GOSUB VALIDA.EMPRESA

        CLIENTE.UNICO[1,3] = RFC.EMP[1,3]
    END ELSE
        CLIENTE.UNICO[1,3] = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)[1,3]
    END

    CLIENTE.UNICO[4,6] = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)[3,6]


    FOR VACIOS = 1 TO 3
        GOSUB LISTA.3; POS.VACIOS = ''
        FINDSTR CLIENTE.UNICO[VACIOS,1] IN LIST.E SETTING POS.VACIOS THEN
            IF POS.VACIOS EQ '' THEN
                CLIENTE.UNICO[VACIOS,1] = 'X'
            END
        END
    NEXT

RETURN



*******************************************************


*..VALIDA SI EL PRIMER NOMBRE ES MARIA O JOSE
NOMBRE.INVALIDO:

    Y.NOMBRE = NOM.COMPLETO
    PRIMER.NOM = FIELD(Y.NOMBRE, ' ', 1)
    IF ((PRIMER.NOM EQ "MARIA") OR (PRIMER.NOM EQ "MA")OR (PRIMER.NOM EQ "MA.") OR (PRIMER.NOM EQ "JOSE" )) THEN
        ELIM.NOM = LEN(PRIMER.NOM) + 1  ;**... ELIMINO EL PRIMER NOMBRE Y EL ESPACIO EN BLANCO. EJEMPLO: MARIA*DE*LOURDES, QUEDA ASI: DE*LOURDES
        Y.NOMBRE[1, ELIM.NOM] = ''
        Y.NOM = DCOUNT(Y.NOMBRE, ' ')
        IF Y.NOM GT 1 THEN
            GOSUB VALIDA.NOM
            CLIENTE.UNICO.RFC[4,1] = Y.NOMBRE[1,1]
        END ELSE
            CLIENTE.UNICO.RFC[4,1] = Y.NOMBRE[1,1]
        END
    END ELSE
        CLIENTE.UNICO.RFC[4,1] = Y.NOMBRE[1,1]
    END

    Y.NOMBRE = NOM.COMPLETO
    PRIMER.NOM = FIELD(Y.NOMBRE, ' ', 1)
    IF ((PRIMER.NOM EQ "MARIA") OR (PRIMER.NOM EQ "MA")OR (PRIMER.NOM EQ "MA.") OR (PRIMER.NOM EQ "JOSE" ) OR (PRIMER.NOM EQ "J" ) OR (PRIMER.NOM EQ "J." )) THEN
        ELIM.NOM = LEN(PRIMER.NOM) + 1  ;**... ELIMINO EL PRIMER NOMBRE Y EL ESPACIO EN BLANCO. EJEMPLO: MARIA*DE*LOURDES, QUEDA ASI: DE*LOURDES
        Y.NOMBRE[1, ELIM.NOM] = ''
        Y.NOM = DCOUNT(Y.NOMBRE, ' ')
        IF Y.NOM GT 1 THEN
            GOSUB VALIDA.NOM
            CLIENTE.UNICO.CURP[4,1] = Y.NOMBRE[1,1]
        END ELSE
            CLIENTE.UNICO.CURP[4,1] = Y.NOMBRE[1,1]
        END
    END ELSE
        CLIENTE.UNICO.CURP[4,1] = Y.NOMBRE[1,1]
    END
RETURN

VALIDA.APE:

    FOR Y.PAT = 1 TO Y.APE.PAT
        A.APE = FIELD(APE.PATERNO, ' ',Y.PAT)
        GOSUB LISTA.2; POS.APE = ''
        FINDSTR A.APE IN LIST.D SETTING POS.APE THEN
            IF NOT(A.APE = LIST.D<POS.APE>) THEN
                POS.APE = ''
            END
        END
        IF (POS.APE EQ '') AND (POS.APE NE ' ') THEN
            APE.PATERNO = ''
            APE.PATERNO = A.APE
            BREAK
        END
    NEXT
RETURN

VALIDA.APE.2:

    FOR Y.MAT = 1 TO Y.APE.MAT
        B.APE = FIELD(APE.MATERNO, ' ',Y.MAT)
        GOSUB LISTA.2; POS.APE.2 = ''
        FINDSTR B.APE IN LIST.D SETTING POS.APE.2 THEN
            IF NOT(B.APE EQ LIST.D<POS.APE.2>) THEN
                POS.APE.2 = ''
            END
        END
        IF (POS.APE.2 EQ '') AND (POS.APE.2 NE ' ') THEN
            APE.MATERNO = ''
            APE.MATERNO = B.APE
            BREAK
        END
    NEXT
RETURN

VALIDA.NOM:

    FOR Y.FOR.NOM = 1 TO Y.NOM
        C.NOM1 = FIELD(Y.NOMBRE, ' ',Y.FOR.NOM)
        GOSUB LISTA.2; POS.NOM = ''
        FINDSTR C.NOM1 IN LIST.D SETTING POS.NOM THEN
            IF NOT(C.NOM1 EQ LIST.D<POS.NOM>) THEN
                POS.NOM = ''
            END
        END
        IF (POS.NOM EQ '') AND (POS.NOM NE ' ') THEN
            Y.NOMBRE = ''
            Y.NOMBRE = C.NOM1
            BREAK
        END
    NEXT
RETURN

VALIDA.EMPRESA:

    RFC.EMP = ''
    FOR Y.EMPRESA = 1 TO Y.VAL.EMP
        D.EMP = FIELD(NOMBRE.EMP, ' ', Y.EMPRESA)
        GOSUB LISTA.2; POS.EMP = ''
        FINDSTR D.EMP IN LIST.D SETTING POS.EMP THEN
            IF NOT(D.EMP EQ LIST.D<POS.EMP>) THEN
                POS.EMP = ''
            END
        END
        IF POS.EMP = '' THEN
            VAL.TMP = D.EMP
        END
        IF (POS.EMP EQ '') AND (POS.EMP NE ' ') AND (LEN(RFC.EMP LT 3)) THEN
            IF Y.EMPRESA EQ Y.VAL.EMP THEN
                RFC.EMP := VAL.TMP[1,2]
            END ELSE
                RFC.EMP := VAL.TMP[1,1]
            END
        END
        IF (Y.EMPRESA EQ Y.VAL.EMP) AND (LEN(RFC.EMP LT 3)) THEN
            RFC.EMP := VAL.TMP[2,1]
        END
    NEXT
RETURN


*..PALABRAS IMPROPIAS
LISTA:

    LIST.C  = 'BACA*BACX*BXCA':@FM:'BAKA*BAKX*BXKA':@FM:'BUEI*BUEX*BXEI':@FM:'BUEY*BUEX*BXEY':@FM:'CACA*CACX*CXCA':@FM:'CACO*CACX*CXCO':@FM:'CAGA*CAGX*CXGA':@FM:'CAGO*CAGX*CXGO':@FM
    LIST.C := 'CAKA*CAKX*CXKA':@FM:'CAKO*CAKX*CXKO':@FM:'COGE*COGX*CXGE':@FM:'COGI*COGX*CXGI':@FM:'COJA*COJX*CXJA':@FM:'COJE*COJX*CXJE':@FM:'COJI*COJX*CXJI':@FM:'COJO*COJX*CXJO':@FM
    LIST.C := 'COLA*COLX*CXLA':@FM:'CULO*CULX*CXLO':@FM:'FALO*FALX*FXLO':@FM:'FETO*FETX*FXTO':@FM:'GETA*GETX*GXTA':@FM:'GUEI*GUEX*GXEI':@FM:'GUEY*GUEX*GXEY':@FM:'JETA*JETX*JXTA':@FM
    LIST.C := 'JOTO*JOTX*JXTO':@FM:'KACA*KACX*KXCA':@FM:'KACO*KACX*KXCO':@FM:'KAGA*KAGX*KXGA':@FM:'KAGO*KAGX*KXGO':@FM:'KAKA*KAKX*KXKA':@FM:'KAKO*KAKX*KXKO':@FM:'KOGE*KOGX*KXGE':@FM
    LIST.C := 'KOGI*KOGX*KXGI':@FM:'KOJA*KOJX*KXJA':@FM:'KOJE*KOJX*KXJE':@FM:'KOJI*KOJX*KXJI':@FM:'KOJO*KOJX*KXJO':@FM:'KOLA*KOLX*KXLA':@FM:'KULO*KULX*KXLO':@FM:'LILO*LILX*LXLO':@FM
    LIST.C := 'LOCA*LOCX*LXCA':@FM:'LOCO*LOCX*LXCO':@FM:'LOKA*LOKX*LXKA':@FM:'LOKO*LOKX*LXKO':@FM:'MAME*MAMX*MXME':@FM:'MAMO*MAMX*MXMO':@FM:'MEAR*MEAX*MXAR':@FM:'MEAS*MEAX*MXAS':@FM
    LIST.C := 'MEON*MEOX*MXON':@FM:'MIAR*MIAX*MXAR':@FM:'MION*MIOX*MXON':@FM:'MOCO*MOCX*MXCO':@FM:'MOKO*MOKX*MXKO':@FM:'MULA*MULX*MXLA':@FM:'MULO*MULX*MXLO':@FM:'NACA*NACX*NXCA':@FM
    LIST.C := 'NACO*NACX*NXCO':@FM:'PEDA*PEDX*PXDA':@FM:'PEDO*PEDX*PXDO':@FM:'PENE*PENX*PXNE':@FM:'PIPI*PIPX*PXPI':@FM:'PITO*PITX*PXTO':@FM:'POPO*POPX*PXPO':@FM:'PUTA*PUTX*PXTA':@FM
    LIST.C := 'PUTO*PUTX*PXTO':@FM:'QULO*QULX*QXLO':@FM:'RATA*RATX*RXTA':@FM:'ROBA*ROBX*RXBA':@FM:'ROBE*ROBX*RXBE':@FM:'ROBO*ROBX*RXBO':@FM:'RUIN*RUIX*RXIN':@FM:'SENO*SENX*SXNO':@FM
    LIST.C := 'TETA*TETX*TXTA':@FM:'VACA*VACX*VXCA':@FM:'VAGA*VAGX*VXGA':@FM:'VAGO*VAGX*VXGO':@FM:'VAKA*VAKX*VXKA':@FM:'VUEI*VUEX*VXEI':@FM:'VUEY*VUEX*VXEY':@FM:'WUEI*WUEX*WXEI':@FM
    LIST.C := 'WUEY*WUEX*WXEY'

RETURN


*..PREPOSICIONES, CONJUNCIONES, CONTRACCIONES
LISTA.2:

    LIST.D := 'DA':@FM:'DAS':@FM:'DE':@FM:'DEL':@FM:'DER':@FM:'DI':@FM:'DIE':@FM:'DD':@FM:'EL':@FM:'LA':@FM:'LOS':@FM:'LAS':@FM:'LE':@FM:'LES':@FM:'MAC':@FM:'MC':@FM:'VAN':@FM
    LIST.D := 'VON':@FM:'Y':@FM:'PARA':@FM:'EN':@FM:'CON':@FM:'COMPAA':@FM:'A':@FM:'A.':@FM:'P':@FM:'P.':@FM:'C':@FM:'C.':@FM:'R':@FM:'R.':@FM:'AC':@FM:'A.C':@FM:'A.C.':@FM
    LIST.D := 'AC.':@FM:'AP':@FM:'A.P':@FM:'A.P.':@FM:'AP.':@FM:'S':@FM:'S.':@FM:'RL':@FM:'R.L':@FM:'R.L.':@FM:'RL.':@FM:'CV':@FM:'C.V':@FM:'C.V.':@FM:'CV.':@FM:'SA':@FM
    LIST.D := 'S.A':@FM:'S.A.':@FM:'SA.':@FM:'SC':@FM:'S.C':@FM:'S.C.':@FM:'SC.':@FM:'RL':@FM:'R.L':@FM:'R.L.':@FM:'RL.':@FM:'SCS':@FM:'S.CS':@FM:'S.C.S':@FM:'S.C.S.':@FM
    LIST.D := 'SCS.':@FM:'SPR':@FM:'S.PR':@FM:'S.P.R':@FM:'S.P.R.':@FM:'SPR.':@FM:'SNC':@FM:'S.NC':@FM:'S.N.C':@FM:'S.N.C.':@FM:'SNC.':@FM:'CIA'

RETURN

LISTA.3:

    LIST.E := 'A':@FM:'B':@FM:'C':@FM:'D':@FM:'E':@FM:'F':@FM:'G':@FM:'H':@FM:'I':@FM:'J':@FM:'K':@FM:'L':@FM:'M':@FM:'N':@FM:'O':@FM:'P':@FM:'Q':@FM:'R':@FM:'S':@FM:'T':@FM
    LIST.E := 'U':@FM:'V':@FM:'W':@FM:'X':@FM:'Y':@FM:'Z'

RETURN


CLIENTE.DUPLICADO:

**.. VALIDA LOS APELLIDOS Y NOMBRE INGRESADOS PARA EVITAR ERRORRES EN EL SELECT. EJEMPLO: APE.PAT: DE LEON, APE.MAT: DE LA GARZA, NOMBRE1: MARIA DE LOS, NOMBRE2: ANGELES

    Y.APE.PAT = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName)
    Y.APE.MAT = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)
    Y.NOMBRE  = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)

    NO.APE.PAT = DCOUNT(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName), ' ')
    IF NO.APE.PAT GT 1 THEN
        Y.APE.PAT = FIELD(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName), ' ', NO.APE.PAT)
        Y.APE.PAT = '...':Y.APE.PAT     ;**... SE TOMARIA "...LEON"
    END

    NO.APE.MAT = DCOUNT(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne), ' ')
    IF NO.APE.MAT GT 1 THEN
        Y.APE.MAT = FIELD(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne), ' ', NO.APE.MAT)
        Y.APE.MAT = '...':Y.APE.MAT     ;**... SE TOMARIA ASI "...GARZA"
    END


    NOMBRE.COMP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)
    NOMBRE.COMP = EREPLACE(NOMBRE.COMP,FM," ")
    NOMBRE.COMP = EREPLACE(NOMBRE.COMP,VM," ")
    NOMBRE.COMP = EREPLACE(NOMBRE.COMP,"  "," ")

    NOMBRE.NUEVO  = NOMBRE.COMP
    NOMBRE.NUEVO := " " : EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName):" "
    NOMBRE.NUEVO := EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)

    NO.NOMBRE = DCOUNT(NOMBRE.COMP, ' ')

    IF NO.NOMBRE GT 1 THEN
        Y.NOMBRE = FIELD(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)<1,1>, ' ', 1)
        Y.NOMBRE = Y.NOMBRE:' ...'      ;**... SE TOMARIA ASI "MARIA..."
    END

**.. QUITO DOS ESPACIOS SEGUIDOS INTERMEDIOS AL FORMAR EL NOMBRE COMPLETO INGRESADO. EJEMPLO: MARIA*DE*LOS*ANGELES**DE*LEON*DE*LA*GARZA
    LONG.APE  = LEN(NOMBRE.NUEVO)
    FOR Y.APE = 1 TO LONG.APE
        IF NOMBRE.NUEVO[Y.APE,2] = '  ' THEN
            NOMBRE.NUEVO[Y.APE,1] = ''
            Y.APE = Y.APE - 1
        END
    NEXT Y.APE
**..

**.. SE HACE UNA BUSQUEDA CON EL APE.PAT, APE.MAT, NOMBRE1, FEC.NAC, LUG.NAC Y SEXO INGRESADO, PARA VER SI YA FUE CAPTURADO ANTERIORMENTE

    ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.CLIENTE = ID.NEW
    Y.RFC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.DATE.BIRTH = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)
    Y.CURP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)

    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector) GE "2001" THEN
        Y.RFC.AUX = Y.RFC[1,9]
        Y.ESTADO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,YPOS.LUGAR.CONST>
        Y.NOM.PER.MORAL = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,YPOS.NOM.PER.MORAL>)
        GOSUB VALIDA.CLIENTE.PM
    END ELSE
        Y.RFC.AUX = Y.RFC[1,10]
        Y.ESTADO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDistrictName)
        Y.SHORT.NAME = TRIM(Y.APE.PAT)
        Y.NAME.1 = TRIM(Y.APE.MAT)
        Y.NAME.2 = TRIM(Y.NOMBRE)
        GOSUB VALIDA.CLIENTE.PF
        IF EB.SystemTables.getEtext() EQ '' THEN
            GOSUB VALIDA.CLIENTE.PF
            Y.RFC.AUX = Y.CURP[1,10]
        END
    END



RETURN

******************
VALIDA.CLIENTE.PM:
******************

    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC.AUX,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
* Before incorporation : CALL F.READ(FN.ABC.INFO.VAL.CUS,Y.RFC.AUX,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
    IF R.VAL.CUS THEN
        Y.RFC.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc>
        Y.CURP.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp>
        Y.CLIENTE.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente>
        Y.GENDER.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender>
        Y.DATE.BIRTH.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth>
        Y.SHORT.NAME.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName>
        Y.NAME.1.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1>
        Y.NAME.2.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2>
        Y.NOM.PER.MORAL.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral>
        Y.ESTADO.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado>

        CHANGE @VM TO @FM IN Y.RFC.LIST
        CHANGE @VM TO @FM IN Y.CURP.LIST
        CHANGE @VM TO @FM IN Y.CLIENTE.LIST
        CHANGE @VM TO @FM IN Y.GENDER.LIST
        CHANGE @VM TO @FM IN Y.DATE.BIRTH.LIST
        CHANGE @VM TO @FM IN Y.SHORT.NAME.LIST
        CHANGE @VM TO @FM IN Y.NAME.1.LIST
        CHANGE @VM TO @FM IN Y.NAME.2.LIST
        CHANGE @VM TO @FM IN Y.NOM.PER.MORAL.LIST
        CHANGE @VM TO @FM IN Y.ESTADO.LIST

        LOCATE Y.RFC IN Y.RFC.LIST SETTING POS THEN
            Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
            IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                Y.ERROR = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ' :Y.CLIENTE.1   ;* ABC Capital. ':Y.CLIENTE.1 ;*20241029_RZN.SCL - S - E
                RETURN
            END
        END

        NUM.RFC = DCOUNT(Y.RFC.LIST, @FM)

        FOR X = 1 TO NUM.RFC
            GOSUB LIMPIA.VARIABLES

            Y.CLIENTE.1 = Y.CLIENTE.LIST<X>
            Y.DATE.BIRTH.1 = Y.DATE.BIRTH.LIST<X>
            Y.NOM.PER.MORAL.1 = Y.NOM.PER.MORAL.LIST<X>
            Y.ESTADO.1 = Y.ESTADO.LIST<X>

            IF Y.DATE.BIRTH EQ Y.DATE.BIRTH.1 AND Y.NOM.PER.MORAL EQ Y.NOM.PER.MORAL.1 AND Y.ESTADO EQ Y.ESTADO.1 THEN
                IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                    Y.ERROR = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ' :Y.CLIENTE.1         ;* ABC Capital. ':Y.CLIENTE.1 ;*20241029_RZN.SCL - S - E
                    RETURN
                END
            END
        NEXT X
    END

RETURN

******************
VALIDA.CLIENTE.PF:
******************

    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC.AUX,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)

* Before incorporation : CALL F.READ(FN.ABC.INFO.VAL.CUS,Y.RFC.AUX,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
    IF R.VAL.CUS THEN
        Y.RFC.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc>
        Y.CURP.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp>
        Y.CLIENTE.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente>
        Y.GENDER.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender>
        Y.DATE.BIRTH.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth>
        Y.SHORT.NAME.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName>
        Y.NAME.1.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1>
        Y.NAME.2.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2>
        Y.NOM.PER.MORAL.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral>
        Y.ESTADO.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado>

        CHANGE @VM TO @FM IN Y.RFC.LIST
        CHANGE @VM TO @FM IN Y.CURP.LIST
        CHANGE @VM TO @FM IN Y.CLIENTE.LIST
        CHANGE @VM TO @FM IN Y.GENDER.LIST
        CHANGE @VM TO @FM IN Y.DATE.BIRTH.LIST
        CHANGE @VM TO @FM IN Y.SHORT.NAME.LIST
        CHANGE @VM TO @FM IN Y.NAME.1.LIST
        CHANGE @VM TO @FM IN Y.NAME.2.LIST
        CHANGE @VM TO @FM IN Y.NOM.PER.MORAL.LIST
        CHANGE @VM TO @FM IN Y.ESTADO.LIST

        LOCATE Y.CURP IN Y.CURP.LIST SETTING POS THEN
            Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
            IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                EB.SystemTables.setEtext('Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ' :Y.CLIENTE.1)     ;* ABC Capital. ':Y.CLIENTE.1 ;*20241029_RZN.SCL - S - E
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

        NUM.RFC = DCOUNT(Y.RFC.LIST, FM)

        FOR X = 1 TO NUM.RFC
            GOSUB LIMPIA.VARIABLES

            Y.CLIENTE.1 = Y.CLIENTE.LIST<X>
            Y.GENDER.1 = Y.GENDER.LIST<X>
            Y.DATE.BIRTH.1 = Y.DATE.BIRTH.LIST<X>
            Y.SHORT.NAME.1 = Y.SHORT.NAME.LIST<X>
            Y.NAME.1.1 = Y.NAME.1.LIST<X>
            Y.NAME.2.1 = Y.NAME.2.LIST<X>
            Y.NOM.PER.MORAL.1 = Y.NOM.PER.MORAL.LIST<X>
            Y.ESTADO.1 = Y.ESTADO.LIST<X>

            IF Y.DATE.BIRTH EQ Y.DATE.BIRTH.1 AND Y.SHORT.NAME EQ Y.SHORT.NAME.1 AND Y.NAME.1 EQ Y.NAME.1.1 AND Y.NAME.2 EQ Y.NAME.2.1 AND Y.ESTADO EQ Y.ESTADO.1 THEN
                IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                    EB.SystemTables.setEtext('Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ' :Y.CLIENTE.1) ;* ABC Capital. ':Y.CLIENTE.1 ;*20241029_RZN.SCL - S - E
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
        NEXT X
    END

RETURN
******************************* FIN ABCCORE-3715 *******************************

*****************
LIMPIA.VARIABLES:
*****************

    Y.CLIENTE.1 = ''
    Y.GENDER.1 = ''
    Y.DATE.BIRTH.1 = ''
    Y.SHORT.NAME.1 = ''
    Y.NAME.1.1 = ''
    Y.NAME.2.1 = ''
    Y.NOM.PER.MORAL.1 = ''
    Y.ESTADO.1 = ''

RETURN

ABRE.TABLAS:

    F.ABC.ESTADO  = ""
    FN.ABC.ESTADO = "F.ABC.ESTADO"
    EB.DataAccess.Opf(FN.ABC.ESTADO, F.ABC.ESTADO)

    F.CUST$NAU  = ""
    FN.CUST$NAU = "F.CUSTOMER$NAU"
    EB.DataAccess.Opf(FN.CUST$NAU,F.CUST$NAU)

    F.CUSTOMER  = ""
    FN.CUSTOMER = "F.CUSTOMER"
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ABC.INFO.VAL.CUS = 'F.ABC.INFO.VAL.CUS'
    F.ABC.INFO.VAL.CUS = ''
    EB.DataAccess.Opf(FN.ABC.INFO.VAL.CUS,F.ABC.INFO.VAL.CUS)

*****************************************************************************
*Campos Locales
    
    
    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'NOM.PER.MORAL': @VM : 'LUGAR.CONST':@VM:'BIRTH.PROVINCE'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)
    
    YPOS.NOM.PER.MORAL   = V.FLD.POS<1,1>
    YPOS.LUGAR.CONST     = V.FLD.POS<1,2>
 *   Y.POS.BIRTH.PROV     = V.FLD.POS<1,3> 
    
*****************************************************************************

*20241029_RZN.SCL - S
    Y.RAZON.SOCIAL.ARG = "SHORT" ; Y.RAZON.SOCIAL = ''
    ABC.BP.AbcGetRazonSocial(Y.RAZON.SOCIAL.ARG)
    Y.RAZON.SOCIAL = Y.RAZON.SOCIAL.ARG
*20241029_RZN.SCL - E
 
RETURN

****************
MANTEN.REGISTRO:
****************
*    Y.VAL.ACTUAL = EB.SystemTables.getComi()
*    Y.ORIGEN = "GENERICO"
*    ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN

***************
VALIDA.DATOS:
********************
    APE.PATERNO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName)
    APE.MATERNO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)
    NOMBRE      = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)
    FEC.NAC     = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)
    LUG.NAC     = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDistrictName)
    GENERO      = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)

    IF LEN(APE.PATERNO) EQ 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA APELLIDO PATERNO"
        RETURN
    END

    IF LEN(APE.MATERNO) EQ 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA APELLIDO MATERNO"
        RETURN
    END

    IF LEN(NOMBRE) EQ 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA PRIMER NOMBRE"
        RETURN
    END

    IF LEN(FEC.NAC) EQ 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA FECHA DE NACIMIENTO"
        RETURN
    END

*    IF LEN(LUG.NAC) EQ 0 THEN
*        RES = ETEINC
*        MENSAJE = "FALTA LUGAR DE NACIMIENTO"
*        RETURN
*    END

*    IF LEN(GENERO) EQ 0 THEN
*        IF LEN(COMI) EQ 0 THEN
*            RES = ETEINC
*            MENSAJE = "FALTA SEXO"
*            RETURN
*        END
*
*    END
RETURN

VALIDA.DATOS.M:
    NOMBRE.EMP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)
    FEC.CONSTI = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)

    IF LEN(NOMBRE.EMP) EQ 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA INGRESAR NOMBRE DE LA EMPRESA"
        RETURN
    END

    IF LEN(FEC.CONSTI) EQ 0 THEN
        IF LEN(COMI) EQ 0 THEN
            RES = ETEINC
            MENSAJE = "FALTA FECHA DE CONSTITUCION DE EMPRESA"
            RETURN
        END
        Y.COMI = EB.SystemTables.getComi()
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusDateOfBirth,Y.COMI)
    END
RETURN


END
