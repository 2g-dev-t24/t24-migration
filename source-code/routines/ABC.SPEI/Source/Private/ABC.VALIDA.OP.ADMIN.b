* @ValidationCode : MjoxMzU2NjMwNDMxOkNwMTI1MjoxNzUzMTQ3MjE0ODYxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2025 22:20:14
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

SUBROUTINE ABC.VALIDA.OP.ADMIN
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
    Y.AC.OP.ADMIN = EB.SystemTables.getComi()
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.AC.OP.ADMIN EQ 'NO' THEN
        EB.SystemTables.setRNew(AbcTable.AbcComisionistas.IdAdministrador, '')
        EB.SystemTables.setRNew(AbcTable.AbcComisionistas.RfcAdmin, '')
        
        tmpAdmin = EB.SystemTables.getT(AbcTable.AbcComisionistas.IdAdministrador)
        tmpAdmin<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcComisionistas.IdAdministrador, tmpAdmin)
        
        tmpRfc = EB.SystemTables.getT(AbcTable.AbcComisionistas.RfcAdmin)
        tmpRfc<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcComisionistas.RfcAdmin, tmpRfc)
        EB.Display.RebuildScreen()
    END
    IF Y.AC.OP.ADMIN EQ '' THEN
        ETEXT = "FAVOR DE INDICAR SI TIENE OPERACION CON ADMINISTRADORES "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
END
