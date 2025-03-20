*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
   $PACKAGE ABC.BP 
    SUBROUTINE ABC.GENERA.MNEMONIC

*-----------------------------------------------------------------------
* This subroutine will get the mnemonic for the customer automatically
* as per the following algorithm.
*-----------------------------------------------------------------------
*------------------------------------------------------------------------
    
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display

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

    EB.Display.RebuildScreen()

    RETURN

END
