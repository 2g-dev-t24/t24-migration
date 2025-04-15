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
    $USING EB.LocalReferences

    GOSUB INIT.VARS
    GOSUB PROCESS
    GOSUB MANTEN.REGISTRO


*    EB.Display.RebuildScreen()

    RETURN

**********
INIT.VARS:
**********
    V.STAFF.OFF = ""
*    Y.ORIGEN.RECURSOS = ""
*    Y.DESTINO.RECURSOS = ""
*    Y.COD.POS = ""
*    Y.GENERICO = ""
    Y.FIRMA = ""
    Y.NUM.ANIOS = ""
*    V.RELCODE = ""
    Y.EDO.CIVIL = ""
    Y.TIPO.CASA = ""
    RETURN

********
PROCESS:
********

    BEGIN CASE
    CASE Y.ORIGEN EQ "EMPLEADO.ABC"
        V.STAFF.OFF = Y.VAL.ACTUAL
        ABC.BP.AbcValidaEmpleAbc(V.STAFF.OFF)
    *CASE Y.ORIGEN EQ "ORIGEN.RECS"
*        Y.ORIGEN.RECURSOS = Y.VAL.ACTUAL

*    CASE Y.ORIGEN EQ "DESTINO.RECS"
*        Y.DESTINO.RECURSOS = Y.VAL.ACTUAL

*    CASE Y.ORIGEN EQ "DIRECCION"
*        Y.COD.POS = Y.VAL.ACTUAL

*    CASE Y.ORIGEN EQ "GENERICO"
*        Y.GENERICO = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "FIRMA"
        Y.FIRMA = Y.VAL.ACTUAL
         ABC.BP.AbcValidaFimaElect(Y.FIRMA)
    CASE Y.ORIGEN EQ "NUM.ANIOS"
        Y.NUM.ANIOS = Y.VAL.ACTUAL
        ABC.BP.AbcHabilitaDirCus(Y.NUM.ANIOS)
*    CASE Y.ORIGEN EQ "REL.CODE"
*        V.RELCODE = Y.VAL.ACTUAL

    CASE Y.ORIGEN EQ "EDO.CIVIL"
        Y.EDO.CIVIL = Y.VAL.ACTUAL
        ABC.BP.AbcValidaCusMarstatus(Y.EDO.CIVIL)
    CASE Y.ORIGEN EQ "TIPO.CASA"
        Y.TIPO.CASA = Y.VAL.ACTUAL
        ABC.BP.AbcHabilitaOtraVivienda(Y.TIPO.CASA)
    END CASE

    RETURN

****************
MANTEN.REGISTRO:
****************


**    ABC.BP.AbcHabilitaDirCus(Y.NUM.ANIOS)
*    ABC.BP.AbcValidaCusRelcode(V.RELCODE)
**    ABC.BP.AbcValidaCusMarstatus(Y.EDO.CIVIL)
*    ABC.BP.AbcValidaFimaElect(Y.FIRMA)
*    ABC.BP.AbcValidaEmpleAbc(V.STAFF.OFF)
**    ABC.BP.AbcHabilitaOtraVivienda(Y.TIPO.CASA)
*    ABC.BP.AbcCusValidaOrigRec(Y.ORIGEN.RECURSOS)
*    ABC.BP.AbcCusValidaDestRec(Y.DESTINO.RECURSOS)

    
    RETURN
END
