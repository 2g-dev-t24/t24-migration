*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.OBTEN.TASA.INT
*===============================================================================


    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports
    $USING IC.Config

    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

    RETURN

***********
INICIA:
***********

    Y.ACCT.GEN.CONDITION.ID = EB.Reports.getOData()

    EB.Reports.setOData("")
    RETURN


***********
ABRE.ARCHIVOS:
***********

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    EB.DataAccess.Opf(FN.GROUP.CREDIT.INT, F.GROUP.CREDIT.INT)



    RETURN

*****************
PROCESO:
*****************

    Y.SEL.CMD = 'SELECT ':FN.GROUP.CREDIT.INT:' WITH @ID LIKE ':Y.ACCT.GEN.CONDITION.ID:'MXN20... BY-DSND @ID'

    Y.LIST=''
    Y.NO.REG=''
    Y.SEL.ERR=''
    EB.DataAccess.Readlist(Y.SEL.CMD,Y.LIST,'',Y.NO.REG,Y.SEL.ERR)
    Y.ID.GROUP.CREDIT.INT = Y.LIST<1>

    EB.DataAccess.FRead(FN.GROUP.CREDIT.INT,Y.ID.GROUP.CREDIT.INT,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,Y.GROUP.CREDIT.INT.ERR)
    IF R.GROUP.CREDIT.INT THEN

	EB.Reports.setOData(R.GROUP.CREDIT.INT<IC.Config.GroupCreditInt.GciCrIntRate>)

    END ELSE
        EB.Reports.setEnqError('TASA NO DISPONIBLE')
    END


    RETURN


END
