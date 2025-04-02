* @ValidationCode : Mjo0MjYyMDU2Nzg6Q3AxMjUyOjE3NDM2Mjg3MjQ2NjU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Apr 2025 18:18:44
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
SUBROUTINE ABC.COMISIONISTAS.VAL.FECHA(Y.VALOR)
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

    Y.FECHA.OFS.T24 = ''
    Y.FECHA.COMISIONISTA = Y.VALOR
RETURN

******************************************************************************
* proceso general de validacion
******************************************************************************
PROCESS:

    Y.FECHA.OFS.T24 =Y.FECHA.COMISIONISTA[5,4]:Y.FECHA.COMISIONISTA[1,2]:Y.FECHA.COMISIONISTA[3,2]
    Y.VALOR = Y.FECHA.OFS.T24

RETURN
END
