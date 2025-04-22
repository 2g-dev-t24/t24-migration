* @ValidationCode : MjotMzk0MjM5ODM0OkNwMTI1MjoxNzQ1MjgxNjUyNjAzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2025 21:27:32
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

$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.CANAL(Y.CANAL, Y.ERROR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING AbcTable
    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

RETURN

***********
INICIALIZA:
***********

    FN.ABC.CANAL = 'F.ABC.CANAL'
    F.ABC.CANAL = ''
    EB.DataAccess.Opf(FN.ABC.CANAL,F.ABC.CANAL)

RETURN

***************
VALIDA.USUARIO:
***************

    EB.DataAccess.FRead(FN.ABC.CANAL,Y.CANAL,R.ABC.CANAL,F.ABC.CANAL,ERR.CANAL)
    IF R.ABC.CANAL NE '' THEN
        Y.USUARIO.LISTA = R.ABC.CANAL<AbcTable.AbcCanal.Usuario>
        Y.USUARIO.LISTA = RAISE(Y.USUARIO.LISTA)
        Y.OPERATOR = EB.SystemTables.getOperator()

        LOCATE Y.OPERATOR IN Y.USUARIO.LISTA SETTING YPOSICION ELSE
            Y.ERROR = 'EL USUARIO NO TIENE PERMISOS PARA EL CANAL INGRESADO'
        END
    END ELSE
        Y.ERROR = 'EL CANAL INGRESADO NO SE ENCUENTRA REGISTRADO'
    END

RETURN

END

