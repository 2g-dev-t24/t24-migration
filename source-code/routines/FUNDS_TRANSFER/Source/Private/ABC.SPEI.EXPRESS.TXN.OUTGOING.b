* @ValidationCode : MjoxNTQ2MTU2NjAwOkNwMTI1MjoxNzQ0ODM4MDIzNjQ0OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:13:43
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

*===============================================================================
* <Rating>-50</Rating>
*===============================================================================
$PACKAGE ABC.BP
SUBROUTINE ABC.SPEI.EXPRESS.TXN.OUTGOING
*===============================================================================
* Nombre de Programa :  ABC.SPEI.EXPRESS.TXN.OUTGOING
* Objetivo           :  Rutina principal para el envio de SPEI Express, no se valida cuenta CLABE de la tabla ABC.CUENTAS.DESTINO
* Requerimiento      :  Proyecto ABC Digital
* Desarrollador      :  Alexis Almaraz Robles - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  17/Junio/2020
*===============================================================================
* Modificaciones:
*===============================================================================

*    $INSERT GLOBUS.BP I_COMMON
*    $INSERT GLOBUS.BP I_EQUATE
*    $INSERT GLOBUS.BP I_F.CUSTOMER
*    $INSERT GLOBUS.BP I_F.ACCOUNT
*    $INSERT GLOBUS.BP I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING EB.Display
*-----------------------------------------------------------------------------

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
    Y.MONTO           = ''
    Y.CTA.BENEF      = ''
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

*    FN.ACCOUNT = "F.ACCOUNT"
*    F.ACCOUNT  = ""
*    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*    FN.CUSTOMER = "F.CUSTOMER"
*    F.CUSTOMER  = ""
*    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    sGetIDNEW = EB.SystemTables.getIdNew()
 
    Y.CUENTA.ORDEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)     ;*R.NEW(FT.DEBIT.ACCT.NO)
    Y.MONTO             = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)     ;*R.NEW(FT.DEBIT.AMOUNT)
    Y.CTA.BENEF       = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.CTA.EXT.TRANSF>     ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.CTA.EXT.TRANSF>
    Y.NOM.BENEF       = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)<1,1>     ;*R.NEW(FT.PAYMENT.DETAILS)<1,1>
    Y.RFC.BENEF        = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.RFC.BENEF.SPEI>        ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI>
    Y.MONTO.IVA       = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.AMT.IVA.SPEI>        ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.AMT.IVA.SPEI>
    Y.TIPO.PAGO        = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.TIPO.SPEI>        ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.TIPO.SPEI>
    Y.CANAL              = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.CANAL>        ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.CANAL>
    Y.INSTITU.BENEF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditTheirRef)     ;*R.NEW(FT.CREDIT.THEIR.REF)

    Y.CLAVE.RASTREO.TEMP = sGetIDNEW ;*ID.NEW[3,LEN(ID.NEW)-2]
    Y.CLAVE.RASTREO = Y.CLAVE.RASTREO.TEMP[3,LEN(Y.CLAVE.RASTREO.TEMP)-2]
    Y.REFERENCIA  = TRIM(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.CANAL>)      ;*TRIM(R.NEW(FT.LOCAL.REF)<1,Y.POS.REFERENCIA>)

    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.CUENTA.ORDEN, Y.ERR.ACC)
* Before incorporation : CALL F.READ(FN.ACCOUNT,Y.CUENTA.ORDEN,R.ACCOUNT,F.ACCOUNT,Y.ERR.ACC)
    IF R.ACCOUNT THEN
        Y.CTA.CLABE.ORDEN = R.ACCOUNT<AC.AccountOpening.Account.LocalRef><1,Y.POS.CLABE>;*<AC.LOCAL.REF><1,Y.POS.CLABE>
        Y.CUS.ORDEN = R.ACCOUNT<AC.AccountOpening.Account.Customer>     ;*<AC.CUSTOMER>

        R.CUSTOMER = ST.Customer.Customer.Read(Y.CUS.ORDEN, Y.ERR.CUS)
* Before incorporation : CALL F.READ(FN.CUSTOMER,Y.CUS.ORDEN,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
        IF R.CUSTOMER THEN
            Y.RFC.ORDEN = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>       ;*<EB.CUS.TAX.ID><1,1>
        END

*        COMI = Y.CUS.ORDEN:'*1'
        EB.SystemTables.setComi(Y.CUS.ORDEN:'*1')
        ABC.BP.vpmVCustomerName()
        Y.NOM.ORDEN = EB.SystemTables.getComiEnri()      ;*COMI.ENRI

    END

    Y.NOM.ORDEN = EREPLACE(Y.NOM.ORDEN,"Ñ","N")
    Y.NOM.BENEF = EREPLACE(Y.NOM.BENEF,"Ñ","N")

    Y.NOM.ORDEN = EREPLACE(Y.NOM.ORDEN,"�","N")
    Y.NOM.BENEF = EREPLACE(Y.NOM.BENEF,"�","N")

    IF LEN(Y.NOM.ORDEN) GT 40 THEN
        Y.NOM.ORDEN.TEMP = EB.SystemTables.getComiEnri()       ;*COMI.ENRI[1,40]
        Y.NOM.ORDEN = Y.NOM.ORDEN.TEMP[1,40]
    END
    IF LEN(Y.NOM.BENEF) GT 40 THEN
        Y.NOM.BENEF = Y.NOM.BENEF[1,40]
    END
*    IF LEN(R.NEW(FT.EXTEND.INFO)) GT 40 THEN
    IF LEN(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)) GT 40 THEN
        Y.CONCEPTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)        ;*R.NEW(FT.EXTEND.INFO)[1,40]
        Y.CONCEPTO = EREPLACE(Y.CONCEPTO[1,40],VM," ")
    END ELSE
        Y.CONCEPTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)        ;*R.NEW(FT.EXTEND.INFO)
        Y.CONCEPTO = EREPLACE(Y.CONCEPTO,VM," ")
    END

    IF LEN(Y.NOM.ORDEN) GT 30 THEN
        Y.NOM.ORDEN = Y.NOM.ORDEN[1,30]
    END

*    R.NEW(FT.LOCAL.REF)<1,Y.POS.TIME.SPEUA> = Y.HORA
*    R.NEW(FT.LOCAL.REF)<1,Y.POS.RASTREO> = ID.NEW[3,14]
    sGetLocalRefFT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.HORA = TIMEDATE()
    sGetLocalRefFT<1,Y.POS.RASTREO> = Y.HORA[1,8]
    sGetLocalRefFT<1,Y.POS.RASTREO> = sGetIDNEW[3,14]
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, sGetLocalRefFT)

    Y.STRING.ESCRIBIR  = Y.CUENTA.ORDEN :Y.SEP: Y.CTA.CLABE.ORDEN :Y.SEP: Y.RFC.ORDEN :Y.SEP: Y.NOM.ORDEN :Y.SEP: Y.MONTO :Y.SEP: Y.CTA.BENEF :Y.SEP
    Y.STRING.ESCRIBIR := Y.NOM.BENEF :Y.SEP: Y.RFC.BENEF :Y.SEP: Y.CONCEPTO :Y.SEP: Y.REFERENCIA :Y.SEP: Y.MONTO.IVA :Y.SEP: Y.TIPO.PAGO :Y.SEP
    Y.STRING.ESCRIBIR := Y.CANAL :Y.SEP: Y.CLAVE.RASTREO :Y.SEP: Y.INSTITU.BENEF

    Y.RESPONSE = ''
    ABC.BP.abcSpeiExpressPreparaRequest(Y.STRING.ESCRIBIR, Y.RESPONSE)

    IF Y.RESPONSE EQ "" THEN
        Y.MENSAJE = "NO SE RECIBIO RESPUESTA DEL SPEI"
    END ELSE
        ABC.BP.abcSpeiInterpretaResponse(Y.RESPONSE, Y.MESSAGE.OUT)
        Y.TIPO.MESSAGE = FIELD(Y.MESSAGE.OUT, Y.SEPARA.MESSAGE, 1)
        Y.DESC.MESSAGE = FIELD(Y.MESSAGE.OUT, Y.SEPARA.MESSAGE, 2)
        Y.MENSAJE = Y.TIPO.MESSAGE : " / " : Y.DESC.MESSAGE
    END

    IF Y.TIPO.MESSAGE NE 0 THEN
        IF Y.MENSAJE NE "" THEN
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef);*AF = FT.LOCAL.REF
            PRINT Y.MENSAJE
            EB.SystemTables.setEtext(Y.MENSAJE)     ;*ETEXT = Y.MENSAJE
            EB.SystemTables.setE(EB.SystemTables.getEtext())     ;*E = ETEXT
            EB.ErrorProcessing.StoreEndError()
            EB.Display.RebuildScreen()
*            CALL STORE.END.ERROR
*            CALL REBUILD.SCREEN
        END
    END

RETURN

*-------------------------------------------------------------------------------
GET.FIELDS.LOCAL:
*-------------------------------------------------------------------------------
    Y.NOMBRE.APP = ""
    Y.NOMBRE.CAMPO = ""
    R.POS.CAMPO = ""
    Y.NOMBRE.APP<-1> = "FUNDS.TRANSFER"
    Y.NOMBRE.APP<-1> = "ACCOUNT"
    Y.NOMBRE.CAMPO<1,1> = "CTA.EXT.TRANSF"
    Y.NOMBRE.CAMPO<1,2> = "RFC.BENEF.SPEI"
    Y.NOMBRE.CAMPO<1,3> = "AMT.IVA.SPEI"
    Y.NOMBRE.CAMPO<1,4> = "TIPO.SPEI"
    Y.NOMBRE.CAMPO<1,5> = "CANAL"
    Y.NOMBRE.CAMPO<1,6> = "RASTREO"
    Y.NOMBRE.CAMPO<1,7> = "TIMESTAMP.SPEUA"
    Y.NOMBRE.CAMPO<1,8> = "REFERENCIA"
    Y.NOMBRE.CAMPO<2,1> = "CLABE"

*    CALL MULTI.GET.LOC.REF(Y.NOMBRE.APP,Y.NOMBRE.CAMPO,R.POS.CAMPO)
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)

    Y.POS.CTA.EXT.TRANSF = R.POS.CAMPO<1,1>
    Y.POS.RFC.BENEF.SPEI  = R.POS.CAMPO<1,2>
    Y.POS.AMT.IVA.SPEI      = R.POS.CAMPO<1,3>
    Y.POS.TIPO.SPEI           = R.POS.CAMPO<1,4>
    Y.POS.CANAL                = R.POS.CAMPO<1,5>
    Y.POS.RASTREO            = R.POS.CAMPO<1,6>
    Y.POS.TIME.SPEUA        = R.POS.CAMPO<1,7>
    Y.POS.REFERENCIA       = R.POS.CAMPO<1,8>
    Y.POS.CLABE                = R.POS.CAMPO<2,1>

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
