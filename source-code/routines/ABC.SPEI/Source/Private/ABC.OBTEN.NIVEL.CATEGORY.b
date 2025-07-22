*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.OBTEN.NIVEL.CATEGORY
*===============================================================================


    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports
    $USING IC.Config
    $USING AbcGetGeneralParam

    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

    RETURN

***********
INICIA:
***********

    Y.ID.CATEGORY = EB.Reports.getOData()

    EB.Reports.setOData("")
    RETURN


***********
ABRE.ARCHIVOS:
***********

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)



    RETURN

*****************
PROCESO:
*****************

    Y.ID.GEN.PARAM = 'ABC.NIVEL.CUENTAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
        LOCATE Y.ID.CATEGORY IN Y.CATEGORIA SETTING POS THEN
             EB.Reports.setOData(Y.PARAM)
        END
    END
        
    NEXT Y.AA

    IF Y.GO.A.HEAD EQ "" THEN
        EB.Reports.setEnqError("NIVEL NO ENCONTRADO")
    END


    RETURN


END
