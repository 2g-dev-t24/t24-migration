* @ValidationCode : MjoxNzk5NTE5OTgzOkNwMTI1MjoxNzUxNTA4NTkyODA3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jul 2025 23:09:52
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

SUBROUTINE ABC.LLENA.DEBIT.CASHIN.BBVA
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING FT.Contract
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ID.GEN.PARAM = "ABC.CTA.CASHIN.BBVA"
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.CTA.DEBIT = ''
    Y.ERROR = ''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    LOCATE "DEBIT.ACCT" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CTA.DEBIT = Y.LIST.VALUES<POS>
    END ELSE
        Y.ERROR = "NO SE ENCONTRO CUENTA PARAMETRIZADA"
    END

    IF Y.ERROR NE '' THEN
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.CTA.DEBIT)
        EB.Display.RebuildScreen()
    END
    
RETURN
*-----------------------------------------------------------------------------
END
