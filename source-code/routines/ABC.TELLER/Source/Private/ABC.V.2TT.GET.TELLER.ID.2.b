*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.V.2TT.GET.TELLER.ID.2


    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract


    FN.TELLER.USER = 'F.TELLER.USER' ; F.TELLER.USER = '' ; EB.DataAccess.Opf(FN.TELLER.USER, F.TELLER.USER)
    EB.DataAccess.CacheRead(FN.TELLER.USER,EB.SystemTables.getOperator(),R.REC.VAL,YERR)
    Y.TELLER.ID = R.REC.VAL<1>

    EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo, Y.TELLER.ID )
    EB.Display.RebuildScreen()
    RETURN
END
