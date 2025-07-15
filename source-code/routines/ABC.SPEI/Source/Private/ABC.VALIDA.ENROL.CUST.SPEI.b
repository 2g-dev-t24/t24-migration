$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VALIDA.ENROL.CUST.SPEI
*===============================================================================
* Nombre de Programa : ABC.VALIDA.ENROL.CUST.SPEI
* Objetivo           : Rutina para validar enrolamiento mediante la rtn: ABC.VALIDA.CLIENTE.ENROL
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.Template
    $USING ABC.BP
    $USING EB.ErrorProcessing
    $USING EB.Updates

    GOSUB INICIALIZA
    IF (Y.NIVEL.CTA NE 'NIVEL.1') AND (Y.NIVEL.CTA NE 'NIVEL.2') THEN
        GOSUB VALIDA.CLIENTE
        RETURN
    END ELSE RETURN


*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT   = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    EB.DataAccess.Opf(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    FN.EB.LOOKUP    = 'F.EB.LOOKUP'
    F.EB.LOOKUP    = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP,F.EB.LOOKUP)

    EB.Updates.MultiGetLocRef('ACCOUNT', 'NIVEL', POS.NIVEL)

    Y.ID.CUST = ''
    Y.TRAN.TYPE = ''


    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
* CASE PARA SELECCIONAR CUENTA DE CLIENTE DEPENDIENDO DEL TRANSACTION.TYPE
    IF INDEX('R',Y.V.FUNCTION,1) THEN
        Y.ID.FT = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.FT,Y.ID.FT,REC.FT,F.FT,ERR.FT)
        IF ERR.FT THEN
            Y.ID.FT.HIS = Y.ID.FT : ";1"
            EB.DataAccess.FRead(FN.FT.HIS,Y.ID.FT.HIS,REC.FT,F.FT.HIS,ERR.FT)
        END
        Y.TRAN.TYPE = REC.FT<FT.Contract.FundsTransfer.TransactionType>
        BEGIN CASE
        CASE Y.TRAN.TYPE EQ 'ACSE'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
            EB.SystemTables.setAv(0)

        CASE Y.TRAN.TYPE EQ 'ACSR'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
            EB.SystemTables.setAv(0)

        CASE Y.TRAN.TYPE EQ 'ACSD'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
            EB.SystemTables.setAv(0)

        CASE Y.TRAN.TYPE EQ 'AC'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
            EB.SystemTables.setAv(0)

        END CASE
    END ELSE
        EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
        BEGIN CASE

        CASE Y.TRAN.TYPE EQ 'ACSE'
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
            EB.SystemTables.setAv(0)

        CASE Y.TRAN.TYPE EQ 'ACSR'
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
            EB.SystemTables.setAv(0)

        CASE Y.TRAN.TYPE EQ 'ACSD'
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
            EB.SystemTables.setAv(0)

        CASE Y.TRAN.TYPE EQ 'AC'
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
            EB.SystemTables.setAv(0)

        END CASE
    END

*LEEMOS EL REGISTRO DE LA CUENTA PARA OBTENER EL CLIENTE Y EL NIVEL
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACC.CUS, R.ACC.CUS, FN.ACCOUNT, ERR.FOL)

    IF R.ACC.CUS THEN
        Y.ID.CUST = R.ACC.CUS<AC.AccountOpening.Account.Customer>
        Y.ACCOUNT.CATEGORY = R.ACC.CUS<AC.AccountOpening.Account.Category>
        GOSUB LEER.NIVEL
    END



    RETURN

*---------------------------------------------------------------
VALIDA.CLIENTE:
*---------------------------------------------------------------
    IF Y.ID.CUST THEN
        ABC.BP.AbcValidaClienteEnrol(Y.ID.CUST, Y.ESTATUS)
        IF Y.ESTATUS NE '' THEN
            IF Y.ESTATUS MATCHES "ENCONTRADO" THEN
                RETURN
            END
            ELSE
                EB.SystemTables.setE(Y.ESTATUS)
                EB.ErrorProcessing.Err()
            END
        END
    END

    RETURN

*---------------------------------------------------------------
LEER.NIVEL:
*---------------------------------------------------------------

    Y.EB.LOOKUP = "ABC.NIVEL.CUENTA*":Y.ACCOUNT.CATEGORY
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, ERR.EB.LOOKUP)

    IF R.EB.LOOKUP NE '' THEN
        Y.NIVEL.CTA = R.EB.LOOKUP<EB.Template.Lookup.LuDescription,1>
    END ELSE
        Y.ERROR = "NIVEL DE CUENTA NO CONFIGURADO"
    END

RETURN

END