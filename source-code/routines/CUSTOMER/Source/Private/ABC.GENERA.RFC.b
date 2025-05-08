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

    GOSUB SET.LISTA.ANEXO.1
    GOSUB SET.LISTA.ANEXO.2
    GOSUB SET.LISTA.ANEXO.3

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

        A.FIS.NOMBRE = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)
        A.FIS.NOMBRE = EREPLACE(A.FIS.NOMBRE,FM," ")
        A.FIS.NOMBRE = EREPLACE(A.FIS.NOMBRE,VM," ")
        A.FIS.NOMBRE = EREPLACE(A.FIS.NOMBRE,"  "," ")
        A.FIS.NOMBRE = TRIM(A.FIS.NOMBRE)

        IF Y.SECTOR LT 1300 THEN
            A.CLIENTE = A.FIS.APE.PATERNO : ' ' : A.FIS.APE.MATERNO : ' ' : A.FIS.NOMBRE
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

    CHANGE ',' TO ' ' IN A.CLIENTE

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

    A.NUM.NOMBRE = '0'

    FOR A.I.NOM = 1 TO LEN(A.NOM.CLIENTE.ORIG)

        FIND ('K' : A.NOM.CLIENTE.ORIG[A.I.NOM, 1]) IN A.ANEXO.1 SETTING Ap,Vp THEN

            A.NUM.NOMBRE := A.ANEXO.1<Ap,2>

        END

    NEXT A.I.NOM

    A.SUM.HOM = 0

    FOR A.I.NUM.NOM = 1 TO LEN(A.NUM.NOMBRE)

        A.NUM.1 = A.NUM.NOMBRE[A.I.NUM.NOM, 2]
        A.NUM.2 = A.NUM.NOMBRE[(A.I.NUM.NOM+1), 1]

        A.SUM.HOM += A.NUM.NOMBRE[A.I.NUM.NOM, 2] * A.NUM.NOMBRE[(A.I.NUM.NOM+1), 1]

    NEXT A.I.NUM.NOM

    A.SUM.HOM = MOD(A.SUM.HOM, 1000)

    A.RES.HOM = MOD(A.SUM.HOM, 34)

    A.COC.HOM = (A.SUM.HOM-A.RES.HOM) / 34

    FIND ('K' : A.COC.HOM) IN A.ANEXO.2 SETTING Ap,Vp THEN

        A.COC.HOM = A.ANEXO.2<Ap,2>

    END

    FIND ('K' : A.RES.HOM) IN A.ANEXO.2 SETTING Ap,Vp THEN

        A.RES.HOM = A.ANEXO.2<Ap,2>

    END

    OUT.RFC := A.COC.HOM : A.RES.HOM

RETURN

SET.LISTA.ANEXO.1:

    A.ANEXO.1  = 'K ' : VM : '00' : FM
    A.ANEXO.1 := 'K0' : VM : '00' : FM
    A.ANEXO.1 := 'K1' : VM : '01' : FM
    A.ANEXO.1 := 'K2' : VM : '02' : FM
    A.ANEXO.1 := 'K3' : VM : '03' : FM
    A.ANEXO.1 := 'K4' : VM : '04' : FM
    A.ANEXO.1 := 'K5' : VM : '05' : FM
    A.ANEXO.1 := 'K6' : VM : '06' : FM
    A.ANEXO.1 := 'K7' : VM : '07' : FM
    A.ANEXO.1 := 'K8' : VM : '08' : FM
    A.ANEXO.1 := 'K9' : VM : '09' : FM
    A.ANEXO.1 := 'K&' : VM : '10' : FM
    A.ANEXO.1 := 'KA' : VM : '11' : FM
    A.ANEXO.1 := 'KB' : VM : '12' : FM
    A.ANEXO.1 := 'KC' : VM : '13' : FM
    A.ANEXO.1 := 'KD' : VM : '14' : FM
    A.ANEXO.1 := 'KE' : VM : '15' : FM
    A.ANEXO.1 := 'KF' : VM : '16' : FM
    A.ANEXO.1 := 'KG' : VM : '17' : FM
    A.ANEXO.1 := 'KH' : VM : '18' : FM
    A.ANEXO.1 := 'KI' : VM : '19' : FM
    A.ANEXO.1 := 'KJ' : VM : '21' : FM
    A.ANEXO.1 := 'KK' : VM : '22' : FM
    A.ANEXO.1 := 'KL' : VM : '23' : FM
    A.ANEXO.1 := 'KM' : VM : '24' : FM
    A.ANEXO.1 := 'KN' : VM : '25' : FM
    A.ANEXO.1 := 'KO' : VM : '26' : FM
    A.ANEXO.1 := 'KP' : VM : '27' : FM
    A.ANEXO.1 := 'KQ' : VM : '28' : FM
    A.ANEXO.1 := 'KR' : VM : '29' : FM
    A.ANEXO.1 := 'KS' : VM : '32' : FM
    A.ANEXO.1 := 'KT' : VM : '33' : FM
    A.ANEXO.1 := 'KU' : VM : '34' : FM
    A.ANEXO.1 := 'KV' : VM : '35' : FM
    A.ANEXO.1 := 'KW' : VM : '36' : FM
    A.ANEXO.1 := 'KX' : VM : '37' : FM
    A.ANEXO.1 := 'KY' : VM : '38' : FM
    A.ANEXO.1 := 'KZ' : VM : '39' : FM
    A.ANEXO.1 := 'K':Y.MAYUS : VM : '40'

RETURN

SET.LISTA.ANEXO.2:

    A.ANEXO.2  = 'K0'  : VM : '1' : FM
    A.ANEXO.2 := 'K1'  : VM : '2' : FM
    A.ANEXO.2 := 'K2'  : VM : '3' : FM
    A.ANEXO.2 := 'K3'  : VM : '4' : FM
    A.ANEXO.2 := 'K4'  : VM : '5' : FM
    A.ANEXO.2 := 'K5'  : VM : '6' : FM
    A.ANEXO.2 := 'K6'  : VM : '7' : FM
    A.ANEXO.2 := 'K7'  : VM : '8' : FM
    A.ANEXO.2 := 'K8'  : VM : '9' : FM
    A.ANEXO.2 := 'K9'  : VM : 'A' : FM
    A.ANEXO.2 := 'K10' : VM : 'B' : FM
    A.ANEXO.2 := 'K11' : VM : 'C' : FM
    A.ANEXO.2 := 'K12' : VM : 'D' : FM
    A.ANEXO.2 := 'K13' : VM : 'E' : FM
    A.ANEXO.2 := 'K14' : VM : 'F' : FM
    A.ANEXO.2 := 'K15' : VM : 'G' : FM
    A.ANEXO.2 := 'K16' : VM : 'H' : FM
    A.ANEXO.2 := 'K17' : VM : 'I' : FM
    A.ANEXO.2 := 'K18' : VM : 'J' : FM
    A.ANEXO.2 := 'K19' : VM : 'K' : FM
    A.ANEXO.2 := 'K20' : VM : 'L' : FM
    A.ANEXO.2 := 'K21' : VM : 'M' : FM
    A.ANEXO.2 := 'K22' : VM : 'N' : FM
    A.ANEXO.2 := 'K23' : VM : 'P' : FM
    A.ANEXO.2 := 'K24' : VM : 'Q' : FM
    A.ANEXO.2 := 'K25' : VM : 'R' : FM
    A.ANEXO.2 := 'K26' : VM : 'S' : FM
    A.ANEXO.2 := 'K27' : VM : 'T' : FM
    A.ANEXO.2 := 'K28' : VM : 'U' : FM
    A.ANEXO.2 := 'K29' : VM : 'V' : FM
    A.ANEXO.2 := 'K30' : VM : 'W' : FM
    A.ANEXO.2 := 'K31' : VM : 'X' : FM
    A.ANEXO.2 := 'K32' : VM : 'Y' : FM
    A.ANEXO.2 := 'K33' : VM : 'Z' : FM

RETURN

SET.DIGITO.VER:

    A.SUM.DIG = 0
    A.FACTOR = 13

    AUX.RFC = OUT.RFC

    IF LEN(AUX.RFC) EQ 11 THEN AUX.RFC = ' ' : AUX.RFC

    FOR A.I.NOM = 1 TO 12

        FIND ('K' : AUX.RFC[A.I.NOM, 1]) IN A.ANEXO.3 SETTING Ap,Vp THEN
            A.SUM.DIG += A.ANEXO.3<Ap, 2> * A.FACTOR
            A.FACTOR -= 1
        END
    NEXT A.I.NOM

    A.RES.DIG = MOD(A.SUM.DIG, 11)

    IF A.RES.DIG GT 0 THEN
        A.RES.DIG = 11 - A.RES.DIG
        IF A.RES.DIG EQ 10 THEN A.RES.DIG = 'A'
    END

    OUT.RFC := A.RES.DIG

    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, OUT.RFC)

RETURN

SET.LISTA.ANEXO.3:

    A.ANEXO.3  = 'K0'  : VM : '00' : FM
    A.ANEXO.3 := 'K1'  : VM : '01' : FM
    A.ANEXO.3 := 'K2'  : VM : '02' : FM
    A.ANEXO.3 := 'K3'  : VM : '03' : FM
    A.ANEXO.3 := 'K4'  : VM : '04' : FM
    A.ANEXO.3 := 'K5'  : VM : '05' : FM
    A.ANEXO.3 := 'K6'  : VM : '06' : FM
    A.ANEXO.3 := 'K7'  : VM : '07' : FM
    A.ANEXO.3 := 'K8'  : VM : '08' : FM
    A.ANEXO.3 := 'K9'  : VM : '09' : FM
    A.ANEXO.3 := 'KA'  : VM : '10' : FM
    A.ANEXO.3 := 'KB'  : VM : '11' : FM
    A.ANEXO.3 := 'KC'  : VM : '12' : FM
    A.ANEXO.3 := 'KD'  : VM : '13' : FM
    A.ANEXO.3 := 'KE'  : VM : '14' : FM
    A.ANEXO.3 := 'KF'  : VM : '15' : FM
    A.ANEXO.3 := 'KG'  : VM : '16' : FM
    A.ANEXO.3 := 'KH'  : VM : '17' : FM
    A.ANEXO.3 := 'KI'  : VM : '18' : FM
    A.ANEXO.3 := 'KJ'  : VM : '19' : FM
    A.ANEXO.3 := 'KK'  : VM : '20' : FM
    A.ANEXO.3 := 'KL'  : VM : '21' : FM
    A.ANEXO.3 := 'KM'  : VM : '22' : FM
    A.ANEXO.3 := 'KN'  : VM : '23' : FM
    A.ANEXO.3 := 'K&'  : VM : '24' : FM
    A.ANEXO.3 := 'KO'  : VM : '25' : FM
    A.ANEXO.3 := 'KP'  : VM : '26' : FM
    A.ANEXO.3 := 'KQ'  : VM : '27' : FM
    A.ANEXO.3 := 'KR'  : VM : '28' : FM
    A.ANEXO.3 := 'KS'  : VM : '29' : FM
    A.ANEXO.3 := 'KT'  : VM : '30' : FM
    A.ANEXO.3 := 'KU'  : VM : '31' : FM
    A.ANEXO.3 := 'KV'  : VM : '32' : FM
    A.ANEXO.3 := 'KW'  : VM : '33' : FM
    A.ANEXO.3 := 'KX'  : VM : '34' : FM
    A.ANEXO.3 := 'KY'  : VM : '35' : FM
    A.ANEXO.3 := 'KZ'  : VM : '36' : FM
    A.ANEXO.3 := 'K '  : VM : '37' : FM
    A.ANEXO.3 := 'K':Y.MAYUS  : VM : '38' : FM

RETURN
END
