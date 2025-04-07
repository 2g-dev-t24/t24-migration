* @ValidationCode : MjotNzIwMTE3Mjk4OkNwMTI1MjoxNzQ0MDU0ODczMTUzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2025 16:41:13
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
SUBROUTINE ABC.COMISIONISTAS.CARGA.INIC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    GOSUB CARGA.CLIENTE

***************
CARGA.CLIENTE:
***************

    TEXT = "INICIANDO CON LA CARGA DE CLIENTE"
    CALL REM

    Y.APLICACION.OFS        = "CUSTOMER"
    ARR.APLICACION.DEP      = ""
*    AbcComisionistasRtn.AbcComisionistasAplicaOfs(Y.APLICACION.OFS,ARR.APLICACION.DEP)

    TEXT = "TERMINO CARGA DE CLIENTE"

*  INPUT.BUFFER = C.U:" QUERY INFORME.CARGA.COMISIONISTAS"

    GOSUB CARGA.CTA

**********
CARGA.CTA:
**********

    TEXT = "INICIANDO CON LA CARGA DE CUENTAS"
    CALL REM

    Y.APLICACION.OFS        = "ACCOUNT"
    Y.APLICACION.DEPENDIENTE= "CUSTOMER"
    Y.CAMPO.DEPENDIENTE     = "CUSTOMER"
    ARR.APLICACION.DEP      = Y.APLICACION.DEPENDIENTE:@VM:Y.CAMPO.DEPENDIENTE
*   AbcComisionistasRtn.AbcComisionistasAplicaOfs(Y.APLICACION.OFS,ARR.APLICACION.DEP)

    TEXT = "TERMINO CARGA DE CUENTAS"



END
