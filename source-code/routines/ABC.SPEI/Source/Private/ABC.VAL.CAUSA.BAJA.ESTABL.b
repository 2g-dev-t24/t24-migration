* @ValidationCode : Mjo2MDg0ODc4NTk6Q3AxMjUyOjE3NTMyMDA5NzkzODA6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Jul 2025 13:16:19
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

SUBROUTINE ABC.VAL.CAUSA.BAJA.ESTABL
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
    Y.TIPO.MOV = EB.SystemTables.getComi()
    Y.ACE.CAUSA.BAJA = EB.SystemTables.getRNew(AbcTable.AbcComisionistasEstabl.CausaBaja)
    tmp = EB.SystemTables.getT(AbcTable.AbcComisionistasEstabl.CausaBaja)
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.TIPO.MOV EQ 'ALTA' OR Y.TIPO.MOV EQ 'ACTUALIZACION' AND Y.ACE.CAUSA.BAJA EQ '' THEN
        EB.SystemTables.setRNew(AbcTable.AbcComisionistasEstabl.CausaBaja, '0')
        
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcComisionistasEstabl.CausaBaja, tmp)
        EB.Display.RebuildScreen()
    END ELSE
        IF Y.TIPO.MOV EQ 'ALTA' OR Y.TIPO.MOV EQ 'ACTUALIZACION' AND Y.ACE.CAUSA.BAJA EQ '0' THEN
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcComisionistasEstabl.CausaBaja, tmp)
            EB.Display.RebuildScreen()
        END ELSE
            IF Y.TIPO.MOV EQ 'BAJA' AND Y.ACE.CAUSA.BAJA EQ '0' THEN
                EB.SystemTables.setRNew(AbcTable.AbcComisionistasEstabl.CausaBaja, '')
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
END
