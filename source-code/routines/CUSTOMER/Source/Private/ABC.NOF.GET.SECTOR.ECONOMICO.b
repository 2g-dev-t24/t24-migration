$PACKAGE ABC.BP
***********************************************************
SUBROUTINE ABC.NOF.GET.SECTOR.ECONOMICO(R.DATA)
***********************************************************

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AbcTable

    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

**********
INIT.VARS:
**********

    ID.NEW = EB.SystemTables.getIdNew()

    Y.SEP        = "*"

    FN.ABC.ACTIVIDAD.ECONOMICA = 'F.ABC.ACTIVIDAD.ECONOMICA'
    F.ABC.ACTIVIDAD.ECONOMICA = ''

RETURN

***********
OPEN.FILES:
***********

    EB.DataAccess.Opf(FN.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA)

RETURN

********
PROCESS:
********

    R.CUSTOMER = ST.Customer.Customer.Read(ID.NEW,CUST.ERR)
    Y.INDUSTRY = R.CUSTOMER<ST.Customer.Customer.EbCusIndustry>
    IF LEN(Y.INDUSTRY) < 4 THEN
        Y.FILTRO = FMT(Y.INDUSTRY, "R%4")
    END
    Y.FILTRO = Y.FILTRO[1,3]

    R.DATA = ""
    Y.CADENA.SALIDA = ""
    SEL.CMD = "SELECT " : FN.ABC.ACTIVIDAD.ECONOMICA : " WITH @ID LK " :DQUOTE(Y.FILTRO): "..."

    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
        
    FOR Y.I = 1 TO Y.NO.REGISTROS
        Y.ID.ACT.ECONOMICA = Y.LIST.REG<Y.I>
        EB.DataAccess.FRead(FN.INDUSTRY, Y.ID.ACT.ECONOMICA, R.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, ERR.IND)
        Y.ACT.ECON.DESC = R.ABC.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.Descripcion>
        Y.CADENA.SALIDA = "BANXICO.ECO.ACTIVITY*"Y.ID.ACT.ECONOMICA : Y.SEP : Y.ACT.ECON.DESC : Y.SEP
        R.DATA<-1> = Y.CADENA.SALIDA
    NEXT Y.I

RETURN

END
