* @ValidationCode : MjoxODA4NjEyODkzOkNwMTI1MjoxNzUzOTMyNzg4NDUwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Jul 2025 00:33:08
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

SUBROUTINE ABC.BR2.TT.CHK.LIMIT
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
    $USING AbcTable
    $USING EB.Updates
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.OVERRIDES
    END
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    PROCESS.GOAHEAD = 1
    APP.CODE = "TT" ;* Set to product code ; e.g FT, FX
    ACCT.OFFICER = ""         ;* Used in call to EXCEPTION. Should be relevant A/O
    EXCEP.CODE = ""

    CURR.NO = 0
    EB.OverrideProcessing.StoreOverride(CURR.NO)
    
    APPLICATION = EB.SystemTables.getApplication()

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.ABC.2BR.LIMITES.CAJA = 'F.ABC.2BR.LIMITES.CAJA'
    FV.ABC.2BR.LIMITES.CAJA = ''
    EB.DataAccess.Opf(FN.ABC.2BR.LIMITES.CAJA,FV.ABC.2BR.LIMITES.CAJA)

RETURN
*-----------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------------------------------------------------------------
    Y.AMOUNT.LOCAL.1 = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)<1,1>
    LOOP.CNT = 1
    MAX.LOOPS = 3
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF APPLICATION NE 'TELLER' THEN PROCESS.GOAHEAD = 0
            CASE LOOP.CNT EQ 2
                Y.ID.APP = 'SYSTEM'
                VPM.CAT.REC = ''
                EB.DataAccess.FRead(FN.VPM.2BR.LIMITES.CAJA, Y.ID.APP, VPM.CAT.REC, FV.VPM.2BR.LIMITES.CAJA, Y.ERR)
                IF (VPM.CAT.REC) THEN
                    TRANS.CODE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
                    
                    LOCATE TRANS.CODE IN VPM.CAT.REC<AbcTable.Abc2brLimitesCaja.Transaction,1> SETTING VPOS THEN
                        MIN.LIM.AMT = VPM.CAT.REC<AbcTable.Abc2brLimitesCaja.MinTransAmt,VPOS>
                        MAX.LIM.AMT = VPM.CAT.REC<AbcTable.Abc2brLimitesCaja.MaxTransAmt,VPOS>
                    END ELSE
                        MIN.LIM.AMT = 0
                        MAX.LIM.AMT = 0
                        TEXT = "YOU MUST DEFINE LIMITS IN TABLE VPM.2BR.LIMITES.CAJA"
                        TEXT := " FOR THIS TYPE OF TRANSACTION ":TRANS.CODE
                        EB.SystemTables.setText(TEXT)
                        EB.OverrideProcessing.Ove()
                    END
                END ELSE
                    ETEXT = 'EB-LOCAL.REF.FIELD.NOT.DEFINED'
                    ETEXT<2,1> = Y.ID.APP
                    PROCESS.GOAHEAD = 0
                END
            
            CASE LOOP.CNT EQ 3
                IF NOT(Y.AMOUNT.LOCAL.1) THEN
                    ETEXT = 'EB-FIELD.INPUT.MISSING'
                    ETEXT<2,1> = 'AMOUNT.LOCAL.1'
                    EB.SystemTables.setEtext(ETEXT)
                    PROCESS.GOAHEAD = 0
                END

        END CASE

        LOOP.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.OVERRIDES:
*-----------------------------------------------------------------------------

    EB.SystemTables.setAf(TT.Contract.Teller.TeTransactionCode)
    
    IF (Y.AMOUNT.LOCAL.1 LE MIN.LIM.AMT) OR (Y.AMOUNT.LOCAL.1 GE MAX.LIM.AMT) THEN
        GOSUB DO.OVERRIDE
    END

RETURN
*-----------------------------------------------------------------------------
DO.OVERRIDE:
*-----------------------------------------------------------------------------

    IF Y.AMOUNT.LOCAL.1 LE MIN.LIM.AMT THEN
        TEXT = "TRANS. AMT. ":Y.AMOUNT.LOCAL.1:" LOWER OR EQUAL THEN MINIMUM ":MIN.LIM.AMT:" ALLOWED FOR THIS TYPE OF TRANSACTION"
        EB.SystemTables.setText(TEXT)
    END

    IF Y.AMOUNT.LOCAL.1 GE MAX.LIM.AMT THEN
        TEXT = "TRANS. AMT. ":Y.AMOUNT.LOCAL.1:" GREATER OR EQUAL THEN MAXIMUM ":MAX.LIM.AMT:" ALLOWED FOR THIS TYPE OF TRANSACTION"
        EB.SystemTables.setText(TEXT)
    END
    
    
    EB.Display.Rem()

    TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
    EB.SystemTables.setText(TEXT)
    
    EB.OverrideProcessing.StoreOverride(CURR.NO)

    IF TEXT = 'NO' THEN
        GOTO PROGRAM.ABORT
    END

RETURN
**-----------------------------------------------------------------------------
*EXCEPTION.MESSAGE:
**-----------------------------------------------------------------------------
*    EB.SystemTabl
*    CALL EXCEPTION.LOG("U",
*    APP.CODE,
*    APPLICATION,
*    APPLICATION,
*    EXCEP.CODE,
*    "",
*    FULL.FNAME,
*    ID.NEW,
*    R.NEW(V-7),
*    EXCEP.MESSAGE,
*    ACCT.OFFICER)
*
*RETURN
*-----------------------------------------------------------------------------
PROGRAM.ABORT:
*-----------------------------------------------------------------------------
RETURN TO PROGRAM.ABORT

RETURN
*-----------------------------------------------------------------------------
END