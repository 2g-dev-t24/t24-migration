$PACKAGE AbcSpei
SUBROUTINE ABC.2BR.V.CHECK.SPEI.TYPE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING EB.SystemTables
    $USING AbcTable

    GOSUB INITIALIZATION

    IF E NE '' THEN
        RETURN
    END

    GOSUB VALIDATION

    RETURN

*-----------------------------------------------------------------------------
VALIDATION:
*-----------------------------------------------------------------------------
    IF (EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType) EQ R.PARAMETROS.SPEI<AbcTable.AbcParametrosSpei.DispIntTxn>) THEN
        E = "La transferencia es transferencia interna masiva " : EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
        EB.SystemTables.setEtext(E)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF ((EB.SystemTables.getPgmVersion() EQ ",VPM.2BR.VER.FTS") OR (EB.SystemTables.getPgmVersion() EQ ",VPM.2BR.VER.RECH.DISP")) AND (EB.SystemTables.getVFunction() NE "S") THEN
        E = "Solo se permite función 'Ver' en esta versión"
        EB.SystemTables.setEtext(E)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    RETURN

*-----------------------------------------------------------------------------
INITIALIZATION:
*-----------------------------------------------------------------------------
    E = ''
    FN.PARAMETROS.SPEI = "F.ABC.PARAMETROS.SPEI"
    F.PARAMETROS.SPEI = ''
    EB.DataAccess.Opf(FN.PARAMETROS.SPEI, F.PARAMETROS.SPEI)
    EB.DataAccess.FRead(FN.PARAMETROS.SPEI, "SYSTEM", R.PARAMETROS.SPEI, F.PARAMETROS.SPEI, YF.ERR)
    IF NOT(R.PARAMETROS.SPEI) THEN
        E = "Registro SYSTEM de ABC.PARAMETROS.SPEI no existe"
        EB.SystemTables.setEtext(E)
        EB.ErrorProcessing.StoreEndError()
    END
    RETURN

END 