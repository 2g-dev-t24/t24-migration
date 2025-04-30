* @ValidationCode : MjozMDA4NjE3Mzc6Q3AxMjUyOjE3NDM3Mzc3OTExMjI6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:36:31
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
$PACKAGE AbcGetGeneralParam
SUBROUTINE ABC.GET.GENERAL.PARAM(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING AbcTable
    $USING EB.DataAccess

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*---------------------------------------------------
INITIALIZE:
*---------------------------------------------------

RETURN

***********
OPEN.FILES:
***********
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID.PARAM,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
    Y.LIST.PARAMS = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro>)

RETURN
END

