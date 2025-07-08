*===============================================================================
* <Rating>-50</Rating>
*===============================================================================
$PACKAGE AbcSpei
    SUBROUTINE ABC.VAL.LIMIT.MOVS.AC.COMI(Y.ID.MOVS.AC.COMI,Y.MONTO.TRANS,Y.MONTO.LIMIT.PARAM,Y.ID.NEW.FT,Y.ID.ADMIN,Y.ID.COMI,Y.ID.ESTAB,Y.CLIENTE)
*===============================================================================
* Modificaciones:
*===============================================================================

    
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.MONTO.ACUMULADO = 0
    Y.FECHA.MOVI = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")

    RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ABC.MOVS.CTA.COMISIONISTA = "F.ABC.MOVS.CTA.COMISIONISTA"
    F.ABC.MOVS.CTA.COMISIONISTA  = ""
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.COMISIONISTA,F.ABC.MOVS.CTA.COMISIONISTA)

    FN.CURRENCY = "F.CURRENCY"
    F.CURRENCY = ""
    EB.DataAccess.Opf(FN.CURRENCY, F.CURRENCY)

    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    GOSUB GET.MONTO.ACUMULA

    Y.MONTO.VAL.COMI.IN = Y.MONTO.ACUMULADO.IN + Y.MONTO.TRANS
    Y.MONTO.PERMI.IN = Y.MONTO.LIMIT.PARAM - Y.MONTO.ACUMULADO.IN

    IF Y.MONTO.VAL.COMI.IN GT Y.MONTO.LIMIT.PARAM THEN
        ETEXT = "EL MONTO DE LA TRANSACCION SUPERA EL LIMITE PERMITIDO EN CASHIN. SE PERMITE UN MONTO MAXIMO DE ":Y.MONTO.PERMI.IN:" MXN"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        Y.MOVS.IN = R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.OperacionIn>
        Y.NO.MOVS.IN = DCOUNT(Y.MOVS.IN,@VM)

        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.Customer> = Y.CLIENTE
        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.OperacionIn, Y.NO.MOVS.IN+1> = Y.ID.NEW.FT
        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.MontoIn, Y.NO.MOVS.IN+1> = Y.MONTO.TRANS
        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.FechaMovIn, Y.NO.MOVS.IN+1> = Y.FECHA.MOVI
        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.AdminComisIn, Y.NO.MOVS.IN+1> = Y.ID.ADMIN
        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.IdComiIn, Y.NO.MOVS.IN+1> = Y.ID.COMI
        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.ComiEstabIn, Y.NO.MOVS.IN+1> = Y.ID.ESTAB

        R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.MontoTotalIn> = Y.MONTO.VAL.COMI.IN

        EB.DataAccess.FWrite(FN.ABC.MOVS.CTA.COMISIONISTA,Y.ID.MOVS.AC.COMI,R.ABC.MOVS.CTA.COMISIONISTA)
    END

    RETURN

*-------------------------------------------------------------------------------
GET.MONTO.ACUMULA:
*-------------------------------------------------------------------------------

    R.ABC.MOVS.CTA.COMISIONISTA = ''
    Y.ERR.MOVS.AC.COMI = ''
    Y.MONTO.ACUMULADO.IN = ''
    EB.DataAccess.FRead(FN.ABC.MOVS.CTA.COMISIONISTA, Y.ID.MOVS.AC.COMI, R.ABC.MOVS.CTA.COMISIONISTA, F.ABC.MOVS.CTA.COMISIONISTA, Y.ERR.MOVS.AC.COMI)
    IF R.ABC.MOVS.CTA.COMISIONISTA THEN
        Y.MONTO.ACUMULADO.IN = R.ABC.MOVS.CTA.COMISIONISTA<AbcTable.AbcMovsCtaComisionista.MontoTotalIn>
    END

    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

    RETURN

END
