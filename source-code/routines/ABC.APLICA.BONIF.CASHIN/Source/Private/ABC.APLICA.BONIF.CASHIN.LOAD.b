* @ValidationCode : MjoxOTAzMjI4Mzc0OkNwMTI1MjoxNzQzNzM3NTA2OTMwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:31:46
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
SUBROUTINE ABC.APLICA.BONIF.CASHIN.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.API
    $USING AbcTable
    $USING AbcGetGeneralParam


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
    AbcAplicaBonifCashin.setFnAbcBonifCashin(FN.ABC.BONIF.CASHIN)
    AbcAplicaBonifCashin.setFAbcBonifCashin(F.ABC.BONIF.CASHIN)
    

    Y.ID.COM.PARAM = 'CASHIN.BONIFICACION.PARAM'

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.COM.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)

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
    EB.API.Cdt('', Y.PRIMER.DIA.MES.ACTUAL, '-1C')
    Y.MES.APLICACION = Y.PRIMER.DIA.MES.ACTUAL[1,6]

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN

