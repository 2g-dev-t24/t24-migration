* @ValidationCode : MjoxMTQ5ODM1NjM3OkNwMTI1MjoxNzUzOTMwMzA0OTE2Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Jul 2025 23:51:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcNotif
*------------------------------------------------------------------------------------
* <Rating>-31</Rating>
*------------------------------------------------------------------------------------
SUBROUTINE ABC.ENVIA.NOTIF.ALTERNA.SELECT
*------------------------------------------------------------------------------------
*===============================================================================
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:                2021-04-22
* Descripcion:          Rutina SELECT para enviar la notificacion alterna.
*===============================================================================

    $USING EB.DataAccess
    $USING EB.Service

    GOSUB INICIALIZA
    GOSUB PROCESO
    GOSUB FINALIZA

RETURN

***********
INICIALIZA:
***********

    SEL.CMD = ''
    Y.LIST = ''
    Y.CNT = ''
    Y.SEL.ERR = ''

RETURN

********
PROCESO:
********

    SEL.CMD = "SELECT ":AbcNotif.getFnSmsEmail():" WITH ((STATUS.ALTERNA EQ '' AND NOTIFICA.ALTERNA EQ 'SI') OR (STATUS.GALILEO EQ '' AND NOTIFICA.GALILEO EQ 'SI')) BY DATE.TIME"
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST,'',Y.CNT,Y.SEL.ERR)
    
    EB.Service.BatchBuildList('',Y.LIST)

RETURN

*********
FINALIZA:
*********

RETURN

END
