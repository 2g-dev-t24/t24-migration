$PACKAGE AbcTaxes

SUBROUTINE ABC.TEST.SOME.RTN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    ETEXT = "LLAMADA DESDE ABC.TEST.CALL.BASIC"
    EB.SystemTables.setEtext(ETEXT)
    EB.ErrorProcessing.StoreEndError()

    RETURN
    END