* @ValidationCode : Mjo4MTI4MzQwMzY6Q3AxMjUyOjE3NTI2MzIyMzE0NjU6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jul 2025 23:17:11
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

$PACKAGE AbcTeller

SUBROUTINE V.GIC.ACCT.CCY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    $USING TT.Contract
    $USING AbcSpei
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    APP.NAME<1>     = "TELLER"
    FIELD.NAME<1>   = "CLEARED.BAL": @VM :"DRAW.CUST.NAME"
    
    FIELD.POS = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    Y.CBAL.POS     = FIELD.POS<1,1>
    Y.DCNAME.POS   = FIELD.POS<1,2>
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* Valida que la cuenta no este embargada.
    Y.ID.ACCT = EB.SystemTables.getComi()
    AbcSpei.AbcValPostRest(Y.ID.ACCT)
    MESSAGE = EB.SystemTables.getMessage()

    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END
    
    YR.ACCOUNT = EB.SystemTables.getComi()

    REC.CUENTA = AC.AccountOpening.Account.Read(YR.ACCOUNT, Y.ACCT.ERR)
    
    Y.LIMIT.REF = REC.CUENTA<AC.AccountOpening.Account.LimitRef>
    Y.CATEGORY = REC.CUENTA<AC.AccountOpening.Account.Category>
    Y.CUSTOMER = REC.CUENTA<AC.AccountOpening.Account.Customer>

    IF (Y.LIMIT.REF EQ 'NOSTRO') OR (Y.CATEGORY EQ 3000) THEN
        E = "CUENTA NO PERMITIDA"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi('')
    END ELSE
        YR.CCY = REC.CUENTA<AC.AccountOpening.Account.Currency>
        YR.BAL = REC.CUENTA<AC.AccountOpening.Account.OnlineClearedBal>

        EB.SystemTables.setRNew(TT.Contract.Teller.TeCurrencyTwo,YR.CCY)

        TT.LOCAL.REF    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        TT.LOCAL.REF<1,Y.CBAL.POS> = YR.BAL
        
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne,"")

*La variable COMI es utilizada por la rutina VPM.V.CUSTOMER.NAME para buscar al cliente
        Y.COMI = Y.CUSTOMER
        EB.SystemTables.setComi(Y.CUSTOMER)
        AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE)

        TT.LOCAL.REF<1,Y.DCNAME.POS> = Y.NOMBRE
        
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,TT.LOCAL.REF)
    
*Devolvemos el valor que traCOMI
        EB.SystemTables.setComi(YR.ACCOUNT)
    END

    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END