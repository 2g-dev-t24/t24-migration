* @ValidationCode : MjotNjQ0OTQwMTgwOkNwMTI1MjoxNzUzMTQ2MjU3NTk3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2025 22:04:17
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

SUBROUTINE ABC.CREA.ID.ADMIN
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
    Y.FECHA = EB.SystemTables.getToday()
    Y.PER.JURI.ADMIN = EB.SystemTables.getComi()
    Y.CLAVE.ENTIDAD = EB.SystemTables.getRNew(AbcTable.AbcComisionistasAdmin.ClaveEntidad)
    Y.CLAVE.FORMULARIO = EB.SystemTables.getRNew(AbcTable.AbcComisionistasAdmin.ClaveFormulario)
    Y.RFC = EB.SystemTables.getRNew(AbcTable.AbcComisionistasAdmin.Rfc)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.PER.JURI.ADMIN EQ 'FISICA' OR Y.PER.JURI.ADMIN EQ 'MORAL' THEN
        IF Y.PER.JURI.ADMIN EQ 'FISICA' THEN
            Y.PER.JURI = '1'
        END ELSE
            Y.PER.JURI = '2'
        END
        Y.ID.ADMINISTRADOR = Y.PER.JURI:Y.CLAVE.ENTIDAD:Y.CLAVE.FORMULARIO:Y.RFC
        EB.SystemTables.setRNew(AbcTable.AbcComisionistasAdmin.IdAdministrador, Y.ID.ADMINISTRADOR)
        EB.Display.RebuildScreen()
    END ELSE
        ETEXT = "SELECCIONAR PERSONA JURIDICA "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
END
