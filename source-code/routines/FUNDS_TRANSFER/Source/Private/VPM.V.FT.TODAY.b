* @ValidationCode : MjotMTc0NjgyMDI4ODpDcDEyNTI6MTc0NDgzOTg1MTI5NjptYXJjbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:44:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.V.FT.TODAY
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------

* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_F.FUNDS.TRANSFER  ;* Not Used anymore
    
    $USING EB.SystemTables
    $USING FT.Contract
    $USING ABC.BP

    IF LEN(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)) = 0 THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitValueDate, EB.SystemTables.getToday())
    END

    IF LEN(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)) = 0 THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditValueDate, EB.SystemTables.getToday())
    END

RETURN

END
