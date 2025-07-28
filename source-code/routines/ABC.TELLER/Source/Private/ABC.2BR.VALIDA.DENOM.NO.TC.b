*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.VALIDA.DENOM.NO.TC

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING EB.ErrorProcessing
    $USING EB.Display

    Y.TOT.DEN = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit), VM)

    FOR Y.CONT = 1 TO Y.TOT.DEN
        Y.NOM.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)<1,Y.CONT>[1,5]
        Y.CANT.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)<1,Y.CONT>
        IF (Y.NOM.DENOM[1,3] EQ "USD") AND (Y.NOM.DENOM[4,2] EQ "TC") AND (Y.CANT.DENOM NE 0) THEN
            ETEXT = "NO SE PERMITEN DENOMINACIONES DE CHEQUES DE VIAJERO"
            EB.Display.Rem();
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

    NEXT Y.CONT

    Y.TOT.DEN = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit), VM)

    FOR Y.CONT = 1 TO Y.TOT.DEN
        Y.NOM.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)<1,Y.CONT>[1,5]
        Y.CANT.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)<1,Y.CONT>
        IF (Y.NOM.DENOM[1,3] EQ "USD") AND (Y.NOM.DENOM[4,2] EQ "TC") AND (Y.CANT.DENOM NE 0) THEN
            ETEXT = "NO SE PERMITEN DENOMINACIONES DE CHEQUES DE VIAJERO"
            EB.Display.Rem();
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

    NEXT Y.CONT

    RETURN
**********
END


