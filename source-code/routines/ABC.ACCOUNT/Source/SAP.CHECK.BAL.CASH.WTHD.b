* @ValidationCode : MjoxMzIwMDkyMDI2OkNwMTI1MjoxNzUzNDYxOTkyNzY1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2025 13:46:32
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
$PACKAGE AbcAccount

SUBROUTINE SAP.CHECK.BAL.CASH.WTHD(YIN.CUENTA,YIN.MONTO,YIN.COMISION,YOUT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING AC.Config
    
*******************************************
* Main program loop
*******************************************

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN
******************************
PROCESS:
******************************
    IF YIN.COMISION GT 0 THEN
        SEL.CMD.TAX = 'SELECT ':FN.TAX:' WITH @ID LIKE ':DQUOTE(SQUOTE(Y.ID.TAX):"..."):" BY @ID"   ;*ITSS-NYADAV -  Added DQUOTE / SQUOTE
        EB.DataAccess.Readlist(SEL.CMD.TAX,Y.TAX.LIST,'',Y.TAX.NO,'')

        FOR I = Y.TAX.NO TO 1 STEP -1
            Y.ID.TAX = Y.TAX.LIST<Y.TAX.NO>

            Y.FECHA.IVA = FIELD(Y.ID.TAX,".",2)

            IF TODAY GE Y.FECHA.IVA THEN
                BREAK
            END ELSE
                CONTINUE
            END
        NEXT I

        IF Y.ID.TAX NE '' THEN
            EB.DataAccess.FRead(FN.TAX,Y.ID.TAX,Y.TAX.REC,FV.TAX,Y.TAX.ERR)

            IF Y.TAX.REC NE '' THEN
                Y.IVA.COM = DROUND(Y.TAX.REC<EB.TAX.RATE>/100,2)
            END
        END
    END

    Y.TXN.AMT = YIN.MONTO + YIN.COMISION + Y.IVA.COM

    Y.ACCOUNT = YIN.CUENTA

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.FERROR)

    Y.AVAIL.BAL = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    Y.POST.REST= R.ACCOUNT<AC.AccountOpening.Account.PostingRestrict>

    IF Y.POST.REST NE '' THEN
        R.POST=''
        ERR.POST=''
        EB.DataAccess.FRead(FN.POST,Y.POST.REST,R.POST,F.POST,ERR.POST)
        Y.REST.TYPE=R.POST<AC.Config.PostingRestrict.PosRestrictionType>
        IF Y.REST.TYPE EQ 'ALL' THEN
            YOUT = "01|Cuenta con Restricciones|"
            RETURN
        END

    END
    IF Y.AVAIL.BAL LE 0 THEN
        YOUT = "51|Saldo Insuficiente|"
        RETURN
    END

    AbcSpei.AbcMontoBloqueado(Y.ACCOUNT,YACCT.LOCKED.AMT)
*CALL ABC.MONTO.BLOQUEADO(Y.ACCOUNT,YACCT.LOCKED.AMT)
    Y.AVAIL.BAL = Y.AVAIL.BAL - YACCT.LOCKED.AMT

    IF Y.AVAIL.BAL LT Y.TXN.AMT THEN
        YOUT = "51|Saldo Insuficiente|"
        RETURN
    END

    YOUT = ''

RETURN

******************************
INITIALIZE:
******************************
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.TAX = 'F.TAX'
    F.TAX  = ''
    EB.DataAccess.Opf(FN.TAX, F.TAX)
    FN.POST="F.POSTING.RESTRICT"
    F.POST=""
    EB.DataAccess.Opf(FN.POST,F.POST)

    Y.ID.TAX    = 10
    Y.IVA.COM   = 0
    SEL.CMD.TAX = ''
    Y.TAX.LIST  = ''
    Y.TAX.NO    = ''
    Y.FECHA.IVA = ''
    TODAY = EB.SystemTables.getToday()
RETURN
END

