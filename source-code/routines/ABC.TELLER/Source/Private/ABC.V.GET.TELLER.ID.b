*-----------------------------------------------------------------------
* <Rating>69</Rating>
*-----------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.V.GET.TELLER.ID
*-----------------------------------------------------------------------
*
* This subroutine has to be Attached to the teller APPLICATION so that
* the currency will default to the accounts currency
*-----------------------------------------------------------------------
*
*       Revision History
*
*       First Release:
*       Developed for: BX+
*       Developed by : JUAN CARLOS CANDO
*
*------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract

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

*****change******Vane Feb. 2007********************************

    CMD='SSELECT ':FN.TELLER.ID:' WITH USER EQ ':"'":Y.OPERATOR:"'"
    YLIST=''; YNO=''; YCO=''
    EB.DataAccess.Readlist(CMD,YLIST,'',YNO,YCO)
    YFLAG=0

    FOR Y.CONT = 1 TO YNO
        YTELLER.ID = YLIST<Y.CONT>
    NEXT Y.CONT


    EB.SystemTables.setComi(YTELLER.ID)
    R.NEW(TT.TID.USER) = Y.OPERATOR
    EB.SystemTables.setRNew(TT.Contract.TellerId.TidUser, Y.OPERATOR)
    
    CALL REBUILD.SCREEN

    IF (EB.SystemTables.getPgmVersion() EQ ",VPM.2BR.CIERRE.AS") OR (EB.SystemTables.getPgmVersion() EQ ",VPM.2BR.CIERRE") OR (EB.SystemTables.getPgmVersion() EQ ",VPM.CIERRE") THEN
        AbcTeller.ABcVCheckCuadreSbc()
    END

    RETURN



INITIALISE:
*----------
*----------
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID = ""
    EB.DataAccess.Opf(FN.TELLER.ID, F.TELLER)

    RETURN
END

