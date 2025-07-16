*-----------------------------------------------------------------------------
* <Rating>928</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.STORE.INFO.SMS.EMAIL

*-----------------------------------------------------------------------------
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.Updates
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Utility

    GOSUB INIT

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.ABC.SMS.EMAIL.TO.SEND = 'F.ABC.SMS.EMAIL.TO.SEND'
    F.ABC.SMS.EMAIL.TO.SEND = ''
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.TO.SEND, F.ABC.SMS.EMAIL.TO.SEND)

    FN.ABC.EMAIL.SMS.PARAMETER = 'F.ABC.EMAIL.SMS.PARAMETER'
    F.ABC.EMAIL.SMS.PARAMETER = ''
    EB.DataAccess.Opf(FN.ABC.EMAIL.SMS.PARAMETER, F.ABC.EMAIL.SMS.PARAMETER)

    FN.ABC.BANC.INT.IMP = 'F.ABC.BANC.INT.IMP'
    F.ABC.BANC.INT.IMP = ''
    EB.DataAccess.Opf(FN.ABC.BANC.INT.IMP,F.ABC.BANC.INT.IMP)

    EB.DataAccess.FRead(FN.ABC.EMAIL.SMS.PARAMETER,'SYSTEM',Y.REC.PARAM,F.ABC.EMAIL.SMS.PARAMETER,YERR.PARAMETER)

    IF NOT(Y.REC.PARAM) THEN
        RETURN
    END

    Y.FNCTION = EB.SystemTables.getVFunction()
*Identificamos cuando se genera una reversa para notificarlo al cliente
    IF (INDEX('R',Y.FNCTION,1) OR (INDEX('A',Y.FNCTION,1) AND EB.SystemTables.getRNew(V - 8) EQ 'RNAU')) AND EB.SystemTables.getApplication() NE 'ABC.CUENTAS.DESTINO' THEN
        EB.DataAccess.FRead(FN.ABC.SMS.EMAIL.TO.SEND,Y.REFERENCE,Y.REC,F.ABC.SMS.EMAIL.TO.SEND,YERR.SMSEMAIL)
        IF NOT(Y.REC) THEN
            RETURN
        END

*Si la transaccion es del mismo dia entonces es
        FINDSTR Y.JULDATE IN Y.REFERENCE SETTING Ap, Vp THEN
            IF Y.REC<AbcTable.AbcSmsEmailToSend.Status> EQ '' THEN
                Y.REC<AbcTable.AbcSmsEmailToSend.Status> = 'ROK'
            END ELSE
                Y.REC<AbcTable.AbcSmsEmailToSend.Status> = 'R'
            END

            Y.BANDERA.REV = 'R'
            GOSUB ESCRIBE.REGISTRO
        END ELSE
            RETURN
        END

    END ELSE
        BEGIN CASE
        CASE EB.SystemTables.getApplication() EQ 'AC.LOCKED.EVENTS'
            GOSUB COMPRA.POS
        CASE EB.SystemTables.getApplication() EQ 'ABC.CUENTAS.DESTINO'
            IF INDEX('I',Y.FNCTION,1) OR Y.FNCTION EQ ''  THEN
                GOSUB TRANSACCION.BANCA.INTERNET.2
            END ELSE
                GOSUB TRANSACCION.BANCA.INTERNET
            END

        CASE EB.SystemTables.getApplication() EQ 'CUSTOMER'
            GOSUB TRANSACCION.CUSTOMER
        CASE EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER'
            GOSUB TRANSACCION.ATM.SPEI
        END CASE


    END

    RETURN
***********
COMPRA.POS:
***********

    Y.DEBIT.ACCT = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    Y.TRANS.TYPE = 'POS'

    Y.CUSTOMER = ''
    GOSUB GET.CUSTOMER

    Y.AMOUNT = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLockedAmount)
    Y.TIME = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckDateTime)[7,2]:":":EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckDateTime)[9,2]


    GOSUB ESCRIBE.REGISTRO

    RETURN
*********************
TRANSACCION.ATM.SPEI:
*********************

    Y.FT.TRANSACTION = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)


    FIND Y.FT.TRANSACTION IN Y.REC.PARAM<AbcTable.AbcEmailSmsParameter.Transaction> SETTING Ap,Vp THEN
        Y.TRANS.TYPE = Y.REC.PARAM<AbcTable.AbcEmailSmsParameter.TranType,Vp>
    END ELSE
        Y.SALIR = 'S'
    END

    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER',"CTA.EXT.TRANSF",CTA.EXT.TRANSF.POS)


    Y.AMOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    IF Y.AMOUNT EQ '' THEN
        Y.AMOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    END

    Y.AMOUNT = FMT(Y.AMOUNT, "15L,2")

    Y.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)[7,2]:":":EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)[9,2]

    IF Y.TRANS.TYPE EQ 'SPEI' THEN
        Y.DEBIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
        Y.CREDIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,CTA.EXT.TRANSF.POS>
        Y.CUSTOMER = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCustomer)
    END ELSE
        IF EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)[1,3] EQ 'MXN' THEN
            Y.DEBIT.ACCT = ''
            Y.CREDIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            Y.CUSTOMER = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCustomer)
        END ELSE
            Y.DEBIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
            Y.CUSTOMER = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCustomer)

            IF EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)[1,3] EQ 'MXN' THEN
                Y.CREDIT.ACCT = ''
            END ELSE
                Y.CREDIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            END
        END
    END

    GOSUB ESCRIBE.REGISTRO

    RETURN
*********************
TRANSACCION.CUSTOMER:
*********************

    Y.CUSTOMER = Y.REFERENCE
    Y.TIME = OCONV(TIME(),'MTS')
    Y.TIME = Y.TIME[1,5]

    Y.OLD.EMAIL = EB.SystemTables.getROld(ST.Customer.Customer.EbCusEmailOne)<1,1>
    Y.OLD.MOVIL = EB.SystemTables.getROld(ST.Customer.Customer.EbCusSmsOne)<1,1>
    Y.NEW.EMAIL  = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusEmailOne)<1,1>
    Y.NEW.MOVIL  = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSmsOne)<1,1>

    Y.SAVE.REF = Y.REFERENCE
    IF Y.OLD.EMAIL NE Y.NEW.EMAIL THEN
        Y.TRANS.TYPE = 'CUEM'
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE
        GOSUB ESCRIBE.REGISTRO
    END

    IF Y.OLD.MOVIL NE Y.NEW.MOVIL THEN
        Y.TRANS.TYPE = 'CUMO'
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE
        GOSUB ESCRIBE.REGISTRO
    END

    RETURN
***************************
TRANSACCION.BANCA.INTERNET:
***************************

    Y.BANCA.REC = ''
    Y.CUSTOMER = FIELD(Y.REFERENCE,'.',1)
    Y.CUENTA = FIELD(Y.REFERENCE,'.',2)

*Se modifica la referencia para conservar el funcionamiento original
*de las notificaciones de Email y SMS
    Y.REFERENCE = Y.CUSTOMER
    Y.TIME = OCONV(TIME(),'MTS')
    Y.TIME = Y.TIME[1,5]
    Y.STATUS.CTA = ''
    Y.TIPO.CTA = ''

    Y.ID.BIIMP = Y.CUSTOMER:'.':TODAY
    EB.DataAccess.FRead(FN.ABC.BANC.INT.IMP,Y.ID.BIIMP,Y.BANCA.REC,F.ABC.BANC.INT.IMP,YERR.BCNINTIMP)
    IF NOT(Y.BANCA.REC) THEN
        Y.SALIR = 'S'
        RETURN
    END
    GOSUB REVISA.CUENTAS

    Y.SAVE.REF = Y.REFERENCE
    IF Y.CTA.TERCERO.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAT'
        Y.CTA.TERCERO = Y.CTA.TERCERO.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.TERCERO = ''
    END

    IF Y.CTA.TERCERO.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMT'
        Y.CTA.TERCERO = Y.CTA.TERCERO.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.TERCERO = ''

    END

    IF Y.CTA.TERCERO.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBT'

        Y.CTA.TERCERO = Y.CTA.TERCERO.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.TERCERO = ''

    END

    IF Y.CTA.INTERBA.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAI'
        Y.CTA.INTERBA = Y.CTA.INTERBA.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.INTERBA.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMI'
        Y.CTA.INTERBA = Y.CTA.INTERBA.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.INTERBA.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBI'
        Y.CTA.INTERBA = Y.CTA.INTERBA.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CREDITO.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAC'
        Y.CTA.CREDITO = Y.CTA.CREDITO.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CREDITO.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMC'
        Y.CTA.CREDITO = Y.CTA.CREDITO.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CREDITO.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBC'
        Y.CTA.CREDITO = Y.CTA.CREDITO.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END
    IF Y.CTA.DEBITO.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAD'
        Y.CTA.DEBITO = Y.CTA.DEBITO.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.DEBITO.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMD'
        Y.CTA.DEBITO = Y.CTA.DEBITO.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.DEBITO.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBD'
        Y.CTA.DEBITO = Y.CTA.DEBITO.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CELULAR.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BACE'
        Y.CTA.CELULAR = Y.CTA.CELULAR.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CELULAR.MODI NE '' THEN
        Y.TRANS.TYPE = 'BMCE'
        Y.CTA.CELULAR = Y.CTA.CELULAR.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CELULAR.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BBCE'
        Y.CTA.CELULAR = Y.CTA.CELULAR.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB ESCRIBE.REGISTRO
        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    RETURN
*****************************
TRANSACCION.BANCA.INTERNET.2:
*****************************

    Y.CUSTOMER = FIELD(Y.REFERENCE,'.',1)
    Y.CUENTA = FIELD(Y.REFERENCE,'.',2)

*Se modifica la referencia para conservar el funcionamiento original
*de las notificaciones de Email y SMS
    Y.REFERENCE = Y.CUSTOMER

    Y.STATUS.CTA = ''
    Y.TIPO.CTA = ''
    Y.BANCA.REC = ''

    Y.TIME = OCONV(TIME(),'MTS')
    Y.TIME = Y.TIME[1,5]

    GOSUB REVISA.CUENTAS

    Y.SAVE.REF = Y.REFERENCE
    IF Y.CTA.TERCERO.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAT'
        Y.CTA.TERCERO = Y.CTA.TERCERO.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.TERCERO = ''
    END

    IF Y.CTA.TERCERO.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMT'
        Y.CTA.TERCERO = Y.CTA.TERCERO.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.TERCERO = ''

    END

    IF Y.CTA.TERCERO.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBT'

        Y.CTA.TERCERO = Y.CTA.TERCERO.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.TERCERO = ''

    END

    IF Y.CTA.INTERBA.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAI'
        Y.CTA.INTERBA = Y.CTA.INTERBA.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.INTERBA.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMI'
        Y.CTA.INTERBA = Y.CTA.INTERBA.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.INTERBA.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBI'
        Y.CTA.INTERBA = Y.CTA.INTERBA.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CREDITO.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAC'
        Y.CTA.CREDITO = Y.CTA.CREDITO.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CREDITO.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMC'
        Y.CTA.CREDITO = Y.CTA.CREDITO.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CREDITO.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBC'
        Y.CTA.CREDITO = Y.CTA.CREDITO.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END
    IF Y.CTA.DEBITO.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BIAD'
        Y.CTA.DEBITO = Y.CTA.DEBITO.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.DEBITO.MODI NE '' THEN
        Y.TRANS.TYPE = 'BIMD'
        Y.CTA.DEBITO = Y.CTA.DEBITO.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.DEBITO.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BIBD'
        Y.CTA.DEBITO = Y.CTA.DEBITO.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CELULAR.ALTA NE '' THEN
        Y.TRANS.TYPE = 'BACE'
        Y.CTA.CELULAR = Y.CTA.CELULAR.ALTA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CELULAR.MODI NE '' THEN
        Y.TRANS.TYPE = 'BMCE'
        Y.CTA.CELULAR = Y.CTA.CELULAR.MODI
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    IF Y.CTA.CELULAR.BAJA NE '' THEN
        Y.TRANS.TYPE = 'BBCE'
        Y.CTA.CELULAR = Y.CTA.CELULAR.BAJA
        Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE

        GOSUB NOTIFICA.SUC.OPE

        Y.CTA.INTERBA = ''
    END

    RETURN
*************
GET.CUSTOMER:
*************

    IF Y.CUSTOMER EQ '' THEN
        EB.DataAccess.FRead(FN.ACCOUNT,Y.DEBIT.ACCT,Y.ACC.REC,F.ACCOUNT,YERR.ACC)
        IF Y.ACC.REC THEN
            Y.CUSTOMER = Y.ACC.REC<AC.AccountOpening.Account.Customer>
        END

    END

    RETURN
*****************
NOTIFICA.SUC.OPE:
*****************

    IF Y.TRANS.TYPE MATCHES Y.REC.PARAM<AbcTable.AbcEmailSmsParameter.TranTypeTwo> THEN
        IF INDEX('I',Y.FNCTION,1) OR Y.FNCTION EQ ''  THEN
            Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE:".INPUT"
            GOSUB ESCRIBE.REGISTRO
        END ELSE
            IF INDEX('A',Y.FNCTION,1) THEN
                Y.OPERATOR = EB.SystemTables.getOperator()
                Y.AUTH.USR = Y.OPERATOR
                Y.REFERENCE = Y.SAVE.REF:".":Y.TRANS.TYPE:".AUTH"
                GOSUB ESCRIBE.REGISTRO
            END ELSE
                RETURN
            END
        END
    END

    RETURN
***************
REVISA.CUENTAS:
***************

    Y.TIPO.CTA = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipoCta)
    IF EB.SystemTables.getIdOld() NE '' THEN
        IF EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.RecordStatus) EQ "RNAU" THEN
            Y.STATUS.CTA = 'B'
        END ELSE
            Y.STATUS.CTA = 'M'
        END
    END ELSE
        Y.STATUS.CTA = 'A'

    END

    BEGIN CASE
    CASE Y.STATUS.CTA EQ 'A'
        BEGIN CASE
        CASE Y.TIPO.CTA EQ 'CUENTA'
            Y.CTA.TERCERO.ALTA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'CLABE'
            Y.CTA.INTERBA.ALTA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'TARJETA DE CREDITO'
            Y.CTA.CREDITO.ALTA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'TARJETA DEBITO'
            Y.CTA.DEBITO.ALTA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'CELULAR'
            Y.CTA.CELULAR.ALTA<-1> = Y.CUENTA
        END CASE

    CASE Y.STATUS.CTA EQ 'M'
        Y.BANDERA = ''

        IF EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Alias) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Alias) OR EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Beneficiario) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Beneficiario) OR EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Email) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Email) OR EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Movil) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Movil) THEN
            Y.BANDERA = 'S'
        END

        IF Y.BANDERA EQ 'S' THEN
            BEGIN CASE
            CASE Y.TIPO.CTA EQ 'CUENTA'
                Y.CTA.TERCERO.MODI<-1> = Y.CUENTA
            CASE Y.TIPO.CTA EQ 'CLABE'
                Y.CTA.INTERBA.MODI<-1> = Y.CUENTA
            CASE Y.TIPO.CTA EQ 'TARJETA DE CREDITO'
                Y.CTA.CREDITO.MODI<-1> = Y.CUENTA
            CASE Y.TIPO.CTA EQ 'TARJETA DEBITO'
                Y.CTA.DEBITO.MODI<-1> = Y.CUENTA
            CASE Y.TIPO.CTA EQ 'CELULAR'
                Y.CTA.CELULAR.MODI<-1> = Y.CUENTA
            END CASE
        END

    CASE Y.STATUS.CTA EQ 'B'
        BEGIN CASE
        CASE Y.TIPO.CTA EQ 'CUENTA'
            Y.CTA.TERCERO.BAJA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'CLABE'
            Y.CTA.INTERBA.BAJA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'TARJETA DE CREDITO'
            Y.CTA.CREDITO.BAJA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'TARJETA DEBITO'
            Y.CTA.DEBITO.BAJA<-1> = Y.CUENTA
        CASE Y.TIPO.CTA EQ 'CELULAR'
            Y.CTA.CELULAR.BAJA<-1> = Y.CUENTA
        END CASE

    END CASE

    RETURN
*****************
ESCRIBE.REGISTRO:
*****************

    IF Y.SALIR EQ 'S' THEN RETURN
    IF Y.BANDERA.REV EQ '' THEN
        Y.REC<AbcTable.AbcSmsEmailToSend.CustomerId> = Y.CUSTOMER
        Y.REC<AbcTable.AbcSmsEmailToSend.DebitAcctNo> = Y.DEBIT.ACCT
        Y.REC<AbcTable.AbcSmsEmailToSend.CreditAcctNo> = Y.CREDIT.ACCT
        Y.REC<AbcTable.AbcSmsEmailToSend.TransType> = Y.TRANS.TYPE
        Y.REC<AbcTable.AbcSmsEmailToSend.Amount> = Y.AMOUNT
        Y.REC<AbcTable.AbcSmsEmailToSend.DateTime> = Y.TIME
        Y.REC<AbcTable.AbcSmsEmailToSend.Status> = ''
        Y.REC<AbcTable.AbcSmsEmailToSend.OldEmail> = Y.OLD.EMAIL
        Y.REC<AbcTable.AbcSmsEmailToSend.OldMovil> = Y.OLD.MOVIL
        Y.REC<AbcTable.AbcSmsEmailToSend.NewEmail> = Y.NEW.EMAIL
        Y.REC<AbcTable.AbcSmsEmailToSend.NewMovil> = Y.NEW.MOVIL
        Y.REC<AbcTable.AbcSmsEmailToSend.ValueDate> = TODAY
        Y.REC<AbcTable.AbcSmsEmailToSend.Inputter> = EB.SystemTables.getRNew(V - 6)
        Y.REC<AbcTable.AbcSmsEmailToSend.Authoriser> = Y.AUTH.USR

        IF Y.CTA.TERCERO NE '' THEN
            FOR YY=1 TO DCOUNT(Y.CTA.TERCERO,@FM)
                Y.REC<AbcTable.AbcSmsEmailToSend.CtaTercero,YY> = Y.CTA.TERCERO<YY>
            NEXT YY
        END ELSE
            Y.REC<AbcTable.AbcSmsEmailToSend.CtaTercero> = ""
        END

        IF Y.CTA.INTERBA NE '' THEN
            FOR YY=1 TO DCOUNT(Y.CTA.INTERBA,@FM)
                Y.REC<AbcTable.AbcSmsEmailToSend.CtaInterba,YY> = Y.CTA.INTERBA<YY>
            NEXT YY
        END ELSE
            Y.REC<AbcTable.AbcSmsEmailToSend.CtaInterba> = ""
        END

        IF Y.CTA.CREDITO NE '' THEN
            FOR YY=1 TO DCOUNT(Y.CTA.CREDITO,@FM)
                Y.REC<AbcTable.AbcSmsEmailToSend.CtaCredito,YY> = Y.CTA.CREDITO<YY>
            NEXT YY
        END ELSE
            Y.REC<AbcTable.AbcSmsEmailToSend.CtaCredito> = ""
        END
        IF Y.CTA.DEBITO NE '' THEN
            FOR YY=1 TO DCOUNT(Y.CTA.DEBITO,@FM)
                Y.REC<AbcTable.AbcSmsEmailToSend.CtaDebito,YY> = Y.CTA.CREDITO<YY>
            NEXT YY
        END ELSE
            Y.REC<AbcTable.AbcSmsEmailToSend.CtaDebito> = ""
        END

        IF Y.CTA.CELULAR NE '' THEN
            FOR YY=1 TO DCOUNT(Y.CTA.CELULAR,@FM)
                Y.REC<AbcTable.AbcSmsEmailToSend.CtaCelular,YY> = Y.CTA.CELULAR<YY>
            NEXT YY
        END ELSE
            Y.REC<AbcTable.AbcSmsEmailToSend.CtaCelular> = ""
        END
    END

    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.TO.SEND,Y.REFERENCE,Y.REC)

    Y.REC = ''

    RETURN
*****
INIT:
*****

    Y.CUSTOMER = ''
    Y.CUST.NAME = ''

    Y.ACC.REC = ''
    Y.CREDIT.ACCT = ''
    Y.DEBIT.ACCT = ''
    Y.AMOUNT = ''
    Y.REFERENCE = ID.NEW
    Y.TIME = ''
    Y.TRANS.TYPE = ''
    Y.REC.PARAMETER = ''
    Y.REC = ''
    Y.FT.TRANSACTION = ''
    Y.SALIR = ''
    Y.JULDATE = EB.SystemTables.getRDates(EB.Utility.Dates.DatJulianDate)[3,5]
    Y.EMAIL.POS = ''
    Y.MOVIL.POS = ''
    Y.OLD.EMAIL = ''
    Y.OLD.MOVIL = ''
    Y.NEW.EMAIL = ''
    Y.NEW.MOVIL = ''
    Y.AUTH.USR = ''

    Y.CTA.TERCERO.ALTA = ''
    Y.CTA.TERCERO.MODI = ''
    Y.CTA.TERCERO.BAJA = ''
    Y.CTA.INTERBA.ALTA = ''
    Y.CTA.INTERBA.MODI = ''
    Y.CTA.INTERBA.BAJA = ''
    Y.CTA.CREDITO.ALTA = ''
    Y.CTA.CREDITO.MODI = ''
    Y.CTA.CREDITO.BAJA = ''
    Y.CTA.DEBITO.ALTA = ''
    Y.CTA.DEBITO.MODI = ''
    Y.CTA.DEBITO.BAJA = ''

    Y.CTA.CELULAR.ALTA = ''
    Y.CTA.CELULAR.MODI = ''
    Y.CTA.CELULAR.BAJA = ''
    Y.CTA.TERCERO = ''
    Y.CTA.INTERBA = ''
    Y.CTA.CREDITO = ''
    Y.CTA.DEBITO = ''
    Y.CTA.CELULAR = ''
    Y.BANDERA.REV = ''
    Y.SAVE.REF = ''

    RETURN
***********
END



