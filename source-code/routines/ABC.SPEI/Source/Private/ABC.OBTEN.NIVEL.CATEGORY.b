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
    Y.GO.A.HEAD = ""
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
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
        CHANGE '|' TO @FM IN Y.CATEGORIA
        LOCATE Y.ID.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
            Y.NIVEL = Y.PARAM
            Y.GO.A.HEAD = 1

        END

*        Y.NO.CATEGORY = DCOUNT (Y.CATEGORIA,@FM)
*        FOR Y.BB = 1 TO Y.NO.CATEGORY
*            IF Y.ID.CATEGORY EQ Y.CATEGORIA<Y.BB> THEN
*               Y.NIVEL = Y.PARAM
*               Y.GO.A.HEAD = 1
*            END
*        NEXT Y.BB
        
    NEXT Y.AA

    IF Y.GO.A.HEAD EQ "" THEN
        EB.Reports.setEnqError("NIVEL NO ENCONTRADO ":Y.LIST.VALUES)
    END ELSE
       EB.Reports.setOData(Y.NIVEL)
    END


    RETURN


END
