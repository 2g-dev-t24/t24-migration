* @ValidationCode : MjotMTM1Njc0NzI2MDpDcDEyNTI6MTc1MzE0ODk2NTU5MzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Jul 2025 22:49:25
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

SUBROUTINE ABC.CREA.ID.COMI
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
    Y.PER.JURI.COMI = EB.SystemTables.getComi()
    Y.CLAVE.ENTIDAD = EB.SystemTables.getRNew(AbcTable.AbcComisionistas.ClaveEntidad)
    Y.CLAVE.FORMULARIO = EB.SystemTables.getRNew(AbcTable.AbcComisionistas.ClaveFormulario)
    Y.RFC = EB.SystemTables.getRNew(AbcTable.AbcComisionistas.RfcComisionista)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.PER.JURI.COMI EQ 'FISICA' OR Y.PER.JURI.COMI EQ 'MORAL' THEN
        IF Y.PER.JURI.COMI EQ 'FISICA' THEN
            Y.PER.JURI = '1'
        END ELSE
            Y.PER.JURI = '2'
        END
        Y.ID.COMISIONISTA =Y.PER.JURI:Y.CLAVE.ENTIDAD:Y.CLAVE.FORMULARIO:Y.RFC
        EB.SystemTables.setRNew(AbcTable.AbcComisionistas.IdComisionista,Y.ID.COMISIONISTA)
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
