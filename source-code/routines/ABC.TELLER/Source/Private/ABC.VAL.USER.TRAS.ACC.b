*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.VAL.USER.TRAS.ACC
*===============================================================================
* Nombre de Programa : ABC.VAL.USER.TRAS.ACC
* Objetivo           : Rutina de que valida si el USER tiene privilegios para
* hacer la autorizacion de la transaccion
* Desarrollador      :
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
    
    GOSUB INICIALIZA
    IF Y.REC.STAT EQ 'INAU' THEN
        GOSUB VALIDA
    END
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    Y.OPERADOR = ''
    Y.OPER.AUT = ''
    Y.BAND.AUT = ''
    Y.REC.STAT = ''

    Y.OPERADOR = EB.SystemTables.getOperator()
    Y.REC.STAT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)


    RETURN
*---------------------------------------------------------------
VALIDA:
*---------------------------------------------------------------
*DEBUG
    Y.ID.GEN.PARAM = 'ABC.USER.TRANSAC'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.TOT.USR = DCOUNT(Y.LIST.VALUES, FM)

    FOR Y.IT = 1 TO Y.TOT.USR
        Y.OPER.AUT = ''
        IF Y.LIST.PARAMS<Y.IT> EQ 'SUPER.USER' THEN
            Y.OPER.AUT = Y.LIST.VALUES<Y.IT>
            IF Y.OPERADOR EQ Y.OPER.AUT THEN
                Y.BAND.AUT = 1
            END
        END
    NEXT Y.IT

    IF Y.BAND.AUT EQ '' THEN
        
        E = "USUARIO NO PUEDE AUTORIZAR TRANSACCION"
        EB.SystemTables.setEtext(E)
        EB.ErrorProcessing.StoreEndError()
        
    END
    RETURN
