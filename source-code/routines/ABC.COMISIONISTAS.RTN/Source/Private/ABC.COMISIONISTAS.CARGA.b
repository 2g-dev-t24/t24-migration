* @ValidationCode : MjotMTY2MzA5MDA1NTpDcDEyNTI6MTc0NDA1Mzg5NjkwMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2025 16:24:56
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
SUBROUTINE ABC.COMISIONISTAS.CARGA(RESPUESTA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    Y.ID.COMISIONISTA = "VECTOR"
    Y.MENSAJE         = ""
    AbcComisionistasRtn.AbcComisionistasFileLoad(Y.ID.COMISIONISTA,Y.MENSAJE)

    RESPUESTA = Y.MENSAJE
RETURN
END
