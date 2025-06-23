$PACKAGE AbcSpei

SUBROUTINE ABC.VALIDA.CCC.SPEI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AbcTable
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Display

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------

    FN.ABC.BANCOS = "F.ABC.BANCOS"
    F.ABC.BANCOS  = ""
    EB.DataAccess.Opf(FN.ABC.BANCOS, F.ABC.BANCOS)

    FN.ABC.PARAMETROS.BANXICO = "F.ABC.PARAMETROS.BANXICO"
    F.ABC.PARAMETROS.BANXICO  = ""
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.BANXICO, F.ABC.PARAMETROS.BANXICO)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.ABC.CTAS.AUTORIZADAS = "F.ABC.CTAS.AUTORIZADAS"
    F.ABC.CTAS.AUTORIZADAS = ""
    EB.DataAccess.Opf(FN.ABC.CTAS.AUTORIZADAS, F.ABC.CTAS.AUTORIZADAS)

    EB.DataAccess.FRead(FN.ABC.PARAMETROS.BANXICO, "SYSTEM", R.ABC.PARAMETROS.BANXICO, F.ABC.PARAMETROS.BANXICO, Y.ERR.PARAM)
    
    IF NOT(R.ABC.PARAMETROS.BANXICO) THEN
        Y.BANCO.PROPIO = "000"
    END ELSE
        Y.BANCO.PROPIO = R.ABC.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.NumBanco> * 1
    END

    NOM.CAMPOS     = 'CTA.EXT.TRANSF':@VM:'RFC.BENEF.SPEI'
    POS.CAMP.LOCAL = ""
        
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)

    YPOS.CTA.EXT.TRANSF = POS.CAMP.LOCAL<1,1>
    YPOS.RFC.BENEF.SPEI = POS.CAMP.LOCAL<1,2>

    RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.COMI = EB.SystemTables.getComi()

    IF Y.COMI NE "" THEN

        Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.CTA.EXT.TRANSF = Y.LOCAL.REF<1, YPOS.CTA.EXT.TRANSF>

        IF ( (LEN(Y.COMI) NE 18) AND (Y.CTA.EXT.TRANSF EQ "") ) THEN
            V.ERROR.MSG = "La cuenta debe ser de 18 digitos"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
            RETURN
        END

        IF (LEN(Y.COMI) EQ 18) THEN
            YCADENA = Y.COMI
            YCADENA.ORIGINAL = YCADENA
            Y.CUENTA = Y.COMI[7,11] * 1
            Y.PLAZA  = Y.COMI[4,3] * 1
            IF Y.PLAZA LE 0 THEN
                ETEXT = "Plaza (4-7) debe ser mayor a 0"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.Err()
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            IF Y.CUENTA LE 0 THEN
                ETEXT = "Cuenta (7-17) debe ser mayor a 0"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.Err()
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            Y.BANCO = Y.COMI[1,3] * 1
            IF Y.BANCO.PROPIO EQ Y.BANCO THEN
                ETEXT = "Banco no puede ser este mismo"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.Err()
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            Y.ID.BANCO = ""
            EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, "ABC.INSTITUCIONES", R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
            IF R.ABC.GENERAL.PARAM THEN
                LISTA.TIPO = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>
                CONVERT VM TO FM IN LISTA.TIPO
                NUM.LISTA.TIPO = DCOUNT(LISTA.TIPO,FM)
                FOR CT = 1 TO NUM.LISTA.TIPO
                    Y.ID.BANCO = LISTA.TIPO<CT>:STR("0",3-LEN(Y.BANCO)):Y.BANCO
                    EB.DataAccess.FRead(FN.ABC.BANCOS, Y.ID.BANCO, R.ABC.BANCOS, F.ABC.BANCOS, Y.ERR.PARAM)
                    IF R.ABC.BANCOS THEN
                        CT = NUM.LISTA.TIPO
                    END
                NEXT CT
            END ELSE
                Y.ID.BANCO = "40" :STR("0",3-LEN(Y.BANCO)):Y.BANCO
            END

            IF NOT(R.ABC.BANCOS) THEN
                ETEXT = "Numero de Banco: " :Y.ID.BANCO: " no existe"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.Err()
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            AbcSpei.AbcCalculaCcc(YCADENA,YERROR)

            IF YERROR EQ 1 THEN
                V.ERROR.MSG = "La cuenta no esta completa"
                EB.SystemTables.setE(V.ERROR.MSG)
                EB.ErrorProcessing.Err()
            END
            ELSE
                IF YERROR EQ 2 THEN
                    V.ERROR.MSG = "La cuenta no es numerica"
                    EB.SystemTables.setE(V.ERROR.MSG)
                    EB.ErrorProcessing.Err()
                END
                ELSE
                    IF YCADENA.ORIGINAL NE YCADENA THEN
                        V.ERROR.MSG = "El digito no es correcto"
                        EB.SystemTables.setE(V.ERROR.MSG)
                        EB.ErrorProcessing.Err()
                    END
                    ELSE
                        Y.COMI = YCADENA
                        IF EB.SystemTables.getAv() NE YPOS.CTA.EXT.TRANSF THEN
                            GOSUB VALIDATE.AUTH.ACCOUNT
                        END
                        Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
                        IF (Y.PGM.VERSION NE ",SPEI.T.T.OFS") AND (Y.PGM.VERSION NE ",ABC.2FX.OFS.SPEI") AND (Y.PGM.VERSION NE ",ABC.2BR.OFS.SPEI.DISP") THEN
                            IF EB.SystemTables.getMessage() NE "VAL" THEN

                                Y.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF> = ""
                                Y.LOCAL.REF<1,YPOS.RFC.BENEF.SPEI> = ""
                                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
                                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails) = ""
                            END
                        END
                        EB.Display.RebuildScreen()
                    END
                END
            END
        END
        ELSE
            V.ERROR.MSG = "La cuenta debe ser de 18 digitos"
            EB.SystemTables.setE(V.ERROR.MSG)
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
            RETURN
        END
    END

    RETURN

*---------------------------------------------------------------
VALIDATE.AUTH.ACCOUNT:
*---------------------------------------------------------------

    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()

    YACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    EB.DataAccess.FRead(FN.ACCOUNT, YACCOUNT, R.ACCOUNT, F.ACCOUNT, Y.ERR.PARAM)

    YCUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>

    EB.DataAccess.FRead(FN.ABC.CTAS.AUTORIZADAS, YCUSTOMER, R.ABC.CTAS.AUTORIZADAS, F.ABC.CTAS.AUTORIZADAS, Y.ERR.PARAM)

    IF R.ABC.CTAS.AUTORIZADAS EQ '' THEN

        IF (PGM.VERSION NE ",ABC.2FX.OFS.SPEI") AND (PGM.VERSION NE ",ABC.2BR.OFS.SPEI.DISP") THEN
            AbcSpei.AbcValidaComisionSpei()
        END
        RETURN
    END

    LOCATE Y.COMI IN R.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.CtaClabe,1> SETTING YPOSICION THEN
        V.ERROR.MSG = "Cta autorizada, seleccione de lista"
        EB.SystemTables.setE(V.ERROR.MSG)
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi('')
        RETURN
    END

    IF (PGM.VERSION NE ",ABC.2FX.OFS.SPEI") AND (PGM.VERSION NE ",ABC.2BR.OFS.SPEI.DISP") THEN
        AbcSpei.AbcValidaComisionSpei()
    END

    RETURN

END