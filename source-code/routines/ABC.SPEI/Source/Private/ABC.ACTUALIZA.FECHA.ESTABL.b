* @ValidationCode : MjoxMTMwNTUxNDg5OkNwMTI1MjoxNzUzMjAxMjQ5ODc3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Jul 2025 13:20:49
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

SUBROUTINE ABC.ACTUALIZA.FECHA.ESTABL
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
    Y.ACE.CAUSA.BAJA = EB.SystemTables.getComi()
    Y.TIPO.MOVIMIENTO = EB.SystemTables.getRNew(AbcTable.AbcComisionistasEstabl.TipoMovimiento)
    Y.FECHA = EB.SystemTables.getToday()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.TIPO.MOVIMIENTO EQ 'BAJA' AND Y.ACE.CAUSA.BAJA EQ '0' THEN
        ETEXT = "NO SE PERMITE CERO CUANDO ES BAJA DE ADMINISTRADORES "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcComisionistasEstabl.FecMov, Y.FECHA)
        EB.Display.RebuildScreen()
    END
    
RETURN
*-----------------------------------------------------------------------------
END
