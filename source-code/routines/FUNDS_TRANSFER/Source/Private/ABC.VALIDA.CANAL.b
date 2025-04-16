* @ValidationCode : MjotMTU2Mzg1OTA1OkNwMTI1MjoxNzQ0NDE4ODg5MzA3OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 19:48:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VALIDA.CANAL (Y.CANAL, Y.ERROR)
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.VALIDA.CANAL
* Objetivo:             Rutina que valida que el usuario corresponda al canal
*      del registro
* Desarrollador:        C�sar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC CAPITAL
* Fecha Creacion:       05 - Junio - 2020
* Modificaciones:
*-----------------------------------------------------------------------------

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE

*    $INSERT ABC.BP I_F.ABC.CANAL
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ABC.BP

    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

RETURN

***********
INICIALIZA:
***********

*    FN.ABC.CANAL = 'F.ABC.CANAL'
*    F.ABC.CANAL = ''
*    CALL OPF(FN.ABC.CANAL,F.ABC.CANAL)

RETURN

***************
VALIDA.USUARIO:
***************

*    CALL F.READ(FN.ABC.CANAL,Y.CANAL,R.ABC.CANAL,F.ABC.CANAL,ERR.CANAL)
    EB.DataAccess.FRead(FN.ABC.CANAL,Y.CANAL,R.ABC.CANAL,F.ABC.CANAL,ERR.CANAL)
    IF R.ABC.CANAL NE '' THEN
        Y.USUARIO.LISTA = R.ABC.CANAL<ABC.BP.AbcCanal.AbcCanalUsuario> ;*R.ABC.CANAL<ABC.CNL.USUARIO>
        Y.USUARIO.LISTA = RAISE(Y.USUARIO.LISTA)
        Y.OPERATOR = EB.SystemTables.getOperator();*OPERATOR

        LOCATE Y.OPERATOR IN Y.USUARIO.LISTA SETTING YPOSICION ELSE
            Y.ERROR = 'EL USUARIO NO TIENE PERMISOS PARA EL CANAL INGRESADO'
        END
    END ELSE
        Y.ERROR = 'EL CANAL INGRESADO NO SE ENCUENTRA REGISTRADO'
    END

RETURN

END
