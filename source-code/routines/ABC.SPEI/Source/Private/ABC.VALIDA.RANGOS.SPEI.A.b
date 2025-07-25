* @ValidationCode : MjotMzY5NDQzNjcyOkNwMTI1MjoxNzQ4ODc1Mzc4NzQ5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jun 2025 11:42:58
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

$PACKAGE AbcSpei
SUBROUTINE ABC.VALIDA.RANGOS.SPEI.A
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Security
    $USING FT.Contract
    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.ABC.PARAM.MTOS.SPEI = 'F.ABC.PARAM.MTOS.SPEI'
    F.ABC.PARAM.MTOS.SPEI = ''
    EB.DataAccess.Opf(FN.ABC.PARAM.MTOS.SPEI, F.ABC.PARAM.MTOS.SPEI)


    FN.USER = 'F.USER'
    F.USER = ''
    EB.DataAccess.Opf(FN.USER, F.USER)

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.MONTO         = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()

    IF (Y.V.FUNCTION EQ 'A') THEN
        IF Y.MONTO < 1 THEN
            V.ERROR.MSG = "MONTO DEBE SER MAYOR A 0"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            RETURN
        END
    END

    IF (Y.V.FUNCTION EQ 'I') THEN
        Y.ID.PP = 'MX0010001'
        EB.DataAccess.FRead(FN.ABC.PARAM.MTOS.SPEI, Y.ID.PP, R.ABC.PARAM.MTOS.SPEI, F.ABC.PARAM.MTOS.SPEI, Y.ERR.PARAM)
        R.USER = EB.SystemTables.getRUser()
        IF R.ABC.PARAM.MTOS.SPEI NE '' THEN
            Y.DEPTOS = RAISE(R.ABC.PARAM.MTOS.SPEI<AbcTable.AbcParamMtosSpei.Departamento)
            Y.NO.DEPTOS = DCOUNT(Y.DEPTOS, @FM)

            Y.I = 1
            LOOP
            WHILE Y.I LE Y.NO.DEPTOS
            
                Y.SUCURSAL = FIELD(Y.DEPTOS, FM, Y.I)
                Y.LONG.SUC = LEN(Y.SUCURSAL)
                Y.DEPTO.SPEI = R.USER<EB.Security.User.UseDepartmentCode>[1, Y.LONG.SUC]
            
                IF Y.SUCURSAL EQ Y.DEPTO.SPEI THEN
                    GOSUB SUCURSAL.EQ.DEPTO.SPEI
                END ELSE
                    GOSUB SUCURSAL.NE.DEPTO.SPEI
                END
                Y.I++
            REPEAT
        END
    END


RETURN

*-----------------------------------------------------------------------------
SUCURSAL.EQ.DEPTO.SPEI:
*-----------------------------------------------------------------------------

    LOCATE Y.DEPTO.SPEI IN R.ABC.PARAM.MTOS.SPEI<AbcTable.AbcParamMtosSpei.Departamento, 1> SETTING Y.POS.DEPTO THEN

        Y.DEPTO.X = RAISE(R.ABC.PARAM.MTOS.SPEI<AbcTable.AbcParamMtosSpei.Departamento>)
        Y.MONTO.X = RAISE(R.ABC.PARAM.MTOS.SPEI<AbcTable.AbcParamMtosSpei.Monto>)
        Y.ESTATUS.X = RAISE(R.ABC.PARAM.MTOS.SPEI<AbcTable.AbcParamMtosSpei.Estatus>)

        Y.DEPTO.PARAM = FIELD(Y.DEPTO.X, FM, POS.DEPTO)
        Y.MONTO.PARAM = FIELD(Y.MONTO.X, FM, POS.DEPTO)
        Y.ESTATUS.PARAM = FIELD(Y.ESTATUS.X, FM, POS.DEPTO)

        IF (Y.MONTO.PARAM < Y.MONTO) AND (Y.ESTATUS.PARAM EQ 'ACTIVA') THEN
            V.ERROR.MSG.MONTO = "MONTO PERMITIDO EXCEDIDO, CONTACTAR A TESORERIA"
            EB.SystemTables.setE(V.ERROR.MSG.MONTO)
            EB.ErrorProcessing.Err()
        END

    END

RETURN

*-----------------------------------------------------------------------------
SUCURSAL.NE.DEPTO.SPEI:
*-----------------------------------------------------------------------------

    IF Y.I EQ Y.NO.DEPTOS THEN
        V.ERROR.MSG.NO = "OPERACION NO PERMITIDA, CONTACTAR A TESORERIA"
        EB.SystemTables.setE(V.ERROR.MSG.NO)
        EB.ErrorProcessing.Err()
    END
RETURN


*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END
