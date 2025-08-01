* @ValidationCode : MjoxODcxMjUxNzU1OkNwMTI1MjoxNzU0MDI2MjgwMzAyOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Aug 2025 02:31:20
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
*-----------------------------------------------------------------------------
* <Rating>58</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.ENV.EMAIL.SPEI.DEV
*===============================================================================
* Desarrollador:        FyG Solutions
* Compania:             ABC Capital
* Fecha:                2020-07-07
* Descripcion:          Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR para
* la notificacion de correo para EMAIL.SPEI.DEV
*===============================================================================
* Desarrollador:        CAST - FyG Solutions  CAST20220907
* Compania:             ABC Capital
* Fecha:                2022-09-07
* Descripcion:          Si la rutina es llamada desde ABC.ENVIA.NOTIF.ALTERNA lee el registro desde ABC.SMS.EMAIL.ENVIAR y toma la informacion
*      Cuando se llama desde ABC.ENVIA.NOTIF.ALTERNA se le agrega un 0 en la referencia

    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING FT.Contract
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AbcTable
    $USING AC.AccountOpening
    $USING ABC.BP
    
    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    TODAY = EB.SystemTables.getToday()

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

*CAST20220907.I
    FN.ABC.SMS.EMAIL.ENVIAR = 'F.ABC.SMS.EMAIL.ENVIAR'
    F.ABC.SMS.EMAIL.ENVIAR = ''
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)
*CAST20220907.F

    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","RASTREO", POS.RASTREO)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','EXT.TRANS.ID', POS.EXT.TRANS.ID)
    EB.LocalReferences.GetLocRef("ACCOUNT", "CANAL", Y.POS.CANAL.ACC)
    EB.LocalReferences.GetLocRef("ACCOUNT", "PRN", Y.POS.PRN.ACC)

    Y.TIPO.EMAIL = "EMAIL.SPEI.DEV"
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.NO.REF = EB.SystemTables.getIdNew()
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    Y.EXT.TRANS.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.EXT.TRANS.ID = Y.EXT.TRANS.ID<1,POS.EXT.TRANS.ID>

*CAST20220907.I
    IF ID.SMS.EMAIL.ORI NE '' THEN
        R.ABC.SMS.EMAIL.ENVIAR = ''
        EB.DataAccess.FRead(FN.ABC.SMS.EMAIL.ENVIAR,ID.SMS.EMAIL.ORI,R.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR,Y.ERR.SMS)
        IF R.ABC.SMS.EMAIL.ENVIAR THEN
            Y.MONTO = R.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>
            Y.NO.CUENTA = R.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>
            Y.NO.REF = R.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>:'0'
            Y.DATE.TIME = TODAY[3,6]:TIMEDATE()[1,2]:TIMEDATE()[4,2]
            Y.EXT.TRANS.ID = R.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.ExtTransId>
        END
    END
*CAST20220907.F
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
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    EB.DataAccess.FRead(FN.CUENTA,Y.NO.CUENTA,R.CUENTA,F.CUENTA,ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
*********** TODO A DEFINIR DE DONDE VIENE ****************************
    Y.CANAL.ENTIDAD = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.CANAL.ACC>
    Y.PRN = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.PRN.ACC>
*********** TODO A DEFINIR DE DONDE VIENE ****************************


    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)

    EB.SystemTables.setComi(Y.ID.CUS:'*1')
    ABC.BP.VpmVCustomerName()
    Y.NOMBRE = EB.SystemTables.getComiEnri()

*ITSS-SINDHU-START
*    CALL DBR('CUSTOMER':FM:EB.CUS.EMAIL.1,Y.ID.CUS,Y.RESUL.EMAIL)
    EB.DataAccess.FRead(FN.CLIENTE,Y.ID.CUS,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
    Y.RESUL.EMAIL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne>
*ITSS-SINDHU-END
    GOSUB OBTIENE.ID

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>   = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>  = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>   = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>   = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>   =   Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>   = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.NO.REF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>        = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>          = Y.PRN
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.ExtTransId> = Y.EXT.TRANS.ID

    IF Y.CANAL.ENTIDAD NE '' THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.SaldoCuenta> = Y.WORKING.BALANCE
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'NO'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'SI'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'NO'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.GALILEO.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaGalileo> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaGalileo> = 'NO'
    END

    WRITE REC.ABC.SMS.EMAIL.ENVIAR TO F.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR

RETURN

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------
