* @ValidationCode : MjoxOTE5ODA5NzMwOkNwMTI1MjoxNzQ0NTYzNDEyMjIwOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2025 11:56:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
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
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.GET.GENERAL.PARAM(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
*===============================================================================
* Nombre de Programa:   ABC.GET.GENERAL.PARAM
* Objetivo:             Rutina que obtiene los parametros de la tabla ABC.GENERAL.PARAM
* Desarrollador:        Franco Manrique - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       2017-02-16
* Modificaciones:
*===============================================================================


*---------------------------------------------------
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE I_F.ABC.GENERAL.PARAM
    $USING EB.DataAccess
*---------------------------------------------------

    GOSUB INITIALIZE
*    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*---------------------------------------------------
INITIALIZE:
*---------------------------------------------------

RETURN

***********
OPEN.FILES:
***********
*    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
*    F.ABC.GENERAL.PARAM = ''
**    CALL OPF(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------

*    CALL F.READ(FN.ABC.GENERAL.PARAM,Y.ID.PARAM,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
*    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID.PARAM,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
    R.PARAMETROS = ABC.BP.AbcGeneralParam.Read(Y.ID.PARAM, GRL.ERR)
    IF R.PARAMETROS THEN
        Y.LIST.PARAMS = RAISE(R.PARAMETROS<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro>);*PBS.GEN.PARAM.NOMB.PARAMETRO
        Y.LIST.VALUES = RAISE(R.PARAMETROS<ABC.BP.AbcGeneralParam.PbsGenParamDatoParametro>);*PBS.GEN.PARAM.DATO.PARAMETRO
    END ELSE
        Y.LIST.PARAMS = GRL.ERR
        Y.LIST.VALUES = GRL.ERR
    END
RETURN
END
