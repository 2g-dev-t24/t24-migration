$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.GET.RAZON.SOCIAL(Y.RAZON.SOCIAL)
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Security
    $USING ABC.BP
    $USING EB.LocalReferences
    $USING AbcGetGeneralParam


    GOSUB INICIALIZA
    GOSUB OBTENER.RAZON.SOCIAL

RETURN

***********
INICIALIZA:
***********

    Y.ID.GEN.PARAM = 'RAZON.SOCIAL.PARAM'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

RETURN

***************
OBTENER.RAZON.SOCIAL:
***************

    Y.STR.RAZON.SOCIAL = ''
    LOCATE 'RAZON.SOCIAL.FULL' IN Y.LIST.PARAMS SETTING YPOSICION THEN
        Y.RZN.SCL.FLL = Y.LIST.VALUES<YPOSICION>
    END

    LOCATE 'RAZON.SOCIAL.SHORT' IN Y.LIST.PARAMS SETTING YPOSICION THEN
        Y.RZN.SCL.SHRT = Y.LIST.VALUES<YPOSICION>
    END

    IF (Y.RAZON.SOCIAL NE 'FULL') AND (Y.RAZON.SOCIAL NE 'SHORT') THEN
        Y.RAZON.SOCIAL = "UALA ABC"
        RETURN
    END

    IF Y.RAZON.SOCIAL EQ 'FULL' THEN
        Y.RAZON.SOCIAL = Y.RZN.SCL.FLL
    END ELSE
        Y.RAZON.SOCIAL = Y.RZN.SCL.SHRT
    END


RETURN

END
