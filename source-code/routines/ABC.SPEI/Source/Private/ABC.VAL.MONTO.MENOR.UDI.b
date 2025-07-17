* @ValidationCode : MjotMTA0MjU1MjY4OTpDcDEyNTI6MTc0ODg3NzQ2MjU0MTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jun 2025 12:17:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei
SUBROUTINE ABC.VAL.MONTO.MENOR.UDI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcGetGeneralParam
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING ST.Customer
    
    
    GOSUB INICIALIZA
    GOSUB PROCESO
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    Y.ID.GEN.PARAM = 'ABC.MONTO.UDIS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'MONTO.MAXIMO.PESOS' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.MONTO.MAX = Y.LIST.VALUES<YPOS.PARAM>
    END


    NOM.CAMPOS     = 'FOL.VALIDACION'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)
    POS.FOL.VAL     = POS.CAMP.LOCAL<1,1>


RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

    Y.MONTO.TRA = ''
    Y.FOL.VAL = ''
    Y.TRAN.TYPE = ''
    Y.BAND.ENV.NULL = ''

    Y.TRAN.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.FOL.VAL = Y.LOCAL.REF<1, POS.FOL.VAL>

    BEGIN CASE

        CASE Y.TRAN.TYPE EQ 'ACSE'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

        CASE Y.TRAN.TYPE EQ 'ACSR'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

        CASE Y.TRAN.TYPE EQ 'ACSD'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

        CASE Y.TRAN.TYPE EQ 'AC'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

    END CASE

*LEEMOS EL REGISTRO DE LA CUENTA PARA OBTENER EL CLIENTE Y EL NIVEL

    R.ACC.CUS = AC.AccountOpening.Account.Read(Y.ACC.CUS, Error)

    IF R.ACC.CUS THEN
        Y.ID.CUST = R.ACC.CUS<AC.AccountOpening.Account.Customer>
    END

*LEEMOS EL REGISTRO DEL CLIENTE PARA OBTENER CLASSIFICATION
    REC.CUSTO = ST.Customer.Customer.Read(Y.ID.CUST, Error)

    IF REC.CUSTO THEN
        Y.CLASS.CUST = REC.CUSTO<ST.Customer.Customer.EbCusSector>
    END

    IF (Y.CLASS.CUST NE 1001) AND (Y.CLASS.CUST NE 1100) THEN
        Y.BAND.ENV.NULL = 1
    END

    IF Y.MONTO.TRA LT Y.MONTO.MAX THEN
        Y.BAND.ENV.NULL = 1
    END

    IF Y.BAND.ENV.NULL EQ 1 THEN
        Y.LOCAL.REF<1, POS.FOL.VAL> = ''
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
    END

    EB.Display.RebuildScreen()

RETURN
END
