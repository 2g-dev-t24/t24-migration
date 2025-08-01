* @ValidationCode : MjoxMTA3OTExNzM6Q3AxMjUyOjE3NTM4NDg5NjkzNTg6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Jul 2025 01:16:09
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

SUBROUTINE ABC.2BR.TT.CHKALLOW.AMT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.OverrideProcessing

    $USING TT.Contract
    $USING AbcTable
    $USING TT.Config
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.LIM.CAJA = 'F.ABC.2BR.LIMITES.CAJA'
    FV.LIM.CAJA = ''
    EB.DataAccess.Opf(FN.LIM.CAJA,FV.LIM.CAJA)

    FN.TELLER.ID = 'F.TELLER.ID'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER.ID, FV.TELLER.ID)
    
    CALL GET.LOC.REF('TELLER.ID','TILL.LIMIT',TPOS)
    
    Y.APP = "TELLER.ID"
    Y.FLD = "TILL.LIMIT"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    TPOS = Y.POS.FLD<1,1>
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CURR.NO = 0
    EB.OverrideProcessing.StoreOverride(CURR.NO)

    STR.USER = EB.SystemTables.getOperator()
    STR.TELLER.ID = ''
    NUM.REG = ''

    STR.ENQ = "SELECT " :FN.TELLER.ID: " WITH STATUS EQ 'OPEN'  AND USER EQ " : SQUOTE(STR.USER)
    EB.DataAccess.Readlist(STR.ENQ,STR.TELLER.ID,'',NUM.REG,'')
* Obtiene el numero de cajero
    ID.CAJERO = STR.TELLER.ID<1,1>

* Obtener el ID de teller transaction
    TEL.CURR = "MXN"

    R.TEL.REC = TT.Config.TellerParameter.CacheRead("MX0010001", ERR.TEL)
    CAT.CODE2 = R.TEL.REC<TT.Config.TellerParameter.ParTranCategory>

    CAT.CODE = CAT.CODE2<1,1>
    CUENTA.CAJA = TEL.CURR : CAT.CODE : ID.CAJERO
    
    Y.TELLER.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeTellerIdOne)
    TELLER.ID.REC = TT.Contract.TellerId.Read(Y.TELLER.ID, TELL.ID.ERR)
    
    TRANS.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    TEL.CURR = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)

    TT.TE.ACCOUNT.2 = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
    IF TT.TE.ACCOUNT.2 EQ CUENTA.CAJA THEN
        TRANS.AMT = TRANS.AMT * (-1)
    END

    TELL.CAT =  "SYSTEM"
    EB.DataAccess.FRead(FN.LIM.CAJA,TELL.CAT,CAJA.REC,FV.LIM.CAJA,CAJA.ERR)
    
    CAJA.REC.CURRENCY = RAISE(CAJA.REC<AbcTable.Abc2brLimitesCaja.Currency>)
    
    LOCATE TEL.CURR IN CAJA.REC.CURRENCY SETTING VPPOS THEN
        
        ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
        ACREC = AC.AccountOpening.Account.Read(ACCOUNT.ID, AC.ERR)
        AC.ACT.BAL = ACREC<AC.AccountOpening.Account.OnlineActualBal>
        
        TOTAL.AMT = TRANS.AMT + ABS(AC.ACT.BAL)
        CALLOW.AMT = CAJA.REC<AbcTable.Abc2brLimitesCaja.CallowAmt,VPPOS>
        IF TOTAL.AMT GE CALLOW.AMT THEN
* SPECIAL AUTHORIZATION IS NEEDED
            TEXT = "THE TILL WILL HAVE (":TOTAL.AMT:") MAXIMUM ALLOWED (":CALLOW.AMT:")"
            EB.SystemTables.setText(TEXT)
            EB.Display.Rem()
            TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
            EB.SystemTables.setText(TEXT)
            EB.OverrideProcessing.StoreOverride(CURR.NO)
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END