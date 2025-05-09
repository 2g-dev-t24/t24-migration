* @ValidationCode : MjotMTc2MDYwNDMxOTpDcDEyNTI6MTc0NTkyOTQ1NjUwMjpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Apr 2025 09:24:16
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
*    Y.VAL.AUX = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusText)
    tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusText)
    
    IF (Y.TIENE.FIRMA EQ 'SI') THEN
        tmp<3>=""
        EB.SystemTables.setT(ST.Customer.Customer.EbCusText, tmp)
        RETURN
    END

    tmp<3>="NOINPUT"
    EB.SystemTables.setT(ST.Customer.Customer.EbCusText, tmp)
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusText,"")

RETURN
********

END
