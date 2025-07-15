* @ValidationCode : MjoxODcyNjY5OTA2OkNwMTI1MjoxNzUyNDU3MDI4NTgyOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2025 22:37:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.INSERT.FT.DETS.CONCAT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING FT.Contract
    $USING EB.Updates
    $USING AbcTable
    $USING EB.Versions
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INICIO
    GOSUB CHECK.VERSION.AUTH

RETURN
*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    FN.ABC.FT.DETAIL = "F.ABC.L.FT.TXN.DETAIL"
    FV.ABC.FT.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL, FV.ABC.FT.DETAIL)

    FN.ABC.FT.DETAIL.HIS = "F.ABC.L.FT.TXN.DETAIL$HIS"
    FV.ABC.FT.DETAIL.HIS = ''
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL.HIS, FV.ABC.FT.DETAIL.HIS)
    
    APP.NAME<1>     = "FUNDS.TRANSFER"
    FIELD.NAME<1>   = "EXT.TRANS.ID"
    FIELD.POS       = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    Y.POS.EXT.TRANS.ID     = FIELD.POS<1,1>
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)

    Y.FUNCION = ""
    Y.MENSAJE = ""
    Y.NO.AUTH.VERSIO = ""

    Y.ID.FT = ""
    Y.ID.FT.ORI=""
    Y.CUENTA.DEBIT = ""
    Y.CUENTA.CREDIT = ""
    Y.EXT.TRANS.ID = ""
    Y.TRANSAC.TYPE = ""
    Y.TRANSAC.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)

    Y.FUNCION = EB.SystemTables.getVFunction()
    Y.MENSAJE = EB.SystemTables.getMessage()
    Y.NO.AUTH.VERSION = EB.SystemTables.getRVersion(EB.Versions.Version.VerNoOfAuth)
    
RETURN
*-----------------------------------------------------------------------------
CHECK.VERSION.AUTH:
*-----------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.NO.AUTH.VERSION EQ "0"
            GOSUB CHECK.FUNCTION.VERSION
        CASE Y.NO.AUTH.VERSION EQ "1"
            IF Y.FUNCION EQ "A" THEN RETURN
            GOSUB CHECK.FUNCTION.VERSION
    END CASE
    
RETURN
*-----------------------------------------------------------------------------
CHECK.FUNCTION.VERSION:
*-----------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.FUNCION EQ "I"
            GOSUB SAVE.FT.CONCAT
    END CASE

RETURN
*-----------------------------------------------------------------------------
SAVE.FT.CONCAT:
*-----------------------------------------------------------------------------
    Y.ID.FT = EB.SystemTables.getIdNew()
    Y.CUENTA.DEBIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.CUENTA.CREDIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.EXT.TRANS.ID = Y.LOCAL.REF<1,Y.POS.EXT.TRANS.ID>

    IF Y.EXT.TRANS.ID NE '' THEN
        GOSUB VALIDA.EXT.TRANS.ID
        IF REC.FT.DET.CONCAT NE '' THEN
            ETEXT = "EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO: ": Y.ID.FT.ORI
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
        REC.FT.DETAIL = ''
        REC.FT.DETAIL<AbcTable.AbcLFtTxnDetail.IdFt> = Y.ID.FT
        REC.FT.DETAIL<AbcTable.AbcLFtTxnDetail.DebitAcctNo> = Y.CUENTA.DEBIT
        REC.FT.DETAIL<AbcTable.AbcLFtTxnDetail.CreditAcctNo> = Y.CUENTA.CREDIT
        
        EB.DataAccess.FWrite(FN.ABC.FT.DETAIL,Y.EXT.TRANS.ID,REC.FT.DETAIL)
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXT.TRANS.ID:
*-----------------------------------------------------------------------------
    REC.FT.DET.CONCAT = ""
    EB.DataAccess.FRead(FN.ABC.FT.DETAIL, Y.EXT.TRANS.ID, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL, Y.ERR.CONCAT)
    
    IF REC.FT.DET.CONCAT THEN
        Y.ID.FT.ORI = REC.FT.DET.CONCAT<AbcTable.AbcLFtTxnDetail.IdFt>
    END ELSE
        Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
        EB.DataAccess.FReadHistory(FN.ABC.FT.DETAIL.HIS, Y.EXT.TRANS.ID.HIS, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL.HIS, Y.ERR)
        Y.ID.FT.ORI = REC.FT.DET.CONCAT<AbcTable.AbcLFtTxnDetail.IdFt>
    END

RETURN
*-----------------------------------------------------------------------------
END
