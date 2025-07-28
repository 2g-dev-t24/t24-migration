*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.VAL.MNT.MNOR.UDI.TELL
*===============================================================================
* Nombre de Programa : ABC.VAL.MNT.MNOR.UDI.TELL
* Objetivo           : INPUT RTN para versiones de TELLER normal que valida si el monto
*       de una operacion es menor al maximo permitido sin aplicar validacion de folio
*   , si es menor se asegura el envio de '' en FOL.VALIDACION
* Desarrollador      : 
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING AbcGetGeneralParam
   
    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    Y.ID.GEN.PARAM = 'ABC.MONTO.UDIS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'MONTO.MAXIMO.PESOS' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.MONTO.MAX = Y.LIST.VALUES<YPOS.PARAM>
    END

    EB.LocalReferences.GetLocRef('TELLER', 'FOL.VALIDACION', POS.FOL.VAL)
*    CALL GET.LOC.REF("CUSTOMER", "CLASSIFICATION", POS.CLASSIFICATION)

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

    Y.MONTO.TRA = ''
    Y.FOL.VAL = ''
    Y.ACC.CUS = ''

    Y.ACC.CUS = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
    Y.MONTO.TRA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    Y.FOL.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1, POS.FOL.VAL>

*LEEMOS EL REGISTRO DE LA CUENTA PARA OBTENER EL CLIENTE Y EL NIVEL
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACC.CUS, R.ACC.CUS, F.ACCOUNT, ERR.FOL)

    IF R.ACC.CUS THEN
        Y.ID.CUST = R.ACC.CUS<AC.AccountOpening.Account.Customer>
    END

*LEEMOS EL REGISTRO DEL CLIENTE PARA OBTENER CLASSIFICATION
    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUST, REC.CUSTO, F.CUSTOMER, ERR.CUS)

    IF REC.CUSTO THEN
*        Y.CLASS.CUST = REC.CUSTO<EB.CUS.LOCAL.REF, POS.CLASSIFICATION>
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
    END

    IF (Y.SECTOR NE 1300) AND (Y.SECTOR NE 1301) THEN
        Y.BAND.ENV.NULL = 1
    END

    IF Y.MONTO.TRA LT Y.MONTO.MAX THEN
        Y.BAND.ENV.NULL = 1
    END

    IF Y.BAND.ENV.NULL EQ 1 THEN
        TT.LOCAL.REF<1, POS.FOL.VAL>  = ''
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END


    EB.Display.RebuildScreen()

    RETURN
