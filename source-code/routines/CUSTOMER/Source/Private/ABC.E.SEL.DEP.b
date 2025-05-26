*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.E.SEL.DEP(ENQ.PARAM)


    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Security

    FN.USER      = 'F.USER'
    F.USER       = ''
    EB.DataAccess.Opf(FN.USER, F.USER)

    Y.OPERADOR = EB.SystemTables.getRUser()

    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)

    Y.DEPT = R.USER<EB.Security.User.UseDepartmentCode>
    Y.DEPT = Y.DEPT[1,9]

    ENQ.PARAM<2,1> = 'DEPT.ACCT.OFF.CODE'
    ENQ.PARAM<3,1> = 'LK'
    ENQ.PARAM<4,1,1> = Y.DEPT:'...'

    RETURN
END
