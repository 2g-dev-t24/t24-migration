* @ValidationCode : MjoxOTA0NzIwMzA3OkNwMTI1MjoxNzQ0ODM3MjE5ODI5Om1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:00:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
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
* <Rating>60</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.ENV.EMAIL.MIGRACION
*===============================================================================
* Desarrollador:        Luis Cruz - FyG Solutions
* Compania:             ABC Capital
* Fecha:                2022-04-05
* Descripci�n:          Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR
* para la notificacion de correo para EMAIL.MIGRACION
*===============================================================================
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------

* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_F.CUSTOMER  ;* Not Used anymore
* $INSERT I_F.ACCOUNT  ;* Not Used anymore
* $INSERT I_F.FUNDS.TRANSFER  ;* Not Used anymore
* $INSERT I_F.ABC.GENERAL.PARAM - Not Used anymore;
* $INSERT I_F.ABC.SMS.EMAIL.ENVIAR - Not Used anymore;
    
    $USING EB.Versions
    $USING EB.SystemTables
*    $USING EB.DataAccess - Not Used anymore;
    $USING EB.ErrorProcessing
    $USING ST.Customer
    $USING FT.Contract
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING ABC.BP

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

*    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
*    FV.ABC.SMS.EMAIL.ENVIAR = ""
*    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR, FV.ABC.SMS.EMAIL.ENVIAR)
*
*    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
*    FV.ABC.GENERAL.PARAM = ""
*    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)
*
*    FN.CLIENTE = "F.CUSTOMER"
*    FV.CLIENTE = ""
*    EB.DataAccess.Opf(FN.CLIENTE, FV.CLIENTE)
*
*    FN.CUENTA = "F.ACCOUNT"
*    FV.CUENTA = ""
*    EB.DataAccess.Opf(FN.CUENTA, FV.CUENTA)

*    CALL GET.LOCAL.REFM("ACCOUNT", "CANAL", Y.POS.CANAL.ACC)
    applications     = ""
    fields           = ""
    applications<1>  = "ACCOUNT"
    fields<1,1>      = "CANAL"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    Y.POS.CANAL.ACC = field_Positions<1,1>

    Y.TIPO.EMAIL = "EMAIL.MIGRACION"
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.NO.REF = EB.SystemTables.getIdNew()
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)

*    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.TIPO.EMAIL, R.DATOS.EMAIL, FV.ABC.GENERAL.PARAM, ERR.PARAM)
    R.DATOS.EMAIL = ABC.BP.AbcGeneralParam.Read(Y.TIPO.EMAIL, ERR.PARAM)
    
    Y.ASUNTO.EMAIL = R.DATOS.EMAIL<ABC.BP.AbcGeneralParam.PbsGenParamModulo>
    Y.LIST.PARAMS = RAISE(R.DATOS.EMAIL<ABC.BP.AbcGeneralParam.PbsGenParamNombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS.EMAIL<ABC.BP.AbcGeneralParam.PbsGenParamDatoParametro>)

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
        Y.CANAL.ALTERNA.LISTA = "VACIO"
    END

    LOCATE "Y.CANAL.GALILEO" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.GALILEO.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.GALILEO.LISTA
    END ELSE
        Y.CANAL.GALILEO.LISTA = "VACIO"
    END

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

*    EB.DataAccess.FRead(FN.CUENTA, Y.NO.CUENTA, R.CUENTA, FV.CUENTA, ERR.CUENTA)
    R.CUENTA = AC.AccountOpening.Account.Read(Y.NO.CUENTA,ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
    Y.CANAL.ENTIDAD = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.CANAL.ACC>

    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA, 4)

    EB.SystemTables.setComi(Y.ID.CUS : '*1')
    ABC.BP.vpmVCustomerName()
    Y.NOMBRE = EB.SystemTables.getComiEnri()

*    EB.DataAccess.FRead(FN.CLIENTE, Y.ID.CUS, R.CUSTOMER, FV.CLIENTE, ERR.PARAM)
    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,ERR.PARAM)
    Y.RESUL.EMAIL = R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>
    GOSUB OBTIENE.ID

    Y.PROCESO.MILI = FIELD(TIMESTAMP(), '.', 2)
    Y.PROCESO.MILO = Y.PROCESO.MILI [1, 3]

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCustomer>     = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarTipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarAsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNombre>       = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarEmail>        = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCuenta>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarMonto>        = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarHora>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarFecha>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarReferencia>   = Y.NO.REF
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarFechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarCanal>        = Y.CANAL.ENTIDAD

    IF Y.CANAL.ENTIDAD NE '' THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarSaldoCuenta> = Y.WORKING.BALANCE
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaEmail> = 'NO'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaEmail> = 'SI'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaAlterna> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaAlterna> = 'NO'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.GALILEO.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaGalileo> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<ABC.BP.AbcSmsEmailEnviar.AbcSmsEmailEnviarNotificaGalileo> = 'NO'
    END

*    WRITE REC.ABC.SMS.EMAIL.ENVIAR TO FV.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR
*    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR,ID.ABC.SMS.EMAIL.ENVIAR,REC.ABC.SMS.EMAIL.ENVIAR)
    ABC.BP.AbcSmsEmailEnviar.Write(ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE : "-" : EB.SystemTables.getToday() : "." : TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2] : TIMEDATE()[7,2]

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------
