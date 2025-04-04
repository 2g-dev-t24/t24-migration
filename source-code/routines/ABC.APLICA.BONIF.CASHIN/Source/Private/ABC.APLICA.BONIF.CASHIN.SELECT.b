* @ValidationCode : Mjo5MzM4NDE1ODpDcDEyNTI6MTc0MzczMTQ5NzYwMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Apr 2025 22:51:37
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
$PACKAGE AbcAplicaBonifCashin
SUBROUTINE ABC.APLICA.BONIF.CASHIN.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------
    SEL.CMD.CASHIN = ''
    Y.LISTA.IDS = ''
    Y.TOTAL.IDS = ''
    ERR.SEL = ''
    
    FN.ABC.BONIF.CASHIN = AbcAplicaBonifCashin.getFnAbcBonifCashin()
    F.ABC.BONIF.CASHIN = AbcAplicaBonifCashin.getFAbcBonifCashin()

RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    SEL.CMD.CASHIN  = 'SELECT ':FN.ABC.BONIF.CASHIN:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.MES.APLICACION))
    SEL.CMD.CASHIN := ' AND BONIFICADO NE SI'
    EB.DataAccess.Readlist(SEL.CMD.CASHIN, Y.LISTA.IDS, '', Y.TOTAL.IDS, ERR.SEL)
    EB.Service.BatchBuildList('', Y.LISTA.IDS)

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN

