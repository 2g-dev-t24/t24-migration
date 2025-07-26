*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.EXTRAE.DEFAULT

******************************************************************
*  
*
******************************************************************

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING EB.Security
    $USING TT.Config

**************MAIN PROCESS
    GOSUB INICIALIZA

    GOSUB GENERABOVEDA

    RETURN
**************

INICIALIZA:

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    RETURN

GENERABOVEDA:

    Y.OPERADOR = EB.SystemTables.getRUser()
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
    IF R.USER THEN
        Y.SUCURSAL = R.USER<EB.Security.User.UseDepartmentCode>
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE EQ ":DQUOTE(Y.SUCURSAL) 
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID

        Y.BOVEDA = Y.ID.BVD<Y.NUM.BVD>

        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH USER EQ ":DQUOTE(Y.OPERADOR)
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID

        Y.CAJERO = Y.ID.BVD<Y.NUM.BVD>

    END

    IF EB.SystemTables.getAf() EQ TT.Contract.Teller.TeTellerIdOne THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne,Y.BOVEDA)
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo,Y.CAJERO)
    END
    IF EB.SystemTables.getAf() EQ TT.Contract.Teller.TeTellerIdTwo THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne,Y.BOVEDA)
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo,Y.CAJERO)
    END
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeTellerIdOne, tmp)
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeTellerIdTwo, tmp)

    RETURN

END
