$PACKAGE AbcTaxes

SUBROUTINE ABC.TEST.SOME.RTN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()

    ETEXT = "LLAMADA DESDE: " : Y.PGM.VERSION
    EB.SystemTables.setEtext(ETEXT)
    EB.ErrorProcessing.StoreEndError()

    RETURN
    END