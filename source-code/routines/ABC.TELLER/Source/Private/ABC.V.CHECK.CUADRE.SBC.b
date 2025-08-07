*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.V.CHECK.CUADRE.SBC

*-------------------------------------------------------
* Subroutine        : VPM.V.CHECK.CUADRE.SBC
* Objective         : Check if the teller has input
*                     the transaction for closing SBC
*                     balance before closing the till
*                     (TELLER.TRANSACTION 16), if not
*                     don't let the teller close the
*                     till
* First Released For: 
* First Released    : 
* Author            :
*-------------------------------------------------------


    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.ErrorProcessing

*-------------------------------
* Main Program Loop
*-------------------------------

    GOSUB INITIALIZE
    GOSUB VALIDATE
    RETURN

*-------------
VALIDATE:
*-------------
*-------------
* Checks for SBC transactions in LCY
*-------------
    Y.LIST = "" ; Y.NO = ""; Y.STATUS = ""
    Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH (TRANSACTION.CODE EQ '11' OR TRANSACTION.CODE EQ '101') AND TELLER.ID.1 EQ ":DQUOTE(COMI):" AND CURRENCY.1 EQ 'MXN'" ; *ITSS - NYADAV - Added DQUOTE / '
    EB.DataAccess.Readlist(Y.SELECT.CMD,Y.LIST,"",Y.NO,Y.STATUS)
    IF Y.NO THEN
        Y.LIST = "" ; Y.NO = ""; Y.STATUS = ""
        Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ '16' AND TELLER.ID.1 EQ ":DQUOTE(COMI):" AND CURRENCY.1 EQ 'MXN'"  ; * ITSS - NYADAV - Added DQUOTE / '
        EB.DataAccess.Readlist(Y.SELECT.CMD,Y.LIST,"",Y.NO,Y.STATUS)
        IF NOT(Y.NO) THEN
            ETEXT = "Debe hacer el cierre SBC antes"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

*-------------
* Checks for SBC transactions in FCY
*-------------

    Y.LIST = "" ; Y.NO = ""; Y.STATUS = ""
    Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ '99' AND TELLER.ID.1 EQ ":DQUOTE(COMI)  ;* ITSS - NYADAV - Added DQUOTE 
    EB.DataAccess.Readlist(Y.SELECT.CMD,Y.LIST,"",Y.NO,Y.STATUS)
    IF Y.NO THEN
        Y.LIST = "" ; Y.NO = ""; Y.STATUS = ""
        Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ '16' AND TELLER.ID.1 EQ ":DQUOTE(COMI):" AND CURRENCY.1 EQ 'USD'"  ;* ITSS - NYADAV - Added DQUOTE / '
        EB.DataAccess.Readlist(Y.SELECT.CMD,Y.LIST,"",Y.NO,Y.STATUS)
        IF NOT(Y.NO) THEN
            ETEXT = "Debe hacer el cierre SBC para dolares antes"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END


    RETURN

*-------------
INITIALIZE:
*-------------
    FN.TELLER = "F.TELLER"
    F.TELLER  = ""
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    RETURN
