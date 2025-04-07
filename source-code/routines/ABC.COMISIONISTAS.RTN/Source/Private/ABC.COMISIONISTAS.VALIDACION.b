* @ValidationCode : Mjo0MDEyMDQ0NzU6Q3AxMjUyOjE3NDQwNDkxNjU3Nzk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 07 Apr 2025 15:06:05
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

    MENSAJE = "ABC Capital"
    MENSAJE:= " Inicia Validacion de Carga"

    TEXT = MENSAJE
    CALL REM

    Y.PROCESO.APLICA  = "VALIDA"
    Y.ID.COMISIONISTA = "VECTOR"
    AbcComisionistasRtn.AbcComisionistasFileLoad(Y.PROCESO.APLICA,Y.ID.COMISIONISTA)

    MENSAJE = "El Proceso de Validacion ha concluido"
    TEXT = MENSAJE
    CALL REM
RETURN
END
