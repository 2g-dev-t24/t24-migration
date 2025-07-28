*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.VALIDA.TRANS.TYPE.AC
*===============================================================================
* Nombre de Programa : ABC.VALIDA.TRANS.TYPE.AC
* Objetivo           : @ID-RTN para version de traspaso AC de caja que valida que
*                     que la txn ingresada sea AC
* Desarrollador      : 
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING EB.Security
    $USING FT.Contract
    $USING EB.ErrorProcessing

    GOSUB INICIALIZA
    GOSUB VALIDA
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    EB.DataAccess.Opf(FN.FT.NAU, F.FT.NAU)

    RETURN
*---------------------------------------------------------------
VALIDA:
*---------------------------------------------------------------

    Y.ID.FT = ''
    R.FT = ''
    Y.TRAN.TYPE = ''

    Y.ID.FT = EB.SystemTables.getComi()

    EB.DataAccess.FRead(FN.FT.NAU, Y.ID.FT, R.FT, F.FT.NAU, FT.ERR)

    IF R.FT NE "" THEN
        Y.TRAN.TYPE = R.FT<FT.Contract.FundsTransfer.TransactionType>
        IF Y.TRAN.TYPE NE "AC" THEN
            E = "SOLO TRANSACCIONES DE TRASPASO DE CAJA"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
    EB.Display.RebuildScreen()
    

    RETURN
