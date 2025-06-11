* @ValidationCode : MjotNjE1MTU3MDU4OkNwMTI1MjoxNzQ5NjEzNTE4MDU2Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jun 2025 00:45:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>168</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTaxes
SUBROUTINE ABC.TAX.ISR.AA(PASS.CUSTOMER, PASS.DEAL.AMOUNT, PASS.DEAL.CCY, PASS.CCY.MKT,PASS.CROSS.RATE,PASS.CROSS.CCY, PASS.DWN.CCY, PASS.DATA,PASS.CUST.CDN,R.TAX,CHARGE.AMOUNT)
*-----------------------------------------------------------------------------
*===============================================================================
* Modificaciones:
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:          2016-10-14
* Descripcion:   El monto de la inversion se obtiene del campo AMOUNT.
*      Se llama a la rutina FYG.AA.SCHEDULE.PROJECTOR para obtener
*      las fechas de pago para el calculo de ISR.
*      Se utiliza la variable global PREVIOUS.PAY.DATE de
*      I_AA.USER.DEFINE.PAY.AMT.COMMON para guardar la fecha de
*      pago anterior como auxiliar para el calculo de ISR.
*
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:          2016-12-28
* Descripcion:   Se utiliza la variable global ULTIMO.PAGO de
*      I_VPM.TAX.ISR.AA.COMMON en lugar de la variable
*                       PREVIOUS.PAY.DATE para guardar la fecha de
*      pago anterior como auxiliar para el calculo de ISR.
*                       Se utiliza diferente metodo para la APPLICATION ENQUIRY.SELECT
*
* Desarrollador:        Franco Manrique - FyG Solutions   (FGMT)
* Compania:             ABC Capital
* Fecha:          2017-05-12
* Descripcion:   Se modifica logica de calculo de MATURITY.DATE de pagares para solucionar problema
*     de cierre al vencimiento
*===============================================================================
*=============================================================================
*       Req:         Parametrizacion del numero de dias para base de calculo
*       Banco:       ABCCAPITAL
*       Autor:       Cesar Miranda (CAMB) FYG
*       Fecha:       21 Junio 2019
*       Descripcion: Se modifica la Rutina para que el numero de dias se obtengan
*                    del registro ABC.BASE.CALCULO.DIAS de la aplicacion
*                    ABC.GENERAL.PARAM
*=============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_AA.APP.COMMON
*    $INSERT ../T24_BP I_F.ACCOUNT
*    $INSERT ../T24_BP I_F.TAX
*    $INSERT ../T24_BP I_AA.USER.DEFINE.PAY.AMT.COMMON
*    $INSERT ../T24_BP I_AA.TAX.COMMON
*    $INSERT ../T24_BP I_AA.CONTRACT.DETAILS
*    $INSERT ../T24_BP I_ENQUIRY.COMMON
*    $INSERT ../T24_BP I_F.AA.SETTLEMENT
*    $INSERT ../T24_BP I_F.AA.TERM.AMOUNT
*    $INSERT ../T24_BP I_F.AA.ARRANGEMENT
*    $INSERT ../T24_BP I_F.AA.ACCOUNT.DETAILS
*    $INSERT ABC.BP I_VPM.TAX.ISR.AA.COMMON

    $USING AbcGetGeneralParam
    $USING AA.Framework
    $USING AA.Settlement
    $USING AA.TermAmount
    $USING AA.Tax
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.SystemTables
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING CG.ChargeConfig
    
    APPLICATION   = EB.SystemTables.getApplication()
    GOSUB GET.ACCT.DETAILS

    IF TAX.CAL EQ '' OR TAX.CAL EQ 'N' THEN

        Y.ID.GEN.PARAM = 'ABC.BASE.CALCULO.DIAS'
        Y.NOMB.PARAM = 'NUM.DIAS'
        Y.DATA.PARAM = ''
        AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)
        Y.DIGITS.CALC = Y.DATA.PARAM


* fOR PROMISSORY PRODUCT we can use CHK.PRO.NO.OF.DAYS gosub itself
*        IF PRODUCT.ID EQ 'DEPOSIT.PROMISSORY' AND ARR.TOT.REC<AA.ARR.ORIG.CONTRACT.DATE> NE '' THEN
        IF PRODUCT.ID EQ 'DEPOSIT.PROMISSORY' THEN
            GOSUB CHK.PRO.NO.OF.DAYS
        END ELSE
            GOSUB CHK.NO.OF.DAYS

        END
        GOSUB GET.COMMIT.DETAILS

        CHARGE.AMOUNT = Y.BASE * PRINC.AMT * TERM / Y.DIGITS.CALC

        IF CHARGE.AMOUNT >= PASS.DEAL.AMOUNT THEN
            CHARGE.AMOUNT = 0
        END

    END ELSE
        CHARGE.AMOUNT = 0
    END


    DISPLAY 'ISR = ':CHARGE.AMOUNT:', AA = ':ARR.ID

RETURN

*******************
CHK.PRO.NO.OF.DAYS:
*******************

    FROM.DATE = ''; MAT.DATE = ''
    IF ARR.TOT.REC<AA.Framework.Arrangement.ArrOrigContractDate> EQ '' THEN
        FROM.DATE = ARR.TOT.REC<AA.Framework.Arrangement.ArrStartDate>
    END ELSE
        FROM.DATE = ARR.TOT.REC<AA.Framework.Arrangement.ArrOrigContractDate>

    END
    
    AA.Framework.GetArrangementConditions(ARR.ID, 'TERM.AMOUNT', '',ST.DT ,returnIds, returnConditions, returnError)
    returnConditions = RAISE(returnConditions)
    MAT.DATE = returnConditions<AA.TermAmount.TermAmount.AmtMaturityDate>
*TERMINA FGMT

    TERM = 'C'
    EB.API.Cdd('',FROM.DATE,MAT.DATE,TERM)

RETURN

***************
CHK.NO.OF.DAYS:
***************

    FROM.DATE = ''; MAT.DATE = ''; NO.OF.DAYS1 = '';

*------------------------------INICIA (CAMB)-------------------------------------------------
    IF APPLICATION NE "ENQUIRY.SELECT" THEN
        LOCATE TODAY IN TOT.PAY.DATES BY 'AN' SETTING NEXT.POS THEN
            IF ARR.TOT.REC<AA.Framework.Arrangement.ArrStartDate> EQ TODAY AND ARR.TOT.REC<AA.Framework.Arrangement.ArrOrigContractDate> EQ '' THEN
                FROM.DATE = TODAY
                MAT.DATE = TOT.PAY.DATES<NEXT.POS+1>
            END ELSE
                FROM.DATE = TOT.PAY.DATES<NEXT.POS-1>
                MAT.DATE  = TODAY
            END
        END ELSE
            FROM.DATE =TOT.PAY.DATES<NEXT.POS-1>
            MAT.DATE=TOT.PAY.DATES<NEXT.POS>
        END

    END ELSE
        IF ULTIMO.PAGO EQ 0 THEN        ;*OR RUNNING.UNDER.BATCH THEN ;*20201125 SE QUITA PARA CORREGIR EL CALCULO CUANDO SE EJECUTA VECTOR
            COUNT.TOT.PAY.DATES = DCOUNT(TOT.PAY.DATES,FM)
            FOR X = 1 TO COUNT.TOT.PAY.DATES
                IF TOT.PAY.DATES<X> GT TODAY THEN
                    IF ARR.TOT.REC<AA.Framework.Arrangement.ArrStartDate> EQ TODAY AND  TOT.PAY.DATES<1> EQ TODAY THEN
                        ULTIMO.PAGO = TODAY
                    END ELSE
                        ULTIMO.PAGO = TOT.PAY.DATES<X-1>
                    END
                    X = COUNT.TOT.PAY.DATES
                END
            NEXT X
        END

        LOCATE ULTIMO.PAGO IN TOT.PAY.DATES BY 'AN' SETTING NEXT.POS THEN
            FROM.DATE = TOT.PAY.DATES<NEXT.POS>
            MAT.DATE =TOT.PAY.DATES<NEXT.POS+1>
        END
    END
*------------------------------TERMINA (CAMB)-------------------------------------------------

    TERM = 'C'

    IF PRODUCT.ID NE 'DEPOSIT.PROMISSORY' AND ARR.TOT.REC<AA.Framework.Arrangement.ArrOrigContractDate> NE '' THEN
        MIG.FROM.DATE = ARR.TOT.REC<AA.Framework.Arrangement.ArrStartDate>
        IF FROM.DATE EQ MIG.FROM.DATE THEN
            FN.PRE.SCH.DATE='F.ABC.LEG.PRE.SCH'
            F.PRE.SCH.DATE=''
            EB.DataAccess.Opf(FN.PRE.SCH.DATE,F.PRE.SCH.DATE)
            EB.DataAccess.FRead(FN.PRE.SCH.DATE,ARR.ID,NEW.FROM.DATE,F.PRE.SCH.DATE,PRE.ERR)

            IF (MAT.DATE NE 0) AND (MAT.DATE NE '') THEN
                EB.API.Cdd('',NEW.FROM.DATE,MAT.DATE,TERM)
            END
        END ELSE

            IF (FROM.DATE NE 0 AND FROM.DATE NE '') AND (MAT.DATE NE 0 AND MAT.DATE NE '') THEN
                EB.API.Cdd('',FROM.DATE,MAT.DATE,TERM)
            END
        END
    END ELSE

        IF (FROM.DATE NE 0 AND FROM.DATE NE '') AND (MAT.DATE NE 0 AND MAT.DATE NE '') THEN
            EB.API.Cdd('',FROM.DATE,MAT.DATE,TERM)
        END
    END

*------------------------------INICIA (CAMB)-------------------------------------------------
    PRINT 'DE: ':FROM.DATE:', A: ':MAT.DATE:', TERM: ':TERM
    IF APPLICATION EQ "ENQUIRY.SELECT" THEN
        ULTIMO.PAGO = MAT.DATE
    END
*------------------------------TERMINA (CAMB)-------------------------------------------------

RETURN

*******************
GET.COMMIT.DETAILS:
*******************
    AA.Framework.GetArrangementConditions(ARR.ID, 'TERM.AMOUNT', '',ST.DT ,returnIds, returnConditions, returnError)
    returnConditions = RAISE(returnConditions)
    PRINC.AMT = returnConditions<AA.TermAmount.TermAmount.AmtAmount>
    MAT.DATE = returnConditions<AA.TermAmount.TermAmount.AmtMaturityDate>

    IF ULTIMO.PAGO EQ MAT.DATE OR APPLICATION NE "ENQUIRY.SELECT" THEN
        ULTIMO.PAGO = 0
    END

    ACC.NO = ARR.ACC
    AC.BALANCE.TYPE= "CURACCOUNT"
    ST.DT = FROM.DATE
    END.DT = MAT.DATE
    AA.Framework.GetPeriodBalances(ACC.NO,AC.BALANCE.TYPE,REQUEST.TYPE,END.DT,END.DT,'',AC.BAL.DETAILS,RET.ERR)
    C.ACCOUNT = AC.BAL.DETAILS<4>

*------------------------------INICIA (CAMB)-------------------------------------------------
    IF APPLICATION NE "ENQUIRY.SELECT" THEN
        PRINC.AMT = C.ACCOUNT
    END
*------------------------------TERMINA (CAMB)-------------------------------------------------
RETURN

*****************
GET.ACCT.DETAILS:
*****************
    ARR.ID = AA$ARR.ID
    EFF.DATE = TODAY
    ARR.TOT.REC = ''; PRODUCT.ID= '';PROPERTY.LIST = '';ARR.REC = '';
    AA.Framework.GetArrangementProduct(ARR.ID,EFF.DATE,ARR.TOT.REC,PRODUCT.ID,PROPERTY.LIST)
    FN.ACC='F.ACCOUNT'
    F.ACC=''
    EB.DataAccess.Opf(FN.ACC,F.ACC)
*------------------------------INICIA (CAMB)-------------------------------------------------
* IF RUNNING.UNDER.BATCH THEN
    IF APPLICATION NE "ENQUIRY.SELECT" THEN
        TOT.PAY.DATES = FULL.PAYMENT.DATES
    END ELSE
        DUE.DATES = ''; CYCLE.DATE = ''; TOT.PAYMENT = '';
*TODO FALTA CONVERTIR ESTA RUTINA
*CALL FYG.AA.SCHEDULE.PROJECTOR(ARR.ID,SIM.REF,"1",CYCLE.DATE,TOT.PAYMENT,DUE.DATES)

        TOT.PAY.DATES = DUE.DATES
        DUE.DATES = ''; CYCLE.DATE = ''; TOT.PAYMENT = '';
    END

    CORR.DETAILS  = AA$CONTRACT.DETAILS<4>
*------------------------------TERMINA (CAMB)-------------------------------------------------
    ARR.ACC = AA.Framework.getLinkedAccount()
    
    
    CALL AA.GET.PROPERTY.RECORD('', ARR.ID, '', TODAY, 'SETTLEMENT', '', SET.RECORD, R.ERR)

    ACC.NO = SET.RECORD<AA.Settlement.Settlement.SetPayoutAccount>


    APP.NAME = "ACCOUNT"
    FIELD.NAME = "EXENTO.IMPUESTO": VM :"GPO.CLUB.AHORRO"
    FIELD.POS = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    TAX.PROCESS = FIELD.POS<1,1>
    GROUP.ID    = FIELD.POS<1,2>


    EB.DataAccess.FRead(FN.ACC,ACC.NO,ACC.REC,F.ACC,ACC.ERR)
    EB.DataAccess.FRead(FN.ACC,ARR.ACC,ARR.REC,F.ACC,ARR.ERR)
    
    ACC.CAT = ARR.REC<AC.AccountOpening.Account.Category>
    TAX.CAL = ACC.REC<AC.AccountOpening.Account.LocalRef,TAX.PROCESS>
    GRP.ID  = ACC.REC<AC.AccountOpening.Account.LocalRef,GROUP.ID>

    GOSUB GET.TAX

RETURN

*--------------------*
GET.TAX:
*--------------------*
    Y.TAX.CALC.TYPE =''
    Y.POS.TAX=''
    Y.BASE = 0
    LOCATE 'MXN' IN R.TAX<CG.ChargeConfig.Tax.EbTaxCurrency,1> SETTING Y.POS.TAX ELSE Y.POS.TAX =''
    IF Y.POS.TAX EQ '' THEN
        Y.BASE = 0
    END ELSE
        Y.TAX.CALC.TYPE = R.TAX<CG.ChargeConfig.Tax.EbTaxCalcType>
        Y.NO.CALC.TYPE= DCOUNT(Y.TAX.CALC.TYPE,SM)

        Y.BASE = (R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate,Y.POS.TAX,Y.NO.CALC.TYPE>)/100
    END

RETURN

END
