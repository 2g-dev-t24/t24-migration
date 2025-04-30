*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.CUS.VALIDA.DEST.REC(Y.DESTINO.RECURSOS)
*-----------------------------------------------------------------------------

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
        V.FLD.NAME = 'DESTINO.REC' : @VM
        V.FLD.POS  = ''

        EB.LocalReferences.GetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)
        V.DESTINO.RECURSOS = V.FLD.POS<1,1>

        IF Y.DESTINO.RECURSOS EQ 'Otro' THEN
            T.LOCREF<V.DESTINO.RECURSOS,7> = ''
        END ELSE
            IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,V.DESTINO.RECURSOS> NE '' THEN
                Y.LOCAL.REF             = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
                Y.LOCAL.REF<1,V.DESTINO.RECURSOS> = ''
                EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF)
                
            END
            tmp=EB.SystemTables.getTLocref()
            tmp<V.DESTINO.RECURSOS,7>="NOINPUT"
            EB.SystemTables.setTLocref(tmp)
        END
    END

    RETURN
END
