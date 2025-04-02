* @ValidationCode : MjotMjI1MjA5NTc4OkNwMTI1MjoxNzQzNjI4MjY4MzA2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Apr 2025 18:11:08
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
SUBROUTINE ABC.COMISIONISTAS.VAL.SEXO(Y.VALOR)
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

    Y.SEXO.OFS.T24.MASCULINO = ''
    Y.SEXO.OFS.T24.FEMENINO = ''

RETURN

******************************************************************************
* proceso general de validacion
******************************************************************************
PROCESS:


    IF Y.VALOR = 'F' THEN

        Y.SEXO.OFS.T24.FEMENINO = 'FEMENINO'
        Y.VALOR = Y.SEXO.OFS.T24.FEMENINO

    END
    ELSE
        IF Y.VALOR = 'M' THEN

            Y.SEXO.OFS.T24.MASCULINO = 'MASCULINO'
            Y.VALOR = Y.SEXO.OFS.T24.MASCULINO

        END



    END
RETURN
END
