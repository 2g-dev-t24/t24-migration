*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.CUS.VALIDA.ORIG.REC(V.ORIGEN.RECURSOS)

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Display


    IF EB.SystemTables.getMessage() EQ 'VAL' THEN
        RETURN
    END ELSE

        V.APP      = 'CUSTOMER'
        V.FLD.NAME = 'ORIGEN.REC'
        V.FLD.POS  = ''

        EB.LocalReferences.GetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)
        V.OR.POS= V.FLD.POS<1,1>

        IF V.ORIGEN.RECURSOS EQ 'Otro' THEN
            Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.LOCAL.REF<1,V.FLD.POS> = ''
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
            T.LOCREF<V.OR.POS,7> = ''
        END ELSE
            Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.LOCAL.REF<1,V.OR.POS> = ''
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
            T.LOCREF<V.OR.POS,7> = 'NOINPUT'
        END
    END

    RETURN
END
