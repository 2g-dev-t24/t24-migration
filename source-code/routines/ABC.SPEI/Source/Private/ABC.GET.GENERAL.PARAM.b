*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.GET.GENERAL.PARAM(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
*===============================================================================

*---------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable

*---------------------------------------------------

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
