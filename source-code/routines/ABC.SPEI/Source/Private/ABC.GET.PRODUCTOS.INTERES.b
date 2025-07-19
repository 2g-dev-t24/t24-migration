*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.GET.PRODUCTOS.INTERES(ENQ.PARAM)

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports
    $USING AbcGetGeneralParam

    Y.GO.A.HEAD = ""

    FIND 'VALUE' IN ENQ.PARAM SETTING Y.FM, Y.VM THEN
        Y.VALUE = ENQ.PARAM<4,Y.VM,1>
    END


    Y.ID.GEN.PARAM = 'ABC.PRODUCTOS.PAGAN.INTERES'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        IF Y.PARAM EQ 'CATEGORY' THEN
            Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
            IF Y.CATEGORIA EQ Y.VALUE THEN
                Y.GO.A.HEAD = 1
            END
        END
    NEXT Y.AA

    IF Y.GO.A.HEAD EQ "" THEN
        EB.Reports.setEnqError("PRODUCTO NO VALIDO")
    END

    RETURN
END
