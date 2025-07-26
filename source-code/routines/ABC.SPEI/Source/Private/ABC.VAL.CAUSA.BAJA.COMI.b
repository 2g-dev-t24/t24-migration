* @ValidationCode : MjotMTM3MzEwMjIxMjpDcDEyNTI6MTc1MzE0ODQ1MjMzMTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Jul 2025 22:40:52
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

SUBROUTINE ABC.VAL.CAUSA.BAJA.COMI
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
    GOSUB FINALIZE

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.TIPO.MOV = EB.SystemTables.getComi()
    Y.AC.CAUSA.BAJA = EB.SystemTables.getRNew(AbcTable.AbcComisionistas.CausaBaja)
    Y.AC.OP.ADMIN = EB.SystemTables.getRNew(AbcTable.AbcComisionistas.OpAdmin)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    tmp = EB.SystemTables.getT(AbcTable.AbcComisionistas.CausaBaja)
    
    IF Y.TIPO.MOV EQ 'ALTA' OR Y.TIPO.MOV EQ 'ACTUALIZACION' AND Y.AC.CAUSA.BAJA EQ '' THEN
        EB.SystemTables.setRNew(AbcTable.AbcComisionistas.CausaBaja, '0')
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcComisionistas.CausaBaja, tmp)
        EB.Display.RebuildScreen()
    END ELSE
        IF Y.TIPO.MOV EQ 'ALTA' OR Y.TIPO.MOV EQ 'ACTUALIZACION' AND Y.AC.CAUSA.BAJA EQ '0' THEN
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcComisionistas.CausaBaja, tmp)
            EB.Display.RebuildScreen()
        END ELSE
            IF Y.TIPO.MOV EQ 'BAJA' AND Y.AC.CAUSA.BAJA EQ '0' THEN
                EB.SystemTables.setRNew(AbcTable.AbcComisionistas.CausaBaja, '')
                EB.Display.RebuildScreen()
            END
        END
    END
    IF Y.TIPO.MOV EQ '' THEN
        ETEXT = "FAVOR DE SELECCIONAR SI ES ALTA O BAJA "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------
    IF Y.AC.OP.ADMIN EQ 'NO' THEN
        tmpAdmin = EB.SystemTables.getT(AbcTable.AbcComisionistas.IdAdministrador)
        tmpAdmin<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcComisionistas.IdAdministrador, tmpAdmin)
    END
RETURN
*-----------------------------------------------------------------------------
END
