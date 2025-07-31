* @ValidationCode : MjoxOTk4MDkzMTAwOkNwMTI1MjoxNzUzOTMwODkwMDUxOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 Jul 2025 00:01:30
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
* <Rating>-26</Rating>
*------------------------------------------------------------------------------------
SUBROUTINE ABC.ENVIA.NOTIF.ALTERNA.LOAD
*------------------------------------------------------------------------------------
*===============================================================================
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:                2021-04-22
* Descripcion:          Rutina LOAD para enviar la notificacion alterna.
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20220907
* Compania:             ABC Capital
* Fecha:                2022-09-07
* Descripcion:          Se crea nuevo flujo para tipo EMAIL.SPEI.DEV
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20241028
* Compania:             ABC Capital
* Fecha:                2024-10-28
* Descripcion:          ABCCORE-3098 Modificacion al servicio de notificaciones

    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    
    GOSUB INICIALIZA
    GOSUB FINALIZA

RETURN

***********
INICIALIZA:
***********
    TODAY = EB.SystemTables.getToday()
    FN.SS        = 'F.STANDARD.SELECTION'
    F.SS        = ''
    EB.DataAccess.Opf(FN.SS,F.SS)
    AbcNotif.setFnSs(FN.SS)
    AbcNotif.setFSs(F.SS)
    
    FN.SMS.EMAIL = 'F.ABC.SMS.EMAIL.ENVIAR'
    F.SMS.EMAIL = ''
    EB.DataAccess.Opf(FN.SMS.EMAIL,F.SMS.EMAIL)
    AbcNotif.setFnSmsEmail(FN.SMS.EMAIL)
    AbcNotif.setFSmsEmail(F.SMS.EMAIL)
        
*CAST20220907.I
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    EB.DataAccess.Opf(FN.FT,F.FT)
    AbcNotif.setFnFt(FN.FT)
    AbcNotif.setFFt(F.FT)
    
    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU = ''
    EB.DataAccess.Opf(FN.FT.NAU,F.FT.NAU)
    AbcNotif.setFnFtNau(FN.FT.NAU)
    AbcNotif.setFFtNau(F.FT.NAU)
*CAST20220907.F

*CAST20241028.I
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
        
    Y.PARAM.MENSAJE.RESPUESTA =''
    Y.PARAM.STATUS.RESPUESTA=''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,"NOTIFICACION.ALTERNA.RESP.GALILEO",R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,F.ERROR)
    IF R.ABC.GENERAL.PARAM THEN
        Y.NOMBRES.PARAMETROS = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>
        Y.DATOS.PARAMETROS = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>
        Y.NO.PARAM = DCOUNT(Y.DATOS.PARAMETROS,@VM)
        CONVERT '|' TO @SM IN Y.DATOS.PARAMETROS
        FOR Y.AA=1 TO Y.NO.PARAM
            Y.PARAMETRO = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro,Y.AA>
            IF Y.PARAMETRO EQ 'OK' OR Y.PARAMETRO EQ 'ERROR' THEN
                Y.PARAM.MENSAJE.RESPUESTA<-1> = Y.DATOS.PARAMETROS<1,Y.AA,1>
                Y.PARAM.STATUS.RESPUESTA<-1> = Y.DATOS.PARAMETROS<1,Y.AA,2>
            END
        NEXT Y.AA
        AbcNotif.setYParamMensajeRespuesta(Y.PARAM.MENSAJE.RESPUESTA)
        AbcNotif.setYParamStatusRespuesta(Y.PARAM.STATUS.RESPUESTA)
        FIND 'STATUS.GENERAN.LOG' IN Y.NOMBRES.PARAMETROS SETTING Y.FM.POS, Y.VM.POS THEN
            Y.STATUS.GENERAN.LOG = Y.DATOS.PARAMETROS<1,Y.VM.POS>
            CONVERT @SM TO @FM IN Y.STATUS.GENERAN.LOG
            AbcNotif.setYStatusGeneranLog(Y.STATUS.GENERAN.LOG)
        END
    END
*CAST20241028.F


    YSEP = '|'

    AbcNotif.setFechaFile(FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4"))

    Y.DATE = TODAY[3,6]

    AbcNotif.setYSalto(CHAR(10))

    Y.CANALES = ''

RETURN

*********
FINALIZA:
*********

RETURN

END
