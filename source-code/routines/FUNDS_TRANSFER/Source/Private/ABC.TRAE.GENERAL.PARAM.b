* @ValidationCode : MjoxMTY3NTMzODE0OkNwMTI1MjoxNzQ0ODI5NDIwMDE5OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 13:50:20
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
SUBROUTINE ABC.TRAE.GENERAL.PARAM(Y.ID.MOD, Y.CADENA.PARAM, Y.CADENA.DATOS)
*       by LEO BASABE *~*
*       2O11sEpT
*---------------------------------------------------
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ./ABC.BP I_F.ABC.GENERAL.PARAM
*---------------------------------------------------
    GOSUB INITIALIZE
*    GOSUB OPEN.FILES
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

***********
OPEN.FILES:
***********
*    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
*    F.ABC.GENERAL.PARAM = ''
*    CALL OPF(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------
    Y.NUM.BUSCADOS = DCOUNT(Y.CAMPOS, Y.SEPARADOR)
    Y.DATOS.ENCONTRADOS = ""
*    CALL F.READ(FN.ABC.GENERAL.PARAM,Y.MODULO,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
    R.PARAMETROS = ABC.BP.AbcGeneralParam.Read(Y.MODULO, GRL.ERR)
    Y.NUM.PARAMS = DCOUNT(R.PARAMETROS<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro>,VM)
    FOR Y.J = 1 TO Y.NUM.BUSCADOS
        Y.PARAM.BUSCADO = FIELD(Y.CAMPOS,Y.SEPARADOR,Y.J)
        Y.ENCONTRADO = 0
        FOR Y.I = 1 TO Y.NUM.PARAMS
            Y.NOM.PARAMETRO = R.PARAMETROS<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro,Y.I>
            Y.DAT.PARAMETRO = R.PARAMETROS<ABC.BP.AbcGeneralParam.PbsGenParamDatoParametro,Y.I>
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
