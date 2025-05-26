
    $PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.DATO.FISCAL
*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING ST.Customer

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'DENOM.SO.FISCAL':@VM:'APE.PAT.FISCAL':@VM:'APE.MAT.FISCAL':@VM:'NOMBRES.FISCAL'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)

    Y.POS.DENOM   = V.FLD.POS<1,1>
    Y.POS.PATERNO = V.FLD.POS<1,2>
    Y.POS.MATERNO = V.FLD.POS<1,3>
    Y.POS.NOMBRE  = V.FLD.POS<1,4>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.SECTOR    = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSector)
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.T.LOC.REF = EB.SystemTables.getTLocref()

    IF Y.SECTOR EQ 2200 THEN

        Y.LOCAL.REF<1,Y.POS.PATERNO> = ''
        Y.LOCAL.REF<1,Y.POS.MATERNO> = ''
        Y.LOCAL.REF<1,Y.POS.NOMBRE>  = ''

        Y.T.LOC.REF<Y.POS.PATERNO,7> = "NOINPUT"
        Y.T.LOC.REF<Y.POS.MATERNO,7> = "NOINPUT"
        Y.T.LOC.REF<Y.POS.NOMBRE,7>  = "NOINPUT"

    END ELSE

        Y.LOCAL.REF<1,Y.POS.DENOM> = ''
        Y.T.LOC.REF<Y.POS.DENOM,7> = "NOINPUT"

    END

    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, Y.LOCAL.REF)
    EB.SystemTables.setTLocref(Y.T.LOC.REF)

    RETURN

END
