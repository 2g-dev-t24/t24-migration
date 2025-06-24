* @ValidationCode : MjotNDcxMzc2NDpDcDEyNTI6MTc0NTYxMzMzNDY2ODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2025 17:35:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-28</Rating>
* Descripcion: Reporte que genera el RFC, En caso de usar la rutina en un
*              proceso de alta, asignar al parametro IN.ID.CLIENTE vac
******************************************************************************************
$PACKAGE ABC.BP
SUBROUTINE ABC.GENERA.RFC (IN.ID.CLIENTE, OUT.RFC, OUT.ERROR)

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences

    GOSUB INICIALIZACION
    GOSUB ABRIR.ARCHIVOS
    GOSUB PROCESO

RETURN

INICIALIZACION:

    FN.CTE   = "F.CUSTOMER"
    F.CTE    = ""
    CTE.RS   = ""
    CTE.ERR1 = ""
    Y.MINUS  = CHAR(164)
    Y.MAYUS  = CHAR(165)

    CTE.CAMPOS.LOCALES = ""
    POS.CLASSIFICATION = 0
    Y.SECTOR = ""

    OUT.ERROR = ''

RETURN

ABRIR.ARCHIVOS:

    EB.DataAccess.Opf(FN.CTE, F.CTE)

RETURN

PROCESO:

    IF IN.ID.CLIENTE NE "" THEN

        EB.DataAccess.FRead(FN.CTE, IN.ID.CLIENTE, CTE.RS, F.CTE, CTE.ERR1)

        IF CTE.RS EQ "" THEN

            OUT.ERROR = 'ERROR.1 NO SE ENCONTRO EL CLIENTE'

            RETURN
        END
    END


    IF IN.ID.CLIENTE NE "" THEN
        Y.SECTOR = CTE.RS<ST.Customer.Customer.EbCusSector>
    END ELSE
        Y.SECTOR = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    END

***
** OBTERNER LA FECHA DEL CLIENTE


    IF IN.ID.CLIENTE NE "" THEN
        A.FECHA.RFC = CTE.RS<ST.Customer.Customer.EbCusDateOfBirth>
    END ELSE
        A.FECHA.RFC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)
        IF A.FECHA.RFC EQ "" THEN A.FECHA.RFC = EB.SystemTables.getComi()
    END

    A.FECHA.RFC = A.FECHA.RFC[3, 6]

***
    IF A.FECHA.RFC EQ "" THEN
        OUT.ERROR = 'ERROR.2 NO SE ENCONTRO LA FECHA PARA EL CALCULO DEL RFC'
        RETURN
    END

** OBTENER NOMBRE DE CLIENTE PARA PERSONA MORAL Y HOMONIMIA

    GOSUB SET.NOMBRE.CLIENTE

    IF Y.SECTOR LT 1300 THEN

        GOSUB PROCESO.PER.FIS

        Y.CURP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)
        OUT.RFC = Y.CURP[1,4]

        IF LEN(OUT.RFC) NE 4 THEN
            OUT.ERROR = 'ERROR.3 NO SE PUDIERON CALCULAR LOS PRIMEROS 3 CARACTERES DE LA PERSONA MORAL'
            RETURN
        END
    END ELSE

        GOSUB PROCESO.PER.MORAL

        IF LEN(OUT.RFC) NE 3 THEN
            OUT.ERROR = 'ERROR.4 NO SE PUDIERON CALCULAR LOS PRIMEROS 4 CARACTERES DE LA PERSONA FISICA'
            RETURN
        END
    END

    OUT.RFC := A.FECHA.RFC

    GOSUB SET.HOMONIMIA

    IF LEN(OUT.RFC) NE 11 AND LEN(OUT.RFC) NE 12 THEN

        OUT.ERROR = 'ERROR.5 NO SE PUDIERON CALCULAR LOS 2 CARACTERES DE LA HOMONIMIA'

        RETURN

    END

    GOSUB SET.DIGITO.VER

    IF LEN(OUT.RFC) NE 12 AND LEN(OUT.RFC) NE 13 THEN

        OUT.ERROR = 'ERROR.6 NO SE PUDO CALCULAR EL DIGITO VERIFICADOR'

        RETURN

    END



RETURN

PROCESO.PER.FIS:

    GOSUB SET.INF.PER.FIS

    GOSUB SET.PER.FIS.REGLA.6

    GOSUB SET.LISTA.PER.FIS.ANEXO.V
    GOSUB SET.PER.FIS.ANEXO.V

    GOSUB SET.PER.FIS.REGLA.5

    IF LEN(A.FIS.APE.PATERNO) LE 2 THEN

        GOSUB SET.PER.FIS.REGLA.4

    END ELSE

        A.APELLIDOS = A.FIS.APE.PATERNO : '|' : A.FIS.APE.MATERNO
        A.APELLIDOS = TRIM(A.APELLIDOS)

        A.CANT.APELLIDOS = DCOUNT(A.APELLIDOS, '|')

        IF A.CANT.APELLIDOS EQ 1 THEN

            GOSUB SET.PER.FIS.REGLA.7

        END ELSE

            GOSUB SET.PER.FIS.REGLA.1

        END

    END

    GOSUB SET.PER.FIS.REGLA.9

RETURN

SET.INF.PER.FIS:

    IF IN.ID.CLIENTE NE '' THEN

        A.FIS.APE.PATERNO = CTE.RS<ST.Customer.Customer.EbCusShortName>
        A.FIS.APE.MATERNO = CTE.RS<ST.Customer.Customer.EbCusNameOne>

        POS.NOMBRE.2 = FIELD(CTE.CAMPOS.LOCALES,'#',3)
        A.NOMBRE.2 = CTE.RS<ST.Customer.Customer.EbCusLocalRef, POS.NOMBRE.2 >

        POS.NOMBRE.3 = FIELD(CTE.CAMPOS.LOCALES,'#',4)
        A.NOMBRE.3 = CTE.RS<ST.Customer.Customer.EbCusLocalRef, POS.NOMBRE.3 >


        A.FIS.NOMBRE = CTE.RS<ST.Customer.Customer.EbCusNameTwo> : '|' : A.NOMBRE.2 : '|' : A.NOMBRE.3
        A.FIS.NOMBRE = TRIM(A.FIS.NOMBRE)
    END

RETURN

SET.PER.FIS.REGLA.6:

    A.CANT.NOMBRES = DCOUNT(A.FIS.NOMBRE, '|')

    IF A.CANT.NOMBRES GE 2 THEN

        A.PRIM.NOMBRE = FIELD(A.FIS.NOMBRE, '|',1)

        IF  A.PRIM.NOMBRE EQ 'MA.' OR A.PRIM.NOMBRE EQ 'MA' OR A.PRIM.NOMBRE EQ 'MARIA' OR A.PRIM.NOMBRE EQ 'MARIA' OR A.PRIM.NOMBRE EQ 'JOSE' OR A.PRIM.NOMBRE EQ 'JOSE' THEN

            A.NEW.NOMBRE = ''

            FOR A.I.NOM = 2 TO A.CANT.NOMBRES

                A.NEW.NOMBRE := ' ' : FIELD(A.FIS.NOMBRE, '|', A.I.NOM)

            NEXT A.I.NOM

            A.NEW.NOMBRE = TRIM(A.NEW.NOMBRE)

            A.FIS.NOMBRE = A.NEW.NOMBRE
        END
    END

    A.FIS.NOMBRE = TRIM(A.FIS.NOMBRE)

RETURN

SET.PER.FIS.ANEXO.V:

    A.PARTE.NOMBRE = A.FIS.APE.PATERNO
    GOSUB PROCESO.PER.FIS.ANEXO.V
    A.FIS.APE.PATERNO = A.PARTE.NOMBRE

    A.PARTE.NOMBRE = A.FIS.APE.MATERNO
    GOSUB PROCESO.PER.FIS.ANEXO.V
    A.FIS.APE.MATERNO = A.PARTE.NOMBRE

    A.PARTE.NOMBRE = A.FIS.NOMBRE
    GOSUB PROCESO.PER.FIS.ANEXO.V
    A.FIS.NOMBRE = A.PARTE.NOMBRE

RETURN

PROCESO.PER.FIS.ANEXO.V:

    A.PARTE.NOMBRE = TRIM(A.PARTE.NOMBRE)

    A.CANT.PALABRAS = DCOUNT(A.PARTE.NOMBRE, ' ')

    A.NEW.NOMBRE = ''

    FOR A.I.PALABRAS = 1 TO A.CANT.PALABRAS

        A.PALABRA = FIELD(A.PARTE.NOMBRE, ' ', A.I.PALABRAS)

        FIND A.PALABRA IN A.FIS.LISTA SETTING Ap,Vp ELSE

            A.NEW.NOMBRE := ' ' : A.PALABRA

        END

    NEXT A.I.PALABRAS

    A.NEW.NOMBRE = TRIM(A.NEW.NOMBRE)

    A.PARTE.NOMBRE = A.NEW.NOMBRE

RETURN

SET.LISTA.PER.FIS.ANEXO.V:

    A.FIS.LISTA = ''
    A.FIS.LISTA<-1> = 'DE'
    A.FIS.LISTA<-1> = 'LA'
    A.FIS.LISTA<-1> = 'LAS'
    A.FIS.LISTA<-1> = 'MC'
    A.FIS.LISTA<-1> = 'VON'
    A.FIS.LISTA<-1> = 'DEL'
    A.FIS.LISTA<-1> = 'LOS'
    A.FIS.LISTA<-1> = 'Y'
    A.FIS.LISTA<-1> = 'MAC'
    A.FIS.LISTA<-1> = 'VAN'
    A.FIS.LISTA<-1> = 'MI'

RETURN

SET.PER.FIS.REGLA.5:

    A.FIS.APE.PATERNO = FIELD(A.FIS.APE.PATERNO, ' ', 1)
    A.FIS.APE.PATERNO = TRIM(A.FIS.APE.PATERNO)

    A.FIS.APE.MATERNO = FIELD(A.FIS.APE.MATERNO, ' ', 1)
    A.FIS.APE.MATERNO = TRIM(A.FIS.APE.MATERNO)

RETURN

SET.PER.FIS.REGLA.4:

    OUT.RFC = A.FIS.APE.PATERNO[1, 1] : A.FIS.APE.MATERNO[1, 1] : A.FIS.NOMBRE[1, 2]

RETURN

SET.PER.FIS.REGLA.7:

    OUT.RFC = A.APELLIDOS[1, 2] : A.FIS.NOMBRE[1, 2]

RETURN

SET.PER.FIS.REGLA.1:

    A.VOCALES = 'A' : FM : 'E' : FM : 'I' : FM : 'O' : FM : 'U'

    FOR A.I.LETRA = 2 TO LEN(A.FIS.APE.PATERNO)

        FIND A.FIS.APE.PATERNO[A.I.LETRA, 1] IN A.VOCALES SETTING Ap,Vp THEN

            A.VOCAL = A.FIS.APE.PATERNO[A.I.LETRA, 1]

            A.I.LETRA = LEN(A.FIS.APE.PATERNO) + 1
        END
    NEXT A.I.LETRA

    OUT.RFC = A.FIS.APE.PATERNO[1, 1] : A.VOCAL : A.FIS.APE.MATERNO[1, 1] : A.FIS.NOMBRE[1, 1]

RETURN

SET.PER.FIS.REGLA.9:

    GOSUB SET.LISTA.PER.FIS.REG.9

    FIND ('K' : OUT.RFC) IN A.LISTA.PAL.ALT SETTING Ap,Vp THEN
        OUT.RFC = A.LISTA.PAL.ALT<Ap,2>
    END

RETURN

SET.LISTA.PER.FIS.REG.9:

    A.LISTA.PAL.ALT  = 'KBUEI' : VM : 'BUEX' : FM
    A.LISTA.PAL.ALT := 'KBUEY' : VM : 'BUEX' : FM
    A.LISTA.PAL.ALT := 'KCACA' : VM : 'CACX' : FM
    A.LISTA.PAL.ALT := 'KCACO' : VM : 'CACX' : FM
    A.LISTA.PAL.ALT := 'KCAGA' : VM : 'CAGX' : FM
    A.LISTA.PAL.ALT := 'KCAGO' : VM : 'CAGX' : FM
    A.LISTA.PAL.ALT := 'KCAKA' : VM : 'CAKX' : FM
    A.LISTA.PAL.ALT := 'KCOGE' : VM : 'COGX' : FM
    A.LISTA.PAL.ALT := 'KCOJA' : VM : 'COJX' : FM
    A.LISTA.PAL.ALT := 'KCOJE' : VM : 'COJX' : FM
    A.LISTA.PAL.ALT := 'KCOJI' : VM : 'COJX' : FM
    A.LISTA.PAL.ALT := 'KCOJO' : VM : 'COJX' : FM
    A.LISTA.PAL.ALT := 'KCULO' : VM : 'CULX' : FM
    A.LISTA.PAL.ALT := 'KFETO' : VM : 'FETX' : FM
    A.LISTA.PAL.ALT := 'KGUEY' : VM : 'GUEX' : FM
    A.LISTA.PAL.ALT := 'KJOTO' : VM : 'JOTX' : FM
    A.LISTA.PAL.ALT := 'KKACA' : VM : 'KACX' : FM
    A.LISTA.PAL.ALT := 'KKACO' : VM : 'KACX' : FM
    A.LISTA.PAL.ALT := 'KKAGA' : VM : 'KAGX' : FM
    A.LISTA.PAL.ALT := 'KKAGO' : VM : 'KAGX' : FM
    A.LISTA.PAL.ALT := 'KKOGE' : VM : 'KOGX' : FM
    A.LISTA.PAL.ALT := 'KKOJO' : VM : 'KOJX' : FM
    A.LISTA.PAL.ALT := 'KKAKA' : VM : 'KAKX' : FM
    A.LISTA.PAL.ALT := 'KKULO' : VM : 'KULX' : FM
    A.LISTA.PAL.ALT := 'KMAME' : VM : 'MAMX' : FM
    A.LISTA.PAL.ALT := 'KMAMO' : VM : 'MAMX' : FM
    A.LISTA.PAL.ALT := 'KMEAR' : VM : 'MEAX' : FM
    A.LISTA.PAL.ALT := 'KMEON' : VM : 'MEOX' : FM
    A.LISTA.PAL.ALT := 'KMION' : VM : 'MIOX' : FM
    A.LISTA.PAL.ALT := 'KMOCO' : VM : 'MOCX' : FM
    A.LISTA.PAL.ALT := 'KMULA' : VM : 'MULX' : FM
    A.LISTA.PAL.ALT := 'KPEDA' : VM : 'PEDX' : FM
    A.LISTA.PAL.ALT := 'KPEDO' : VM : 'PEDX' : FM
    A.LISTA.PAL.ALT := 'KPENE' : VM : 'PENX' : FM
    A.LISTA.PAL.ALT := 'KPUTA' : VM : 'PUTX' : FM
    A.LISTA.PAL.ALT := 'KPUTO' : VM : 'PUTX' : FM
    A.LISTA.PAL.ALT := 'KQULO' : VM : 'QULX' : FM
    A.LISTA.PAL.ALT := 'KRATA' : VM : 'RATX' : FM
    A.LISTA.PAL.ALT := 'KRUIN' : VM : 'RUIX' : FM


RETURN

PROCESO.PER.MORAL:

    GOSUB SET.PER.MOR.ANEXO.V
    GOSUB SET.PER.MOR.ANEXO.VI
    GOSUB SET.MOR.REGLA.4
    GOSUB SET.MOR.REGLA.10

    A.CANT.PALABRAS = DCOUNT(A.CLIENTE, ' ')

    IF A.CANT.PALABRAS EQ 1 THEN

        GOSUB SET.MOR.REGLA.7.Y.8

    END ELSE

        IF A.CANT.PALABRAS EQ 2 THEN

            GOSUB SET.MOR.REGLA.6

        END ELSE

            GOSUB SET.MOR.REGLA.1

        END
    END

RETURN


SET.NOMBRE.CLIENTE:

    IF IN.ID.CLIENTE EQ "" THEN

        A.FIS.APE.PATERNO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName)
        A.FIS.APE.MATERNO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)

        A.FIS.APE.PATERNO = TRIM(A.FIS.APE.PATERNO) ;*PRUEBA
        A.FIS.APE.MATERNO = TRIM(A.FIS.APE.MATERNO) ;*PRUEBA

        A.FIS.NOMBRE = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)

        *A.FIS.NOMBRE = EREPLACE(A.FIS.NOMBRE,FM," ")
        *A.FIS.NOMBRE = EREPLACE(A.FIS.NOMBRE,VM," ")
        *A.FIS.NOMBRE = EREPLACE(A.FIS.NOMBRE,"  "," ")

;*PRUEBA
        Y.NUM.VM = DCOUNT(A.FIS.NOMBRE, @VM)
        NOM.COMPLETO = ""
        FOR I = 1 TO Y.NUM.VM
            Y.NOM.TURNO   = FIELD(A.FIS.NOMBRE, @VM,I)
            NOM.COMPLETO := Y.NOM.TURNO : " "
        NEXT I

        NOM.COMPLETO = TRIM(NOM.COMPLETO)

        LONG.NOM  = LEN(NOM.COMPLETO)
        FOR POS.CARACTER = 1 TO LONG.NOM
            IF NOM.COMPLETO[LONG.NOM,1] EQ ' ' THEN
                NOM.COMPLETO[LONG.NOM,1] = ''
                POS.CARACTER = LONG.NOM - 1
            END
        NEXT

        *A.FIS.NOMBRE = TRIM(A.FIS.NOMBRE)
        A.FIS.NOMBRE =  NOM.COMPLETO
;*PRUEBA
        IF Y.SECTOR LT 1300 THEN
            *A.CLIENTE = A.FIS.APE.PATERNO : ' ' : A.FIS.APE.MATERNO : ' ' : A.FIS.NOMBRE ;*PRUEBA
            A.CLIENTE = A.FIS.APE.PATERNO : A.FIS.APE.MATERNO : A.FIS.NOMBRE  ;*PRUEBA
        END ELSE
            A.CLIENTE = A.FIS.APE.MATERNO
        END
    END ELSE
        A.BAK.COMI = EB.SystemTables.getComi()
        Y.NEW.COMI = IN.ID.CLIENTE :'*':'1'
        EB.SystemTables.setComi(Y.NEW.COMI)
        ABC.BP.VpmVCustomerName()
        EB.SystemTables.setComi(A.BAK.COMI)

        A.CLIENTE = EB.SystemTables.getComiEnri()
    END

    *CHANGE ',' TO ' ' IN A.CLIENTE

    A.CLIENTE = UPCASE(A.CLIENTE)
    A.CLIENTE = TRIM(A.CLIENTE)

    A.NOM.CLIENTE.ORIG = A.CLIENTE

RETURN

SET.PER.MOR.ANEXO.V:

    GOSUB SET.LISTA.PER.MOR.ANEXO.V

    A.CANT.MOR.COMP = DCOUNT(A.MOR.PALABRAS.COMP, FM)

    FOR A.I.MOR.COMP = 1 TO A.CANT.MOR.COMP
        A.MOR.STRING = A.MOR.PALABRAS.COMP<A.I.MOR.COMP>

        CHANGE A.MOR.STRING TO '' IN A.CLIENTE
    NEXT A.I.MOR.COMP

    CHANGE ',' TO ' ' IN A.CLIENTE

    A.CLIENTE       = TRIM(A.CLIENTE)
    A.CANT.PALABRAS = DCOUNT(A.CLIENTE, ' ')
    A.NEW.NOMBRE    = ''

    FOR A.I.PALABRAS = 1 TO A.CANT.PALABRAS
        A.PALABRA = FIELD(A.CLIENTE, ' ', A.I.PALABRAS)

        FIND A.PALABRA IN A.MOR.PALABRAS.SENC SETTING Ap,Vp ELSE
            A.NEW.NOMBRE := ' ' : A.PALABRA
        END
    NEXT A.I.PALABRAS

    A.NEW.NOMBRE = TRIM(A.NEW.NOMBRE)
    A.CLIENTE = A.NEW.NOMBRE

RETURN

SET.LISTA.PER.MOR.ANEXO.V:

    A.MOR.PALABRAS.COMP = ''
    A.MOR.PALABRAS.COMP<-1> = ' SA DE CV MI'
    A.MOR.PALABRAS.COMP<-1> = ' S.A. DE C.V. M.I.'
    A.MOR.PALABRAS.COMP<-1> = ' S.A DE C.V M.I'
    A.MOR.PALABRAS.COMP<-1> = ' S. A. DE C. V. M. I.'

    A.MOR.PALABRAS.COMP<-1> = ' SC DE AP DE RL DE CV'
    A.MOR.PALABRAS.COMP<-1> = ' S.C. DE A.P. DE R.L. DE C.V.'
    A.MOR.PALABRAS.COMP<-1> = ' S.C DE A.P DE R.L DE C.V'
    A.MOR.PALABRAS.COMP<-1> = ' S. C. DE A. P. DE R. L. DE C. V.'

    A.MOR.PALABRAS.COMP<-1> = ' SA DE CV MI'
    A.MOR.PALABRAS.COMP<-1> = ' S.A. DE C.V. M.I.'
    A.MOR.PALABRAS.COMP<-1> = ' S.A DE C.V M.I'
    A.MOR.PALABRAS.COMP<-1> = ' S. A. DE C. V. M. I.'

    A.MOR.PALABRAS.COMP<-1> = ' SRL CV MI'
    A.MOR.PALABRAS.COMP<-1> = ' S.R.L. C.V. M.I.'
    A.MOR.PALABRAS.COMP<-1> = ' S.R.L C.V M.I'
    A.MOR.PALABRAS.COMP<-1> = ' S. R. L. C. V. M. I.'

    A.MOR.PALABRAS.COMP<-1> = ' S DE RL'
    A.MOR.PALABRAS.COMP<-1> = ' S. DE R.L.'
    A.MOR.PALABRAS.COMP<-1> = ' S DE R.L'
    A.MOR.PALABRAS.COMP<-1> = ' S. DE R. L.'

    A.MOR.PALABRAS.COMP<-1> = ' SA DE CV'
    A.MOR.PALABRAS.COMP<-1> = ' S.A. DE C.V.'
    A.MOR.PALABRAS.COMP<-1> = ' S.A DE C.V'
    A.MOR.PALABRAS.COMP<-1> = ' S. A. DE C. V.'

    A.MOR.PALABRAS.COMP<-1> = ' S EN C POR A'
    A.MOR.PALABRAS.COMP<-1> = ' S. EN C. POR A.'

    A.MOR.PALABRAS.COMP<-1> = ' A EN P'
    A.MOR.PALABRAS.COMP<-1> = ' A. EN P.'

    A.MOR.PALABRAS.COMP<-1> = ' S EN NC'
    A.MOR.PALABRAS.COMP<-1> = ' S. EN N.C.'
    A.MOR.PALABRAS.COMP<-1> = ' S. EN N.C'
    A.MOR.PALABRAS.COMP<-1> = ' S. EN N. C.'

    A.MOR.PALABRAS.COMP<-1> = ' S EN C'
    A.MOR.PALABRAS.COMP<-1> = ' S. EN C.'

    A.MOR.PALABRAS.COMP<-1> = ' SRL CV'
    A.MOR.PALABRAS.COMP<-1> = ' S.R.L. C.V.'
    A.MOR.PALABRAS.COMP<-1> = ' S.R.L C.V'
    A.MOR.PALABRAS.COMP<-1> = ' S. R. L. C. V.'

    A.MOR.PALABRAS.COMP<-1> = ' SA MI'
    A.MOR.PALABRAS.COMP<-1> = ' S.A. M.I.'
    A.MOR.PALABRAS.COMP<-1> = ' S.A M.I'
    A.MOR.PALABRAS.COMP<-1> = ' S. A. M. I.'

    A.MOR.PALABRAS.COMP<-1> = ' SRL MI'
    A.MOR.PALABRAS.COMP<-1> = ' S.R.L. M.I.'
    A.MOR.PALABRAS.COMP<-1> = ' S.R.L M.I'
    A.MOR.PALABRAS.COMP<-1> = ' S. R. L. M. I.'

    A.MOR.PALABRAS.SENC = ''
    A.MOR.PALABRAS.SENC<-1> = 'EL'
    A.MOR.PALABRAS.SENC<-1> = 'LA'
    A.MOR.PALABRAS.SENC<-1> = 'DE'
    A.MOR.PALABRAS.SENC<-1> = 'LOS'
    A.MOR.PALABRAS.SENC<-1> = 'LAS'
    A.MOR.PALABRAS.SENC<-1> = 'Y'
    A.MOR.PALABRAS.SENC<-1> = 'DEL'
    A.MOR.PALABRAS.SENC<-1> = 'SA'
    A.MOR.PALABRAS.SENC<-1> = 'S.A.'
    A.MOR.PALABRAS.SENC<-1> = 'COMPAA'
    A.MOR.PALABRAS.SENC<-1> = 'CIA'
    A.MOR.PALABRAS.SENC<-1> = 'CIA.'
    A.MOR.PALABRAS.SENC<-1> = 'SOCIEDAD'
    A.MOR.PALABRAS.SENC<-1> = 'SOC'
    A.MOR.PALABRAS.SENC<-1> = 'SOC.'
    A.MOR.PALABRAS.SENC<-1> = 'COOPERATIVA'
    A.MOR.PALABRAS.SENC<-1> = 'COOP'
    A.MOR.PALABRAS.SENC<-1> = 'COOP.'
    A.MOR.PALABRAS.SENC<-1> = 'PARA'
    A.MOR.PALABRAS.SENC<-1> = 'EN'
    A.MOR.PALABRAS.SENC<-1> = 'POR'
    A.MOR.PALABRAS.SENC<-1> = 'CON'
    A.MOR.PALABRAS.SENC<-1> = 'AL'
    A.MOR.PALABRAS.SENC<-1> = 'SUS'
    A.MOR.PALABRAS.SENC<-1> = 'E'
    A.MOR.PALABRAS.SENC<-1> = 'SC'
    A.MOR.PALABRAS.SENC<-1> = 'S.C.'
    A.MOR.PALABRAS.SENC<-1> = 'SCL'
    A.MOR.PALABRAS.SENC<-1> = 'S.C.L.'
    A.MOR.PALABRAS.SENC<-1> = 'SCS'
    A.MOR.PALABRAS.SENC<-1> = 'S.C.S.'
    A.MOR.PALABRAS.SENC<-1> = 'SNC'
    A.MOR.PALABRAS.SENC<-1> = 'S.N.C'
    A.MOR.PALABRAS.SENC<-1> = 'THE'
    A.MOR.PALABRAS.SENC<-1> = 'OF'
    A.MOR.PALABRAS.SENC<-1> = 'AND'
    A.MOR.PALABRAS.SENC<-1> = 'COMPANY'
    A.MOR.PALABRAS.SENC<-1> = 'CO'
    A.MOR.PALABRAS.SENC<-1> = 'CO.'
    A.MOR.PALABRAS.SENC<-1> = 'MC'
    A.MOR.PALABRAS.SENC<-1> = 'MAC'
    A.MOR.PALABRAS.SENC<-1> = 'VON'
    A.MOR.PALABRAS.SENC<-1> = 'VAN'
    A.MOR.PALABRAS.SENC<-1> = 'MI'
    A.MOR.PALABRAS.SENC<-1> = 'A'


RETURN

SET.PER.MOR.ANEXO.VI:

    GOSUB SET.LISTA.PER.MOR.ANEXO.VI

    A.CANT.PALABRAS = DCOUNT(A.CLIENTE, ' ')
    A.NEW.NOMBRE = ''

    FOR A.I.PALABRAS = 1 TO A.CANT.PALABRAS
        A.PALABRA = FIELD(A.CLIENTE, ' ', A.I.PALABRAS)

        FIND ('K' :  A.PALABRA) IN A.MOR.CAR.ESP SETTING Ap,Vp THEN
            A.NEW.NOMBRE := ' ' : A.MOR.CAR.ESP<Ap,2>
        END ELSE
            A.NEW.NOMBRE := ' ' : A.PALABRA
        END
    NEXT A.I.PALABRAS

    A.NEW.NOMBRE = TRIM(A.NEW.NOMBRE)
    A.CLIENTE = A.NEW.NOMBRE

RETURN

SET.LISTA.PER.MOR.ANEXO.VI:

    A.MOR.CAR.ESP  = '@' : VM : 'ARROBA'    : FM
    A.MOR.CAR.ESP := "'" : VM : 'APOSTROFE' : FM
    A.MOR.CAR.ESP := '%' : VM : 'PORCIENTO' : FM
    A.MOR.CAR.ESP := '#' : VM : 'NUMERO'    : FM
    A.MOR.CAR.ESP := '!' : VM : 'ADMIRACION': FM
    A.MOR.CAR.ESP := '.' : VM : 'PUNTO'      : FM
    A.MOR.CAR.ESP := '$' : VM : 'PESOS'       : FM
    A.MOR.CAR.ESP := '"' : VM : 'COMILLAS'     : FM
    A.MOR.CAR.ESP := '-' : VM : 'GUION'         : FM
    A.MOR.CAR.ESP := '/' : VM : 'DIAGONAL'       : FM
    A.MOR.CAR.ESP := '+' : VM : 'SUMA'            : FM
    A.MOR.CAR.ESP := '(' : VM : 'ABRE PARENTESIS'  : FM
    A.MOR.CAR.ESP := ')' : VM : 'CIERRA PARENTESIS' : FM

RETURN

SET.MOR.REGLA.4:

    A.CANT.PALABRAS = DCOUNT(A.CLIENTE, ' ')

    A.NEW.NOMBRE.CTE = ''

    FOR  A.I.PALABRAS = 1 TO A.CANT.PALABRAS
        A.PALABRA = FIELD(A.CLIENTE, ' ', A.I.PALABRAS)
        A.CANT.PTOS = COUNT(A.PALABRA, '.')

        IF (2 * A.CANT.PTOS) EQ LEN(A.PALABRA) THEN
            CHANGE '.' TO ' ' IN A.PALABRA
        END

        A.NEW.NOMBRE.CTE := ' ' : A.PALABRA
    NEXT A.I.PALABRAS

    A.NEW.NOMBRE.CTE = TRIM(A.NEW.NOMBRE.CTE)

    A.CLIENTE = A.NEW.NOMBRE.CTE

RETURN

SET.MOR.REGLA.10:

    A.CANT.PALABRAS = DCOUNT(A.CLIENTE, ' ')

    A.NEW.NOMBRE.CTE = ''

    FOR  A.I.PALABRAS = 1 TO A.CANT.PALABRAS

        A.PALABRA = FIELD(A.CLIENTE, ' ', A.I.PALABRAS)

        IF ISDIGIT(A.PALABRA) THEN

            ABC.BP.VpmCantidadLetra(A.PALABRA, A.PALABRA, '', '', Y.ERR.LETRA)

            A.PALABRA = UPCASE(A.PALABRA[1, LEN(A.PALABRA) - 16])

        END

        A.NEW.NOMBRE.CTE := ' ' : A.PALABRA

    NEXT A.I.PALABRAS

    A.NEW.NOMBRE.CTE = TRIM(A.NEW.NOMBRE.CTE)

    A.CLIENTE = A.NEW.NOMBRE.CTE


RETURN

SET.MOR.REGLA.7.Y.8:

    OUT.RFC = A.CLIENTE[1, 3]

    IF LEN(OUT.RFC) LT 3 THEN

        FOR INT.RFC = (LEN(OUT.RFC)) TO 2

            OUT.RFC := 'X'

        NEXT INT.RFC

    END

RETURN

SET.MOR.REGLA.6:

    A.PALABRA = FIELD(A.CLIENTE, ' ', 1)

    OUT.RFC = A.PALABRA[1, 1]

    A.PALABRA = FIELD(A.CLIENTE, ' ', 2)

    OUT.RFC := A.PALABRA[1, 2]


RETURN

SET.MOR.REGLA.1:

    OUT.RFC = ''

    FOR I.PALABRAS = 1 TO 3

        A.PALABRA = FIELD(A.CLIENTE, ' ', I.PALABRAS)

        OUT.RFC := A.PALABRA[1, 1]

    NEXT I.PALABRAS


RETURN

SET.HOMONIMIA:

    A.NUM.NOMBRE = ''

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

    OUT.RFC := A.COC.HOM : A.RES.HOM

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

SET.DIGITO.VER:

    A.SUM.DIG = 0
    A.FACTOR = 13

    AUX.RFC = OUT.RFC

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

    OUT.RFC := A.RES.DIG

    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, OUT.RFC)

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
END
