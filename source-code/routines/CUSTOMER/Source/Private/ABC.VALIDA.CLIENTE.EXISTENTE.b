* @ValidationCode : MjotMTczNTM0NjM2NDpDcDEyNTI6MTc0NjA0MzM3MDc5ODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Apr 2025 17:02:50
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
* <Rating>1450</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.CLIENTE.EXISTENTE
*===============================================
* Nombre de Programa:   ABC.VALIDA.CLIENTE.EXISTENTE
* Objetivo:             Rutina para validar si el cliente
*                       ingresado ya est� registrado.
*===============================================

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Display

    $USING ABC.BP

    GOSUB INICIO
    GOSUB PROCESO

RETURN

*******
INICIO:
*******

    Y.ID = ''
    Y.SECTOR = ''
    Y.RFC = ''
    Y.RFC.OLD = ''
    Y.CURP = ''
    Y.GENDER = ''
    Y.DATE.BIRTH = ''
    Y.SHORT.NAME = ''
    Y.NAME.1 = ''
    Y.NAME.2 = ''
    Y.NOM.PER.MORAL = ''
    Y.ESTADO = ''
    Y.RFC.BAN = ''

    Y.ID.CLIENTE = EB.SystemTables.getIdNew()

    FN.ABC.INFO.VAL.CUS = 'F.ABC.INFO.VAL.CUS'
    F.ABC.INFO.VAL.CUS = ''
    EB.DataAccess.Opf(FN.ABC.INFO.VAL.CUS,F.ABC.INFO.VAL.CUS)

    Y.APP.LOC = 'CUSTOMER'
    Y.FIELD.LOC = 'L.NOM.PER.MORAL':@VM:'CLASS.COTI'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FIELD.LOC, Y.POS.LOC)

    Y.POS.NOM.PER.MORAL = Y.POS.LOC<1,1>
    Y.POS.CLASS.COTI = Y.POS.LOC<1,2>

    Y.RAZON.SOCIAL.ARG = "SHORT" ; Y.RAZON.SOCIAL = ''
    ABC.BP.AbcGetRazonSocial(Y.RAZON.SOCIAL.ARG)
    Y.RAZON.SOCIAL = Y.RAZON.SOCIAL.ARG
RETURN


********
PROCESO:
********
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.SECTOR = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    IF Y.SECTOR GE '1300' AND Y.SECTOR LE '1304' THEN
        Y.SECTOR = Y.LOCAL.REF<1,Y.POS.CLASS.COTI>
    END
    Y.RFC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.RFC.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.CURP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)
    Y.CURP.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusExternCusId)
    Y.DATE.BIRTH = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)

    IF Y.RFC EQ '' THEN
        ABC.BP.AbcGeneraRfc('', Y.RFC, '' )
        Y.RFC.BAN = '1'
    END

    IF Y.SECTOR LT '2001' THEN
        Y.GENDER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)
        Y.SHORT.NAME = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName))
        Y.NAME.1 = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne))
        Y.NAME.2 = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo))
        Y.ESTADO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDistrictName)
        Y.RFC.ID = Y.RFC[1,10]
        Y.RFC.OLD.ID = Y.RFC.OLD[1,10]
        Y.CURP.ID = Y.CURP[1,10]
        Y.CURP.OLD.ID = Y.CURP.OLD[1,10]

        GOSUB VALIDA.CLIENTE.PF
        IF Y.ERROR EQ '' THEN
            R.VAL.CUS.RFC = R.VAL.CUS
            Y.VAL.ID = Y.CURP.ID
            Y.ERROR = ''
            R.VAL.CUS = ''
            GOSUB VALIDA.CLIENTE.PF
        END
        IF Y.ERROR EQ '' THEN
            ABC.BP.AbcInfoValCus.Write(Y.CURP.ID, R.VAL.CUS)

            *IF Y.RFC.BAN EQ '1' THEN
            *    Y.INSERT<1,1> = Y.RFC
            *    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, Y.INSERT)
            *    EB.Display.RebuildScreen()
            *END
        END
    END ELSE
        IF Y.SECTOR LE '2014' THEN
            Y.NOM.PER.MORAL = Y.LOCAL.REF<1,Y.POS.NOM.PER.MORAL>
            *Y.ESTADO = Y.LOCAL.REF<1,Y.POS.LUGAR.CONST>
            Y.RFC.ID = Y.RFC[1,9]
            Y.RFC.OLD.ID = Y.RFC.OLD[1,9]
            Y.CURP.ID = Y.CURP[1,9]
            Y.CURP.OLD.ID = Y.CURP.OLD[1,9]
            GOSUB VALIDA.CLIENTE.PM
        END
    END
RETURN
******************
VALIDA.CLIENTE.PM:
******************
    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.CURP.ID,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
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
                Y.ERROR = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ':Y.CLIENTE.1
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

        NUM.RFC = DCOUNT(Y.RFC.LIST, FM)

        FOR X = 1 TO NUM.RFC
            GOSUB LIMPIA.VARIABLES

            Y.CLIENTE.1 = Y.CLIENTE.LIST<X>
            Y.DATE.BIRTH.1 = Y.DATE.BIRTH.LIST<X>
            Y.NOM.PER.MORAL.1 = Y.NOM.PER.MORAL.LIST<X>
            Y.ESTADO.1 = Y.ESTADO.LIST<X>

            
            IF Y.DATE.BIRTH EQ Y.DATE.BIRTH.1 AND Y.NOM.PER.MORAL EQ Y.NOM.PER.MORAL.1 AND Y.ESTADO EQ Y.ESTADO.1 THEN
                IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                    Y.ERROR = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ':Y.CLIENTE.1
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
            
        NEXT X

        IF Y.CURP.OLD.ID NE '' THEN
            IF Y.CURP.OLD.ID NE Y.CURP.ID THEN
                GOSUB ELIMINA.INFO.ANTERIOR
            END
        END

        LOCATE Y.ID.CLIENTE IN Y.CLIENTE.LIST SETTING POS THEN
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc,POS> = Y.RFC
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp,POS> = Y.CURP
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente,POS> = EB.SystemTables.getIdNew()
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender,POS> = Y.GENDER
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth,POS> = Y.DATE.BIRTH
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName,POS> = Y.SHORT.NAME
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1,POS> = Y.NAME.1
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2,POS> = Y.NAME.2
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral,POS> = Y.NOM.PER.MORAL
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado,POS> = Y.ESTADO
        END ELSE
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc> := @VM:Y.RFC
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp> := @VM:Y.CURP
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente> := @VM:EB.SystemTables.getIdNew()
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender> := @VM:Y.GENDER
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth> := @VM:Y.DATE.BIRTH
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName> := @VM:Y.SHORT.NAME
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1> := @VM:Y.NAME.1
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2> := @VM:Y.NAME.2
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral> := @VM:Y.NOM.PER.MORAL
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado> := @VM:Y.ESTADO
        END
    END ELSE
        IF Y.CURP.OLD.ID NE '' THEN
            IF Y.CURP.OLD.ID NE Y.CURP.ID THEN
                GOSUB ELIMINA.INFO.ANTERIOR
            END
        END

        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc> = Y.RFC
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp> = Y.CURP
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente> = EB.SystemTables.getIdNew()
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender> = Y.GENDER
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth> = Y.DATE.BIRTH
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName> = Y.SHORT.NAME
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1> = Y.NAME.1
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2> = Y.NAME.2
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral> = Y.NOM.PER.MORAL
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado> = Y.ESTADO
    END

    ABC.BP.AbcInfoValCus.Write(Y.CURP.ID, R.VAL.CUS)


    IF Y.RFC.BAN EQ '1' THEN
        Y.INSERT<1,1> = Y.RFC
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, Y.INSERT)
        EB.Display.RebuildScreen()
    END

RETURN
******************
VALIDA.CLIENTE.PF:
******************
EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.CURP.ID,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
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
                Y.ERROR = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ':Y.CLIENTE.1
                EB.SystemTables.setEtext(Y.ERROR)
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

            
            IF Y.GENDER EQ Y.GENDER.1 AND Y.DATE.BIRTH EQ Y.DATE.BIRTH.1 AND Y.SHORT.NAME EQ Y.SHORT.NAME.1 AND Y.NAME.1 EQ Y.NAME.1.1 AND Y.NAME.2 EQ Y.NAME.2.1 AND Y.ESTADO EQ Y.ESTADO.1 THEN
                IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                    Y.ERROR = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ':Y.CLIENTE.1
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
        NEXT X

        LOCATE Y.ID.CLIENTE IN Y.CLIENTE.LIST SETTING POS THEN
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc,POS> = Y.RFC
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp,POS> = Y.CURP
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente,POS> = EB.SystemTables.getIdNew()
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender,POS> = Y.GENDER
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth,POS> = Y.DATE.BIRTH
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName,POS> = Y.SHORT.NAME
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1,POS> = Y.NAME.1
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2,POS> = Y.NAME.2
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral,POS> = Y.NOM.PER.MORAL
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado,POS> = Y.ESTADO
        END ELSE
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc> := @VM:Y.RFC
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp> := @VM:Y.CURP
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente> := @VM:EB.SystemTables.getIdNew()
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender> := @VM:Y.GENDER
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth> := @VM:Y.DATE.BIRTH
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName> := @VM:Y.SHORT.NAME
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1> := @VM:Y.NAME.1
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2> := @VM:Y.NAME.2
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral> := @VM:Y.NOM.PER.MORAL
            R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado> := @VM:Y.ESTADO
        END
    END ELSE

        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc> = Y.RFC
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp> = Y.CURP
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente> = EB.SystemTables.getIdNew()
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusGender> = Y.GENDER
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusDateOfBirth> = Y.DATE.BIRTH
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusShortName> = Y.SHORT.NAME
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName1> = Y.NAME.1
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusName2> = Y.NAME.2
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusNomPerMoral> = Y.NOM.PER.MORAL
        R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusEstado> = Y.ESTADO
    END
RETURN
**********************
ELIMINA.INFO.ANTERIOR:
**********************

    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.CURP.OLD.ID,R.VAL.CUS.OLD,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS.OLD)
    IF R.VAL.CUS.OLD THEN
        Y.RFC.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusRfc>
        Y.CURP.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusCurp>
        Y.CLIENTE.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusCliente>
        Y.GENDER.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusGender>
        Y.DATE.BIRTH.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusDateOfBirth>
        Y.SHORT.NAME.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusShortName>
        Y.NAME.1.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusName1>
        Y.NAME.2.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusName2>
        Y.NOM.PER.MORAL.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusNomPerMoral>
        Y.ESTADO.LIST.OLD = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusEstado>

        CHANGE @VM TO @FM IN Y.RFC.LIST.OLD
        CHANGE @VM TO @FM IN Y.CURP.LIST.OLD
        CHANGE @VM TO @FM IN Y.CLIENTE.LIST.OLD
        CHANGE @VM TO @FM IN Y.GENDER.LIST.OLD
        CHANGE @VM TO @FM IN Y.DATE.BIRTH.LIST.OLD
        CHANGE @VM TO @FM IN Y.SHORT.NAME.LIST.OLD
        CHANGE @VM TO @FM IN Y.NAME.1.LIST.OLD
        CHANGE @VM TO @FM IN Y.NAME.2.LIST.OLD
        CHANGE @VM TO @FM IN Y.NOM.PER.MORAL.LIST.OLD
        CHANGE @VM TO @FM IN Y.ESTADO.LIST.OLD

        LOCATE Y.RFC.OLD IN Y.RFC.LIST.OLD SETTING POS.OLD THEN
            Y.CLIENTE.OLD = Y.CLIENTE.LIST.OLD<POS.OLD>
            IF Y.ID.CLIENTE EQ Y.CLIENTE.OLD THEN
                NUM.RFC.OLD = DCOUNT(Y.RFC.LIST.OLD, FM)

                IF NUM.RFC.OLD LT 2 THEN
                    DELETE F.ABC.INFO.VAL.CUS, Y.CURP.OLD.ID
                END ELSE
                    R.VAL.CUS.NEW = ''
                    FOR Y = 1 TO NUM.RFC.OLD
                        IF Y NE POS.OLD THEN
                            IF R.VAL.CUS.NEW EQ '' THEN
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusRfc> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusRfc,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusCurp> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusCurp,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusCliente> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusCliente,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusGender> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusGender,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusDateOfBirth> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusDateOfBirth,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusShortName> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusShortName,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusName1> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusName1,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusName2> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusName2,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusNomPerMoral> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusNomPerMoral,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusEstado> = R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusEstado,Y>
                            END ELSE
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusRfc> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusRfc,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusCurp> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusCurp,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusCliente> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusCliente,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusGender> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusGender,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusDateOfBirth> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusDateOfBirth,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusShortName> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusShortName,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusName1> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusName1,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusName2> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusName2,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusNomPerMoral> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusNomPerMoral,Y>
                                R.VAL.CUS.NEW<ABC.BP.AbcInfoValCus.ValCusEstado> := @VM:R.VAL.CUS.OLD<ABC.BP.AbcInfoValCus.ValCusEstado,Y>
                            END
                        END
                    NEXT Y

                    ABC.BP.AbcInfoValCus.Write(Y.CURP.OLD.ID, R.VAL.CUS.NEW)

                END
            END
        END
    END

RETURN

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

END
