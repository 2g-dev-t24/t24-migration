*-----------------------------------------------------------------------------
* <Rating>43</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE VPM.V.CUSTOMER.NAME

*-----------------------------------------------------------------------
*
* This subroutine has to be Attached
* with any version in the Customer Id field.
* It will populate the complete Name of the Customer
*-----------------------------------------------------------------------
*
*-----------------------------------------------------------------------

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Display
    $USING FT.Contract


*------ Main Processing Section

    IF EB.SystemTables.getMessage() EQ 'VAL' THEN RETURN

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
    Y.COMI = EB.SystemTables.getComi()
    Y.ESPACIO = " "
    Y.ORDEN = FIELD(Y.COMI,Y.SEPARADOR,2)

    IF INDEX(Y.COMI,Y.SEPARADOR,1) GT 0 THEN
        Y.CUST.NO = FIELD(Y.COMI,Y.SEPARADOR,1)
        Y.ORDEN = FIELD(Y.COMI,Y.SEPARADOR,2)
    END ELSE
        Y.CUST.NO = Y.COMI
        Y.ORDEN = ''
    END

    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUST.NO,R.CUS.REC,F.CUSTOMER,CUS.ERR)
    Y.APELLIDO.P = R.CUS.REC<ST.Customer.Customer.EbCusShortName>
    Y.APELLIDO.M = R.CUS.REC<ST.Customer.Customer.EbCusNameOne>
    Y.NOMBRE.1 =R.CUS.REC<ST.Customer.Customer.EbCusNameTwo>
    Y.CUS.REF = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef>

    EB.Updates.MultiGetLocRef("CUSTOMER","NOM.PER.MORAL",NOM.PER.MORAL.POS)

    Y.SECTOR = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    Y.DENOMINACION =  Y.CUS.REF<1,NOM.PER.MORAL.POS>

    Y.NAME = ""
    Y.NOMBRE = ""

    BEGIN CASE
    CASE Y.SECTOR = 1
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

    CASE Y.SECTOR = 2
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

    CASE Y.SECTOR = 3
        Y.NAME = Y.DENOMINACION
    CASE Y.SECTOR = 4
        Y.NAME = Y.APELLIDO.P
    CASE Y.SECTOR = 5
        Y.NAME = Y.APELLIDO.P
    END CASE

    EB.SystemTables.setComiEnri(Y.NAME)
    EB.Display.RebuildScreen()

    RETURN
END
