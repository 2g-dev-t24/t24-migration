*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
 $PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.CUS.MARSTATUS(Y.EDO.CIVIL)
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences

        
    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'ABC.REGIMEN':@VM:'ABC.NOMBRE.CONY'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)
    V.ABC.REGIMEN.POS     = V.FLD.POS<1,1>
    V.ABC.NOMBRE.CONY.POS = V.FLD.POS<1,2>

    IF Y.EDO.CIVIL EQ '2' THEN
        
        tmp=EB.SystemTables.getTLocref()
        tmp<V.ABC.NOMBRE.CONY.POS,7>=""
        tmp<V.ABC.REGIMEN.POS,7>=""
        EB.SystemTables.setTLocref(tmp)
    END 
    ELSE

        Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        
        IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,V.ABC.NOMBRE.CONY.POS> NE '' THEN
            Y.LOCAL.REF<1,V.ABC.NOMBRE.CONY.POS> = ''
        END

        IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,V.ABC.REGIMEN.POS> NE '' THEN
            Y.LOCAL.REF<1,V.ABC.REGIMEN.POS> = ''
        END
        
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
        
        tmp=EB.SystemTables.getTLocref()
        tmp<V.ABC.NOMBRE.CONY.POS,7>="NOINPUT"
        tmp<V.ABC.REGIMEN.POS,7>="NOINPUT"
        EB.SystemTables.setTLocref(tmp)

    END

    RETURN
END
