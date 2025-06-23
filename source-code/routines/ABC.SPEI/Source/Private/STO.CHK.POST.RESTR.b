* @ValidationCode : MjoxMTQ3NDE0NDQzOkNwMTI1MjoxNzUwMjk3ODE1NDA4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Jun 2025 22:50:15
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

SUBROUTINE STO.CHK.POST.RESTR
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

    $USING TT.Contract
    $USING AC.Config
    $USING DC.Contract
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    APP.GET = EB.SystemTables.getApplication()
    YAPL = FIELD(APP.GET,",",1)
    Y.ID.NEW = EB.SystemTables.getIdNew()
        
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.ABC.PARAMETROS.BANXICO = "F.ABC.PARAMETROS.BANXICO"
    F.ABC.PARAMETROS.BANXICO = ""
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.BANXICO, F.ABC.PARAMETROS.BANXICO)
    
    EB.DataAccess.CacheRead(FN.ABC.PARAMETROS.BANXICO, "SYSTEM", R.REC.APLI, ERR.APLI)
    YPOST.RESTRICT = R.REC.APLI<AbcTable.AbcParametrosBanxico.AcctRest>
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    YCOMIAUX = EB.SystemTables.getComi()
    YCOMI = ''
    YCOMI = YCOMIAUX * 1
    V.FUNCTION = EB.SystemTables.getVFunction()
    
    IF YCOMI AND NUM(YCOMI) THEN
        YCTA = EB.SystemTables.getComi()
    END ELSE
        IF V.FUNCTION EQ "R" THEN
            BEGIN CASE
                CASE YAPL EQ "FUNDS.TRANSFER"
                    R.FT = FT.Contract.FundsTransfer.Read(Y.ID.NEW, YERR.FT)
                    IF NOT(YERR.FT) THEN
                        YCTA = R.FT<FT.Contract.FundsTransfer.DebitAcctNo>
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
                        GOSUB VAL.PR
                        YCTA = R.FT<FT.Contract.FundsTransfer.CreditAcctNo>
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
                    END
                CASE YAPL EQ "TELLER"
                    R.TT = TT.Contract.Teller.Read(Y.ID.NEW, YERR.TT)
                    IF NOT(YERR.TT) THEN
                        YCTA = R.TT<TT.Contract.Teller.TeAccountOne>
                        EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne)
                        GOSUB VAL.PR
                        YCTA = R.TT<TT.Contract.Teller.TeAccountTwo>
                        EB.SystemTables.setAf(TT.Contract.Teller.TeAccountTwo)
                    END
                CASE YAPL EQ "DATA.CAPTURE"
                    R.DC = DC.Contract.DataCapture.Read(Y.ID.NEW, YERR.DC)
                    IF NOT(YERR.DC) THEN
                        YCTA = R.DC<DC.Contract.DataCapture.DcAccountNumber>
                        EB.SystemTables.setAf(DC.Contract.DataCapture.DcAccountNumber)
                        YCRDB = R.DC<DC.Contract.DataCapture.DcSign>
                    END
                CASE YAPL EQ "AC.LOCKED.EVENTS"
                    R.ALE = AC.AccountOpening.LockedEvents.Read(Y.ID.NEW, YERR.ALE)
                    IF NOT(YERR.ALE) THEN
                        YCTA = R.ALE<AC.AccountOpening.LockedEvents.LckAccountNumber>
                        EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
                        YCRDB = 'CREDIT'
                    END
            END CASE
        END ELSE
            BEGIN CASE
                CASE YAPL EQ "FUNDS.TRANSFER"
                    YCTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
                    GOSUB VAL.PR
                    YCTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
                CASE YAPL EQ "TELLER"
                    YCTA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne)
                    GOSUB VAL.PR
                    YCTA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountTwo)
                CASE YAPL EQ "DATA.CAPTURE"
                    YCTA = EB.SystemTables.getRNew(DC.Contract.DataCapture.DcAccountNumber)
                    EB.SystemTables.setAf(DC.Contract.DataCapture.DcAccountNumber)
                    YCRDB = EB.SystemTables.getRNew(DC.Contract.DataCapture.DcSign)
                CASE YAPL EQ "AC.LOCKED.EVENTS"
                    YCTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
                    EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
                    YCRDB = 'DEBIT'
            END CASE
        END
    END
    GOSUB VAL.PR

RETURN
*-----------------------------------------------------------------------------
VAL.PR:
*-----------------------------------------------------------------------------
    EB.SystemTables.setEtext('')
    R.CTA = AC.AccountOpening.Account.Read(YCTA, YERR.AC)
    IF NOT(YERR.AC) THEN
        YPOST.REST = R.CTA<AC.AccountOpening.Account.PostingRestrict>
        IF YPOST.REST THEN
            LOCATE YPOST.REST IN YPOST.RESTRICT<1,1> SETTING YPOSICION THEN
                R.PR = AC.Config.PostingRestrict.Read(YPOST.REST, YERR.PR)
                IF NOT(YERR.PR) THEN
                    YPR.DESC = R.PR<AC.Config.PostingRestrict.PosDescription>
                    YREST.TYP = R.PR<AC.Config.PostingRestrict.PosRestrictionType>
                    IF V.FUNCTION EQ "R" THEN
                        Y.ETEXT = YPR.DESC:" ":YCTA:", sin operaciones "
                    END ELSE
                        Y.ETEXT = YPR.DESC:", sin operaciones "
                    END
                END
                YAF = EB.SystemTables.getAf()
                YFT.DEBIT.ACCT.NO = FT.Contract.FundsTransfer.DebitAcctNo
                YTT.TE.ACCOUNT.2 = TT.Contract.Teller.TeAccountTwo
                YFT.CREDIT.ACCT.NO = FT.Contract.FundsTransfer.CreditAcctNo
                YTT.TE.ACCOUNT.1 = TT.Contract.Teller.TeAccountOne
                BEGIN CASE
                    CASE YREST.TYP EQ "ALL"
                        Y.ETEXT := "ni de crto ni de dto"
                    CASE YREST.TYP EQ "DEBIT"
                        IF YAF EQ YFT.DEBIT.ACCT.NO OR YAF EQ YTT.TE.ACCOUNT.2 OR YCRDB EQ 'D' THEN
                            Y.ETEXT := "de dto"
                        END ELSE
                            Y.ETEXT = ''
                        END
                    CASE YREST.TYP EQ "CREDIT"
                        IF YAF EQ YFT.CREDIT.ACCT.NO OR YAF EQ YTT.TE.ACCOUNT.1 OR YCRDB EQ 'C' THEN
                            Y.ETEXT := "de crto"
                        END ELSE
                            Y.ETEXT = ''
                        END
                END CASE
            END
            IF Y.ETEXT THEN
                EB.SystemTables.setE(Y.ETEXT)
                EB.SystemTables.setEtext(Y.ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
                EB.SystemTables.setTEtext('')
            END
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END
