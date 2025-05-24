* @ValidationCode : MjoxOTk3NDcwNzMwOkNwMTI1MjoxNzQ4MTEyNDMwMTU4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 May 2025 15:47:10
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
$PACKAGE AbcSpei

SUBROUTINE ABC.V.CUSTOMER.NAME(Y.COMI,Y.NOMBRE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates




    IF EB.SystemTables.getMessage() EQ 'VAL' THEN

        GOSUB INITIALISE
        GOSUB PROCESS
    END
    
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
    

    
    NOM.CAMPOS     = 'L.CLASSIFICATION':@VM:'L.NOM.PER.MORAL'
    POS.CAMP.LOCAL = ""
    
    
    EB.Updates.MultiGetLocRef("CUSTOMER",NOM.CAMPOS,POS.CAMP.LOCAL)

    CLASSIFICATION.POS     = POS.CAMP.LOCAL<1,1>
    NOM.PER.MORAL.POS = POS.CAMP.LOCAL<1,2>
    
    

RETURN

*-------
PROCESS:
*-------
    Y.ESPACIO = " "
    Y.ORDEN = FIELD(Y.COMI,Y.SEPARADOR,2)

    IF INDEX(Y.COMI,Y.SEPARADOR,1) GT 0 THEN
        Y.CUST.NO = FIELD(Y.COMI,Y.SEPARADOR,1)
        Y.ORDEN = FIELD(Y.COMI,Y.SEPARADOR,2)
    END ELSE
        Y.CUST.NO = Y.COMI
        Y.ORDEN = ''
    END

    R.CUS.REC = ST.Customer.Customer.Read(Y.CUST.NO, Error)

    
    Y.APELLIDO.P = R.CUS.REC<ST.Customer.Customer.EbCusShortName>
    Y.APELLIDO.M = R.CUS.REC<ST.Customer.Customer.EbCusNameOne>
    Y.NOMBRE.1 =R.CUS.REC<ST.Customer.Customer.EbCusNameTwo>
    Y.CUS.REF = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef>








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
            END ELSE
                Y.NAME = Y.NOMBRE.1
                Y.NAME := Y.ESPACIO:Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M
            END

        CASE Y.CLASSIFICATION = 2
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            IF Y.ORDEN EQ '' THEN
                Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1
            END ELSE
                Y.NAME = Y.NOMBRE.1

                Y.NAME := Y.ESPACIO:Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M
            END

        CASE Y.CLASSIFICATION = 3
            Y.NAME = Y.DENOMINACION
        CASE Y.CLASSIFICATION = 4
            Y.NAME = Y.APELLIDO.P
        CASE Y.CLASSIFICATION = 5
            Y.NAME = Y.APELLIDO.P
    END CASE

    Y.NOMBRE = Y.NAME


RETURN
END

