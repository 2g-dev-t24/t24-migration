* @ValidationCode : MjoyMDkyMzUzNTg1OkNwMTI1MjoxNzQ0ODM4MTI1Mzg0Om1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:15:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.LLENA.DEBIT.ACC.MIG
*===============================================================================
* Nombre de Programa : ABC.LLENA.DEBIT.ACC.MIG
* Objetivo           : Validation rtn para llenar la DEBIT.ACCT.NO en la version
*                      de MIGRACION.SALDOS de FT, a partir de una parametrizacion
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2021-10-27
* Modificaciones:
*===============================================================================
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------

* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_F.FUNDS.TRANSFER  ;* Not Used anymore
* $INSERT I_F.ACCOUNT  ;* Not Used anymore
    
    $USING EB.SystemTables
*    $USING EB.DataAccess
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.Display
    $USING ABC.BP

    GOSUB INICIALIZA
    GOSUB LLENA.DEBIT.ACCT
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

*    FN.CUENTA = 'F.ACCOUNT'
*    F.CUENTA  = ''
*    EB.DataAccess.Opf(FN.CUENTA, F.CUENTA)

*    CALL GET.LOC.REFM("ACCOUNT", "CANAL", POS.CANAL.ACCT)
    
    applications     = ""
    fields           = ""
    applications<1>  = "ACCOUNT"
    fields<1,1>      = "CANAL"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    POS.CANAL.ACCT = field_Positions<1,1>

    Y.ID.GEN.PARAM = "ABC.CTA.MIGRACION.SALDOS"
    Y.LIST.PARAMS = ''  ;  Y.LIST.VALUES = ''
    ABC.BP.abcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.TRANS.TYPE = ''
    Y.TRANS.TYPE = EB.SystemTables.getComi()

RETURN

*---------------------------------------------------------------
LLENA.DEBIT.ACCT:
*---------------------------------------------------------------

    Y.CTA.DEBIT = ''

    FINDSTR "CUENTA" IN Y.LIST.PARAMS SETTING POS.CTA.PARAM THEN
        Y.CTA.DEBIT = Y.LIST.VALUES<POS.CTA.PARAM>
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.CTA.DEBIT)
        EB.Display.RebuildScreen()
    END


RETURN
