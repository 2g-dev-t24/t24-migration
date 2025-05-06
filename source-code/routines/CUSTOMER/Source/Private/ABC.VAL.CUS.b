* @ValidationCode : MjotMTc0OTgxNzk0NjpDcDEyNTI6MTc0NTYxMzM4NjYxNzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2025 17:36:26
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
* <Rating>492</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.CUS

*======================================================================================
* Nombre de Programa : ABC.VAL.CUS
* Objetivo           : Rutina para validar la existencia del cliente y generar el RFC
*                      en caso de que no sea recibido o no tenga la longitud correcta.
*======================================================================================

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING ABC.BP
    $USING EB.Display

    GOSUB INICIO
    IF LEN(Y.CURP) EQ 18 THEN
        GOSUB VALIDA.DATOS
        IF MENSAJE EQ '' THEN
            IF Y.CURP[5,6] EQ Y.FEC.NAC[3,6] THEN
                GOSUB BUSQUEDA
            END ELSE
                Y.ERROR = 'EL CURP NO COINCIDE CON LA FECHA DE NACIMIENTO'
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END ELSE
            Y.ERROR = MENSAJE
            EB.SystemTables.setEtext(Y.ERROR)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END ELSE
        Y.ERROR = "CURP INVALIDO"
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN

*********
INICIO:
*********

    GOSUB LIMPIA.VARIABLES
    GOSUB OPEN.FILES

    Y.CURP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)
    Y.APE.PAT = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName))
    Y.APE.MAT = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne))
    Y.NOMBRE = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo))
    Y.FEC.NAC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)
    Y.SEXO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)
    Y.RFC.ORI = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,1>

RETURN

******************
LIMPIA.VARIABLES:
******************

    Y.CURP = ''
    Y.APE.PAT = ''
    Y.APE.MAT = ''
    Y.NOMBRE = ''
    Y.FEC.NAC = ''
    Y.POS.CURP = ''
    Y.POS.APE.PAT = ''
    Y.POS.APE.MAT =''
    Y.POS.NOMBRE = ''
    Y.POS.FEC.NAC = ''
    Y.POS.CEL = ''
    Y.RFC = ''
    Y.VAL.SEXO = ''
    Y.SEXO = ''
    Y.LUG.NAC = ''
    Y.SEL = ''

RETURN
*********
BUSQUEDA:
*********

    IF Y.CURP THEN
        IF Y.RFC.ORI NE '' AND LEN(Y.RFC.ORI) EQ 13 THEN
            Y.RFC = Y.RFC.ORI[1,10]
            V.RFC = Y.RFC.ORI
        END ELSE
            V.RFC = ""
            ABC.BP.AbcGeneraRfc('', V.RFC, '' )
            Y.RFC = V.RFC[1,10]
        END

        Y.ID.CLIENTE = EB.SystemTables.getIdNew()

        EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
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

            LOCATE V.RFC IN Y.RFC.LIST SETTING POS THEN
                Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
                IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                    Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                END
                RETURN
            END

            LOCATE Y.CURP IN Y.CURP.LIST SETTING POS THEN
                Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
                IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                    Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                END
                RETURN
            END

            NUM.RFC = DCOUNT(Y.RFC.LIST, FM)

            FOR X = 1 TO NUM.RFC
                GOSUB LIMPIA.VARIABLES.BUS

                Y.CLIENTE.1 = Y.CLIENTE.LIST<X>
                Y.GENDER.1 = Y.GENDER.LIST<X>
                Y.DATE.BIRTH.1 = Y.DATE.BIRTH.LIST<X>
                Y.SHORT.NAME.1 = Y.SHORT.NAME.LIST<X>
                Y.NAME.1.1 = Y.NAME.1.LIST<X>
                Y.NAME.2.1 = Y.NAME.2.LIST<X>
                Y.NOM.PER.MORAL.1 = Y.NOM.PER.MORAL.LIST<X>
                Y.ESTADO.1 = Y.ESTADO.LIST<X>

                IF Y.SEXO EQ Y.GENDER.1 AND Y.FEC.NAC EQ Y.DATE.BIRTH.1 AND Y.APE.PAT EQ Y.SHORT.NAME.1 AND Y.APE.MAT EQ Y.NAME.1.1 AND Y.NOMBRE EQ Y.NAME.2.1 THEN
                    IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                        Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                        EB.SystemTables.setEtext(Y.ERROR)
                        EB.ErrorProcessing.StoreEndError()
                    END
                    RETURN
                END
            NEXT X
        END

        IF Y.RFC.ORI EQ '' THEN
            Y.INSERT<1,1> = V.RFC
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, Y.INSERT)
            EB.Display.RebuildScreen()
        END
    END

RETURN

*********************
LIMPIA.VARIABLES.BUS:
*********************

    Y.CLIENTE.1 = ''
    Y.GENDER.1 = ''
    Y.DATE.BIRTH.1 = ''
    Y.SHORT.NAME.1 = ''
    Y.NAME.1.1 = ''
    Y.NAME.2.1 = ''
    Y.NOM.PER.MORAL.1 = ''
    Y.ESTADO.1 = ''

RETURN

*************
VALIDA.DATOS:
*************

    IF LEN(Y.APE.PAT) = 0 THEN
        MENSAJE = "FALTA APELLIDO PATERNO"
        RETURN
    END

    IF LEN(Y.APE.MAT) = 0 THEN
        MENSAJE = "FALTA APELLIDO MATERNO"
        RETURN
    END

    IF LEN(Y.NOMBRE) = 0 THEN
        MENSAJE = "FALTA PRIMER NOMBRE"
        RETURN
    END

    IF LEN(Y.FEC.NAC) = 0 THEN
        MENSAJE = "FALTA FECHA DE NACIMIENTO"
        RETURN
    END

*    IF LEN(Y.SEXO) = 0 THEN
*        MENSAJE = "FALTA SEXO"
*        RETURN
*    END

RETURN

*************
OPEN.FILES:
*************

    FN.ABC.INFO.VAL.CUS = 'F.ABC.INFO.VAL.CUS'
    F.ABC.INFO.VAL.CUS = ''
    EB.DataAccess.Opf(FN.ABC.INFO.VAL.CUS,F.ABC.INFO.VAL.CUS)

RETURN

END
