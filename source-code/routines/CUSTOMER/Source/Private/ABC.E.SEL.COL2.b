*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.E.SEL.COL2(ENQ.PARAM)

    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer
    $USING EB.Updates
    
    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'ABC.COD.POS.ANT'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)

    Y.POS.DIR.COD.POS.ANT = V.FLD.POS<1,1>
    Y.DIR.COD.POS.ANT = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS.DIR.COD.POS.ANT>

    Y.COD.POST = Y.DIR.COD.POS.ANT

    ENQ.PARAM<2,1> = "CODIGO.POSTAL"
    ENQ.PARAM<3,1> = "EQ"
    ENQ.PARAM<4,1,1> = Y.COD.POST


    RETURN
END
