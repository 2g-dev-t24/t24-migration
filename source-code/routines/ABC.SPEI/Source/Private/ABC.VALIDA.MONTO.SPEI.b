* @ValidationCode : MjotMTcyMTg2MTA0OkNwMTI1MjoxNzQ5MDAxNzMzOTc4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Jun 2025 22:48:53
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

SUBROUTINE ABC.VALIDA.MONTO.SPEI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    
    $USING AbcTable
    $USING AbcSpei
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.MtOneZerThrType,"Mt103extend")
    YCONST.ID.TABLA.PARAMETROS = "SYSTEM"
    YMONTO.MINIMO = ""
    
    FN.ABC.PARAMETROS.SPEI = "F.ABC.PARAMETROS.SPEI"
    F.ABC.PARAMETROS.SPEI = ""
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.SPEI, F.ABC.PARAMETROS.SPEI)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    ERR.PARAM.SPEI = ""
    REG.PARAM = ""
    EB.DataAccess.FRead(FN.ABC.PARAMETROS.SPEI, YCONST.ID.TABLA.PARAMETROS, REG.PARAM, F.ABC.PARAMETROS.SPEI, ERR.PARAM.SPEI)
    
    IF (REG.PARAM NE "") THEN
        YCONST.CTA.MENORES = REG.PARAM<AbcTable.AbcParametrosSpei.SpeiCtaMenores>
        YCONST.CTA.BANXICO = REG.PARAM<AbcTable.AbcParametrosSpei.SpeiCtaBanxico>
        YCONST.TXN.TYPE.TRANSF = REG.PARAM<AbcTable.AbcParametrosSpei.TxnTipoMen>
        YCONST.TXN.TYPE.SPEUA = REG.PARAM<AbcTable.AbcParametrosSpei.TxnTipoEnv>
        YMONTO.MINIMO = REG.PARAM<AbcTable.AbcParametrosSpei.SpeiPriNombre>
    END
    Y.ID.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ID.ACCOUNT, Y.AC.ERR)
    Y.AC.WORKING.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    
    Y.COMI = EB.SystemTables.getComi()
    ETEXT = ""
    IF (Y.COMI LE 0) THEN
		Y.MENSAJE.ERR = "Monto a Transferir debe ser > a 0"
    	EB.SystemTables.setE(Y.MENSAJE.ERR)
        EB.ErrorProcessing.Err()
    END

    AbcSpei.RtnFtCheckBalance
    
    Y.ETEXT = EB.SystemTables.getEtext()
    IF (Y.ETEXT NE '') THEN
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    Y.COMI = EB.SystemTables.getComi()
    IF (Y.COMI > Y.AC.WORKING.BALANCE) THEN
        YWORKING.BALANCE.STR = "...Saldo insuficiente "
        EB.SystemTables.setE(YWORKING.BALANCE.STR)
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi("")
    END

    IF (Y.COMI < YMONTO.MINIMO) THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.TransactionType, YCONST.TXN.TYPE.TRANSF)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, YCONST.CTA.MENORES)
    END ELSE
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.TransactionType, YCONST.TXN.TYPE.SPEUA)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, YCONST.CTA.BANXICO)
    END

RETURN
*-----------------------------------------------------------------------------
END
