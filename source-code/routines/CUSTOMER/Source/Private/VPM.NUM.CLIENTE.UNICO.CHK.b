*-----------------------------------------------------------------------------
* <Rating>155</Rating>
*-----------------------------------------------------------------------------
  $PACKAGE ABC.BP  
    SUBROUTINE VPM.NUM.CLIENTE.UNICO.CHK
*-----------------------------------------------------------------------------
*
* MODIFICADO POR: CESAR MIRANDA FYG
*
* DETALLE: Valida que el cliente no se encuentre duplicado en base al RFC
*-----------------------------------------------------------------------------
* Modificado    : Jesus Hernandez JHF   - FyG
* Fecha         : 12/01/2017
* Descripcion   : Se corrige error de cte existente.
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING ABC.BP

    IF EB.SystemTables.getMessage() EQ 'VAL' THEN RETURN

    Y.RFC = ''

    Y.COMI = EB.SystemTables.getComi()
    IF Y.COMI THEN
        Y.RFC = Y.COMI
    END ELSE
         Y.REF.GET = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)
         Y.RFC = Y.REF.GET<1,1>
    END

    Y.ID.CUS = EB.SystemTables.getIdNew()

    GOSUB ABRE.TABLAS
    GOSUB MANTEN.REGISTRO
    GOSUB GENERA.RFC.CURP
    IF Y.RFC NE '' THEN GOSUB CLIENTE.DUPLICADO
    RETURN


GENERA.RFC.CURP:

    ETEINC = 1; ETEOK = 0
    CLIENTE.UNICO = ''; CLIENTE.UNICO.RFC = ''; CLIENTE.UNICO.CURP = ''; RES = ETEOK; MENSAJE = ''; CLAVE.ALFA = ''
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)

    IF ( Y.LOCAL.REF<1,Y.POS.CLASSIFICATION> = "1") OR ( Y.LOCAL.REF<1,Y.POS.CLASSIFICATION> = "2") THEN
        GOSUB VALIDA.DATOS
        IF (RES = 0) AND (MENSAJE = "") THEN
        END ELSE
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusGender, "")
            CALL REBUILD.SCREEN
            EB.SystemTables.setE(MENSAJE)
            EB.ErrorProcessing.Err()
            RETURN
        END
    END
    IF Y.LOCAL.REF<1,Y.POS.CLASSIFICATION> = "3" THEN
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusGender, "")
        GOSUB VALIDA.DATOS.M
        IF (RES = 0) AND (MENSAJE = '') THEN
        END ELSE
            EB.SystemTables.setE(MENSAJE)
            EB.ErrorProcessing.Err()
            RETURN
        END
    END
    RETURN


CLIENTE.DUPLICADO:

    IF Y.LOCAL.REF<1,Y.POS.CLASSIFICATION> GE "3" THEN
        Y.RFC.AUX = Y.RFC[1,9]
    END ELSE
        Y.RFC.AUX = Y.RFC[1,10]
    END
    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC.AUX,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
    IF R.VAL.CUS THEN
        Y.RFC.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc>
        Y.CURP.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp>
        Y.CLIENTE.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente>

        CHANGE @VM TO @FM IN Y.RFC.LIST
        CHANGE @VM TO @FM IN Y.CURP.LIST
        CHANGE @VM TO @FM IN Y.CLIENTE.LIST

        LOCATE Y.RFC IN Y.RFC.LIST SETTING POS THEN
            Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
            IF Y.ID.CUS NE Y.CLIENTE.1 THEN
                Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
            END
            RETURN
        END
    END

    RETURN

ABRE.TABLAS:


    F.VPM.ESTADO  = ""
    FN.VPM.ESTADO = "F.VPM.ESTADO"
    EB.DataAccess.Opf(FN.VPM.ESTADO, F.VPM.ESTADO)

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
    Y.APP.LOC = 'CUSTOMER'
    Y.FIELD.LOC = 'CLASSIFICATION':@VM:'LUG.NAC':@VM:'NOM.PER.MORAL':@VM:'LUGAR.CONST'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FIELD.LOC, Y.POS.LOC)

    Y.POS.CLASSIFICATION = Y.POS.LOC<1,1>
    Y.POS.LUG.NAC = Y.POS.LOC<1,2>
    YPOS.NOM.PER.MORAL = Y.POS.LOC<1,3>
    YPOS.LUGAR.CONST = Y.POS.LOC<1,4>
*****************************************************************************
    RETURN

****************
MANTEN.REGISTRO:
****************

    Y.VAL.ACTUAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)
    Y.ORIGEN = "GENERICO"
    ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
    RETURN

***************
VALIDA.DATOS:
********************
    
    APE.PATERNO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName)
    APE.MATERNO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)
    NOMBRE      = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo)
    FEC.NAC     = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)
    LUG.NAC     = Y.LOCAL.REF<1,Y.POS.LUG.NAC>
    GENERO      = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)

    IF LEN(APE.PATERNO) = 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA APELLIDO PATERNO"
        RETURN
    END

    IF LEN(APE.MATERNO) = 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA APELLIDO MATERNO"
        RETURN
    END

    IF LEN(NOMBRE) = 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA PRIMER NOMBRE"
        RETURN
    END

    IF LEN(FEC.NAC) = 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA FECHA DE NACIMIENTO"
        RETURN
    END

    IF LEN(LUG.NAC) = 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA LUGAR DE NACIMIENTO"
        RETURN
    END

    IF LEN(GENERO) = 0 THEN
        IF LEN(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)) = 0 THEN
            RES = ETEINC
            MENSAJE = "FALTA SEXO"
            RETURN
        END
    END
    RETURN

VALIDA.DATOS.M:
    NOMBRE.EMP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne)
    FEC.CONSTI = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)

    IF LEN(NOMBRE.EMP) = 0 THEN
        RES = ETEINC
        MENSAJE = "FALTA INGRESAR NOMBRE DE LA EMPRESA"
        RETURN
    END

    IF LEN(FEC.CONSTI) = 0 THEN
        IF LEN(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)) = 0 THEN
            RES = ETEINC
            MENSAJE = "FALTA FECHA DE CONSTITUCION DE EMPRESA"
            RETURN
        END
    END
    RETURN

END
