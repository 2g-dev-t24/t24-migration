* @ValidationCode : MjoxOTQwMjAxMjE3OkNwMTI1MjoxNzUzOTMxNzYyNzgxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Jul 2025 00:16:02
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

SUBROUTINE BMV.TT.CHKLIMIT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    $USING TT.Contract
    $USING TT.Config
    $USING AbcTable
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

    FN.TELLER$NAU = 'F.TELLER$NAU'
    FV.TELLER$NAU = ''
    EB.DataAccess.Opf(FN.TELLER$NAU,FV.TELLER$NAU)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* Obtener el usuario del cajero
    STR.USER = EB.SystemTables.getOperator()

    STR.ENQ="SELECT FBNK.TELLER.ID WITH STATUS EQ 'OPEN'  AND USER EQ " : SQUOTE(STR.USER)
    EB.DataAccess.Readlist(STR.ENQ,STR.TELLER.ID,'',NUM.REG,'')

* Obtiene el numero de cajero
    ID.CAJERO = STR.TELLER.ID<1,1>
    TEL.CURR = "MXN"

    R.TEL.REC = TT.Config.TellerParameter.CacheRead("MX0010001", ERR.TEL)
    CAT.CODE2 = R.TEL.REC<TT.Config.TellerParameter.ParTranCategory>

    CAT.CODE = CAT.CODE2<1,1>
    CUENTA.CAJA = TEL.CURR : CAT.CODE : ID.CAJERO
    
    TELLER.ID.REC = TT.Contract.TellerId.Read(ID.CAJERO, TELL.ID.ERR)
    TRANS.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    
    TELL.CAT =  "SYSTEM"
    EB.DataAccess.FRead(FN.LIM.CAJA,TELL.CAT,CAJA.REC,FV.LIM.CAJA,CAJA.ERR)

    CAJA.REC.CURRENCY = RAISE(CAJA.REC<AbcTable.Abc2brLimitesCaja.Currency>)
    LOCATE TEL.CURR IN CAJA.REC.CURRENCY SETTING VPPOS THEN
        
        ACREC = AC.AccountOpening.Account.Read(CUENTA.CAJA, AC.ERR)
        AMOUNT.IN.TILL = ABS(ACREC<AC.AccountOpening.Account.OnlineActualBal>)
        CALLOW.AMT = CAJA.REC<AbcTable.Abc2brLimitesCaja.CallowAmt,VPPOS>

        IF AMOUNT.IN.TILL GT CALLOW.AMT THEN
            E = "LIMITE DIARIO EXCEDE AL AUTORIZADO, HACER CONCENTRACION A BOVEDA"
            E := "      TILL HAS ":AMOUNT.IN.TILL:" BUT, MAXIMUM ALLOWED IN TILL = ":CALLOW.AMT
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

        Y.TT.LIST = ''
        Y.TT.NO = ''
        SEL.CMD = "SELECT ":FN.TELLER$NAU:" WITH RECORD.STATUS EQ 'INAO' AND TELLER.ID.1 EQ ":DQUOTE(ID.CAJERO)
        EB.DataAccess.Readlist(SEL.CMD,Y.TT.LIST,'',Y.TT.NO,'')

        TOTAL.AMT = 0

        LOOP
            REMOVE Y.TT.ID FROM Y.TT.LIST SETTING Y.POS
        WHILE Y.TT.ID : Y.POS

            TELLER.REC = TT.Contract.Teller.ReadNau(Y.TT.ID, TELL.ERR)

            TRANS.AMT = TELLER.REC<TT.Contract.Teller.TeAmountLocalOne>
            
            TT.AC.2 = TELLER.REC<TT.Contract.Teller.TeAccountTwo>
            IF TT.AC.2 EQ CUENTA.CAJA THEN
                TRANS.AMT = TRANS.AMT * (-1)
            END

            TOTAL.AMT += TRANS.AMT

        REPEAT
        
        TOTAL.AMT += AMOUNT.IN.TILL
        IF TOTAL.AMT GT CALLOW.AMT THEN
            E = "UNAUTHORIZED RECORDS FOR THIS TILL MUST BE AUTHORIZED FIRST !!!"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END