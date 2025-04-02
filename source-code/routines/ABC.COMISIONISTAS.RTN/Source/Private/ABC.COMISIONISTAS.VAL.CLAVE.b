* @ValidationCode : MjotMzk1MDQwMjUyOkNwMTI1MjoxNzQzNjI5MDg1NDI1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Apr 2025 18:24:45
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
SUBROUTINE ABC.COMISIONISTAS.VAL.CLAVE(Y.VALOR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
 
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN

******************************************************************************
*
******************************************************************************
INIT:

    Y.CLAVE.INICIAL = '2'
    Y.CLAVE.COMPLETA = ''

RETURN

******************************************************************************
* proceso general de validacion
******************************************************************************
PROCESS:

    Y.CLAVE.COMPLETA = Y.CLAVE.INICIAL:Y.VALOR
    Y.VALOR = Y.CLAVE.COMPLETA

RETURN
END
