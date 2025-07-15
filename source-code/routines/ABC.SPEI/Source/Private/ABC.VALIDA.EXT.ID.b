$PACKAGE AbcSpei
SUBROUTINE ABC.VALIDA.EXT.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING FT.Contract
    $USING AbcTable

    GOSUB INICIO
    GOSUB PROCESS
    RETURN

INICIO:

    FN.ABC.FT.DETAIL = "F.ABC.L.FT.TXN.DETAIL"
    FV.ABC.FT.DETAIL = ''
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL, FV.ABC.FT.DETAIL)

    FN.ABC.FT.DETAIL.HIS = "F.ABC.L.FT.TXN.DETAIL$HIS"
    FV.ABC.FT.DETAIL.HIS = ''
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL.HIS, FV.ABC.FT.DETAIL.HIS)

    Y.NOMBRE.APP = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "EXT.TRANS.ID"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    Y.POS.EXT.TRANS.ID = R.POS.CAMPO<1,1>
    Y.FUNCION = ''
    Y.MENSAJE = ''
    Y.ID.FT.ORI = ''
    RETURN

PROCESS:
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.EXT.TRANS.ID = Y.LOCAL.REF<1, Y.POS.EXT.TRANS.ID>
    IF Y.EXT.TRANS.ID NE '' THEN
        REC.FT.DET.CONCAT = ''
        EB.DataAccess.FRead(FV.ABC.FT.DETAIL, Y.EXT.TRANS.ID, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL, Y.ERR)
        IF REC.FT.DET.CONCAT EQ '' THEN
            Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
            EB.DataAccess.FReadHistory(FN.ABC.FT.DETAIL.HIS, Y.EXT.TRANS.ID.HIS, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL.HIS, Y.ERR)
        END
        IF REC.FT.DET.CONCAT NE '' THEN
            Y.ID.FT.ORI = REC.FT.DET.CONCAT<AbcTable.AbcLFtTxnDetail.IdFt>
            ETEXT = "EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO: ": Y.ID.FT.ORI
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
    RETURN

END 