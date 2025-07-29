*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.INHIBE.LECTOR
*
*************************************************************
* Inhibe campos que han de ser llenados mediante el escaner
*************************************************************


    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.LocalReferences
    
    tmp=EB.SystemTables.getTLocref()
    EB.Updates.MultiGetLocRef("TELLER","DRAW.CHQ.NO", Y.POS)
    tmp<Y.POS,7> = "NOINPUT"

    EB.Updates.MultiGetLocRef("TELLER","DRAW.ACCT.NO", Y.POS)
    tmp<Y.POS,7> = "NOINPUT"

    EB.Updates.MultiGetLocRef("TELLER","DRAW.BANK", Y.POS)
    tmp<Y.POS,7> = "NOINPUT"
    EB.SystemTables.setTLocref(tmp)
    tmp<3>="NOINPUT"
    IF EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne) NE "MXN" THEN

        EB.SystemTables.setT(TT.Contract.Teller.TeAmountFcyOne, tmp)
    END
    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)

    EB.SystemTables.setT(TT.Contract.Teller.TeAccountOne, tmp)



END
