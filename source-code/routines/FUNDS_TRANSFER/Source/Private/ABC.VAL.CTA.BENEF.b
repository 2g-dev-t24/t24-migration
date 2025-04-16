* @ValidationCode : MjotMTc3NDY2MjIzOkNwMTI1MjoxNzQ0ODQxNTI0NDYxOm1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 17:12:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*===============================================================================
* <Rating>-3</Rating>
*===============================================================================
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.CTA.BENEF
*===============================================================================
* Nombre de Programa :  ABC.VAL.CTA.BENEF
* Objetivo           :  Rutina para validar la cuenta beneficiaria y llenar los campos correspondientes cuando la operacion sea mismo Banco
* Requerimiento      :  Proyecto ABC Digital
* Desarrollador      :  Alexis Almaraz Robles - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  11/Junio/2020
*===============================================================================
* Modificaciones:
*===============================================================================

*    $INSERT GLOBUS.BP I_COMMON
*    $INSERT GLOBUS.BP I_EQUATE
*    $INSERT GLOBUS.BP I_F.ACCOUNT
*    $INSERT GLOBUS.BP I_F.CUSTOMER
*    $INSERT GLOBUS.BP I_F.FUNDS.TRANSFER
*    $INSERT ABC.BP I_F.ET.SAP.TARJETA

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AC.Config
    $USING EB.Updates
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING ABC.BP

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.CTA.BENEF = EB.SystemTables.getComi() ;*COMI
    SELECT.CMD = ''
    LIST.IDS = ''
    NO.SELECT.IDS = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.ACC = ''
    R.ACCOUNT = ''
    Y.ERR.ACC = ''
    R.CUSTOMER = ''
    Y.ERR.CUS = ''
    Y.CUS.BENEF = ''
    Y.POS.TIPO.CTA.BEN = ''
    Y.POS.RFC.BENEF.SPEI = ''
    Y.TDD.ID = ''
    R.ET.SAP.TARJETA = ''
    Y.ERR.TARJETA = ''
    R.ALTERNATE.ACCOUNT = ''
    Y.ERR.ALT.ACC = ''
    Y.RFC.BENEF = ''

    Y.NOMBRE.APP<1> = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO<1,1> = "TIPO.CTA.BEN"
    Y.NOMBRE.CAMPO<1,2> = "RFC.BENEF.SPEI"
*CALL MULTI.GET.LOC.REF(Y.NOMBRE.APP,Y.NOMBRE.CAMPO,R.POS.CAMPO)
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    
    Y.POS.TIPO.CTA.BEN    = R.POS.CAMPO<1,1>
    Y.POS.RFC.BENEF.SPEI = R.POS.CAMPO<1,2>

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

*    FN.ACCOUNT = 'F.ACCOUNT'
*    F.ACCOUNT = ''
*    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
*
*    FN.CUSTOMER = 'F.CUSTOMER'
*    F.CUSTOMER = ''
*    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
*
    FN.ET.SAP.TARJETA = 'F.ET.SAP.TARJETA'
    F.ET.SAP.TARJETA = ''
    EB.DataAccess.Opf(FN.ET.SAP.TARJETA, F.ET.SAP.TARJETA)
*
*    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
*    F.ALTERNATE.ACCOUNT = ''
*    EB.DataAccess.Opf(FN.ALTERNATE.ACCOUNT, F.ALTERNATE.ACCOUNT)


RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    sYLocalRef = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.TIPO.CTA.BENEF = sYLocalRef<1, Y.POS.TIPO.CTA.BEN> ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.TIPO.CTA.BEN>

    BEGIN CASE

*     CASE Y.TIPO.CTA.BENEF EQ 40         ;* CUENTA CLABE
*         IF TRIM(LEN(Y.CTA.BENEF)) NE 18 THEN
*             ETEXT = 'Longitud invalida para el tipo de cuenta: ':Y.TIPO.CTA.BENEF
*             CALL STORE.END.ERROR
*         END
*         SELECT.CMD = 'SELECT ' :FN.ACCOUNT: ' WITH CLABE EQ ':Y.CTA.BENEF
*         GOSUB GET.DATA.CLABE

        CASE Y.TIPO.CTA.BENEF EQ 10         ;* NUMERO DE CELULAR
            IF TRIM(LEN(Y.CTA.BENEF)) NE 10 THEN
                EB.SystemTables.setEtext('Longitud invalida para el tipo de cuenta: ':Y.TIPO.CTA.BENEF) ;*ETEXT = 'Longitud invalida para el tipo de cuenta: ':Y.TIPO.CTA.BENEF
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            Y.ID.ALT.ACC = Y.CTA.BENEF
            GOSUB GET.DATA.CEL

        CASE Y.TIPO.CTA.BENEF EQ 3          ;* TDD
            IF TRIM(LEN(Y.CTA.BENEF)) NE 16 THEN
                EB.SystemTables.setEtext('Longitud invalida para el tipo de cuenta: ':Y.TIPO.CTA.BENEF) ;*ETEXT = 'Longitud invalida para el tipo de cuenta: ':Y.TIPO.CTA.BENEF
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            SELECT.CMD = 'SELECT ' :FN.ET.SAP.TARJETA: ' WITH NUMERO EQ ':DQUOTE(Y.CTA.BENEF)  ; * ITSS - ADOLFO - Added DQUOTE
            GOSUB GET.DATA.TDD.CUS

        CASE Y.TIPO.CTA.BENEF EQ 1          ;*CUETA MISMO BANCO
*         IF TRIM(LEN(Y.CTA.BENEF)) NE 11 THEN
*             ETEXT = 'Longitud invalida para el tipo de cuenta: ':Y.TIPO.CTA.BENEF
*             CALL STORE.END.ERROR
*         END
            Y.ID.ACC = Y.CTA.BENEF
            GOSUB GET.MISMO.BANCO

        CASE 1
            EB.SystemTables.setEtext('Tipo de cuenta no valido') ;*ETEXT = 'Tipo de cuenta no valido'
            EB.ErrorProcessing.StoreEndError()

    END CASE

RETURN

*-------------------------------------------------------------------------------
GET.DATA.CEL:
*-------------------------------------------------------------------------------


    R.ALTERNATE.ACCOUNT = AC.AccountOpening.AlternateAccount.Read(Y.ID.ALT.ACC, Y.ERR.ALT.ACC)
* Before incorporation : CALL F.READ(FN.ALTERNATE.ACCOUNT, Y.ID.ALT.ACC, R.ALTERNATE.ACCOUNT, F.ALTERNATE.ACCOUNT, Y.ERR.ALT.ACC)
    IF R.ALTERNATE.ACCOUNT THEN
        Y.ID.ACC = R.ALTERNATE.ACCOUNT<1>
        R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ID.ACC, Y.ERR.ACC)
* Before incorporation : CALL F.READ(FN.ACCOUNT, Y.ID.ACC, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)
        IF R.ACCOUNT THEN
            Y.CUS.BENEF = R.ACCOUNT<AC.AccountOpening.Account.Customer>;*R.ACCOUNT<AC.CUSTOMER>
*CALL F.READ(FN.CUSTOMER, Y.CUS.BENEF, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)
            R.CUSTOMER = ST.Customer.Customer.Read(Y.CUS.BENEF, Y.ERR.CUS)
            IF R.CUSTOMER THEN
                EB.SystemTables.setComi(Y.CUS.BENEF:'*1') ;*COMI = Y.CUS.BENEF:'*1'
                ABC.BP.vpmVCustomerName()
                Y.NOMBRE = EB.SystemTables.getComiEnri() ;*COMI.ENRI
                EB.SystemTables.setComi(Y.CTA.BENEF) ;*COMI = Y.CTA.BENEF
                Y.RFC.BENEF = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId> ;*R.CUSTOMER<EB.CUS.TAX.ID><1,1>
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.ID.ACC) ;*R.NEW(FT.CREDIT.ACCT.NO) = Y.ID.ACC
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.NOMBRE) ;*R.NEW(FT.PAYMENT.DETAILS) = Y.NOMBRE
                Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                Y.LOCAL.REF<1, Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF) ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
                EB.Display.RebuildScreen() ;*CALL REBUILD.SCREEN
            END ELSE
                EB.SystemTables.setEtext('No existe registro del cliente asociado al numero de celular') ;*ETEXT = 'No existe registro del cliente asociado al numero de celular'
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            EB.SystemTables.setEtext('No existe registro de la cuenta asociada al numero de celular') ;*ETEXT = 'No existe registro de la cuenta asociada al numero de celular'
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        EB.SystemTables.setEtext('No existe registro del numero de celular en ALTERNATE.ACCOUNT') ;*ETEXT = 'No existe registro del numero de celular en ALTERNATE.ACCOUNT'
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

* *-------------------------------------------------------------------------------
* GET.DATA.CLABE:
* *-------------------------------------------------------------------------------

*     CALL EB.READLIST(SELECT.CMD, LIST.IDS, '', NO.SELECT.IDS, SYSTEM.RETURN.CODE)

*     IF NO.SELECT.IDS THEN
*         Y.ID.ACC = LIST.IDS<1>
*         CALL F.READ(FN.ACCOUNT, Y.ID.ACC, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)
*         IF R.ACCOUNT THEN
*             Y.CUS.BENEF = R.ACCOUNT<AC.CUSTOMER>
*             CALL F.READ(FN.CUSTOMER, Y.CUS.BENEF, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)
*             IF R.CUSTOMER THEN
*                 Y.RFC.BENEF = R.CUSTOMER<EB.CUS.TAX.ID><1,1>
*                 R.NEW(FT.CREDIT.ACCT.NO) = Y.ID.ACC
*                 R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
*                 CALL REBUILD.SCREEN
*             END ELSE
*                 ETEXT = 'No existe registro del cliente asociado la cuenta CLABE'
*                 CALL STORE.END.ERROR
*             END
*         END ELSE
*             ETEXT = 'No existe registro de la cuenta asociada a la cuenta CLABE'
*             CALL STORE.END.ERROR
*         END
*     END ELSE
*         ETEXT = 'La CLABE no esta asociada a ninguna cuenta'
*         CALL STORE.END.ERROR
*     END

*     RETURN

*-------------------------------------------------------------------------------
GET.DATA.TDD.CUS:
*-------------------------------------------------------------------------------

    EB.DataAccess.Readlist(SELECT.CMD, LIST.IDS, '', NO.SELECT.IDS, SYSTEM.RETURN.CODE)
    IF NO.SELECT.IDS THEN
        Y.TDD.ID = LIST.IDS<1>
        R.ET.SAP.TARJETA = ABC.BP.EtSapTarjeta.Read(Y.TDD.ID, Y.ERR.TARJETA)
        IF R.ET.SAP.TARJETA THEN
            Y.ID.ACC = R.ET.SAP.TARJETA<ABC.BP.EtSapTarjeta.EtSapTarjetaAccountId> ;*R.ET.SAP.TARJETA<CRD.ACCOUNT.ID>
            Y.CUS.BENEF = R.ET.SAP.TARJETA<ABC.BP.EtSapTarjeta.EtSapTarjetaCustomerId> ;*R.ET.SAP.TARJETA<CRD.CUSTOMER.ID>
            R.CUSTOMER = ST.Customer.Customer.Read(Y.CUS.BENEF, Y.ERR.CUS)
            IF R.CUSTOMER THEN
                EB.SystemTables.setComi(Y.CUS.BENEF:'*1') ;*COMI = Y.CUS.BENEF:'*1'
                ABC.BP.vpmVCustomerName()
                Y.NOMBRE = EB.SystemTables.getComiEnri() ;*COMI.ENRI
                EB.SystemTables.setComi(Y.CTA.BENEF) ;*COMI = Y.CTA.BENEF
                Y.RFC.BENEF = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId><1,1> ;*R.CUSTOMER<EB.CUS.TAX.ID><1,1>
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.ID.ACC) ;*R.NEW(FT.CREDIT.ACCT.NO) = Y.ID.ACC
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.NOMBRE) ;*R.NEW(FT.PAYMENT.DETAILS) = Y.NOMBRE
                sYLocalRef = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
*R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
                sYLocalRef<1, Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, sYLocalRef)
                EB.Display.RebuildScreen() ;*CALL REBUILD.SCREEN
            END ELSE
                EB.SystemTables.setEtext('No existe registro del cliente asociado a la TDD') ;*ETEXT = 'No existe registro del cliente asociado a la TDD'
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            EB.SystemTables.setEtext('No existe registro de la TDD: ':Y.TDD.ID) ;*ETEXT = 'No existe registro de la TDD: ':Y.TDD.ID
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        EB.SystemTables.setEtext('No existe registro de la TDD: ':Y.TDD.ID) ;*ETEXT = 'No existe registro de la TDD: ':Y.TDD.ID
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

*-------------------------------------------------------------------------------
GET.MISMO.BANCO:
*-------------------------------------------------------------------------------

    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ID.ACC, Y.ERR.ACC)
* Before incorporation : CALL F.READ(FN.ACCOUNT, Y.ID.ACC, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)
    IF R.ACCOUNT THEN
        Y.CUS.BENEF = R.ACCOUNT<AC.AccountOpening.Account.Customer> ;*R.ACCOUNT<AC.CUSTOMER>
        R.CUSTOMER = ST.Customer.Customer.Read(Y.CUS.BENEF, Y.ERR.CUS)
        IF R.CUSTOMER THEN
            EB.SystemTables.setComi(Y.CUS.BENEF:'*1') ;*COMI = Y.CUS.BENEF:'*1'
            ABC.BP.vpmVCustomerName()
            Y.NOMBRE = EB.SystemTables.getComiEnri() ;*COMI.ENRI
            EB.SystemTables.setComi(Y.CTA.BENEF) ;*COMI = Y.CTA.BENEF
            Y.RFC.BENEF = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId><1,1> ;*R.CUSTOMER<EB.CUS.TAX.ID><1,1>
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.ID.ACC) ;*R.NEW(FT.CREDIT.ACCT.NO) = Y.ID.ACC
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.NOMBRE) ;*EBR.NEW(FT.PAYMENT.DETAILS) = Y.NOMBRE
            sYLocalRef = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            sYLocalRef<1, Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, sYLocalRef) ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
            EB.Display.RebuildScreen() ;*CALL REBUILD.SCREEN
        END ELSE
            EB.SystemTables.setEtext('No existe registro del cliente asociado la cuenta') ;*ETEXT = 'No existe registro del cliente asociado la cuenta'
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        R.ALTERNATE.ACCOUNT = AC.AccountOpening.AlternateAccount.Read(Y.ID.ACC, Y.ERR.ALT.ACC)
* Before incorporation : CALL F.READ(FN.ALTERNATE.ACCOUNT, Y.ID.ACC, R.ALTERNATE.ACCOUNT, F.ALTERNATE.ACCOUNT, Y.ERR.ALT.ACC)
        IF R.ALTERNATE.ACCOUNT THEN
            Y.ID.ACC = R.ALTERNATE.ACCOUNT<1>
            R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ID.ACC, Y.ERR.ACC)
* Before incorporation : CALL F.READ(FN.ACCOUNT, Y.ID.ACC, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)
            IF R.ACCOUNT THEN
                Y.CUS.BENEF = R.ACCOUNT<AC.AccountOpening.Account.Customer> ;*R.ACCOUNT<AC.CUSTOMER>
                R.CUSTOMER = ST.Customer.Customer.Read(Y.CUS.BENEF, Y.ERR.CUS)
                IF R.CUSTOMER THEN
                    EB.SystemTables.setComi(Y.CUS.BENEF:'*1') ;*COMI = Y.CUS.BENEF:'*1'
                    ABC.BP.vpmVCustomerName()
                    Y.NOMBRE = EB.SystemTables.getComiEnri() ;*COMI.ENRI
                    EB.SystemTables.setComi(Y.CTA.BENEF) ;*COMI = Y.CTA.BENEF
                    Y.RFC.BENEF = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId><1,1> ;*R.CUSTOMER<EB.CUS.TAX.ID><1,1>
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.ID.ACC) ;*R.NEW(FT.CREDIT.ACCT.NO) = Y.ID.ACC
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.NOMBRE) ;*EBR.NEW(FT.PAYMENT.DETAILS) = Y.NOMBRE
                    sYLocalRef = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    sYLocalRef<1, Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, sYLocalRef) ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI> = Y.RFC.BENEF
                    EB.Display.RebuildScreen()
                END ELSE
                    EB.SystemTables.setEtext('No existe registro del cliente asociado a la cuenta') ;*ETEXT = 'No existe registro del cliente asociado a la cuenta'
                    EB.ErrorProcessing.StoreEndError()
                END
            END ELSE
                EB.SystemTables.setEtext('No existe registro de la cuenta') ;*ETEXT = 'No existe registro de la cuenta'
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            EB.SystemTables.setEtext('No existe registro del PRN ingresado') ;*ETEXT = 'No existe registro del PRN ingresado'
            EB.ErrorProcessing.StoreEndError()
        END
    END


RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
