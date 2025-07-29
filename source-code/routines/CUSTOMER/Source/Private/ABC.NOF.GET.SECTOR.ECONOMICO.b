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

    Y.INDUSTRY = ""

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

    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,CUST.ERR)

    IF R.CUSTOMER EQ '' THEN
*        Y.ID.CUS = EB.SystemTables.getIdNew()
        DEFFUN System.getVariable()
        Y.ID.CUS = System.getVariable('CURRENT.ID.CUS')
        R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,CUST.ERR)
    END
    Y.INDUSTRY = R.CUSTOMER<ST.Customer.Customer.EbCusIndustry>

    IF LEN(Y.INDUSTRY) < 4 THEN
        Y.FILTRO = FMT(Y.INDUSTRY, "R%4")
        Y.FILTRO = Y.FILTRO[1,3]
    END ELSE
        Y.FILTRO = Y.INDUSTRY[1,3]
    END

    R.DATA = ""
    Y.CADENA.SALIDA = ""
    SEL.CMD = "SELECT " : FN.ABC.ACTIVIDAD.ECONOMICA : " WITH @ID LIKE ":Y.FILTRO:"..."

    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
        
    FOR Y.I = 1 TO Y.NO.REGISTROS
        Y.ID.ACT.ECONOMICA = Y.LIST.REG<Y.I>
        EB.DataAccess.FRead(FN.ABC.ACTIVIDAD.ECONOMICA, Y.ID.ACT.ECONOMICA, R.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, ERR.IND)
        Y.ACT.ECON.DESC = R.ABC.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.Descripcion>
        IF LEN(Y.INDUSTRY) < 4 THEN
            Y.ID.ACT.ECONOMICA = Y.ID.ACT.ECONOMICA[2,6]
        END
        Y.CADENA.SALIDA = "BANXICO.ECO.ACTIVITY*": Y.ID.ACT.ECONOMICA
        R.DATA<-1> = Y.CADENA.SALIDA
    NEXT Y.I

RETURN

END