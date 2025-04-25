* @ValidationCode : Mjo4MTMxNTk0NjU6Q3AxMjUyOjE3NDU1OTA5MDAyMzg6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2025 11:21:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.FIMA.ELECT(Y.TIENE.FIRMA)

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Display

    GOSUB PROCESS
    EB.Display.RebuildScreen()
RETURN

********
PROCESS:
********
    IF Y.TIENE.FIRMA EQ 'NO' THEN
        Y.POS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusText)
*        Y.POS<1,2> = ""
        Y.POS = ""
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusText,Y.POS)

    END
    tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusText)
    tmp<3>=""
    EB.SystemTables.setT(ST.Customer.Customer.EbCusText, tmp)

RETURN
END
