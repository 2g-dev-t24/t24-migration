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
    IF EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker) EQ 'CREDIT' THEN
        EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)<1,AV> = DENOM
        EB.Display.RefreshField(TT.Contract.Teller.TeUnit:'.':AV,"")
    END ELSE
        EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)<1,AV> = DENOM
        EB.Display.RefreshField(TT.Contract.Teller.TeDrUnit:'.':AV,"")
    END

    AbcTeller.ABc2brTeldenomTotUnit()

    RETURN
END
