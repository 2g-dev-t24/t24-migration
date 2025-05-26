    $PACKAGE ABC.BP
    SUBROUTINE ABC.CARGA.ACTIVIDAD.ECONOMICA
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ACT.ECONO = ''
    Y.SEC.ECO = ''
    Y.PROHI.OPER = ''
    R.ABC.ACTIVIDAD.ECONOMICA = ''
    Y.ERR.ACT.ECO = ''

    EB.LocalReferences.GetLocRef("CUSTOMER","SECTOR.ECO",Y.POS.SEC.ECO)

    RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ABC.ACTIVIDAD.ECONOMICA = 'F.ABC.ACTIVIDAD.ECONOMICA'
    F.ABC.ACTIVIDAD.ECONOMICA   = ''
    EB.DataAccess.Opf(FN.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA)

    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    Y.ACT.ECONO = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.ABC.ACTIVIDAD.ECONOMICA, Y.ACT.ECONO, R.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, ERR.ACT.ECONO)

    IF R.ABC.ACTIVIDAD.ECONOMICA THEN
        Y.SEC.ECO = R.ABC.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.SectorEconomico>
        Y.PROHI.OPER = R.ABC.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.ProhibOpera>
        Y.CAMPOS.LOCALES = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        IF Y.PROHI.OPER EQ 'SI' THEN

            Y.CAMPOS.LOCALES<1,Y.POS.SEC.ECO> = ""
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.CAMPOS.LOCALES)

            ETEXT = "LA ACTIVIDAD ECONOMICA SELECCIONADA NO ES PERMITIDA"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()

        END ELSE

            Y.CAMPOS.LOCALES<1,Y.POS.SEC.ECO> = Y.SEC.ECO
            EB.Display.RebuildScreen()

        END
    END ELSE

        ETEXT = "NO EXISTE REGISTRO DE LA ACTIVIDAD ECONOMICA"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    RETURN


*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

    RETURN

END
