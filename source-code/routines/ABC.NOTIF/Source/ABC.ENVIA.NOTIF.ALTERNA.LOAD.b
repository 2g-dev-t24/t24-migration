*------------------------------------------------------------------------------------
* <Rating>-26</Rating>
*------------------------------------------------------------------------------------
    SUBROUTINE ABC.ENVIA.NOTIF.ALTERNA.LOAD
*------------------------------------------------------------------------------------
*===============================================================================
* Desarrollador:        César Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:                2021-04-22
* Descripción:          Rutina LOAD para enviar la notificacion alterna.
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20220907
* Compania:             ABC Capital
* Fecha:                2022-09-07
* Descripción:          Se crea nuevo flujo para tipo EMAIL.SPEI.DEV
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20241028
* Compania:             ABC Capital
* Fecha:                2024-10-28
* Descripción:          ABCCORE-3098 Modificación al servicio de notificaciones

    $INCLUDE ../T24_BP I_COMMON
    $INCLUDE ../T24_BP I_EQUATE
    $INCLUDE ../T24_BP I_TSA.COMMON
    $INCLUDE ../T24_BP I_ENQUIRY.COMMON
    $INCLUDE ../T24_BP I_GTS.COMMON

    $INCLUDE ../T24_BP I_F.STANDARD.SELECTION

    $INCLUDE ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR

    $INCLUDE ABC.BP I_ABC.ENVIA.NOTIF.ALTERNA.COMMON
    $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM



    GOSUB INICIALIZA
*     GOSUB OBTIENE.PARAMERTIZACION
    GOSUB FINALIZA

    RETURN

***********
INICIALIZA:
***********

    FN.SS        = 'F.STANDARD.SELECTION' ; F.SS        = '' ; CALL OPF(FN.SS,F.SS)
    FN.SMS.EMAIL = 'F.ABC.SMS.EMAIL.ENVIAR' ; F.SMS.EMAIL = '' ; CALL OPF(FN.SMS.EMAIL,F.SMS.EMAIL)
*CAST20220907.I
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)
*CAST20220907.F

*CAST20241028.I
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    CALL OPF(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
    Y.PARAM.MENSAJE.RESPUESTA =''
    Y.PARAM.STATUS.RESPUESTA=''
    CALL F.READ(FN.ABC.GENERAL.PARAM,"NOTIFICACION.ALTERNA.RESP.GALILEO",R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,F.ERROR)
    IF R.ABC.GENERAL.PARAM THEN
        Y.NOMBRES.PARAMETROS = R.ABC.GENERAL.PARAM<PBS.GEN.PARAM.NOMB.PARAMETRO>
        Y.DATOS.PARAMETROS = R.ABC.GENERAL.PARAM<PBS.GEN.PARAM.DATO.PARAMETRO>
        Y.NO.PARAM = DCOUNT(Y.DATOS.PARAMETROS,VM)
        CONVERT '|' TO SM IN Y.DATOS.PARAMETROS
        FOR Y.AA=1 TO Y.NO.PARAM
            Y.PARAMETRO = R.ABC.GENERAL.PARAM<PBS.GEN.PARAM.NOMB.PARAMETRO,Y.AA>
            IF Y.PARAMETRO EQ 'OK' OR Y.PARAMETRO EQ 'ERROR' THEN
                Y.PARAM.MENSAJE.RESPUESTA<-1> = Y.DATOS.PARAMETROS<1,Y.AA,1>
                Y.PARAM.STATUS.RESPUESTA<-1> = Y.DATOS.PARAMETROS<1,Y.AA,2>
            END
        NEXT Y.AA
        FIND 'STATUS.GENERAN.LOG' IN Y.NOMBRES.PARAMETROS SETTING Y.FM.POS, Y.VM.POS THEN
            Y.STATUS.GENERAN.LOG = Y.DATOS.PARAMETROS<1,Y.VM.POS>
            CONVERT SM TO FM IN Y.STATUS.GENERAN.LOG
        END
    END
*CAST20241028.F


    YSEP = '|'

    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")

    Y.DATE = TODAY[3,6]

    Y.SALTO = CHAR(10)

    Y.CANALES = ''

    RETURN

* ************************
* OBTIENE.PARAMERTIZACION:
* ************************

*     Y.ID.GEN.PARAM = 'NOTIFICACION.ALTERNA.CANALES'

*     CALL ABC.GET.GENERAL.PARAM(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

*     LOCATE "LISTA.CANALES" IN Y.LIST.PARAMS SETTING YPOS.CANALES THEN
*         Y.CANALES = Y.LIST.VALUES<YPOS.CANALES>
*         CHANGE ',' TO ' ' IN Y.CANALES
*     END

*     RETURN

*********
FINALIZA:
*********

    RETURN

END
