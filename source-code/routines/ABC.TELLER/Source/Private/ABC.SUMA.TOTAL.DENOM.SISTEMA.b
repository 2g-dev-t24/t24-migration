*-----------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.SUMA.TOTAL.DENOM.SISTEMA
* ======================================================================
* Nombre de Programa : ABC.SUMA.TOTAL.DENOM.SISTEMA
* Parametros         :
* Objetivo           : Actualiza el total de denominaciónes en físico y la diferencia con loq ue tiene el sistema
* Requerimiento      : CORE-1305 Generar alertas para cuando se exceda el límite de efectivo y cuando se hacen arqueos
* Desarrollador      : CAST - FyG-Solutions
* Compania           : ABC Capital
* Fecha Creacion     : 
* Modificaciones     :
* ======================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Config
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING AbcTable

    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

    RETURN

*----------
INICIA:
*----------
    IF EB.SystemTables.getComi() EQ "" THEN
        EB.SystemTables.setComi(0)
    END

    RETURN
*----------
*----------
ABRE.ARCHIVOS:
*----------
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    F.TELLER.DENOMINATION = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION, F.TELLER.DENOMINATION)

    RETURN
*----------
*----------
PROCESO:
*----------

    Y.NO.DENOM = DCOUNT(EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Denom),VM)
    FOR Y.AA=1 TO Y.NO.DENOM
        IF Y.AA EQ EB.SystemTables.getAv() THEN
            Y.CANTIDAD = EB.SystemTables.getComi()
        END ELSE
            Y.CANTIDAD = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.CantidadFis)<1,Y.AA>
        END
        Y.DENOM = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Denom)<1,Y.AA>
        R.TELLER.DENOMINATION=""
        EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DENOM,R.TELLER.DENOMINATION,F.TELLER.DENOMINATION,ERR.TELLER.DENOMINATION)
        IF R.TELLER.DENOMINATION THEN
            Y.VALOR = R.TELLER.DENOMINATION<TT.Config.TellerDenomination.DenValue>
            Y.TOTAL.X.DENOM = Y.CANTIDAD * Y.VALOR
        END
        Y.TOTAL += Y.TOTAL.X.DENOM
    NEXT Y.AA
    
    EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.TotalFis, Y.TOTAL)
    Y.TOTAL.SISTEMA = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Total)
    Y.TOTAL.SIS.TOTAL = Y.TOTAL.SISTEMA - Y.TOTAL
    EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Diferencia, Y.TOTAL.SIS.TOTAL)
    EB.Display.RebuildScreen()

    RETURN
*----------

END
