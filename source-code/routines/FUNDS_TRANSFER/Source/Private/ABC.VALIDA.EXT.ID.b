* @ValidationCode : Mjo2MjQ4NjE4MTk6Q3AxMjUyOjE3NDQzOTk2OTkxNDg6VXNpYXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2025 14:28:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
.
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.EXT.ID
*===============================================================================
* Fecha: 20240313
* Descripción: Rutina que valida que el campo EXT.TRANS.ID no este duplicado y en caso
*              existir regresa el ID del FT con el que se utilizo
*===============================================================================
*CARGADA A VERSIONES:
*-------------------------------------------------------------------------------
*FUNDS.TRANSFER,ABC.SPEI.EXPRESS.PRN
*FUNDS.TRANSFER,ABC.PAGO.CREDITO
*FUNDS.TRANSFER,ABC.PAGO.SERVICIOS
*FUNDS.TRANSFER,ABC.PAGO.TDC
*FUNDS.TRANSFER,ABC.SPEI.PRN
*FUNDS.TRANSFER,ABC.TRASPASO.DIGITAL
*FUNDS.TRANSFER,ABC.PAGO.TDC.2
*FUNDS.TRANSFER,ABC.DEVUELVE.GARANTIA
*FUNDS.TRANSFER,ABC.EJERCE.GARANTIA
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN.2
*FUNDS.TRANSFER,ABC.SPEI.EXPRESS.PRN.2
*===============================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.VERSION
*    $INCLUDE ABC.BP I_F.ABC.L.FT.TXN.DETAIL
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AC.Config
    $USING EB.Updates
    $USING EB.ErrorProcessing

    GOSUB INICIO
    GOSUB PROCESS
RETURN

INICIO:

    FN.ABC.FT.DETAIL = "F.ABC.L.FT.TXN.DETAIL"
    FV.ABC.FT.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL, FV.ABC.FT.DETAIL)

    FN.ABC.FT.DETAIL.HIS = "F.ABC.L.FT.TXN.DETAIL$HIS"
    FV.ABC.FT.DETAIL.HIS = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL.HIS, FV.ABC.FT.DETAIL.HIS)

*CALL GET.LOCAL.REFM("FUNDS.TRANSFER","EXT.TRANS.ID", Y.POS.EXT.TRANS.ID)
    Y.NOMBRE.APP<-1> = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO<1,1> = "EXT.TRANS.ID"
    R.POS.CAMPO = ''
    Y.POS.EXT.TRANS.ID = ''
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    Y.POS.EXT.TRANS.ID = R.POS.CAMPO<1, 1>
    
    Y.FUNCION = ""
    Y.MENSAJE = ""
    Y.ID.FT.ORI=""

RETURN

PROCESS:

    Y.LOCAL.REF = ''
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                
    Y.EXT.TRANS.ID = Y.LOCAL.REF<1, Y.POS.EXT.TRANS.ID> ;*R.NEW(FT.LOCAL.REF)<1, Y.POS.EXT.TRANS.ID>
    IF Y.EXT.TRANS.ID NE "" THEN
        REC.FT.DET.CONCAT = ""
*READ REC.FT.DET.CONCAT FROM FV.ABC.FT.DETAIL, Y.EXT.TRANS.ID THEN
        REC.FT.DET.CONCAT = ABC.BP.AbcLFtTxnDetail.Read(Y.EXT.TRANS.ID, ERR.FT.DET)
        IF REC.FT.DET.CONCAT EQ '' THEN
            Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
            REC.FT.DET.CONCAT = ABC.BP.AbcLFtTxnDetail.ReadHis(Y.EXT.TRANS.ID.HIS, ERR.FT.DET)
            Y.ID.FT.ORI = REC.FT.DET.CONCAT<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailIdFt> ;*<FT.TXN.DET.ID.FT>
        END
        
        IF REC.FT.DET.CONCAT NE '' THEN
            Y.ID.FT.ORI =REC.FT.DET.CONCAT<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailIdFt> ;*<FT.TXN.DET.ID.FT>
        END ;*ELSE
*            Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
*            EB.DataAccess.FReadHistory(FN.ABC.FT.DETAIL.HIS, Y.EXT.TRANS.ID.HIS, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL.HIS, Y.ERR)
*            Y.ID.FT.ORI =REC.FT.DET.CONCAT<FT.TXN.DET.ID.FT>
*
*        END
        IF REC.FT.DET.CONCAT NE "" THEN
            EB.SystemTables.setEtext("EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO: ": Y.ID.FT.ORI) ;*ETEXT = "EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO: ": Y.ID.FT.ORI
            EB.ErrorProcessing.StoreEndError()
        END

    END

RETURN

END
