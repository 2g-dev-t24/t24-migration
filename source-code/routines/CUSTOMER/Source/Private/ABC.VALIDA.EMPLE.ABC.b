*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.EMPLE.ABC(V.STAFF.OFF)


    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Display

    V.APP      = "CUSTOMER"
    V.FLD.NAME = "NO.EMPL"
    V.FLD.POS  = ""

    EB.LocalReferences.GetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)
    V.NO.EMP.POS = V.FLD.POS<1,1>

    V.STAFF.OFF = TRIM(V.STAFF.OFF)

    IF V.STAFF.OFF EQ "Y" THEN
        tmp=EB.SystemTables.getTLocref()
        tmp<V.NO.EMP.POS,7>=""
        EB.SystemTables.setTLocref(tmp)
    END

    IF V.STAFF.OFF EQ "N" THEN
        Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.LOCAL.REF<1,V.NO.EMP.POS> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
        EB.Display.RebuildScreen() 
*        CALL REFRESH.GUI.OBJECTS

        tmp=EB.SystemTables.getTLocref()
        tmp<V.NO.EMP.POS,7>="NOINPUT"
        EB.SystemTables.setTLocref(tmp)
    END
    Y.LOCAL.REF<1,107> = ""
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
RETURN
END
