* @ValidationCode : MjoxODA1MzYwNzQ1OkNwMTI1MjoxNzQ0NDE5MzgwNTExOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 19:56:20
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
* <Rating>834</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE STO.CHK.POST.RESTR
*-----------------------------------------------------------------------------
*
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.TELLER
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.POSTING.RESTRICT
*    $INCLUDE ../T24_BP I_F.DATA.CAPTURE
*    $INCLUDE    ABC.BP I_F.VPM.PARAMETROS.BANXICO
*    $INCLUDE ../T24_BP I_F.AC.LOCKED.EVENTS
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING FT.Contract
    $USING TT.Contract
    $USING DC.Contract
    $USING AC.AccountOpening
    $USING AC.Config
    $USING EB.ErrorProcessing

    GOSUB INICIO
    GOSUB OPENF
    GOSUB PROCESA

RETURN
*******
INICIO:
*******

    YAPL = FIELD(APPLICATION,",",1)

RETURN
******
OPENF:
******

*    FN.ACCOUNT = 'F.ACCOUNT'
*    F.ACCOUNT  = ''
**    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
*
*    FN.TELLER  = 'F.TELLER'
*    F.TELLER  = ''
**    CALL OPF(FN.TELLER,F.TELLER)
*    EB.DataAccess.Opf(FN.TELLER,F.TELLER)
*
*    FN.FT      = 'F.FUNDS.TRANSFER'
*    F.FT       = ''
**    CALL OPF(FN.FT,F.FT)
*    EB.DataAccess.Opf(FN.FT,F.FT)
*
*    FN.PR      = 'F.POSTING.RESTRICT'
*    F.PR       = ''
**    CALL OPF(FN.PR,F.FR)
*    EB.DataAccess.Opf(FN.PR,F.FR)
*
*    FN.DC      = 'F.DATA.CAPTURE'
*    F.DC       = ''
**    CALL OPF(FN.DC,F.DC)
*    EB.DataAccess.Opf(FN.DC,F.DC)
*
*    FN.ALE     = 'F.AC.LOCKED.EVENTS'
*    F.ALE      = ''
**    CALL OPF(FN.ALE,F.ALE)
*    EB.DataAccess.Opf(FN.ALE,F.ALE)
*
*    FN.VPM.PARAMETROS.BANXICO = "F.VPM.PARAMETROS.BANXICO"
*    F.VPM.PARAMETROS.BANXICO  = ""
**    CALL OPF(FN.VPM.PARAMETROS.BANXICO,F.VPM.PARAMETROS.BANXICO)
*    EB.DataAccess.Opf(FN.VPM.PARAMETROS.BANXICO,F.VPM.PARAMETROS.BANXICO)

*ITSS-NYADAV
*    CALL DBR("VPM.PARAMETROS.BANXICO":FM:VPM.ACCT.REST,"SYSTEM",YPOST.RESTRICT)
*    CALL CACHE.READ(FN.VPM.PARAMETROS.BANXICO,"SYSTEM",R.REC.APLI,ERR.APLI)
    R.REC.APLI = ABC.BP.VpmParametrosBanxico.Read("SYSTEM", ERR.APLI)
    YPOST.RESTRICT= R.REC.APLI<ABC.BP.VpmParametrosBanxico.VpmParametrosBanxicoAcctRest> ;*<VPM.ACCT.REST>
*ITSS-NYADAV

RETURN
********
PROCESA:
********

    EB.SystemTables.getComi()
    YCOMI = EB.SystemTables.getComi() * 1;* COMI * 1
    IF YCOMI AND NUM(YCOMI) THEN
        YCTA = EB.SystemTables.getComi()
    END ELSE
*        IF V$FUNCTION EQ "R" THEN
        IF EB.SystemTables.getTFunction() EQ "R" THEN
            RecId = EB.SystemTables.getIdNew()
            BEGIN CASE
                CASE YAPL EQ "FUNDS.TRANSFER"
                    YERR.FT = ""
                    R.FT = FT.Contract.FundsTransfer.Read(RecId, YERR.FT)
                    IF NOT(YERR.FT) THEN
*                       YCTA = R.FT<FT.DEBIT.ACCT.NO>
                        YCTA = R.FT<FT.Contract.FundsTransfer.DebitAcctNo>      ;*FT.Contract.getIdDebitAcct() ;*R.FT<FT.Contract.FundsTransfer.DebitAcctNo>
*                        AF = FT.DEBIT.ACCT.NO
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
                        GOSUB VAL.PR
*                        YCTA = R.FT<FT.CREDIT.ACCT.NO>
                        YCTA = R.FT<FT.Contract.FundsTransfer.CreditAcctNo>
*                        AF = FT.CREDIT.ACCT.NO
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
                    END
                CASE YAPL EQ "TELLER"
                    YERR.TT = ''
                    R.TT = TT.Contract.Teller.Read(RecId, YERR.TT) ;*EB.DataAccess.FRead(FN.TELLER,ID.NEW,R.TT,F.TELLER,YERR.TT)
                    IF NOT(YERR.TT) THEN
                        YCTA = R.TT<TT.Contract.Teller.TeAccountOne>  ;*<TT.TE.ACCOUNT.1>
*                        AF = TT.TE.ACCOUNT.1
                        EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne)
                        GOSUB VAL.PR
*                        YCTA = R.TT<TT.TE.ACCOUNT.2>
                        EB.SystemTables.setAf(TT.Contract.Teller.TeAccountTwo)
*                        AF = TT.TE.ACCOUNT.2
                    END
                CASE YAPL EQ "DATA.CAPTURE"
                    R.DC = DC.Contract.DataCapture.Read(RecId, YERR.DC)     ;*EB.DataAccess.FRead(FN.DC,ID.NEW,R.DC,F.DC,YERR.DC)
                    IF NOT(YERR.DC) THEN
                        YCTA = R.DC<DC.Contract.DataCapture.DcAccountNumber>     ;*<DC.DC.ACCOUNT.NUMBER>
*                        AF   = DC.DC.ACCOUNT.NUMBER
                        EB.SystemTables.setAf(DC.Contract.DataCapture.DcAccountNumber)
                        YCRDB = R.DC<DC.Contract.DataCapture.DcSign> ;*<DC.DC.SIGN>
                    END
                CASE YAPL EQ "AC.LOCKED.EVENTS"
                    EB.DataAccess.FRead(FN.ALE,ID.NEW,R.ALE,F.ALE,YERR.ALE)
                    IF NOT(YERR.ALE) THEN
                        YCTA = R.ALE<AC.AccountOpening.LockedEvents.LckAccountNumber> ;*<AC.LCK.ACCOUNT.NUMBER>
*                        AF   = AC.LCK.ACCOUNT.NUMBER
                        EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
                        YCRDB = 'CREDIT'
                    END
            END CASE
        END ELSE
            BEGIN CASE
                CASE YAPL EQ "FUNDS.TRANSFER"
                    YCTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo);* R.NEW(FT.DEBIT.ACCT.NO)
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)        ;*AF = FT.DEBIT.ACCT.NO
                    GOSUB VAL.PR
                    YCTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo) ;*R.NEW(FT.CREDIT.ACCT.NO)
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo) ;*AF = FT.CREDIT.ACCT.NO
                
                CASE YAPL EQ "TELLER"
                    YCTA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne);*R.NEW(TT.TE.ACCOUNT.1)
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne);*AF = TT.TE.ACCOUNT.1
                    GOSUB VAL.PR
                    YCTA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo) ;*R.NEW(TT.TE.ACCOUNT.2)
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountTwo) ;*AF = TT.TE.ACCOUNT.2
                
                CASE YAPL EQ "DATA.CAPTURE"
                    YCTA = EB.SystemTables.getRNew(DC.Contract.DataCapture.DcAccountNumber) ;*R.NEW(DC.DC.ACCOUNT.NUMBER)
                    EB.SystemTables.setAf(DC.Contract.DataCapture.DcAccountNumber) ;*AF   = DC.DC.ACCOUNT.NUMBER
                    YCRDB = EB.SystemTables.getRNew(DC.Contract.DataCapture.DcSign) ;*YCRDB = R.NEW(DC.DC.SIGN)
                
                CASE YCTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber) ;*R.NEW(AC.LCK.ACCOUNT.NUMBER)
                    EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber) ;*AF    = AC.LCK.ACCOUNT.NUMBER
                    YCRDB = 'DEBIT'
            END CASE
        END
    END
    GOSUB VAL.PR

RETURN
*******
VAL.PR:
*******

*    ETEXT = ''
    EB.SystemTables.setEtext("")
    R.CTA = AC.AccountOpening.Account.Read(YCTA, YERR.AC)    ;* EB.DataAccess.FRead(FN.ACCOUNT,YCTA,R.CTA,F.ACCOUNT,YERR.AC)
    IF NOT(YERR.AC) THEN
        YPOST.REST = R.CTA<AC.AccountOpening.Account.PostingRestrict>      ;*<AC.POSTING.RESTRICT>
        IF YPOST.REST THEN
            LOCATE YPOST.REST IN YPOST.RESTRICT<1,1> SETTING YPOSICION THEN
                R.PR = AC.Config.PostingRestrict.Read(YPOST.REST, YERR.PR)
                IF NOT(YERR.PR) THEN
                    YPR.DESC = R.PR<AC.Config.PostingRestrict.PosDescription>     ;*<AC.POS.DESCRIPTION>
                    YREST.TYP = R.PR<AC.Config.PostingRestrict.PosRestrictionType>        ;*<AC.POS.RESTRICTION.TYPE>
*                    IF V$FUNCTION EQ "R" THEN
                    IF EB.SystemTables.getTFunction() EQ "R" THEN
                        EB.SystemTables.setEtext(YPR.DESC:" ":YCTA:", sin operaciones ")        ;*ETEXT = YPR.DESC:" ":YCTA:", sin operaciones "
                    END ELSE
                        EB.SystemTables.setEtext(YPR.DESC:", sin operaciones ")     ;*ETEXT = YPR.DESC:", sin operaciones "
                    END
                END
                BEGIN CASE
                    CASE YREST.TYP EQ "ALL"
                        EB.SystemTables.setEtext(EB.SystemTables.getEtext() : " ni de crto ni de dto")      ;*ETEXT := "ni de crto ni de dto"
                    CASE YREST.TYP EQ "DEBIT"
*                        IF AF EQ FT.DEBIT.ACCT.NO OR AF EQ TT.TE.ACCOUNT.2 OR YCRDB EQ 'D' THEN
                        IF EB.SystemTables.getAf() EQ FT.Contract.FundsTransfer.DebitAcctNo OR EB.SystemTables.getAf() EQ TT.Contract.Teller.TeAccountTwo OR YCRDB EQ 'D' THEN
                            EB.SystemTables.setEtext(EB.SystemTables.getEtext() : " de dto")        ;*ETEXT := "de dto"
                        END ELSE
                            EB.SystemTables.setEtext("")        ;* ETEXT = ''
                        END
                    CASE YREST.TYP EQ "CREDIT"
*                        IF AF EQ FT.CREDIT.ACCT.NO OR AF EQ TT.TE.ACCOUNT.1 OR YCRDB EQ 'C' THEN
                        IF EB.SystemTables.getAf() EQ FT.Contract.FundsTransfer.CreditAcctNo OR EB.SystemTables.getAf() EQ TT.Contract.Teller.TeAccountOne OR YCRDB EQ 'C' THEN
                            EB.SystemTables.setEtext(EB.SystemTables.getEtext() : " de crto")       ;*ETEXT := "de crto"
                        END ELSE
                            EB.SystemTables.setEtext("")        ;* ETEXT = ''
                        END
                END CASE
            END
*            IF ETEXT THEN
            IF EB.SystemTables.getEtext() THEN
                EB.SystemTables.setE(EB.SystemTables.getEtext())        ;*E = ETEXT
                EB.ErrorProcessing.StoreEndError()      ;*CALL STORE.END.ERROR
                RETURN
                EB.SystemTables.setEtext("")        ;* ETEXT=''
            END
        END
    END

RETURN
**********
END
