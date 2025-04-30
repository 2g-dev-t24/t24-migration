* @ValidationCode : Mjo0Mjc4NTEyNjpDcDEyNTI6MTc0NjA0MzYyMzk0MTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Apr 2025 17:07:03
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
$PACKAGE ABC.BP
*------------------------------------------------------------------------------------
SUBROUTINE ABC.VAL.DATOS.COT
*------------------------------------------------------------------------------------
* DESCRIPCION:
* FECHA:
* AUTOR:
*
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

    GOSUB INICIALIZA
    GOSUB LEE.CAMPO

RETURN

***********
INICIALIZA:
***********

    FN.CLIENTE   = 'F.CUSTOMER'
    F.CLIENTE   = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    FN.ABC.INFO.VAL.CUS = 'F.ABC.INFO.VAL.CUS'
    F.ABC.INFO.VAL.CUS = ''
    EB.DataAccess.Opf(FN.ABC.INFO.VAL.CUS,F.ABC.INFO.VAL.CUS)

    Y.RFC.AUX = ''
    Y.ID.CUS = EB.SystemTables.getIdNew()

    Y.RAZON.SOCIAL.ARG = "SHORT" ;
    Y.RAZON.SOCIAL = ''
    
    ABC.BP.AbcGetRazonSocial(Y.RAZON.SOCIAL.ARG)
    Y.RAZON.SOCIAL = Y.RAZON.SOCIAL.ARG

RETURN

************
LEE.CAMPO:
************

* Valido que el Valor Ingresado sea para la Posicion del RFC
    Y.RFC.VAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.SECTOR = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    Y.CURP = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)

* Valido que Tenga RFC
    IF Y.RFC.VAL EQ '' THEN
        ETEXT = "EL RFC NO TIENE DATO"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE

        IF Y.SECTOR GE "1300" THEN
               ETEXT = "NO SE PERMITE EL INGRESO DE ESTA PERSONALIDAD"
               EB.SystemTables.setEtext(ETEXT)
               EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            IF LEN(Y.RFC.VAL) NE 13 THEN
                ETEXT = "EL RFC NO TIENE LA LONGITUD CORRECTA"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            IF NOT(ALPHA(Y.RFC.VAL[1,4])) OR NOT(NUM(Y.RFC.VAL[5,6])) THEN
                ETEXT = "EL RFC NO TIENE LA EL FORMATO CORRECTO"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            Y.RFC.AUX = Y.RFC.VAL[1,10]
            GOSUB VALIDA.DUPLICADO
            IF ETEXT EQ '' THEN
                Y.RFC.AUX = Y.CURP[1,10]
                GOSUB VALIDA.DUPLICADO
            END
        END
    END

RETURN

*****************
VALIDA.DUPLICADO:
*****************

    EB.DataAccess.FRead(FN.ABC.INFO.VAL.CUS,Y.RFC.AUX,R.VAL.CUS,F.ABC.INFO.VAL.CUS,ERROR.VAL.CUS)
    IF R.VAL.CUS THEN
        Y.RFC.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusRfc>
        Y.CURP.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCurp>
        Y.CLIENTE.LIST = R.VAL.CUS<ABC.BP.AbcInfoValCus.ValCusCliente>

        CHANGE @VM TO @FM IN Y.RFC.LIST
        CHANGE @VM TO @FM IN Y.CURP.LIST
        CHANGE @VM TO @FM IN Y.CLIENTE.LIST

        LOCATE Y.CURP IN Y.CURP.LIST SETTING POS THEN
            Y.CLIENTE.1 = Y.CLIENTE.LIST<POS>
            IF Y.ID.CUS NE Y.CLIENTE.1 THEN
                ETEXT = 'Tenemos registrado que ya eres cliente de ' : Y.RAZON.SOCIAL : '. ' :Y.CLIENTE.1     ;* ABC Capital. ':Y.CLIENTE.1 ;*20241029_RZN.SCL - S - E
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                EB.Display.RebuildScreen()
            END
            RETURN
        END
    END

RETURN

END
