*------------------------------------------------------------------------------------
* <Rating>-31</Rating>
*------------------------------------------------------------------------------------
    SUBROUTINE ABC.ENVIA.NOTIF.ALTERNA.SELECT
*------------------------------------------------------------------------------------
*===============================================================================
* Desarrollador:        César Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:                2021-04-22
* Descripción:          Rutina SELECT para enviar la notificacion alterna.
*===============================================================================


    $INCLUDE ../T24_BP I_COMMON
    $INCLUDE ../T24_BP I_EQUATE
    $INCLUDE ../T24_BP I_TSA.COMMON
    $INCLUDE ../T24_BP I_ENQUIRY.COMMON
    $INCLUDE ../T24_BP I_GTS.COMMON

    $INCLUDE ../T24_BP I_F.STANDARD.SELECTION

    $INCLUDE ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR

    $INCLUDE ABC.BP I_ABC.ENVIA.NOTIF.ALTERNA.COMMON


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

*    SEL.CMD = "SELECT ":FN.SMS.EMAIL:" WITH ((STATUS.ALTERNA EQ '' AND NOTIFICA.ALTERNA EQ 'SI') OR (STATUS.GALILEO EQ '' AND NOTIFICA.GALILEO EQ 'SI')) AND CANAL EQ ":Y.CANALES:" BY DATE.TIME"

    SEL.CMD = "SELECT ":FN.SMS.EMAIL:" WITH ((STATUS.ALTERNA EQ '' AND NOTIFICA.ALTERNA EQ 'SI') OR (STATUS.GALILEO EQ '' AND NOTIFICA.GALILEO EQ 'SI')) BY DATE.TIME"

    CALL EB.READLIST(SEL.CMD,Y.LIST,'',Y.CNT,Y.SEL.ERR)
    
    CALL BATCH.BUILD.LIST('',Y.LIST)

    RETURN

*********
FINALIZA:
*********

    RETURN

END
