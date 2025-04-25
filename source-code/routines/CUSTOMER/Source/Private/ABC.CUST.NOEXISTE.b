* @ValidationCode : MjotMTUxOTA4NzEzMzpDcDEyNTI6MTc0NTU5MzY4MTEzMTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2025 12:08:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
SUBROUTINE ABC.CUST.NOEXISTE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING EB.Updates
    
    
    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

***********
INITIALIZE:
***********
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
RETURN

*********
PROCESS:
*********
    Y.NUM.CUSTOMER = EB.SystemTables.getComi()
    R.CUSTOMER = ""

    R.CUSTOMER = ST.Customer.Customer.Read(Y.NUM.CUSTOMER,CUST.ERR)
*    EB.DataAccess.FRead(FN.CUSTOMER, Y.NUM.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUST.ERR)
    
    IF R.CUSTOMER EQ "" THEN
        ETEXT = "CLIENTE " : Y.NUM.CUSTOMER : " NO EXISTE, USE OPCION DE ALTA"
*        EB.SystemTables.setEtext(ETEXT)
*        EB.ErrorProcessing.StoreEndError()
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.Err()
    END
    EB.Display.RebuildScreen()
*  CALL REFRESH.GUI.OBJECTS
RETURN
END
