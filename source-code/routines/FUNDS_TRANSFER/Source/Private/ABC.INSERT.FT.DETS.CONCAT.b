* @ValidationCode : MjoxNTkzOTQwMjU0OkNwMTI1MjoxNzQ0MzkzMDUwNTc0OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 12:37:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

*-----------------------------------------------------------------------------
* <Rating>17</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.INSERT.FT.DETS.CONCAT
*===============================================================================
* Desarrollador:        Luis Cruz - FyG Solutions
* Compania:             ABC Capital
* Fecha:                2022-12-14
* Descripci�n:          Rutina que guarda informacion de FT y cuenta en la tabla concat
*                       ABC.L.FT.TXN.DETAIL
*Cambios: 20240219 - Se modifica rutina  para agregar en la respuesta el id de FT que se ingreso
*===============================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.VERSION
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM
*    $INCLUDE ABC.BP I_F.ABC.L.FT.TXN.DETAIL

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.Versions
    
    GOSUB INICIO
    GOSUB CHECK.VERSION.AUTH
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

*    FN.ABC.FT.DETAIL = "F.ABC.L.FT.TXN.DETAIL"
*    FV.ABC.FT.DETAIL = ""
*    EB.DataAccess.Opf(FN.ABC.FT.DETAIL, FV.ABC.FT.DETAIL)

*    CALL GET.LOCAL.REFM("FUNDS.TRANSFER","EXT.TRANS.ID", Y.POS.EXT.TRANS.ID)
    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = "EXT.TRANS.ID"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    Y.POS.EXT.TRANS.ID     = field_Positions<1,1>

    Y.FUNCION = ""
    Y.MENSAJE = ""
    Y.NO.AUTH.VERSIO = ""
    Y.ID.FT = ""
    Y.ID.FT.ORI=""
    Y.CUENTA.DEBIT = ""
    Y.CUENTA.CREDIT = ""
    Y.EXT.TRANS.ID = ""
    Y.TRANSAC.TYPE = ""
    
    Y.TRANSAC.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)     ;* R.NEW(FT.TRANSACTION.TYPE)

    Y.FUNCION = EB.SystemTables.getTFunction()       ;* V$FUNCTION
    Y.MENSAJE = EB.SystemTables.getMessage()        ;* MESSAGE
    Y.NO.AUTH.VERSION = EB.SystemTables.getRVersion(EB.Versions.Version.VerNoOfAuth)        ;* R.VERSION(EB.VER.NO.OF.AUTH)

RETURN
*-----------------------------------------------------------------------------
CHECK.VERSION.AUTH:
*-----------------------------------------------------------------------------

    BEGIN CASE
        CASE Y.NO.AUTH.VERSION EQ "0"
*        GOSUB SAVE.FT.CONCAT
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

        CASE Y.FUNCION EQ "D"
*        GOSUB GET.EXT.TRANS.ID
*        GOSUB DELETE.FT.CONCAT

    END CASE

RETURN
*-----------------------------------------------------------------------------
SAVE.FT.CONCAT:
*-----------------------------------------------------------------------------

    Y.ID.FT = EB.SystemTables.getIdNew()        ;* ID.NEW
    Y.CUENTA.DEBIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)     ;* R.NEW(FT.DEBIT.ACCT.NO)
    Y.CUENTA.CREDIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)        ;* R.NEW(FT.CREDIT.ACCT.NO)
    Y.EXT.TRANS.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.POS.EXT.TRANS.ID>       ;* R.NEW(FT.LOCAL.REF)<1, Y.POS.EXT.TRANS.ID>

    IF Y.EXT.TRANS.ID NE '' THEN
        GOSUB VALIDA.EXT.TRANS.ID
        REC.FT.DETAIL = ''
*        REC.FT.DETAIL<FT.TXN.DET.ID.FT> = Y.ID.FT
*        REC.FT.DETAIL<FT.TXN.DET.DEBIT.ACCT.NO> = Y.CUENTA.DEBIT
*        REC.FT.DETAIL<FT.TXN.DET.CREDIT.ACCT.NO> = Y.CUENTA.CREDIT
*        WRITE REC.FT.DETAIL TO FV.ABC.FT.DETAIL, Y.EXT.TRANS.ID

        REC.FT.DETAIL<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailIdFt>  = Y.ID.FT
        REC.FT.DETAIL<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailDebitAcctNo> = Y.CUENTA.DEBIT
        REC.FT.DETAIL<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailCreditAcctNo> = Y.CUENTA.CREDIT
        ABC.BP.AbcLFtTxnDetail.Write(Y.EXT.TRANS.ID, REC.FT.DETAIL)
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXT.TRANS.ID:
*-----------------------------------------------------------------------------

    REC.FT.DET.CONCAT = ""
    REC.FT.DET.CONCAT = ABC.BP.AbcLFtTxnDetail.Read(Y.EXT.TRANS.ID, Error)
    IF REC.FT.DET.CONCAT THEN
        Y.ID.FT.ORI = REC.FT.DET.CONCAT<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailIdFt>
    END ELSE
        Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
        REC.FT.DET.CONCAT = ABC.BP.AbcBiometricos.ReadHis(Y.EXT.TRANS.ID.HIS, Y.ERR)
        Y.ID.FT.ORI = REC.FT.DET.CONCAT<ABC.BP.AbcLFtTxnDetail.AbcLFtTxnDetailIdFt>
    END
*    READ REC.FT.DET.CONCAT FROM FV.ABC.FT.DETAIL, Y.EXT.TRANS.ID THEN
*        Y.ID.FT.ORI =REC.FT.DET.CONCAT<FT.TXN.DET.ID.FT>
*
*    END ELSE
*        Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
*        EB.DataAccess.FReadHistory(FN.ABC.FT.DETAIL.HIS, Y.EXT.TRANS.ID.HIS, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL.HIS, Y.ERR)
*        Y.ID.FT.ORI =REC.FT.DET.CONCAT<FT.TXN.DET.ID.FT>
*    END

    IF REC.FT.DET.CONCAT NE '' THEN
        EB.SystemTables.setEtext("EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO: ": Y.ID.FT.ORI)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
*-----------------------------------------------------------------------------
GET.EXT.TRANS.ID:
*-----------------------------------------------------------------------------

    REC.FT = ""
    REC.FT = FT.Contract.FundsTransfer.ReadNau(EB.SystemTables.getIdNew(), Error)
    IF REC.FT THEN
        Y.EXT.TRANS.ID = REC.FT<FT.Contract.FundsTransfer.LocalRef,Y.POS.EXT.TRANS.ID>
    END
*    READ REC.FT FROM FV.FT.NAU, ID.NEW THEN
*        Y.EXT.TRANS.ID = REC.FT<FT.LOCAL.REF, Y.POS.EXT.TRANS.ID>
*    END

RETURN
*-----------------------------------------------------------------------------
DELETE.FT.CONCAT:
*-----------------------------------------------------------------------------

    IF Y.EXT.TRANS.ID NE '' THEN
        REC.FT.DETAIL = ""
        REC.FT.DETAIL = ABC.BP.AbcLFtTxnDetail.Read(Y.EXT.TRANS.ID, Error)
        IF REC.FT.DETAIL THEN
            EB.DataAccess.FDelete(FN.ABC.FT.DETAIL, Y.EXT.TRANS.ID)
        END
*        READ REC.FT.DETAIL FROM FV.ABC.FT.DETAIL, Y.EXT.TRANS.ID THEN
*            EB.DataAccess.FDelete(FN.ABC.FT.DETAIL, Y.EXT.TRANS.ID)
*        END
    END

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------
