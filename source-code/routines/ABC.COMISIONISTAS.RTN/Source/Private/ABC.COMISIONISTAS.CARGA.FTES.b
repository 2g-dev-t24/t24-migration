* @ValidationCode : MjotMTk5MDMyMzA2NjpDcDEyNTI6MTc0NDA1NDU0ODkxNjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2025 16:35:48
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
SUBROUTINE ABC.COMISIONISTAS.CARGA.FTES
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables



    TODAY = EB.SystemTables.getToday()
    Y.ID.COMISIONISTA       = "VECTOR"
    Y.FECHA.PROCESO         = TODAY

    Y.APLICACION.OFS        = "FUNDS.TRANSFER"
    Y.APLICACION.DEPENDIENTE= "ACCOUNT"
    Y.CAMPO.DEPENDIENTE     = "CREDIT.ACCT.NO"
    ARR.APLICACION.DEP      = Y.APLICACION.DEPENDIENTE:@VM:Y.CAMPO.DEPENDIENTE
    AbcComisionistasRtn.AbcComisionistasAplicaOfs(Y.ID.COMISIONISTA,Y.FECHA.PROCESO,Y.APLICACION.OFS,ARR.APLICACION.DEP,Y.MENSAJE)

RETURN
END
