* @ValidationCode : MjotMjk4NzMzNjcxOkNwMTI1MjoxNzQ0MDY5MjAxMTA5OlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2025 18:40:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

*-----------------------------------------------------------------------------
* <Rating>30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.MONTO.BLOQUEADO(Y.NO.ACC,Y.SALDO.BLOQ)
*----------------------------------------------------
* SFE
* FECHA DE CREACION: 2016/12/19
* DESCRIPCION: RUTINA QUE REGRESA EL SALDO BLOQUEADO AL DÃ�A
*----------------------------------------------------
*
*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_ENQUIRY.COMMON
*    $INSERT ../T24_BP I_F.ACCOUNT
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING ABC.BP
    
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

PROCESS:

    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.NO.ACC, Y.ERROR)
* Before incorporation : CALL F.READ(FN.ACCOUNT,Y.NO.ACC,R.ACCOUNT,F.ACCOUNT,Y.ERROR)
    IF R.ACCOUNT THEN
*Y.FROM.DATE      = RAISE(R.ACCOUNT<AC.FROM.DATE>)
        Y.FROM.DATE      = RAISE(R.ACCOUNT<AC.AccountOpening.Account.FromDate>)
*Y.AMOUNT.LOCKED  = RAISE(R.ACCOUNT<AC.LOCKED.AMOUNT>)
        Y.AMOUNT.LOCKED  = RAISE(R.ACCOUNT<AC.AccountOpening.Account.LockedAmount>)
        Y.NUM.DATE       = DCOUNT(Y.FROM.DATE,@FM)
        YACCT.LOCKED.AMT = 0
        YFOUND           = 0
        YFOUND.INT       = 0

        FOR Y.IND = 1 TO Y.NUM.DATE WHILE YFOUND = 0
            IF Y.FROM.DATE<Y.IND> EQ Y.TODAY THEN
                YFOUND     = 1
                YFOUND.IND = Y.IND
            END ELSE
                IF Y.FROM.DATE<Y.IND> GT Y.TODAY THEN
                    YFOUND     = 1
                    YFOUND.IND = Y.IND -1
                END
            END
        NEXT Y.IND
        IF YFOUND.IND > 0 THEN
            YACCT.LOCKED.AMT = Y.AMOUNT.LOCKED<YFOUND.IND>
        END ELSE
            IF Y.IND EQ Y.NUM.DATE THEN
                YACCT.LOCKED.AMT = Y.AMOUNT.LOCKED<Y.NUM.DATE>
            END
        END
        Y.SALDO.BLOQ = YACCT.LOCKED.AMT
    END

RETURN
INITIALIZE:

    Y.SALDO.BLOQ=0
    R.ACCOUNT=''
    Y.ERROR=''
    Y.TODAY = EB.SystemTables.getToday()

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

RETURN
END
