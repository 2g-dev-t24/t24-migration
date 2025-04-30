*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.E.SEL.COL(ENQ.PARAM)

    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer

    Y.POST.CODE = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusPostCode)

    ENQ.PARAM<2,1> = "CODIGO.POSTAL"
    ENQ.PARAM<3,1> = "EQ"
    ENQ.PARAM<4,1,1> = Y.POST.CODE

    RETURN
END
