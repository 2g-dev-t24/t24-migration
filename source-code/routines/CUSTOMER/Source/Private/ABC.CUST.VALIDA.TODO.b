*-----------------------------------------------------------------------------
* <Rating>-39</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.CUST.VALIDA.TODO(Y.VAL.ACTUAL, Y.ORIGEN)
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
*   Autor: Omar Basabe.
*-----------------------------------------------------------------------------
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.Display


    GOSUB INIT.VARS
    GOSUB PROCESS
    GOSUB MANTEN.REGISTRO

   
    EB.Display.RebuildScreen()

    RETURN

**********
INIT.VARS:
**********
    V.STAFF.OFF = ""
    Y.ORIGEN.RECURSOS = ""
    Y.DESTINO.RECURSOS = ""
    Y.COD.POS = ""
    Y.GENERICO = ""
    Y.INGRESOS = ""
    Y.FIRMA = ""
    Y.NUM.ANIOS = ""
    V.RELCODE = ""
    Y.EDO.CIVIL = ""
    Y.TIPO.CASA = ""
    RETURN

********
PROCESS:
********

    BEGIN CASE
    CASE Y.ORIGEN EQ "EMPLEADO.ABC"
        V.STAFF.OFF = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "ORIGEN.RECS"
        Y.ORIGEN.RECURSOS = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "DESTINO.RECS"
        Y.DESTINO.RECURSOS = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "DIRECCION"
        Y.COD.POS = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "INGRESOS"
        Y.INGRESOS = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "GENERICO"
        Y.GENERICO = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "FIRMA"
        Y.FIRMA = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "NUM.ANIOS"
        Y.NUM.ANIOS = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "REL.CODE"
        V.RELCODE = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "EDO.CIVIL"
        Y.EDO.CIVIL = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "TIPO.CASA"
        Y.TIPO.CASA = Y.VAL.ACTUAL
    END CASE

    RETURN

****************
MANTEN.REGISTRO:
****************

    V.GENDER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusGender)
   
*    R.NEW(EB.CUS.GENDER) = V.GENDER

    Y.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","DOM.ANOS",Y.POS) ;* ANIOS EN LA VIVIENDA
    IF Y.NUM.ANIOS EQ "" THEN
        Y.NUM.ANIOS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS>
    END
    ABC.BP.AbcHabilitaDirCus(Y.NUM.ANIOS)
    LocalRef<1,Y.POS> = Y.NUM.ANIOS 
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)

    IF V.RELCODE EQ "" THEN
        V.RELCODE = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusRelationCode)   ;* VALIDA SI ES CLIENTE RELACIONADO
    END
    ABC.BP.AbcValidaCusRelcode(V.RELCODE)
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusRelationCode,V.RELCODE)


    IF Y.EDO.CIVIL EQ "" THEN
        Y.EDO.CIVIL = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusMaritalStatus)          ;* ESTADO CIVIL
    END
    ABC.BP.AbcValidaCusMarstatus(Y.EDO.CIVIL)

    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusMaritalStatus,Y.EDO.CIVIL)

    Y.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","REGIMEN",Y.POS)  ;* REGIMEN DE CASADO

    Y.REGIMEN = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS>
    
    LocalRef<1,Y.POS> = Y.REGIMEN 
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)

    Y.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","TIENE.FIRMA.ELE",Y.POS)    ;* TIENE FIRMA ELECTRONICA S/N
    IF Y.FIRMA EQ "" THEN
        Y.FIRMA = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS>
    END
    ABC.BP.AbcValidaFimaElect(Y.FIRMA)
     LocalRef<1,Y.POS> = Y.FIRMA 
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
    

    Y.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","STAFF.OFFICIAL",Y.POS)     ;* ES EMPLEADO ABC S/N
    IF V.STAFF.OFF EQ "" THEN

        V.STAFF.OFF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS>
    END
    ABC.BP.AbcValidaEmpleAbc(V.STAFF.OFF)
    LocalRef<1,Y.POS> = V.STAFF.OFF
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
    

    IF Y.TIPO.CASA EQ "" THEN
        Y.TIPO.CASA = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusResidenceStatus)        ;* TIPO DE CASA
    END
    ABC.BP.AbcHabilitaOtraVivienda(Y.TIPO.CASA)
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusResidenceStatus,Y.TIPO.CASA)
    


    Y.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","ORIGEN.RECURSOS",Y.POS)    ;* ORIGEN DE LOS RECURSOS
    IF Y.ORIGEN.RECURSOS EQ "" THEN
        Y.ORIGEN.RECURSOS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS>
    END
    ABC.BP.AbcCusValidaOrigRec(Y.ORIGEN.RECURSOS)
    LocalRef<1,Y.POS> = Y.ORIGEN.RECURSOS
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
    

    Y.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","DESTINO.RECURS",Y.POS)     ;* DESTINO DE LOS RECURSOS
    IF Y.DESTINO.RECURSOS EQ "" THEN
        Y.DESTINO.RECURSOS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS>
    END
    ABC.BP.AbcCusValidaDestRec(Y.DESTINO.RECURSOS)
    LocalRef<1,Y.POS> = Y.DESTINO.RECURSOS
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
    

    RETURN
END
