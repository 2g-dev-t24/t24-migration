*-----------------------------------------------------------------------------
* <Rating>47</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.ACC.CUS.NAME

*-----------------------------------------------------------------------
*
* This subroutine has to be Attached
* with any version in the Customer Id field.
* It will populate the complete Name of the Customer
*-----------------------------------------------------------------------

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING FT.Contract
    $USING EB.Updates
    $USING EB.Display
  
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

    YR.ACCOUNT = EB.SystemTables.getComi()

*    CALL DBR('ACCOUNT':FM:AC.CUSTOMER,YR.ACCOUNT,Y.CUSTOMER)

    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","FT.CR.CUS.NAME",FT.CR.CUS.NAME.POS)

    RETURN

*-------
PROCESS:
*-------

    Y.ESPACIO = " "
    Y.CUST.NO = EB.SystemTables.getComi()
    Y.ORDEN = ''

    EB.Updates.MultiGetLocRef("CUSTOMER","NOM.PER.MORAL",NOM.PER.MORAL.POS)

    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUST.NO,R.CUSTOMER,F.CUSTOMER,ERROR.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.APELLIDO.P = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
        Y.APELLIDO.M = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
        Y.NOMBRE.1 = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
        Y.SECTOR = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
        Y.NOM.PER.MORAL = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, NOM.PER.MORAL.POS>
    END ELSE
        ETEXT = "EL CLIENTE NO EXISTE"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    Y.NAME = ""
    Y.NOMBRE = ""

    BEGIN CASE
    CASE Y.SECTOR EQ '1001'
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

    CASE Y.SECTOR EQ '1002'
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

    CASE Y.SECTOR EQ '1003'
        Y.NAME = TRIM(Y.NOM.PER.MORAL)
    CASE Y.SECTOR EQ '1004'
        Y.NAME = TRIM(Y.NOM.PER.MORAL)
    CASE Y.SECTOR EQ '1005'
        Y.NAME = TRIM(Y.NOM.PER.MORAL)
    END CASE

    Y.LOCAL.REF<1,FT.CR.CUS.NAME.POS> = Y.NAME   
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
    EB.Display.RebuildScreen()


    RETURN

END
