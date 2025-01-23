*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
   $PACKAGE ABC.BP 
    SUBROUTINE ABC.GENERA.MNEMONIC

*-----------------------------------------------------------------------
* This subroutine will get the mnemonic for the customer automatically
* as per the following algorithm.
*-----------------------------------------------------------------------
*       Revision History
*
*       First Release: 2004/05/23
*       Developed for: BANCO VE POR MAS
*       Developed by : JUAN CARLOS CANDO
*       Modify by    : FRANCISCO CAMEJO
*       Date         : 13 MAY 2006
*------------------------------------------------------------------------
    
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer

    IF EB.SystemTables.getROld(ST.Customer.Customer.EbCusInputter) <> '' THEN
        GOSUB PROCESS
        RETURN
    END

*------ Main Processing Section
    GOSUB PROCESS

    RETURN

PROCESS:
    ID.NEW = EB.SystemTables.getIdNew()
    Y.CUS.MNEMONIC = "A":ID.NEW
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusMnemonic,Y.CUS.MNEMONIC)

    CALL REBUILD.SCREEN

    RETURN

END
