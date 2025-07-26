*-----------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.FALTANTE.SOBRANTE

******************************************************************
*  
*
*
*  MODIFIED BY : 
*  DATE : 
*
******************************************************************

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING EB.Security
    $USING TT.Config

    IF EB.SystemTables.getMessage() NE "VAL" THEN
        GOSUB INITIALISE
        GOSUB PROCESS
    END

    RETURN

*****************
INITIALISE:
*****************
    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.TELLER.PARAMETER = ''
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    EB.DataAccess.Opf(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    RETURN

*********************
PROCESS:
*********************
    Y.OPERADOR = EB.SystemTables.getRUser()
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
    IF R.USER THEN
        Y.SUCURSAL = R.USER<EB.Security.User.UseDepartmentCode>
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")  ; * ITSS - NYADAV - Added DQUOTE / SQUOTE
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID
        Y.BOVEDA = Y.ID.BVD<Y.NUM.BVD>
    END

    Y.TXN    = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
    Y.MONEDA = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
    Y.ID.TELLER = EB.SystemTables.getComi()

*******************************************************************************************************************
    Y.ID.TT.PARAMETER = "MX0010001"
    EB.DataAccess.FRead(FN.TELLER.PARAMETER,Y.ID.TT.PARAMETER,R.TELLER.PARAMETER,F.TELLER.PARAMETER,ERR.TELLER.PARAMETER)

    Y.OVER.CATEGORY  = R.TELLER.PARAMETER<TT.Config.TellerParameter.ParOverCategory>
    Y.SHORT.CATEGORY = R.TELLER.PARAMETER<TT.Config.TellerParameter.ParShortCategory>

    TEXT = "Y.OVER.CATEGORY " : Y.OVER.CATEGORY
    EB.Display.Rem();

    TEXT = "Y.SHORT.CATEGORY " : Y.SHORT.CATEGORY
    EB.Display.Rem();
*******************************************************************************************************************
    IF Y.TXN EQ 2 THEN
        Y.AC.UNO = Y.MONEDA:Y.SHORT.CATEGORY:Y.ID.TELLER
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.AC.UNO)
        Y.AC.DOS = Y.MONEDA:"10000":Y.BOVEDA
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.AC.DOS)
    END ELSE
        IF Y.TXN EQ 3 THEN
            Y.AC.UNO = Y.MONEDA:"10000":Y.ID.TELLER
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.AC.UNO)
            Y.AC.DOS = Y.MONEDA:Y.OVER.CATEGORY:Y.BOVEDA
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.AC.DOS)
        END
    END

    RETURN
END

