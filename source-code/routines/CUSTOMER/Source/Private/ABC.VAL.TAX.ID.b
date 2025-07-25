* @ValidationCode : MjoxODk4MTAwMTQ6Q3AxMjUyOjE3NDg5MDE0OTY0MTU6dHJhYmFqbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jun 2025 18:58:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : trabajo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*------------------------------------------------------------------------------------
* <Rating>-26</Rating>
*------------------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.TAX.ID
*------------------------------------------------------------------------------------
* DESCRIPCION:
* FECHA:
* AUTOR:
*
*------------------------------------------------------------------------------------

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Display
    
    GOSUB INICIALIZA
    GOSUB LEE.CAMPO
    EB.Display.RebuildScreen()
RETURN
***********
INICIALIZA:
***********

    FN.CLIENTE   = 'F.CUSTOMER'          ; F.CLIENTE   = '' ; EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    Y.POS.CLASSIFICATION = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    EB.LocalReferences.GetLocRef("CUSTOMER","ABC.FIRMA.ELECT",Y.POS.FIRMA.ELE)
    EB.LocalReferences.GetLocRef("CUSTOMER","CDNIA.RESID.EUA",Y.POS.CDNIA.EUA)
    EB.LocalReferences.GetLocRef("CUSTOMER","L.TIPO.EMP.OTRO",Y.POS.TIPO.EMP.OTRO)

RETURN
************
LEE.CAMPO:
************

* Valido que el Valor Ingresado sea para la Posicion del RFC
    Y.RFC.VAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,1>
    Y.CLASSIFICATION = Y.POS.CLASSIFICATION

* Valido que Tenga RFC
    IF Y.RFC.VAL EQ '' THEN
*        EB.SystemTables.setEtext("EL RFC NO TIENE DATO")
*        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        IF Y.CLASSIFICATION GE 2001 AND Y.CLASSIFICATION LE 2014 THEN
            IF LEN(Y.RFC.VAL) NE 12 THEN
                EB.SystemTables.setEtext("EL RFC NO TIENE LA LONGITUD CORRECTA")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            IF NOT(ALPHA(Y.RFC.VAL[1,3])) OR NOT(NUM(Y.RFC.VAL[4,6])) THEN
                EB.SystemTables.setEtext("EL RFC NO TIENE LA EL FORMATO CORRECTO")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END ELSE
            IF LEN(Y.RFC.VAL) NE 13 THEN
                EB.SystemTables.setEtext("EL RFC NO TIENE LA LONGITUD CORRECTA")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            IF NOT(ALPHA(Y.RFC.VAL[1,4])) OR NOT(NUM(Y.RFC.VAL[5,6])) THEN
                EB.SystemTables.setEtext("EL RFC NO TIENE LA EL FORMATO CORRECTO")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END

* Valido que el Valor Ingresado sea para la Posicion de la Firma Electronica
    Y.FIRMA.ELE = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS.FIRMA.ELE>
    Y.FIRMA.VAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusText)
* Valido que Tenga Firma Electronica en el Campo Local "TIENE.FIRMA.ELE"
    IF Y.FIRMA.ELE EQ "SI" THEN
        IF Y.FIRMA.VAL EQ '' THEN
            EB.SystemTables.setEtext("EL CODIGO DE LA FIRMA (FIEL) NO TIENE DATO")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

* Valido que el Valor Ingresado sea para la Posicion del Registro Fiscal
    Y.CDNIA.EUA = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS.CDNIA.EUA>
    Y.CDNIA.VAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTaxId)<1,2>

* Valido que Tenga Firma Electronica en el Campo Local "CDNIA.RESID.EUA"
    IF Y.CDNIA.EUA EQ "SI" THEN
        IF Y.CDNIA.VAL EQ '' THEN
            EB.SystemTables.setEtext("EL NUMERO  DE REGISTRO FISCAL NO TIENE DATO")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

    Y.OTRO.EMP.VAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS.TIPO.EMP.OTRO>
    Y.OCUPACION.VAL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusOccupation)<1,1>

    IF Y.CLASSIFICATION LT 2001 THEN
        IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)<1,1> EQ '' THEN
            EB.SystemTables.setEtext("EL CURP NO TIENE DATO")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        IF Y.OCUPACION.VAL EQ '13' AND Y.OTRO.EMP.VAL EQ '' THEN
            EB.SystemTables.setEtext("NO SE ESPECIFICA OTRO TIPO DE EMPLEO")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
    
RETURN

END
