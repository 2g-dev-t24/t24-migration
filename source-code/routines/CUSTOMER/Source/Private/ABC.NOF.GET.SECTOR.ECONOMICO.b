$PACKAGE ABC.BP
***********************************************************
SUBROUTINE ABC.NOF.GET.SECTOR.ECONOMICO(R.DATA)
***********************************************************

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Reports
    
    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

**********
INIT.VARS:
**********

***se usa este separador porque se pidio caracter * en la salida
    Y.SEP        = "~"

    FN.ABC.ACTIVIDAD.ECONOMICA = 'F.ABC.ACTIVIDAD.ECONOMICA'
    F.ABC.ACTIVIDAD.ECONOMICA = ''

RETURN

***********
OPEN.FILES:
***********

    EB.DataAccess.Opf(FN.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA)

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

RETURN

********
PROCESS:
********

    LOCATE "ID.CUSTOMER" IN SEL.FIELDS SETTING IND.POS THEN
        Y.ID.CUS = SEL.VALUES<IND.POS>
    END

***si se usa en un contexto en el que no se le paso el ID
    IF Y.ID.CUS EQ '' THEN
        Y.ID.CUS = EB.SystemTables.getIdNew()
    END

    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,CUST.ERR)
    Y.INDUSTRY = R.CUSTOMER<ST.Customer.Customer.EbCusIndustry>
    IF LEN(Y.INDUSTRY) < 4 THEN
        Y.FILTRO = FMT(Y.INDUSTRY, "R%4")
    END
    Y.FILTRO = Y.INDUSTRY[1,3]

    R.DATA = ""
    Y.CADENA.SALIDA = ""
    SEL.CMD = "SELECT " : FN.ABC.ACTIVIDAD.ECONOMICA : " WITH @ID LIKE ":Y.FILTRO:"..."

    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
        
    FOR Y.I = 1 TO Y.NO.REGISTROS
        Y.ID.ACT.ECONOMICA = Y.LIST.REG<Y.I>
        EB.DataAccess.FRead(FN.INDUSTRY, Y.ID.ACT.ECONOMICA, R.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, ERR.IND)
        Y.ACT.ECON.DESC = R.ABC.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.Descripcion>
        Y.CADENA.SALIDA = "BANXICO.ECO.ACTIVITY*": Y.ID.ACT.ECONOMICA : Y.SEP : Y.ACT.ECON.DESC : Y.SEP
        R.DATA<-1> = Y.CADENA.SALIDA
    NEXT Y.I

RETURN

END
