* @ValidationCode : MjotNTg1MDcxNTYyOkNwMTI1MjoxNzQ0MjQ2MDQxMDc2OlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2025 19:47:21
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
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>43</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.V.CUSTOMER.NAME

*-----------------------------------------------------------------------
*
* This subroutine has to be Attached
* with any version in the Customer Id field.
* It will populate the complete Name of the Customer
*-----------------------------------------------------------------------
*
*       Revision History
*
*-----------------------------------------------------------------------
* Modificado por : Jesus Andres Rivera Equiuha
* Fecha          : 13/Marzo/2015
* Descripcion    : Se cambio la llamada directa a los campos locales,
*                  por la funcion que regresa la posicion del campo local
*                  proporcionando el nombre del campo
*-----------------------------------------------------------------------
* Modificado por : Jesus Andres Rivera Equiuha
* Fecha          : 20/Mayo/2015
* Descripcion    : Modificacion de campos de R06 a R13
*-----------------------------------------------------------------------
* Modificado por : SFE
* Fecha          : 22/Julio/2016
* Descripcion    : Se sustituye el campo de Nombre para la clasificacion 3
*                   enviando el campo local NOM.PER.MORAL
*-----------------------------------------------------------------------
*       First Release:  Mar 25, 2008
*       Developed for:  BANCO AMIGO
*       Developed by:   JORGE ORTEGA RODRIGUEZ
*
*------------------------------------------------------------------------

*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*    $INSERT I_F.CUSTOMER
*    $INSERT I_F.FUNDS.TRANSFER

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.CUSTOMER
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER

    $USING ST.Customer
    $USING EB.API
    $USING EB.Display
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING ABC.BP

*------ Main Processing Section

*IF MESSAGE = 'VAL' THEN RETURN
    Y.MESSAGE = EB.SystemTables.getMessage()

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*

*----------
INITIALISE:
*----------
    Y.SEPARADOR = '*'
    Y.ORDEN.1 = "1" ;* Ordenamiento del nombre (Nombres y Apellidos)
    Y.ORDEN = ""

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

RETURN

*-------
PROCESS:
*-------
    Y.ESPACIO = " "
*Y.ORDEN = FIELD(COMI,Y.SEPARADOR,2)
    Y.ORDEN = FIELD(EB.SystemTables.getComi(), Y.SEPARADOR, 2)

*IF INDEX(COMI,Y.SEPARADOR,1) GT 0 THEN
    IF INDEX(EB.SystemTables.getComi(), Y.SEPARADOR, 1) GT 0 THEN
*Y.CUST.NO = FIELD(COMI,Y.SEPARADOR,1)
        Y.CUST.NO = FIELD(EB.SystemTables.getComi(), Y.SEPARADOR, 1)
*Y.ORDEN = FIELD(COMI,Y.SEPARADOR,2)
        Y.ORDEN = FIELD(EB.SystemTables.getComi(), Y.SEPARADOR, 2)
    END ELSE
        Y.CUST.NO = EB.SystemTables.getComi() ;*COMI
        Y.ORDEN = ''
    END
*ITSS - NYADAV - START/END
*    CALL DBR("CUSTOMER":FM:EB.CUS.SHORT.NAME,Y.CUST.NO,Y.APELLIDO.P)
*    CALL DBR("CUSTOMER":FM:EB.CUS.NAME.1,Y.CUST.NO,Y.APELLIDO.M)

*    CALL DBR("CUSTOMER":FM:EB.CUS.NAME.2,Y.CUST.NO,Y.NOMBRE.1)
*    CALL DBR("CUSTOMER":FM:EB.CUS.LOCAL.REF,Y.CUST.NO,Y.CUS.REF)

    R.CUS.REC = ST.Customer.Customer.Read(Y.CUST.NO, CUS.ERR)
    Y.APELLIDO.P = R.CUS.REC<ST.Customer.Customer.EbCusShortName> ;*<EB.CUS.SHORT.NAME>
    Y.APELLIDO.M = R.CUS.REC<ST.Customer.Customer.EbCusNameOne> ;*<EB.CUS.NAME.1>
    Y.NOMBRE.1 =R.CUS.REC<ST.Customer.Customer.EbCusNameTwo> ;*<EB.CUS.NAME.2>
    Y.CUS.REF = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef> ;*<EB.CUS.LOCAL.REF>
*ITSS - NYADAV - START/END

*    CALL GET.LOC.REF("CUSTOMER","FORMER.NAME",FORMER.NAME.POS)
*    CALL GET.LOC.REF("CUSTOMER","CLASSIFICATION",CLASSIFICATION.POS)
*    CALL GET.LOC.REF("CUSTOMER","NOM.PER.MORAL",NOM.PER.MORAL.POS)
    Y.APP.LOC = 'CUSTOMER'
    Y.FLD.NAME  = "CLASSIFICATION" : @VM
    Y.FLD.NAME := "NOM.PER.MORAL"
    Y.FLD.POS = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FLD.NAME, Y.FLD.POS)
    CLASSIFICATION.POS = Y.FLD.POS<1,1>
    NOM.PER.MORAL.POS = Y.FLD.POS<1,2>
*    CALL GET.LOC.REF("CUSTOMER","NOMBRE.3",NOMBRE.3.POS)

*    Y.NOMBRE.2 = Y.CUS.REF<1,FORMER.NAME.POS>
*    Y.NOMBRE.3 = Y.CUS.REF<1,NOMBRE.3.POS>
    Y.CLASSIFICATION = Y.CUS.REF<1,CLASSIFICATION.POS>
    Y.DENOMINACION =  Y.CUS.REF<1,NOM.PER.MORAL.POS>

    Y.NAME = ""
    Y.NOMBRE = ""

    BEGIN CASE
        CASE Y.CLASSIFICATION = 1
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            IF Y.ORDEN EQ "" THEN
                Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1

*            IF Y.NOMBRE.2 NE '' THEN
*                Y.NAME := Y.ESPACIO:Y.NOMBRE.2
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END ELSE
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END
            END ELSE
                Y.NAME = Y.NOMBRE.1

*            IF Y.NOMBRE.2 NE '' THEN
*                Y.NAME := Y.ESPACIO:Y.NOMBRE.2
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END ELSE
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END
                Y.NAME := Y.ESPACIO:Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M
            END

        CASE Y.CLASSIFICATION = 2
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            IF Y.ORDEN EQ '' THEN
                Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1

*            IF Y.NOMBRE.2 NE '' THEN
*                Y.NAME := Y.ESPACIO:Y.NOMBRE.2
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END ELSE
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END
            END ELSE
                Y.NAME = Y.NOMBRE.1

*            IF Y.NOMBRE.2 NE '' THEN
*                Y.NAME := Y.ESPACIO:Y.NOMBRE.2
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END ELSE
*                IF Y.NOMBRE.3 NE '' THEN
*                    Y.NAME := Y.ESPACIO:Y.NOMBRE.3
*                END
*            END

                Y.NAME := Y.ESPACIO:Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M
            END

        CASE Y.CLASSIFICATION = 3
            Y.NAME = Y.DENOMINACION
*        Y.NAME = Y.APELLIDO.M
        CASE Y.CLASSIFICATION = 4
            Y.NAME = Y.APELLIDO.P
*        Y.NAME = Y.APELLIDO.M
        CASE Y.CLASSIFICATION = 5
            Y.NAME = Y.APELLIDO.P
*        Y.NAME = Y.APELLIDO.M
    END CASE

*COMI.ENRI = Y.NAME
    EB.SystemTables.setComiEnri(Y.NAME)
    EB.Display.RebuildScreen()

RETURN
END
