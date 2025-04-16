* @ValidationCode : MjotMTU5NjQ4NjI6Q3AxMjUyOjE3NDQ3NDc5MzgxNDY6VXNpYXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Apr 2025 15:12:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
.
*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.ENV.EMAIL.TRAS.AC.2
*===============================================================================
* Nombre de Programa : ABC.ENV.EMAIL.TRAS.AC.2
* Objetivo           : Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR
*                      para la notificacion de pago express con una autorizacion
* Requerimiento      : Refactor
* Desarrollado por   : Fyg Solutions
* Compania           : UALA
* Fecha Creacion     : 2023/09/01
*===============================================================================
* Modificaciones:
*===============================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.CUSTOMER
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*$INSERT I_F.ABC.GENERAL.PARAM
*INSERT I_F.ABC.SMS.EMAIL.ENVIAR
    
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AC.Config
    $USING ABC.BP

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)

*    CALL GET.LOCAL.REFM("ACCOUNT", "PRN", Y.POS.PRN.ACC)
*    CALL GET.LOCAL.REFM("ACCOUNT","CANAL", POS.CANAL.ENTIDAD)
*    CALL GET.LOCAL.REFM("FUNDS.TRANSFER","RASTREO", POS.RASTREO)
*    CALL GET.LOC.REF('FUNDS.TRANSFER','EXT.TRANS.ID', POS.EXT.TRANS.ID)
    Y.NOMBRE.APP<-1> = "ACCOUNT"
    Y.NOMBRE.CAMPO<1,1> = "PRN"
    Y.NOMBRE.CAMPO<1,2> = "CANAL"
    Y.NOMBRE.APP<-1> = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO<2,1> = "RASTREO"
    Y.NOMBRE.CAMPO<2,2> = "EXT.TRANS.ID"
    R.POS.CAMPO = ''
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)

    Y.POS.PRN.ACC = R.POS.CAMPO<1,1>
    POS.CANAL.ENTIDAD = R.POS.CAMPO<1,2>
    POS.RASTREO = R.POS.CAMPO<2,1>
    POS.EXT.TRANS.ID = R.POS.CAMPO<2,2>
    
*    CALL GET.LOCAL.REFM("FUNDS.TRANSFER","CANAL.ENTIDAD", POS.CANAL.ENTIDAD)
*    Y.CANAL.ENTIDAD = R.NEW(FT.LOCAL.REF)<1,POS.CANAL.ENTIDAD>

    Y.TIPO.EMAIL = "EMAIL.TRASPASO.2"
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount) ;*R.NEW(FT.DEBIT.AMOUNT)    ;*R.NEW(FT.CREDIT.AMOUNT)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo) ;*R.NEW(FT.DEBIT.ACCT.NO)
    Y.NO.CUENTA.BEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo) ;*R.NEW(FT.CREDIT.ACCT.NO)
    Y.CREDIT.THEIR.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditTheirRef) ;*R.NEW(FT.CREDIT.THEIR.REF)
    Y.LEN.THEIR.REF = LEN(Y.CREDIT.THEIR.REF)-3
    Y.TERMINACION.CTA = Y.CREDIT.THEIR.REF[Y.LEN.THEIR.REF,4]
    Y.RASTREO = EB.SystemTables.getIdNew() ;*ID.NEW
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.EXT.TRANS.ID = Y.LOCAL.REF<1, POS.EXT.TRANS.ID> ;*R.NEW(FT.LOCAL.REF)<1,POS.EXT.TRANS.ID>

    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime) ;*R.NEW(FT.DATE.TIME)

    R.DATOS = ABC.BP.AbcGeneralParam.Read(Y.TIPO.EMAIL, ERR.PARAM)
* Before incorporation : CALL F.READ(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.ASUNTO.EMAIL = R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamModulo> ;*R.DATOS<PBS.GEN.PARAM.MODULO>
    Y.LIST.PARAMS = RAISE(R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro>) ;*(R.DATOS<PBS.GEN.PARAM.NOMB.PARAMETRO>)
    Y.LIST.VALUES = RAISE(R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamDatoParametro>) ;*(R.DATOS<PBS.GEN.PARAM.DATO.PARAMETRO>)

    LOCATE "Y.CANAL.EMAIL" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.EMAIL.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.EMAIL.LISTA
    END ELSE
        Y.CANAL.EMAIL.LISTA = 'VACIO'
    END

    LOCATE "Y.CANAL.ALTERNA" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.ALTERNA.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.ALTERNA.LISTA
    END ELSE
        Y.CANAL.ALTERNA.LISTA = 'VACIO'
    END

    LOCATE "Y.CANAL.GALILEO" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.GALILEO.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.GALILEO.LISTA
    END ELSE
        Y.CANAL.GALILEO.LISTA = 'VACIO'
    END

RETURN

*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    R.CUENTA = AC.AccountOpening.Account.Read(Y.NO.CUENTA, ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer> ;*R.CUENTA<AC.CUSTOMER>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance> ;*R.CUENTA<AC.WORKING.BALANCE>
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.PRN = Y.LOCAL.REF<1, Y.POS.PRN.ACC> ;*R.CUENTA<AC.LOCAL.REF, Y.POS.PRN.ACC>
    Y.CANAL.ENTIDAD = Y.LOCAL.REF<1, POS.CANAL.ENTIDAD> ;*R.CUENTA<AC.LOCAL.REF, POS.CANAL.ENTIDAD>

    IF Y.CANAL.ENTIDAD EQ '' THEN
        Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)
        Y.NO.CUENTA.BEN = RIGHT(Y.NO.CUENTA.BEN,4)
    END

    EB.SystemTables.setComi(Y.ID.CUS:'*1') ;*COMI = Y.ID.CUS:'*1'
    ABC.BP.vpmVCustomerName()
    Y.NOMBRE = EB.SystemTables.getComiEnri() ;*COMI.ENRI

*ITSS-SINDHU-START
*    CALL DBR('CUSTOMER':FM:EB.CUS.EMAIL.1,Y.ID.CUS,Y.RESUL.EMAIL)
    R.INFO.CLIENTE = ST.Customer.Customer.Read(Y.ID.CUS, ERROR.CLIENTE)
    Y.RESUL.EMAIL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne> ;*<EB.CUS.EMAIL.1>
*ITSS-SINDHU-END
    GOSUB OBTIENE.ID

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    R.INFO.SMS.EMAIL = ''
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUSTOMER>   = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCustomer>   = Y.CLIENTE
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.TIPO.EMAIL>  = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarTipoEmail>  = Y.TIPO.EMAIL
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.ASUNTO.EMAIL>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarAsuntoEmail>  = Y.ASUNTO.EMAIL
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOMBRE>   = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNombre>  = Y.NOMBRE
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.EMAIL>   = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarEmail>   = Y.RESUL.EMAIL
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUENTA>   =   Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCuenta>   =   Y.NO.CUENTA
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUENTA.CLIENTE>   =   Y.NO.CUENTA.BEN
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCuentaCliente>   =   Y.NO.CUENTA.BEN
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.MONTO>   = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarMonto>   = FMT(Y.MONTO, "R2,& #20")
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.HORA>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarHora>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.FECHA>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarFecha>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.REFERENCIA>   = Y.RASTREO
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarReferencia>   = Y.RASTREO
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.FECHA.HORA>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarFechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CANAL>        = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCanal>        = Y.CANAL.ENTIDAD
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.PRN>          = Y.PRN
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarPrn>          = Y.PRN
*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.EXT.TRANS.ID> = Y.EXT.TRANS.ID
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarExtTransId> = Y.EXT.TRANS.ID
    IF Y.CANAL.ENTIDAD NE '' THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarSaldoCuenta> = Y.WORKING.BALANCE ;*<ABC.EMA.SALDO.CUENTA> = Y.WORKING.BALANCE
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaEmail> = 'NO' ;*<ABC.EMA.NOTIFICA.EMAIL> = 'NO'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaEmail> = 'SI' ;*<ABC.EMA.NOTIFICA.EMAIL> = 'SI'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaAlterna> = 'SI' ;*<ABC.EMA.NOTIFICA.ALTERNA> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaAlterna> = 'NO' ;*<ABC.EMA.NOTIFICA.ALTERNA> = 'NO'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.GALILEO.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaGalileo> = 'SI' ;*<ABC.EMA.NOTIFICA.GALILEO> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaGalileo> = 'NO' ;*<ABC.EMA.NOTIFICA.GALILEO> = 'NO'
    END

*WRITE REC.ABC.SMS.EMAIL.ENVIAR TO F.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR
    ABC.BP.AbcSmsEmailEnviar.Write(ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    sYToday = EB.SystemTables.getToday()
    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
*ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":sYToday:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:RND(100)

RETURN

*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------

RETURN
END
*-----------------------------------------------------------------------------
