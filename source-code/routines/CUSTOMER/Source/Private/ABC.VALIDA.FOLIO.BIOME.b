$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VALIDA.FOLIO.BIOME
*===============================================================================
* Nombre de Programa : ABC.VALIDA.FOLIO.BIOME
* Objetivo           : Rutina para validar el registro de FOLIO.VALIDACION en
* ABC.VALIDACION.BIOMETRICOS, para versiones de FUNDS.TRANSFER
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.Updates
    $USING EB.ErrorProcessing
    
    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.FT = "F.FUNDS.TRANSFER"
    F.FT  = ""
    EB.DataAccess.Opf(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER', 'FOL.VALIDACION', POS.FOL.VAL)

    Y.ACC.CUS = ''
    Y.FOL.VAL = ''
    Y.TRAN.TYPE = ''
    Y.MONTO.TRA = ''

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------
* CASE PARA SELECCIONAR CUENTA DE CLIENTE DEPENDIENDO DEL TRANSACTION.TYPE
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    IF INDEX('R',Y.V.FUNCTION,1) THEN
        Y.ID.FT = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.FT,Y.ID.FT,REC.FT,F.FT,ERR.FT)
        
        IF ERR.FT THEN
            Y.ID.FT.HIS = Y.ID.FT : ";1"
            EB.DataAccess.FRead(FN.FT.HIS,Y.ID.FT.HIS,REC.FT,F.FT.HIS,ERR.FT)
        END
        Y.TRAN.TYPE = REC.FT<FT.Contract.FundsTransfer.TransactionType>
        Y.FOL.VAL = REC.FT<FT.Contract.FundsTransfer.LocalRef, POS.FOL.VAL>

        BEGIN CASE
        CASE Y.TRAN.TYPE EQ 'ACSE'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>

        CASE Y.TRAN.TYPE EQ 'ACSR'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>

        CASE Y.TRAN.TYPE EQ 'ACSD'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>

        CASE Y.TRAN.TYPE EQ 'AC'
            Y.ACC.CUS = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>

        END CASE
    END ELSE
        Y.TRAN.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
        Y.LOCAL.REF.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.FOL.VAL = Y.LOCAL.REF.FT<1, POS.FOL.VAL>
        Y.STA.REG = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)

        BEGIN CASE

        CASE Y.TRAN.TYPE EQ 'ACSE'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

        CASE Y.TRAN.TYPE EQ 'ACSR'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

        CASE Y.TRAN.TYPE EQ 'ACSD'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

        CASE Y.TRAN.TYPE EQ 'AC'
            Y.MONTO.TRA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
            Y.ACC.CUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

        END CASE
    END

    Y.DATOS<-1> = Y.ACC.CUS
    Y.DATOS<-1> = Y.FOL.VAL
    Y.DATOS<-1> = Y.MONTO.TRA

    ABC.BP.AbcValidaVerificaFolio(Y.DATOS, Y.ERROR)
    EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
    EB.SystemTables.setAv(POS.FOL.VAL)
    IF Y.ERROR NE '' THEN
        EB.SystemTables.setE(Y.ERROR)
        EB.ErrorProcessing.Err()
    END

    RETURN

END