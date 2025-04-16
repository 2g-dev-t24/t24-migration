* @ValidationCode : MjoyMTI4Mzc4NzE1OkNwMTI1MjoxNzQ0ODM3NzQzMTczOm1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:09:03
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.2BR.V.CHECK.SPEI.TYPE

******************************************************************
*  First release for:      Banco Ve por Mas
*  Date:                   July/8/2005
*  Author:                 Fabian Gamboa
*  Objective:              This routine checks if the FT transaction
*                          is of a SPEI type to allow it to be seen
*                          in a SPEI Version
****************************************************************
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------
*    $INCLUDE I_COMMON
*    $INCLUDE I_EQUATE
*    $INCLUDE I_F.FUNDS.TRANSFER
* $INSERT I_F.VPM.PARAMETROS.SPEI - Not Used anymore;I
    
    $USING EB.SystemTables
*    $USING EB.DataAccess  - Not Used anymore;I
    $USING EB.ErrorProcessing
    $USING ABC.BP

********************************** *
* MAIN
***********************************

    GOSUB INITIALIZATION

    IF EB.SystemTables.getE() THEN
        RETURN
    END

    GOSUB VALIDATION

RETURN

***********************************
VALIDATION:
***********************************


    IF (EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType) = YREC.VPM.PARAMETROS.SPEI<ABC.BP.VpmParametrosSpei.DispIntTxn>) THEN
;*    VPM.DISP.INT.TXN>) THEN

        EB.SystemTables.setE("La transferencia es transferencia interna masiva " : EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType))
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF ((EB.SystemTables.getPgmVersion() = ",VPM.2BR.VER.FTS") OR (EB.SystemTables.getPgmVersion() = ",VPM.2BR.VER.RECH.DISP")) AND (EB.SystemTables.getVFunction()<> "S") THEN
        EB.SystemTables.setE("Solo se permite funci�n 'Ver' en esta versi�n")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN

***********************************
INITIALIZATION:
***********************************

    EB.SystemTables.setE("")

*    FN.VPM.PARAMETROS.SPEI = "F.VPM.PARAMETROS.SPEI"
*    F.VPM.PARAMETROS.SPEI  = ""
*    EB.DataAccess.Opf(FN.VPM.PARAMETROS.SPEI,F.VPM.PARAMETROS.SPEI)
*
*    EB.DataAccess.FRead(F.VPM.PARAMETROS.SPEI,"SYSTEM",YREC.VPM.PARAMETROS.SPEI,F.VPM.PARAMETROS.SPEI,YF.ERR)
    
    YREC.VPM.PARAMETROS.SPEI = ABC.BP.VpmParametrosSpei.Read("SYSTEM", YF.ERR)
    IF NOT(YREC.VPM.PARAMETROS.SPEI) THEN
        EB.SystemTables.setE("Registro SYSTEM de VPM.PARAMETROS.SPEI no existe")
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

END
