*-----------------------------------------------------------------------------
* <Rating>1450</Rating>
*-----------------------------------------------------------------------------
  $PACKAGE ABC.BP  
    SUBROUTINE ABC.VALIDA.CLIENTE.EXISTENTE
*===============================================
* Nombre de Programa:   ABC.VALIDA.CLIENTE.EXISTENTE
* Objetivo:             Rutina para validar si el cliente
*                       ingresado ya está registrado.
*===============================================

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing

    $USING ABC.BP

    GOSUB INICIO
    GOSUB PROCESO

    RETURN

*******
INICIO:
*******

    Y.ID = ''
    Y.CLASSIFICATION = ''
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
    Y.FIELD.LOC = 'CLASSIFICATION':@VM:'NOM.PER.MORAL':@VM:'LUG.NAC':@VM:'LUGAR.CONST':@VM:'CLASS.COTI'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FIELD.LOC, Y.POS.LOC)

    Y.POS.CLASSIFICATION = Y.POS.LOC<1,1>
    Y.POS.NOM.PER.MORAL = Y.POS.LOC<1,2>
    Y.POS.LUG.NAC = Y.POS.LOC<1,3>
    Y.POS.LUGAR.CONST = Y.POS.LOC<1,4>
    Y.POS.CLASS.COTI = Y.POS.LOC<1,5>

    RETURN


********
PROCESO:
********
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.CLASSIFICATION = Y.LOCAL.REF<1,Y.POS.CLASSIFICATION>
    IF Y.CLASSIFICATION EQ 'COT' THEN
        Y.CLASSIFICATION = Y.LOCAL.REF<1,Y.POS.CLASS.COTI>
    END
    Y.RFC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.RFC.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.CURP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)
    Y.DATE.BIRTH = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateOfBirth)

    IF Y.RFC EQ '' THEN
        CALL ABC.GENERA.RFC('', Y.RFC, '' )
        Y.RFC.BAN = '1'
    END

    IF Y.CLASSIFICATION LT 3 THEN
        Y.GENDER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)
        Y.SHORT.NAME = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusShortName))
        Y.NAME.1 = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameOne))
        Y.NAME.2 = TRIM(EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNameTwo))
        Y.ESTADO = Y.LOCAL.REF<1,Y.POS.LUG.NAC>
        Y.RFC.ID = Y.RFC[1,10]
        Y.RFC.OLD.ID = Y.RFC.OLD[1,10]
    END ELSE
        Y.NOM.PER.MORAL = Y.LOCAL.REF<1,Y.POS.NOM.PER.MORAL>
        Y.ESTADO = Y.LOCAL.REF<1,Y.POS.LUGAR.CONST>
        Y.RFC.ID = Y.RFC[1,9]
        Y.RFC.OLD.ID = Y.RFC.OLD[1,9]
    END

    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC.ID,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
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
                Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

        LOCATE Y.CURP IN Y.CURP.LIST SETTING POS THEN
            Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
            IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
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

            IF Y.CLASSIFICATION LT 3 THEN
                IF Y.GENDER EQ Y.GENDER.1 AND Y.DATE.BIRTH EQ Y.DATE.BIRTH.1 AND Y.SHORT.NAME EQ Y.SHORT.NAME.1 AND Y.NAME.1 EQ Y.NAME.1.1 AND Y.NAME.2 EQ Y.NAME.2.1 AND Y.ESTADO EQ Y.ESTADO.1 THEN
                    IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                        Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                        EB.SystemTables.setEtext(Y.ERROR)
                        EB.ErrorProcessing.StoreEndError()
                        RETURN
                    END
                END
            END ELSE
                IF Y.DATE.BIRTH EQ Y.DATE.BIRTH.1 AND Y.NOM.PER.MORAL EQ Y.NOM.PER.MORAL.1 AND Y.ESTADO EQ Y.ESTADO.1 THEN
                    IF Y.ID.CLIENTE NE Y.CLIENTE.1 THEN
                        Y.ERROR = 'Tenemos registrado que ya eres cliente de ABC Capital. ':Y.CLIENTE.1
                        EB.SystemTables.setEtext(Y.ERROR)
                        EB.ErrorProcessing.StoreEndError()
                        RETURN
                    END
                END
            END
        NEXT X

        IF Y.RFC.OLD.ID NE '' THEN
            IF Y.RFC.OLD.ID NE Y.RFC.ID THEN
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
        IF Y.RFC.OLD.ID NE '' THEN
            IF Y.RFC.OLD.ID NE Y.RFC.ID THEN
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
    WRITE R.VAL.CUS TO F.ABC.INFO.VAL.CUS, Y.RFC.ID

    IF Y.RFC.BAN EQ '1' THEN
        Y.INSERT<1,1> = Y.RFC 
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTaxId, Y.INSERT)
        CALL REBUILD.SCREEN
    END

    RETURN

**********************
ELIMINA.INFO.ANTERIOR:
**********************

    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC.OLD.ID,R.VAL.CUS.OLD,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS.OLD)
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
                    DELETE F.ABC.INFO.VAL.CUS, Y.RFC.OLD.ID
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

                    WRITE R.VAL.CUS.NEW TO F.ABC.INFO.VAL.CUS, Y.RFC.OLD.ID
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
