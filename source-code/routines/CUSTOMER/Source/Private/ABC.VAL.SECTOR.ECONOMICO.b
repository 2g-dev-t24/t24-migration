$PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.SECTOR.ECONOMICO
*===============================================================================

    $USING EB.SystemTables
    $USING MXBASE.CustomerRegulatory
    $USING EB.DataAccess
    $USING AbcTable

    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    Y.ID.ACT.ECONOMICA = EB.SystemTables.getComi()

    FN.ABC.ACTIVIDAD.ECONOMICA = 'F.ABC.ACTIVIDAD.ECONOMICA'
    F.ABC.ACTIVIDAD.ECONOMICA = ''
    
    EB.DataAccess.Opf(FN.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA)
    

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

    Y.ID.ACT.ECONOMICA = FIELD(Y.ID.ACT.ECONOMICA, "~", 1)
    Y.ID.ACT.ECONOMICA = FIELD(Y.ID.ACT.ECONOMICA, "*", 2)

    EB.DataAccess.FRead(FN.ABC.ACTIVIDAD.ECONOMICA, Y.ID.ACT.ECONOMICA, R.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, Y.ERR.ACT)
    
    Y.SECTOR.ECONOMICO = R.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.SectorEconomico>
    Y.SECTOR.ECONOMICO = "CNBV.ECO.ACTIVITY*":Y.SECTOR.ECONOMICO

    EB.SystemTables.setRNew(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.CnbvEcoActivityCode, Y.SECTOR.ECONOMICO)

    RETURN
