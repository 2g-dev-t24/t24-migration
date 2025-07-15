$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.EXPRESS.TXN.OUTGOING
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Display
    $USING ST.Customer

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY
    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    Y.CUENTA.ORDEN    = ''
    Y.RFC.ORDEN       = ''
    Y.RFC.ND          = 'ND'
    Y.MONTO           = ''
    Y.CTA.BENEF       = ''
    Y.NOM.BENEF       = ''
    Y.RFC.BENEF       = ''
    Y.MONTO.IVA       = ''
    Y.TIPO.PAGO       = ''
    Y.CANAL           = ''
    Y.CLAVE.RASTREO   = ''
    Y.CONCEPTO        = ''
    R.ACCOUNT         = ''
    Y.ERR.ACC         = ''
    Y.CTA.CLABE.ORDEN = ''
    Y.CUS.ORDEN       = ''
    R.CUSTOMER        = ''
    Y.ERR.CUS         = ''
    Y.NOM.ORDEN       = ''
    Y.INSTITU.BENEF   = ''
    Y.REFERENCIA      = ''
    Y.STRING.ESCRIBIR = ''
    Y.SEP = ';'
    Y.SEPARA.MESSAGE = "/"

    GOSUB GET.FIELDS.LOCAL
    RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    Y.CUENTA.ORDEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.MONTO        = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.LOCAL.REF   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.CTA.BENEF   = Y.LOCAL.REF<1,Y.POS.CTA.EXT.TRANSF>
    Y.NOM.BENEF   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)<1,1>
    Y.RFC.BENEF   = Y.LOCAL.REF<1,Y.POS.RFC.BENEF.SPEI>
    Y.MONTO.IVA   = Y.LOCAL.REF<1,Y.POS.AMT.IVA.SPEI>
    Y.TIPO.PAGO   = Y.LOCAL.REF<1,Y.POS.TIPO.SPEI>
    Y.CANAL       = Y.LOCAL.REF<1,Y.POS.CANAL>
    Y.INSTITU.BENEF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditTheirRef)

    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.CLAVE.RASTREO = Y.ID.NEW[3,LEN(Y.ID.NEW)-2]
    Y.REFERENCIA  = TRIM(Y.LOCAL.REF<1,Y.POS.REFERENCIA>)
    Y.REFERENCIA  = Y.REFERENCIA*1

    EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.ORDEN,R.ACCOUNT,F.ACCOUNT,Y.ERR.ACC)
    IF R.ACCOUNT THEN
        Y.LOCAL.REF.ACCOUNT = R.ACCOUNT<AC.AccountOpening.Account.LocalRef>
        Y.CTA.CLABE.ORDEN = Y.LOCAL.REF.ACCOUNT<1,Y.POS.CLABE>
        Y.CUS.ORDEN = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        EB.DataAccess.FRead(FN.CUSTOMER,Y.CUS.ORDEN,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
        IF R.CUSTOMER THEN
            IF R.CUSTOMER<ST.Customer.Customer.EbCusExternCusId><1,1> EQ '' THEN
                Y.RFC.ORDEN = Y.RFC.ND
            END ELSE
                Y.RFC.ORDEN = R.CUSTOMER<ST.Customer.Customer.EbCusExternCusId><1,1>
            END
        END
        Y.COMI = Y.CUS.ORDEN:'*1'
        AbcSpei.abcVCustomerName(Y.COMI, Y.NOM.ORDEN)
    END
    
    Y.NOM.ORDEN = EREPLACE(Y.NOM.ORDEN,"Ã‘","N")
    Y.NOM.BENEF = EREPLACE(Y.NOM.BENEF,"Ã‘","N")
    Y.NOM.ORDEN = EREPLACE(Y.NOM.ORDEN,"Ñ","N")
    Y.NOM.BENEF = EREPLACE(Y.NOM.BENEF,"Ñ","N")
    IF LEN(Y.NOM.ORDEN) GT 40 THEN
        Y.NOM.ORDEN = Y.NOM.ORDEN[1,40]
    END
    IF LEN(Y.NOM.BENEF) GT 40 THEN
        Y.NOM.BENEF = Y.NOM.BENEF[1,40]
    END
    Y.EXTEND.INFO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)
    IF LEN(Y.EXTEND.INFO) GT 40 THEN
        Y.CONCEPTO = Y.EXTEND.INFO[1,40]
        Y.CONCEPTO = EREPLACE(Y.CONCEPTO,VM," ")
    END ELSE
        Y.CONCEPTO = Y.EXTEND.INFO
        Y.CONCEPTO = EREPLACE(Y.CONCEPTO,VM," ")
    END
    IF LEN(Y.NOM.ORDEN) GT 30 THEN
        Y.NOM.ORDEN = Y.NOM.ORDEN[1,30]
    END
    Y.HORA = TIMEDATE()
    Y.HORA = Y.HORA[1,8]
    Y.LOCAL.REF<1,Y.POS.TIME.SPEUA> = Y.HORA
    Y.LOCAL.REF<1,Y.POS.RASTREO> = Y.ID.NEW[3,14]
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
    Y.STRING.ESCRIBIR  = Y.CUENTA.ORDEN :Y.SEP: Y.CTA.CLABE.ORDEN :Y.SEP: Y.RFC.ORDEN :Y.SEP: Y.NOM.ORDEN :Y.SEP: Y.MONTO :Y.SEP: Y.CTA.BENEF :Y.SEP
    Y.STRING.ESCRIBIR := Y.NOM.BENEF :Y.SEP: Y.RFC.BENEF :Y.SEP: Y.CONCEPTO :Y.SEP: Y.REFERENCIA :Y.SEP: Y.MONTO.IVA :Y.SEP: Y.TIPO.PAGO :Y.SEP
    Y.STRING.ESCRIBIR := Y.CANAL :Y.SEP: Y.CLAVE.RASTREO :Y.SEP: Y.INSTITU.BENEF
    Y.RESPONSE = ''

    AbcSpei.AbcSpeiExpressPreparaRequest(Y.STRING.ESCRIBIR, Y.RESPONSE)

    IF Y.RESPONSE EQ "" THEN
        Y.MENSAJE = "NO SE RECIBIO RESPUESTA DEL SPEI"
    END ELSE
        AbcSpei.AbcSpeiInterpretaResponse(Y.RESPONSE, Y.MESSAGE.OUT)
        Y.TIPO.MESSAGE = FIELD(Y.MESSAGE.OUT, Y.SEPARA.MESSAGE, 1)
        Y.DESC.MESSAGE = FIELD(Y.MESSAGE.OUT, Y.SEPARA.MESSAGE, 2)
        Y.MENSAJE = Y.TIPO.MESSAGE : " / " : Y.DESC.MESSAGE
    END
    IF Y.TIPO.MESSAGE NE 0 THEN
        IF Y.MENSAJE NE "" THEN
            ETEXT = Y.MENSAJE
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            EB.Display.RebuildScreen()
        END
    END
    RETURN

*-------------------------------------------------------------------------------
GET.FIELDS.LOCAL:
*-------------------------------------------------------------------------------
    Y.NOMBRE.APP = "FUNDS.TRANSFER":@FM:"ACCOUNT"
    Y.NOMBRE.CAMPO = "CTA.EXT.TRANSF":@VM:"RFC.BENEF.SPEI":@VM:"AMT.IVA.SPEI":@VM:"TIPO.SPEI":@VM:"CANAL":@VM:"RASTREO":@VM:"TIMESTAMP.SPEUA":@VM:"REFERENCIA":@FM:"CLABE"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    Y.POS.CTA.EXT.TRANSF  = R.POS.CAMPO<1,1>
    Y.POS.RFC.BENEF.SPEI  = R.POS.CAMPO<1,2>
    Y.POS.AMT.IVA.SPEI    = R.POS.CAMPO<1,3>
    Y.POS.TIPO.SPEI       = R.POS.CAMPO<1,4>
    Y.POS.CANAL           = R.POS.CAMPO<1,5>
    Y.POS.RASTREO         = R.POS.CAMPO<1,6>
    Y.POS.TIME.SPEUA      = R.POS.CAMPO<1,7>
    Y.POS.REFERENCIA      = R.POS.CAMPO<1,8>
    Y.POS.CLABE           = R.POS.CAMPO<2,1>
    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
    RETURN

END 