*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.FILL.DEBIT.ACCT.CASHIN
*===============================================================================
*===============================================================================

    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING FT.Contract

    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

    RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    NOM.CAMPOS     = 'ID.ADMIN':@VM:'ID.COMI'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER',NOM.CAMPOS,POS.CAMP.LOCAL)

    Y.POS.ID.ADMIN = POS.CAMP.LOCAL<1,1>
    Y.POS.ID.COMI  = POS.CAMP.LOCAL<1,2>

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)

    RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.ID.PARAM = 'CUENTAS.ABONO.SERVICIOS.CASHIN'
    R.PARAMETROS = ''
    Y.GRL.ERR = ''

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID.PARAM,R.PARAMETROS,F.ABC.GENERAL.PARAM,Y.GRL.ERR)

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.LIST.COMNTS = ''

    Y.LIST.PARAMS = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro>)
    Y.LIST.COMNTS = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.Comentario>)

    Y.CUENTA = ''
    EB.SystemTables.setEtext('')

    GOSUB VAL.ADMI
    GOSUB VAL.COMI

    IF Y.CUENTA EQ '' THEN
        EB.SystemTables.setEtext('Cuenta sin Registro')
        EB.ErrorProcessing.StoreEndError()
    END

    RETURN

*-----------------------------------------------------------------------------
VAL.ADMI:
*-----------------------------------------------------------------------------

    Y.SERVICE.TYPE = ''
    Y.SERVICE.TYPE = Y.LOCAL.REF<1,Y.POS.ID.ADMIN>

    Y.NO.CONT = ''
    Y.NO.CONT = DCOUNT(Y.LIST.PARAMS,@FM)

    FOR X = 1 TO Y.NO.CONT

        Y.CTA.DEBIT = ''
        Y.CTA.COMNT = ''
        Y.CTA.NMBRS = ''

        Y.CTA.DEBIT = Y.LIST.VALUES<X>
        Y.CTA.COMNT = Y.LIST.COMNTS<X>
        Y.CTA.NMBRS = Y.LIST.PARAMS<X>

        IF Y.CTA.NMBRS EQ Y.SERVICE.TYPE AND Y.CTA.COMNT EQ 'ADMINISTRADOR' THEN
            Y.CUENTA = Y.CTA.DEBIT
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.CUENTA)
            EB.Display.RebuildScreen()
            RETURN
        END

    NEXT X

    RETURN

*-----------------------------------------------------------------------------
VAL.COMI:
*-----------------------------------------------------------------------------

    IF Y.CUENTA THEN
        RETURN
    END

    Y.SERVICE.TYPE = ''
    Y.SERVICE.TYPE = Y.LOCAL.REF<1,Y.POS.ID.COMI>

    Y.NO.CONT = ''
    Y.NO.CONT = DCOUNT(Y.LIST.PARAMS,@FM)

    FOR X = 1 TO Y.NO.CONT

        Y.CTA.DEBIT = ''
        Y.CTA.COMNT = ''
        Y.CTA.NMBRS = ''

        Y.CTA.DEBIT = Y.LIST.VALUES<X>
        Y.CTA.COMNT = Y.LIST.COMNTS<X>
        Y.CTA.NMBRS = Y.LIST.PARAMS<X>

        IF Y.CTA.NMBRS EQ Y.SERVICE.TYPE AND Y.CTA.COMNT EQ 'COMISIONISTA' THEN
            Y.CUENTA = Y.CTA.DEBIT
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.CUENTA)
            EB.Display.RebuildScreen()
            RETURN
        END

    NEXT X

    RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

    RETURN

END
