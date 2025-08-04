$PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.SECTOR.ECONOMICO
*===============================================================================

    $USING EB.SystemTables
    $USING MXBASE.CustomerRegulatory
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.ErrorProcessing

    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    Y.ID.ACT.ECONOMICA = EB.SystemTables.getComi()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()

    FN.ABC.ACTIVIDAD.ECONOMICA = 'F.ABC.ACTIVIDAD.ECONOMICA'
    F.ABC.ACTIVIDAD.ECONOMICA = ''
    
    EB.DataAccess.Opf(FN.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA)
    

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

** Ticket #128 - I
    Y.ID.ACT.ECONOMICA = FIELD(Y.ID.ACT.ECONOMICA, "~", 1)

    Y.ID.ACT.ECONOMICA = FIELD(Y.ID.ACT.ECONOMICA, "*", 2)
    IF LEN(Y.ID.ACT.ECONOMICA) < 7 THEN
        Y.ID.ACT.ECONOMICA = FMT(Y.ID.ACT.ECONOMICA, "R%7")
    END

** Ticket #128 - F

    EB.DataAccess.FRead(FN.ABC.ACTIVIDAD.ECONOMICA, Y.ID.ACT.ECONOMICA, R.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, Y.ERR.ACT)

    IF (Y.PGM.VERSION EQ ",ABC.MORAL.EMPLEO") OR (Y.PGM.VERSION EQ ",ABC.MORAL") THEN
        Y.PROHI.OPER = R.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.ProhibOpera>
        IF Y.PROHI.OPER EQ 'SI' THEN
            ETEXT = "LA ACTIVIDAD ECONOMICA SELECCIONADA NO ES PERMITIDA"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

    Y.SECTOR.ECONOMICO = R.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.SectorEconomico>
    Y.SECTOR.ECONOMICO = "CNBV.ECO.ACTIVITY*":Y.SECTOR.ECONOMICO

    EB.SystemTables.setRNew(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.CnbvEcoActivity, Y.SECTOR.ECONOMICO)

    RETURN
END