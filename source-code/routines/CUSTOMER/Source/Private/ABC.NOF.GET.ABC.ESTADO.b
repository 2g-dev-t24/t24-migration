$PACKAGE ABC.BP
SUBROUTINE ABC.NOF.GET.ABC.ESTADO(R.DATA)
***********************************************************
*Se hizo esta rutina tomar los ABC.ESTADO de mx desde rutina y mostrarlos en version por impedimento de la tabla
***********************************************************

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.Reports

    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

**********
INIT.VARS:
**********

    Y.SEP        = "*"

    FN.ABC.ESTADO = 'F.ABC.ESTADO'
    F.ABC.ESTADO = ''

RETURN

***********
OPEN.FILES:
***********

    EB.DataAccess.Opf(FN.ABC.ESTADO, F.ABC.ESTADO)

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

RETURN

********
PROCESS:
********


    LOCATE "ID" IN SEL.FIELDS SETTING IND.POS THEN
        Y.ID.EST = SEL.VALUES<IND.POS>
    END

    R.DATA = ""
    Y.CADENA.SALIDA = ""
    IF Y.ID.EST THEN 
        SEL.CMD = "SELECT " : FN.ABC.ESTADO :" WITH LIKE ...":DQUOTE(Y.ID.EST):"... BY @ID"
    END ELSE
        SEL.CMD = "SELECT " : FN.ABC.ESTADO : " BY @ID"
    END

    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
        
    FOR Y.I = 1 TO Y.NO.REGISTROS
        Y.ID.ABC.EST = Y.LIST.REG<Y.I>
        Y.ID.AUX = FMT(Y.ID.ABC.EST, "R%3")
        IF Y.ID.AUX LT '033' THEN
            EB.DataAccess.FRead(FN.ABC.ESTADO, Y.ID.ABC.EST, R.ABC.ESTADO, F.ABC.ESTADO, ERR.EST)
            Y.EST.DESC = R.ABC.ESTADO<AbcTable.AbcEstado.Estado>
            Y.EST.CLAVE = R.ABC.ESTADO<AbcTable.AbcEstado.Clave>
            Y.CADENA.SALIDA = Y.ID.ABC.EST : Y.SEP : Y.EST.DESC : Y.SEP : Y.EST.CLAVE : Y.SEP
            R.DATA<-1> = Y.CADENA.SALIDA
        END
    NEXT Y.I

RETURN

END
