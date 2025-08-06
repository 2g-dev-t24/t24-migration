*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.EXTRAE.BOVEDA

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING AbcTable
    $USING EB.Display

    GOSUB INICIALIZA
    GOSUB GENERABOVEDA

    
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.FechaSolicitud, EB.SystemTables.getToday())
    Y.FECHA.HORA = TIMEDATE()
    Y.HORA = Y.FECHA.HORA[1,8]
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.HoraSolicitud, Y.HORA)
    RETURN
***********
INICIALIZA:
***********

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    F.ABC.2BR.BOVEDAS = ""
    FN.VPM.2BR.BOVEDAS = "F.ABC.2BR.BOVEDAS"
    EB.DataAccess.Opf(FN.VPM.2BR.BOVEDAS,F.ABC.2BR.BOVEDAS)

    RETURN
*************
GENERABOVEDA:
*************

    Y.MSG = ""
    Y.OPERADOR = EB.SystemTables.getRUser()
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrSolicita, Y.OPERADOR)
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
    IF R.USER THEN
        Y.SUCURSAL = Y.REG.USER<EB.USE.DEPARTMENT.CODE>[1,5]
         SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")  
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID
        R.NEW(BVD.SOLICITANTE) = Y.ID.BVD<Y.NUM.BVD>
        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Solicitante, Y.FECHA)
    END

    EB.Display.RebuildScreen()

    RETURN
**********
END




