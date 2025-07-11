$PACKAGE AbcSpei

SUBROUTINE ABC.TRAE.GENERAL.PARAM(Y.ID.MOD, Y.CADENA.PARAM, Y.CADENA.DATOS)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    RETURN

*---------------------------------------------------
INITIALIZE:
*---------------------------------------------------
    Y.MODULO = Y.ID.MOD
    Y.CAMPOS = Y.CADENA.PARAM
    Y.SEPARADOR = "#"
    Y.DATOS = ""
    RETURN

*---------------------------------------------------
OPEN.FILES:
*---------------------------------------------------
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
    RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------
    Y.NUM.BUSCADOS = DCOUNT(Y.CAMPOS, Y.SEPARADOR)
    Y.DATOS.ENCONTRADOS = ""
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.MODULO,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
    Y.NUM.PARAMS = DCOUNT(R.PARAMETROS<AbcTable.AbcGeneralParam.NombParametro>,VM)
    FOR Y.J = 1 TO Y.NUM.BUSCADOS
        Y.PARAM.BUSCADO = FIELD(Y.CAMPOS,Y.SEPARADOR,Y.J)
        Y.ENCONTRADO = 0
        FOR Y.I = 1 TO Y.NUM.PARAMS
            Y.NOM.PARAMETRO = R.PARAMETROS<AbcTable.AbcGeneralParam.NombParametro,Y.I>
            Y.DAT.PARAMETRO = R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro,Y.I>
            IF Y.PARAM.BUSCADO EQ Y.NOM.PARAMETRO THEN
                Y.DATOS.ENCONTRADOS := Y.DAT.PARAMETRO : Y.SEPARADOR
                Y.ENCONTRADO = 1
            END
        NEXT Y.I
        IF Y.ENCONTRADO NE 1 THEN
            Y.DATOS.ENCONTRADOS := Y.SEPARADOR
        END
    NEXT Y.J
    Y.CADENA.DATOS = Y.DATOS.ENCONTRADOS
    RETURN
END 