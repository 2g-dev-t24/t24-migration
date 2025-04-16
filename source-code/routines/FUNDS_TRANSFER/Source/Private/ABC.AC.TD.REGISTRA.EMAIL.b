* @ValidationCode : MjotMzU2ODk3MTk0OkNwMTI1MjoxNzQ0ODIzODc4ODIwOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 12:17:58
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

*-----------------------------------------------------------------------------
* <Rating>-74</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.AC.TD.REGISTRA.EMAIL
*===============================================================================
* Desarrollador:        C�sar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:          2019-04-04
* Descripci�n:          Rutina que guarda la informacion para la notificacion de correo
*                       cuando se realiza una transferencia a tarjeta de d�bito.
*===============================================================================
* Fecha Modificacion :  2020-07-27
* Modificado por     :  Cesar Miranda - FyG Solutions
* Descripcion        :  Se agrega funcionalidad para la parametrizaci�n de notificaci�n
*                       por email y alterna seg�n el canal
*===============================================================================


*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*
*    $INCLUDE ../T24_BP I_F.CUSTOMER
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
*    $INCLUDE ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR
*
*    $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.Updates
    $USING ST.Customer
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*****
INIT:
*****

*    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
*    F.ABC.SMS.EMAIL.ENVIAR = ""
*    CALL OPF(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)
*
*    FN.CLIENTE = 'F.CUSTOMER'
*    F.CLIENTE = ''
*    CALL OPF(FN.CLIENTE,F.CLIENTE)
*
*    FN.CUENTA = 'F.ACCOUNT'
*    F.CUENTA = ''
*    CALL OPF(FN.CUENTA,F.CUENTA)
*
*    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
*    F.ABC.GENERAL.PARAM = ""
*    CALL OPF(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
*
*    CALL GET.LOCAL.REFM('FUNDS.TRANSFER','REFERENCIA', POS.REFERENCIA)
*
*    CALL GET.LOCAL.REFM("FUNDS.TRANSFER","CANAL.ENTIDAD", POS.CANAL.ENTIDAD)
*    Y.CANAL.ENTIDAD = R.NEW(FT.LOCAL.REF)<1,POS.CANAL.ENTIDAD>
*
*    CALL GET.LOCAL.REFM('FUNDS.TRANSFER','EXT.TRANS.ID', POS.EXT.TRANS.ID)
    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = 'REFERENCIA'
    fields<1,2>      = "CANAL.ENTIDAD"
    fields<1,3>      = "EXT.TRANS.ID"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    POS.REFERENCIA     = field_Positions<1,1>
    POS.CANAL.ENTIDAD     = field_Positions<1,2>
    POS.EXT.TRANS.ID     = field_Positions<1,3>
    
    
    Y.CANAL.ENTIDAD = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,POS.CANAL.ENTIDAD>
RETURN

********
PROCESS:
********

    Y.CUENTA.ORD = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)      ;*R.NEW(FT.DEBIT.ACCT.NO)
    Y.LEN.CTA = LEN(Y.CUENTA.ORD) - 3
    Y.CUENTA.BEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)      ;*R.NEW(FT.CREDIT.ACCT.NO)
    Y.TARJETA.BEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)        ;*R.NEW(FT.PAYMENT.DETAILS)
    Y.LEN.TAR = LEN(Y.TARJETA.BEN) - 3
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)        ;*R.NEW(FT.DEBIT.AMOUNT)
    Y.REFERENCIA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,POS.REFERENCIA>        ;*R.NEW(FT.LOCAL.REF)<1,POS.REFERENCIA>
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)        ;*R.NEW(FT.DATE.TIME)
    Y.EXT.TRANS.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,POS.EXT.TRANS.ID>        ;*R.NEW(FT.LOCAL.REF)<1,POS.EXT.TRANS.ID>

    R.INFO.CUENTA = ''; ERROR.CUENTA = '';
*    CALL F.READ(FN.CUENTA,Y.CUENTA.ORD,R.INFO.CUENTA,F.CUENTA,ERROR.CUENTA)
    R.INFO.CUENTA = AC.AccountOpening.Account.Read(Y.CUENTA.ORD, ERROR.CUENTA)
    Y.CLIENTE = R.INFO.CUENTA<AC.AccountOpening.Account.Customer>       ;*R.INFO.CUENTA<AC.CUSTOMER>

    R.INFO.CUENTA = ''; ERROR.CUENTA = '';
*    CALL F.READ(FN.CUENTA,Y.CUENTA.BEN,R.INFO.CUENTA,F.CUENTA,ERROR.CUENTA)
    R.INFO.CUENTA = AC.AccountOpening.Account.Read(Y.CUENTA.BEN, ERROR.CUENTA)
    Y.CLIENTE.BEN = R.INFO.CUENTA<AC.AccountOpening.Account.Customer>       ;*<AC.CUSTOMER>

*    COMI = Y.CLIENTE:'*1'
    EB.SystemTables.setComi(Y.CLIENTE:'*1')
    ABC.BP.vpmVCustomerName()
    Y.CLIENTE.NOMBRE = EB.SystemTables.getComiEnri()        ;*COMI.ENRI

    COMI = Y.CLIENTE.BEN:'*1'
    EB.SystemTables.setComi(Y.CLIENTE.BEN:'*1')
    ABC.BP.vpmVCustomerName()
    Y.CLIENTE.BEN.NOMBRE = EB.SystemTables.getComiEnri()    ;*COMI.ENRI

    Y.TIPO.EMAIL = "EMAIL.AC.ORD.TD"
    Y.TIPO.EMAIL.2 = "EMAIL.AC.BEN.TD"
    Y.ASUNTO.EMAIL = "Transacci�n Realizada"

    R.INFO.CLIENTE = ''; ERROR.CLIENTE = '';
*    CALL F.READ(FN.CLIENTE,Y.CLIENTE,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
    R.INFO.CLIENTE = ST.Customer.Customer.Read(Y.CLIENTE, ERROR.CLIENTE)
    Y.CLIENTE.EMAIL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne,1>        ;*<EB.CUS.EMAIL.1,1>

    R.INFO.CLIENTE = ''; ERROR.CLIENTE = '';
*    CALL F.READ(FN.CLIENTE,Y.CLIENTE.BEN,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
    R.INFO.CLIENTE = ST.Customer.Customer.Read(Y.CLIENTE.BEN, ERROR.CLIENTE)
    Y.CLIENTE.BEN.EMAIL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne,1>        ;*<EB.CUS.EMAIL.1,1>

    R.DATOS = ABC.BP.AbcGeneralParam.Read(Y.TIPO.EMAIL, ERR.PARAM)
* Before incorporation : CALL F.READ(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.ASUNTO.EMAIL = R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamModulo>        ;*<PBS.GEN.PARAM.MODULO>
    Y.LIST.PARAMS = RAISE(R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro>)        ;*RAISE(R.DATOS<PBS.GEN.PARAM.NOMB.PARAMETRO>)
    Y.LIST.VALUES = RAISE(R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamDatoParametro>)        ;*RAISE(R.DATOS<PBS.GEN.PARAM.DATO.PARAMETRO>)

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

    GOSUB OBTIENE.ID
    GOSUB GENERA.REGISTRO
    GOSUB ENVIA.NOTIFICACION

    Y.CLIENTE = Y.CLIENTE.BEN
    Y.CLIENTE.EMAIL = Y.CLIENTE.BEN.EMAIL
    Y.TIPO.EMAIL = Y.TIPO.EMAIL.2

    R.DATOS = ABC.BP.AbcGeneralParam.Read(Y.TIPO.EMAIL, ERR.PARAM)
* Before incorporation : CALL F.READ(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.ASUNTO.EMAIL = R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamModulo>        ;*R.DATOS<PBS.GEN.PARAM.MODULO>
    Y.LIST.PARAMS = RAISE(R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro>)        ;*RAISE(R.DATOS<PBS.GEN.PARAM.NOMB.PARAMETRO>)
    Y.LIST.VALUES = RAISE(R.DATOS<ABC.BP.AbcGeneralParam.PbsGenParamDatoParametro>)        ;*RAISE(R.DATOS<PBS.GEN.PARAM.DATO.PARAMETRO>)

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

    GOSUB OBTIENE.ID
    GOSUB GENERA.REGISTRO
    GOSUB ENVIA.NOTIFICACION

RETURN

****************
GENERA.REGISTRO:
****************

    REC.ABC.SMS.EMAIL.ENVIAR = ''
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUSTOMER>   = Y.CLIENTE
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.TIPO.EMAIL>  = Y.TIPO.EMAIL
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.ASUNTO.EMAIL>  = Y.ASUNTO.EMAIL
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOMBRE>   = Y.CLIENTE.NOMBRE
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOMBRE.BEN>   = Y.CLIENTE.BEN.NOMBRE
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.EMAIL>   = Y.CLIENTE.EMAIL
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUENTA>   = Y.TARJETA.BEN[Y.LEN.TAR,4]
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUENTA.CLIENTE>   = Y.CUENTA.ORD[Y.LEN.CTA,4]
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.MONTO>   = Y.MONTO     ;*FMT(Y.MONTO, "R2,& #20")
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.HORA>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.FECHA>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.REFERENCIA>   = Y.REFERENCIA
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CANAL> = Y.CANAL.ENTIDAD
*    REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.EXT.TRANS.ID>   = Y.EXT.TRANS.ID

    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCustomer>   = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarTipoEmail>  = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarAsuntoEmail>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNombre>   = Y.CLIENTE.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNombreBen>   = Y.CLIENTE.BEN.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarEmail>   = Y.CLIENTE.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCuenta>   = Y.TARJETA.BEN[Y.LEN.TAR,4]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCuentaCliente>   = Y.CUENTA.ORD[Y.LEN.CTA,4]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarMonto>   = Y.MONTO     ;*FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarHora>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarFecha>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarReferencia>   = Y.REFERENCIA
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCanal> = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarExtTransId>   = Y.EXT.TRANS.ID


    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
*        REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOTIFICA.EMAIL> = 'NO'
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaEmail> = 'NO'
    END ELSE
*        REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOTIFICA.EMAIL> = 'SI'
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaEmail> = 'SI'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
*        REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOTIFICA.ALTERNA> = 'SI'
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaAlterna> = 'SI'
    END ELSE
*        REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOTIFICA.ALTERNA> = 'NO'
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaAlterna> = 'NO'
    END

*    WRITE REC.ABC.SMS.EMAIL.ENVIAR TO F.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR
    ABC.BP.AbcSmsEmailEnviar.Write(ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

***********
OBTIENE.ID:
***********

*     SEL.CMD = ''
*     Y.LIST = ''
*     Y.CNT = ''
*     Y.SEL.ERR = ''
*     SEL.CMD = "SELECT ":FN.ABC.SMS.EMAIL.ENVIAR:" WITH @ID LIKE ":Y.CLIENTE:"-":TODAY:"... BY @ID"
*     CALL EB.READLIST(SEL.CMD,Y.LIST,'',Y.CNT,Y.SEL.ERR)

*     IF Y.CNT GT 0 THEN
*         Y.CONSECUTIVO = FIELD(Y.LIST<Y.CNT>,'.',2)
*         Y.CONSECUTIVO += 1
*         Y.CONSECUTIVO = FMT(Y.CONSECUTIVO,"2'0'R")
*         ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":TODAY:".":Y.CONSECUTIVO
*     END ELSE
*         ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":TODAY:".01"
*     END
    sGetTODAY = EB.SystemTables.getToday()
    ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":sGetTODAY:".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]

RETURN

*******************
ENVIA.NOTIFICACION:
*******************

*    CALL ABC.ENVIA.NOTIFICACION.EMAIL(ID.ABC.SMS.EMAIL.ENVIAR)

RETURN

********
FINALLY:
********

RETURN

END
