*-----------------------------------------------------------------------------
* <Rating>47</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.EMAIL.RETIRO.EFECTIVO
*===============================================================================
* Rutina         : ABC.EMAIL.RETIRO.EFECTIVO
* Requerimiento  : Notificación para Retiro en Efectivo.
* Banco          : ABCCAPITAL
* Modificado por : 
* Tipo           : AUTHORISER ROUTINE
* Fecha          : 
* Descripcion    : Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR
*                  para la notificacion de Retiro en Efectivo.
*===============================================================================

    $USING TT.Contract
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING EB.Updates
    $USING AbcSpei
    $USING EB.LocalReferences

*    $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM
*    $INCLUDE ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINAL

    RETURN

*----------
INITIALISE:
*----------

    Y.TIPO.EMAIL       = ''
    Y.NO.CUENTA        = ''
    Y.RASTREO          = ''
    Y.MONTO            = ''
    Y.CANAL            = ''
    Y.ID.CUS           = ''
    Y.WORKING.BALANCE  = ''


    RETURN

*----------
OPEN.FILES:
*----------

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM    = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM    = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)

    FN.CUSTOMER = "F.CUSTOMER" 
    F.CUSTOMER = "" 
    EB.DataAccess.Opf (FN.CUSTOMER, F.CUSTOMER)

    EB.LocalReferences.GetLocRef("ACCOUNT", "CANAL", Y.POS.CANAL)
    EB.LocalReferences.GetLocRef("ACCOUNT", "PRN", Y.POS.PRN.ACC)

    Y.TIPO.EMAIL = "EMAIL.RETIRO"

    Y.DATE.TIME        = EB.SystemTables.getToday()

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)

    Y.ASUNTO.EMAIL = R.DATOS<AbcTable.AbcGeneralParam.Modulo>
    Y.LIST.PARAMS = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)

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

*-------
PROCESS:
*-------

    Y.REFERENCIA = EB.SystemTables.getIdNew()
    Y.NO.CUENTA  = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
    Y.MONTO      = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)

    EB.DataAccess.FRead(FN.CUENTA,Y.NO.CUENTA,R.CUENTA,F.CUENTA,ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
    Y.CANAL = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.CANAL>
    Y.PRN = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.PRN.ACC>


    COMI = Y.ID.CUS:'*1'
    Y.NOMBRE = EB.SystemTables.getComiEnri()
    AbcSpei.abcVCustomerName(COMI, Y.NOMBRE)

    EB.DataAccess.FRead(FN.CUSTOMER,Y.ID.CUS, RECORD.VAL, F.CUSTOMER, ERR.VAL)
    Y.RESUL.EMAIL = RECORD.VAL<ST.Customer.Customer.EbCusEmailOne>
    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]
    GOSUB OBTIENE.ID

    IF Y.CANAL EQ '' THEN Y.NO.CUENTA = Y.NO.CUENTA[LEN(Y.NO.CUENTA)-3,4]

    R.INFO.SMS.EMAIL = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>     = Y.ID.CUS
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>       = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = Y.DATE.TIME[1,4]:'-':Y.DATE.TIME[5,2]:'-':Y.DATE.TIME[7,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>         = TIMEDATE()[1,5]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = Y.DATE.TIME[1,4]:'-':Y.DATE.TIME[5,2]:'-':Y.DATE.TIME[7,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>        = Y.CANAL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>        = Y.MONTO
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.REFERENCIA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>          = Y.PRN

    IF Y.CANAL NE '' THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.SaldoCuenta> = Y.WORKING.BALANCE
    END

    LOCATE Y.CANAL IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'NO'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'SI'
    END

    LOCATE Y.CANAL IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'NO'
    END

    LOCATE Y.CANAL IN Y.CANAL.GALILEO.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaGalileo> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaGalileo> = 'NO'
    END

    IF Y.CANAL NE '' THEN
       EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR,ID.ABC.SMS.EMAIL.ENVIAR,REC.ABC.SMS.EMAIL.ENVIAR)
    END

    RETURN

*----------
OBTIENE.ID:
*----------

	ID.ABC.SMS.EMAIL.ENVIAR =Y.ID.CUS:"-":EB.SystemTables.getToday():".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

	RETURN

*-----
FINAL:
*-----

    RETURN

END
