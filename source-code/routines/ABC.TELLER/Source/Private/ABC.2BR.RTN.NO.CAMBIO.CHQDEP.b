*-----------------------------------------------------------------------------
* <Rating>49</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.RTN.NO.CAMBIO.CHQDEP

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Display

    IF EB.SystemTables.getMessage() NE 'VAL' THEN
        IF EB.SystemTables.getAf() EQ TT.Contract.Teller.TeAmountLocalOne AND EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne) EQ "MXN" THEN
            T(TT.TE.AMOUNT.FCY.1)<3> = "NOINPUT"
        END

        VER.SOL = EB.SystemTables.getPgmVersion()
        IF VER.SOL EQ ',VPM.2BR.CASHCHL' OR VER.SOL EQ ',VPM.2BR.CASHCHLDP'THEN
        AMT.LOCAL.1 = EB.SystemTables.getComi()
        EB.LocalReferences.GetLocRef("TELLER","DRAW.CHQ.AMT",POS.DRAW.CHQ.AMT)
        AMT.DRAW.CHQ.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,POS.DRAW.CHQ.AMT>
        IF AMT.DRAW.CHQ.AMT NE '' THEN
            IF AMT.LOCAL.1 NE AMT.DRAW.CHQ.AMT THEN
                COMI = AMT.DRAW.CHQ.AMT
                ETEXT ="El Monto se tiene que cambia por medio de la Lectora"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()

                TEXT = ETEXT
                EB.Display.Rem();
                EB.SystemTables.setMessage("RET")
*                CALL TRANSACTION.ABORT
*                MESSAGE = "RET"

            END
        END
    END

    RETURN
**********
END


