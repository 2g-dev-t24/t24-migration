*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
* 
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.AUTO.ACCT
*
*
*    First Release : 
*    Developed for : 
*    Developed by  : 
*    Date          : 
*
*************************************************************************

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract

    GOSUB INIT
    GOSUB PROCESS

    RETURN

**************************************************************************
INIT:

    FN.TT = 'F.TELLER$NAU'
    FV.TT = ''
    EB.DataAccess.Opf(FN.TT,FV.TT)
    ID.TT.F = ''
    ID.TT.L = ''
    ID.TT = ''
    TT.ERR = ''

    RETURN
***************************************************************************
PROCESS:


    ID.TT.F = EB.SystemTables.getIdNew()[1,12]

    ID.TT.L = '01'

    ID.TT = ID.TT.F:"-":ID.TT.L

    EB.DataAccess.FReadD(FN.TT,ID.TT,REC.TT,FV.TT,TT.ERR)
    IF REC.TT THEN
        Y.REC.TT = REC.TT<TT.Contract.Teller.TeAccountTwo>
 
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo,Y.REC.TT)
         tmp<3>="NOINPUT"
        EB.SystemTables.setT(TT.Contract.Teller.TeAccountTwo, tmp)
  
    END

    RETURN
END
