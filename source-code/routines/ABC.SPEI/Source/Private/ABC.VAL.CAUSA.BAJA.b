* @ValidationCode : MjotNzk5OTMwNzM1OkNwMTI1MjoxNzUzNDU3NTQ1ODQ3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Jul 2025 12:32:25
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

SUBROUTINE ABC.VAL.CAUSA.BAJA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.TIPO.MOV = EB.SystemTables.getComi()
    Y.ACA.CAUSA.BAJA = EB.SystemTables.getRNew(AbcTable.AbcComisionistasAdmin.CausaBaja)
    tmp = EB.SystemTables.getT(AbcTable.AbcComisionistasAdmin.CausaBaja)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.TIPO.MOV EQ 'ALTA' OR Y.TIPO.MOV EQ 'ACTUALIZACION' AND Y.ACA.CAUSA.BAJA EQ '' THEN
        EB.SystemTables.setRNew(AbcTable.AbcComisionistasAdmin.CausaBaja, '0')
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcComisionistasAdmin.CausaBaja, tmp)
        EB.Display.RebuildScreen()
    END ELSE
        IF Y.TIPO.MOV EQ 'ALTA' OR Y.TIPO.MOV EQ 'ACTUALIZACION' AND Y.ACA.CAUSA.BAJA EQ '0' THEN
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcComisionistasAdmin.CausaBaja, tmp)
            EB.Display.RebuildScreen()
        END ELSE
            IF Y.TIPO.MOV EQ 'BAJA' AND Y.ACA.CAUSA.BAJA EQ '0' THEN
                EB.SystemTables.setRNew(AbcTable.AbcComisionistasAdmin.CausaBaja, '')
                EB.Display.RebuildScreen()
            END
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END
