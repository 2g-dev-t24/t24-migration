* @ValidationCode : Mjo2MTUxMjk1ODU6Q3AxMjUyOjE3NDQ3NDI4NzE5NjU6bWFyY286LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Apr 2025 13:47:51
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
*-------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.VALIDATE.IVA.SPEI
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código y se cambia el .15 a .16
*-----------------------------------------------------------------------

    * $INSERT I_COMMON  ;* Not Used anymore
    * $INSERT I_EQUATE  ;* Not Used anymore
    * $INSERT I_F.FUNDS.TRANSFER  ;* Not Used anymore
    
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING ABC.BP

* Main Program Loop


    YIVA.RATE = .16 ;* .15

    YIVA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount) * YIVA.RATE

    IF EB.SystemTables.getComi() >  YIVA THEN
        EB.SystemTables.setE("Monto de IVA es incorrecto")
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi("")
    END

RETURN
