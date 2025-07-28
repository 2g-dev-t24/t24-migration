*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.BR2.TELDENOM.TOT

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.LocalReferences


    EB.LocalReferences.GetLocRef("TELLER","GRAN.TOTAL",Y.POS.GRAN.TOTAL)

    VPM.UNIT.VAL = EB.SystemTables.getComi()
    POSN = EB.SystemTables.getAv()
    DENOM.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)<1,POSN>
    DENOM.VAL = DENOM.VAL[4,6]
    IF NOT(NUM(DENOM.VAL)) THEN
        DENOM.VAL = FIELD(DENOM.VAL,',',2)
        DENOM.VAL = 0.01 * DENOM.VAL
    END

    IF POSN = 1 THEN
        TOTALVAL = VPM.UNIT.VAL * DENOM.VAL
        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = TOTALVAL
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END ELSE
        CURR.VAL = VPM.UNIT.VAL * DENOM.VAL
        POSN = POSN - 1
        SUM.DR = 0
        DENOM.VAL = ''
        VPM.UNIT.VAL = 0
        PREV.VAL = 0

        FOR NO.OF.DENOM = 1 TO POSN
            DENOM.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)<1,NO.OF.DENOM>
            DENOM.VAL = DENOM.VAL[4,6]
            IF NOT(NUM(DENOM.VAL)) THEN
                DENOM.VAL = FIELD(DENOM.VAL,',',2)
                DENOM.VAL = 0.01 * DENOM.VAL
            END
            VPM.UNIT.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)<1,NO.OF.DENOM>
            PREV.VAL = VPM.UNIT.VAL * DENOM.VAL
            SUM.DR += PREV.VAL
        NEXT NO.OF.DENOM
        TOTALVAL = CURR.VAL + SUM.DR
        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = TOTALVAL
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END
    EB.Display.RebuildScreen()

    RETURN
**********
END



