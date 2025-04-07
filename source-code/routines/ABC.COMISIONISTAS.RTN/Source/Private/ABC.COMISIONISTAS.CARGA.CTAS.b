* @ValidationCode : Mjo3MzQyMzUwOTc6Q3AxMjUyOjE3NDQwNTQyNzg5NDU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 07 Apr 2025 16:31:18
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
SUBROUTINE ABC.COMISIONISTAS.CARGA.CTAS(Y.MENSAJE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables



    TODAY = EB.SystemTables.getToday()
*  -Parametros de carga, donde se indica cuales fueron los clientes vector cargados en determinada fecha
    Y.ID.COMISIONISTA       = "VECTOR"
    Y.FECHA.PROCESO         = TODAY

*   -Indicar la aplicacion que sera cargada
    Y.APLICACION.OFS        = "ACCOUNT"

*   -En caso de existir Parametros Dependientes se indican
    ARR.APLICACION.DEP      = ""

    Y.APLICACION.DEPENDIENTE= "CUSTOMER"
    Y.CAMPO.DEPENDIENTE     = "CUSTOMER"
    ARR.APLICACION.DEP      = Y.APLICACION.DEPENDIENTE:@VM:Y.CAMPO.DEPENDIENTE
    AbcComisionistasRtn.AbcComisionistasAplicaOfs(Y.ID.COMISIONISTA,Y.FECHA.PROCESO,Y.APLICACION.OFS,ARR.APLICACION.DEP,Y.MENSAJE)
    
RETURN
END
