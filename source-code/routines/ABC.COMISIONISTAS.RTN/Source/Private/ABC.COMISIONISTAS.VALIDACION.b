* @ValidationCode : MjoxNzc2ODgzMTgwOkNwMTI1MjoxNzQ0ODMyNDM3MTI5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:40:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcComisionistasRtn
SUBROUTINE ABC.COMISIONISTAS.VALIDACION
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING AbcComisionistasRtn
    $USING EB.Display

    MENSAJE = "ABC Capital"
    MENSAJE:= " Inicia Validacion de Carga"

    TEXT = MENSAJE
    EB.Display.Rem();
    

    Y.PROCESO.APLICA  = "VALIDA"
    Y.ID.COMISIONISTA = "VECTOR"
    AbcComisionistasRtn.AbcComisionistasFileLoad(Y.PROCESO.APLICA,Y.ID.COMISIONISTA)

    MENSAJE = "El Proceso de Validacion ha concluido"
    TEXT = MENSAJE
    EB.Display.Rem();
RETURN
END
