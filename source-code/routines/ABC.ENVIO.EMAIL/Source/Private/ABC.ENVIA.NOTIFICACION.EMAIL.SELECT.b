* @ValidationCode : MjoyMDk2MzkyMjQ5OkNwMTI1MjoxNzUzOTIzMjY2ODkzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 30 Jul 2025 21:54:26
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
$PACKAGE AbcEnvioEmail


SUBROUTINE ABC.ENVIA.NOTIFICACION.EMAIL.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.Service
    $USING EB.DataAccess
*-----------------------------------------------------------------------------
    GOSUB INICIALIZA
    GOSUB PROCESO
    GOSUB FINALIZA

RETURN

***********
INICIALIZA:
***********

    SEL.CMD = ''
    Y.LIST = ''
    Y.CNT = ''
    Y.SEL.ERR = ''

RETURN

********
PROCESO:
********
    FN.SMS.EMAIL = AbcEnvioEmail.getFnSmsEmail()
    
    SEL.CMD = "SELECT ":FN.SMS.EMAIL:" WITH STATUS.EMAIL EQ '' AND NOTIFICA.EMAIL EQ 'SI' BY-DSND FECHA.HORA"
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST,'',Y.CNT,Y.SEL.ERR)

    EB.Service.BatchBuildList('',Y.LIST)

RETURN

*********
FINALIZA:
*********

RETURN

END

