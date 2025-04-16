* @ValidationCode : MjotNTc0NzQ4NzU3OkNwMTI1MjoxNzQ0MjE3NjgyODg1OlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2025 11:54:42
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
SUBROUTINE ABC.APLICA.BONIF.CASHIN.LOAD
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
    $USING EB.API
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING ABC.BP

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------

    FN.ABC.BONIF.CASHIN = "F.ABC.BONIFICACION.CASH.IN"
    F.ABC.BONIF.CASHIN = ""
    EB.DataAccess.Opf(FN.ABC.BONIF.CASHIN, F.ABC.BONIF.CASHIN)

    Y.ID.COM.PARAM = 'CASHIN.BONIFICACION.PARAM'
*CALL ABC.GET.GENERAL.PARAM(Y.ID.COM.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)
    ABC.BP.abcGetGeneralParam(Y.ID.COM.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)

    LOCATE "OFS.SOURCE" IN Y.NOMB.PARAM SETTING POS THEN
        Y.OFS.SOURCE = Y.DATA.PARAM<POS>
    END

    LOCATE "USUARIO.OFS" IN Y.NOMB.PARAM SETTING POS THEN
        Y.USR = Y.DATA.PARAM<POS>
    END

    LOCATE "PASSWORD.OFS" IN Y.NOMB.PARAM SETTING POS THEN
        Y.PWD = Y.DATA.PARAM<POS>
    END

    Y.FECHA.APLICACION = "" ; Y.PRIMER.DIA.FECHA.ACTUAL = ""
    Y.MES.APLICACION = ""

RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.FECHA.APLICACION = OCONV(DATE(), "DY4"):"-":FMT(OCONV(DATE(), "DM"),"2'0'R"):"-":FMT(OCONV(DATE(), "DD"),"2'0'R")
    Y.PRIMER.DIA.MES.ACTUAL = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):"01"
*CALL CDT('', Y.PRIMER.DIA.MES.ACTUAL, '-1C')
    EB.API.Cdt('',Y.PRIMER.DIA.MES.ACTUAL,"-1C")
    
    Y.MES.APLICACION = Y.PRIMER.DIA.MES.ACTUAL[1,6]

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN
