*-----------------------------------------------------------------------------
* <Rating>78</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.V.CLOSE.TILL.SBC
*-----------------------------------------------------------------------
*
*-----------------------------------------------------------------------
*
*       Revision History
*
*       First Release:
*       Developed for: BX+
*       Developed by : 
*
*------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING TT.Config
    $USING EB.DataAccess
    $USING EB.Display

*------ Main Processing Section

    GOSUB INITIALISE
    GOSUB PROCESS

    RETURN
*
*-------
PROCESS:
*-------
*
    IF EB.SystemTables.getMessage() EQ 'VAL' THEN 
      RETURN
    END  

    Y.OPERATOR = EB.SystemTables.getOperator()

    CMD='SSELECT ':FN.TELLER.ID:' WITH USER EQ ':DQUOTE(Y.OPERATOR)
    YLIST=''; YNO=''; YCO=''
    EB.DataAccess.Readlist(CMD,YLIST,'',YNO,YCO)
    YFLAG=0

    FOR Y.CONT = 1 TO YNO
        YTELLER.ID = YLIST<Y.CONT>
    NEXT Y.CONT


    Y.TELLER.TRANSACTION = 11

    EB.DataAccess.FRead(FN.TELLER.TRANSACTION,Y.TELLER.TRANSACTION,R.TT.VAL,F.TELLER.TRANSACTION,ERR.TT)
    Y.CATEG.1 = R.TT.VAL<TT.Config.TellerTransaction.TrCatDeptCodeOne>

    CMD='SSELECT ':FN.TELLER:' WITH ACCOUNT.1 LIKE ':DQUOTE('...':SQUOTE('MXN':Y.CATEG.1:YTELLER.ID)) 
    Y.LIST=''; Y.NO=''; Y.CO=''
    EB.DataAccess.FRead(CMD,Y.LIST,'',Y.NO,Y.CO)
    Y.FLAG=0
    Y.TILL.BALANCE = 0
    FOR Y.POS = 1 TO Y.NO
        Y.TT.ID = Y.LIST<Y.POS>
        
        EB.DataAccess.FRead(FN.TELLER, Y.TT.ID, R.TELLER, F.TELLER, Y.ERR.PARAM)
        IF R.TELLER THEN
            TEXT = "Error al leer F.TELLER"
            EB.Display.Rem();
            RETURN
        END
        Y.TILL.BALANCE += R.TELLER<TT.Contract.Teller.TeAmountLocalOne>
    NEXT Y.POS

    EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne,Y.TILL.BALANCE)
    EB.Display.RebuildScreen()

    RETURN


INITIALISE:
*----------
*----------
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID = ""
    EB.DataAccess.Opf(FN.TELLER.ID, F.TELLER)

    FN.TELLER = "F.TELLER"
    F.TELLER = ""
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION = ""
    EB.DataAccess.Opf(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    RETURN

END
