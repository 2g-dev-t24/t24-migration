* @ValidationCode : MjoxMjE0OTc2Mzg4OkNwMTI1MjoxNzQ0MTQ4NTM2NzcwOlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2025 16:42:16
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
.
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.APLICA.BONIF.CASHIN.SELECT
*===============================================================================
* Nombre de Programa : ABC.APLICA.BONIF.CASHIN
* Objetivo           : Rtn Multithread de aplicacion de FTs de bonificaciones
*                      por depositos CASH IN a cuentas de clientes
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2022-08-16
* Modificaciones:
*===============================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_TSA.COMMON
*    $INSERT I_F.ABC.BONIFICACION.CASH.IN
    $INSERT I_ABC.APLI.BONIF.CASHIN.COMMON
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.Service
    $USING ABC.BP

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

RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    SEL.CMD.CASHIN  = 'SELECT ':FN.ABC.BONIF.CASHIN:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.MES.APLICACION))
    SEL.CMD.CASHIN := ' AND BONIFICADO NE SI'
*CALL EB.READLIST(SEL.CMD.CASHIN, Y.LISTA.IDS, '', Y.TOTAL.IDS, ERR.SEL)
    EB.DataAccess.Readlist(SEL.CMD.CASHIN, Y.LISTA.IDS, '', Y.TOTAL.IDS, ERR.SEL)
*CALL BATCH.BUILD.LIST('', Y.LISTA.IDS)
    EB.Service.BatchBuildList('', Y.LISTA.IDS)

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN
