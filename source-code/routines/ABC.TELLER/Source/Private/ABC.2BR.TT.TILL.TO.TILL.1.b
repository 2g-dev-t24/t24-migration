*=======================================================================
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.TT.TILL.TO.TILL.1
*=======================================================================
*
*
*    First Release : Banco Ve por Mas
*    Developed for : Banco Ve por Mas
*    Developed by  : 
*    Date          : 
*
*
*=======================================================================
*
* This routine updates the Denomenations both DR and CR sides
* when transfer is done from Till to till or Till to Vault
*


    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING AC.AccountOpening
    $USING AbcTeller

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*=======================================================================

*===============
INIT:
*===============
    FN.TELLER.ID = 'F.TELLER.ID'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER.ID,FV.TELLER.ID)

    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,FV.ACCOUNT)

    FN.TELLER = 'F.TELLER'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER,FV.TELLER)

    RETURN

*===========================================================================

*===============
PROCESS:
*===============
    DENOM = EB.SystemTables.getComi()
    Y.POS<1,EB.SystemTables.setAv(0)> = DENOM
    IF EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker) EQ 'CREDIT' THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeUnit, Y.POS)
        EB.Display.RefreshField(TT.Contract.Teller.TeUnit:'.':EB.SystemTables.setAv(0),"")
    END ELSE
        EB.SystemTables.setRNew(TT.Contract.Teller.TeDrUnit, Y.POS)
        EB.Display.RefreshField(TT.Contract.Teller.TeDrUnit:'.':EB.SystemTables.setAv(0),"")
    END

    AbcTeller.Abc2brTeldenomTotUnit()

    RETURN
END
