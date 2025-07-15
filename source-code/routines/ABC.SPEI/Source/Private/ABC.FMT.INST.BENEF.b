$PACKAGE AbcSpei

SUBROUTINE ABC.FMT.INST.BENEF
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Updates
    $USING FT.Contract

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

***********
INITIALIZE:
***********
    Y.INST.BENEF = EB.SystemTables.getComi()
    Y.ID.PARAM = "ABC.INSTITUCIONES"
    Y.POS.CTA.EXT.TRANSF = ""
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","CTA.EXT.TRANSF",Y.POS.CTA.EXT.TRANSF)

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.CTA.EXT.TRANSF = Y.LOCAL.REF<1,Y.POS.CTA.EXT.TRANSF>

    FN.ABC.BANCOS = "F.ABC.BANCOS"
    F.ABC.BANCOS = ""
    EB.DataAccess.Opf(FN.ABC.BANCOS,F.ABC.BANCOS)

    RETURN

*********
PROCESS:
*********

    IF LEN(Y.INST.BENEF) EQ 5 OR LEN(Y.INST.BENEF) EQ 3 THEN
        IF LEN(Y.INST.BENEF) NE 5 THEN
            IF Y.INST.BENEF EQ '138' THEN
                ETEXT = 'No se permite la operacion para cuenta del mismo banco'
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                IF Y.INST.BENEF NE Y.CTA.EXT.TRANSF[1,3] AND LEN(Y.CTA.EXT.TRANSF) EQ 18 THEN
                    ETEXT = 'La cuenta beneficiaria no pertenece al banco ingresado'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
            Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
            AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
            IF Y.LIST.VALUES NE '' THEN
                NUM.LIST.VALUES = DCOUNT(Y.LIST.VALUES,FM)
                FOR CT = 1 TO NUM.LIST.VALUES
                    Y.TIPO.INST = Y.LIST.VALUES<CT>
                    Y.BANCO = Y.TIPO.INST:Y.INST.BENEF
                    EB.DataAccess.FRead(FN.ABC.BANCOS,Y.BANCO,R.ABC.BANCOS,F.ABC.BANCOS,F.ERROR.ABC.BANCOS)
                    IF R.ABC.BANCOS NE '' THEN
                        Y.INST.BENEF = Y.BANCO
                        BREAK
                    END
                NEXT CT
                IF LEN(Y.INST.BENEF) NE 5 THEN
                    ETEXT = 'La institucion ':Y.INST.BENEF:' no se encuentre registrada'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END ELSE
                    EB.SystemTables.setComi(Y.INST.BENEF)
                END
            END ELSE
                Y.INST.BENEF = '40':Y.INST.BENEF
                EB.DataAccess.FRead(FN.ABC.BANCOS,Y.INST.BENEF,R.ABC.BANCOS,F.ABC.BANCOS,F.ERROR.ABC.BANCOS)
                IF R.ABC.BANCOS EQ '' THEN
                    ETEXT = 'La institucion ':Y.INST.BENEF:' no se encuentre registrada'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END ELSE
                    EB.SystemTables.setComi(Y.INST.BENEF)
                END
            END
        END ELSE
            IF Y.INST.BENEF[3,3] EQ '138' THEN
                ETEXT = 'No se permite la operacion para cuenta del mismo banco'
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                IF Y.INST.BENEF[3,3] NE Y.CTA.EXT.TRANSF[1,3] AND LEN(Y.CTA.EXT.TRANSF) EQ 18 THEN
                    ETEXT = 'La cuenta beneficiaria no pertenece al banco ingresado'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
            EB.DataAccess.FRead(FN.ABC.BANCOS,Y.INST.BENEF,R.ABC.BANCOS,F.ABC.BANCOS,F.ERROR.ABC.BANCOS)
            IF R.ABC.BANCOS EQ '' THEN
                ETEXT = 'La institucion ':Y.INST.BENEF:' no se encuentre registrada'
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END ELSE
        ETEXT = 'La institucion beneficiaria no tiene la longitud correcta'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    RETURN
END 