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
    V.FLD.NAME = 'ABC.REGIMEN':@VM:'NOM.CONYUGUE'
    V.FLD.POS  = ''

    EB.LocalReferences.GetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)
    V.REG.POS = V.FLD.POS<1,1>
    V.NOM.CON.POS = V.FLD.POS<1,2>

    IF Y.EDO.CIVIL EQ '2' THEN
        T.LOCREF<V.NOM.CON.POS,7> = ''
        T.LOCREF<V.REG.POS,7> = ''
    END 
    ELSE

        IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,V.NOM.CON.POS> NE '' THEN

            Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.LOCAL.REF<1,V.NOM.CON.POS> = ''
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
        END

        T.LOCREF<V.NOM.CON.POS,7> = 'NOINPUT'

        IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,V.REG.POS> NE '' THEN
            Y.LOCAL.REF2             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.LOCAL.REF2<1,V.REG.POS> = ''
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF2)
        END

        T.LOCREF<V.REG.POS,7> = 'NOINPUT'

    END

    RETURN
END
