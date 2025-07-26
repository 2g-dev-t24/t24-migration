* @ValidationCode : MjoxNDAxOTI2OTkwOkNwMTI1MjoxNzUzMDY3NjcxMzcxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2025 00:14:31
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
$PACKAGE AbcSpei

SUBROUTINE ABC.ACTUALIZA.FECHA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Display
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ACA.CAUSA.BAJA = EB.SystemTables.getComi()
    Y.TIPO.MOVIMIENTO = EB.SystemTables.getRNew(AbcTable.AbcComisionistasAdmin.TipoMovimiento)
    Y.FECHA = EB.SystemTables.getToday()
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.TIPO.MOVIMIENTO EQ 'BAJA' AND Y.ACA.CAUSA.BAJA EQ '0' THEN
        ETEXT = "NO SE PERMITE CERO CUANDO ES BAJA DE ADMINISTRADORES "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()

    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcComisionistasAdmin.FecMov, Y.FECHA)
        EB.Display.RebuildScreen()
    END
    
RETURN
*-----------------------------------------------------------------------------
END
