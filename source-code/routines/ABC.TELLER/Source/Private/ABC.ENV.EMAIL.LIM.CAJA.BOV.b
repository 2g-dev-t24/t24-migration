*===============================================================================
* <Rating>-125</Rating>
*===============================================================================
$PACKAGE AbcTeller
    SUBROUTINE ABC.ENV.EMAIL.LIM.CAJA.BOV
*===============================================================================
* Nombre de Programa : ABC.ENV.EMAIL.LIM.CAJA.BOV
* Objetivo           : 
* Requerimiento      : 
* Desarrollador      : 
* Compania           : 
* Fecha Creacion     : 
*===============================================================================


    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Updates
    $USING ST.Config
    $USING BF.ConBalanceUpdates
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING ST.Config

    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

    RETURN

*-------------------------------------------------------------------------------
INICIA:
*-------------------------------------------------------------------------------

    Y.ID.DAO  = EB.SystemTables.getRNew(TT.Contract.Teller.TeDeptCode)
    Y.DATE.TIME  = EB.SystemTables.getRNew(TT.Contract.Teller.TeDateTime)
    Y.NO.REF     = EB.SystemTables.getIdNew()
    Y.CTA.CAJA =  ''          
    Y.CTA.BOVEDA = ''         
    Y.ID.GEN.PARAM = 'LIMITE.CAJA.BOV'
    Y.TIPO.EMAIL = "EMAIL.LIMITE.CAJA.BOVEDA"
    Y.LIST.PARAMS  = ''
    Y.LIST.VALUES  = ''
    Y.POS.PARAM    = ''
    Y.BENEFICIARIO = ''
    Y.HORA.NOTIF = Y.DATE.TIME[7,2] : ':' : Y.DATE.TIME[9,2]          
    Y.HORA.VALIDACION = Y.DATE.TIME[7,2] : Y.DATE.TIME[9,2]
    Y.VERSION.TT = EB.SystemTables.getPgmVersion()

    RETURN

*-------------------------------------------------------------------------------
ABRE.ARCHIVOS:
*-------------------------------------------------------------------------------

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR  = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
    F.DEPT.ACCT.OFFICER = ""
    EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER, F.DEPT.ACCT.OFFICER)

    RETURN

*-------------------------------------------------------------------------------
PROCESO:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM

    R.EB.CONTRACT.BALANCES = ""

    BEGIN CASE      ;

    CASE Y.TIPO.VALIDACION EQ 'BOVEDA'
        GOSUB VALIDA.LIMITE.BOVEDA

    CASE Y.TIPO.VALIDACION EQ 'CAJA' AND Y.VERSION.TT EQ ',VPM.2BR.EM.CASHINL'
        GOSUB VALIDA.LIMITE.DEPOSIT.CAJA

    CASE Y.TIPO.VALIDACION EQ 'CAJA' AND Y.VERSION.TT NE ',VPM.2BR.EM.CASHINL'
        GOSUB VALIDA.LIMITE.CAJA

    CASE Y.TIPO.VALIDACION EQ 'ALL'
        GOSUB VALIDA.LIMITE.BOVEDA
        GOSUB VALIDA.LIMITE.CAJA

    CASE OTHERWISE
        RETURN

    END CASE



    RETURN
*-------------------------------------------------------------------------------
VALIDA.LIMITE.BOVEDA:
*-------------------------------------------------------------------------------
    R.EB.CONTRACT.BALANCES = ''
    Y.CTA.BOVEDA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)

    EB.DataAccess.FRead(FN.EB.CONTRACT.BALANCES, Y.CTA.BOVEDA, R.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES, Y.ERR.EBC)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.WB.BOVEDA = R.EB.CONTRACT.BALANCES<RE.ConBalanceUpdates.EbContractBalances.EcbWorkingBalance> * -1
        IF Y.WB.BOVEDA GT Y.LIMITE.BOVEDA THEN
            Y.NO.CUENTA = Y.CTA.BOVEDA
            Y.MONTO = Y.WB.BOVEDA
            Y.BENEFICIARIO = 'Boveda'
            GOSUB ESCRIBE.REGISTRO
        END
    END

    RETURN
*-------------------------------------------------------------------------------
VALIDA.LIMITE.CAJA:
*-------------------------------------------------------------------------------
    R.EB.CONTRACT.BALANCES = ''
    Y.CTA.CAJA = R.NEW(TT.TE.ACCOUNT.2)


    EB.DataAccess.FRead(FN.EB.CONTRACT.BALANCES, Y.CTA.CAJA, R.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES, Y.ERR.EBC)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.WB.CAJA = R.EB.CONTRACT.BALANCES<RE.ConBalanceUpdates.EbContractBalances.EcbWorkingBalance> * -1
        IF Y.WB.CAJA GT Y.LIMITE.CAJA THEN
            Y.NO.CUENTA = Y.CTA.CAJA
            Y.MONTO = Y.WB.CAJA
            Y.BENEFICIARIO = 'Caja'
            GOSUB ESCRIBE.REGISTRO
        END
    END

    RETURN
*-------------------------------------------------------------------------------
VALIDA.LIMITE.DEPOSIT.CAJA:
*-------------------------------------------------------------------------------
    R.EB.CONTRACT.BALANCES = ''
    Y.CTA.CAJA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)

    EB.DataAccess.FRead(FN.EB.CONTRACT.BALANCES, Y.CTA.CAJA, R.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES, Y.ERR.EBC)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.WB.CAJA = R.EB.CONTRACT.BALANCES<RE.ConBalanceUpdates.EbContractBalances.EcbWorkingBalance> * -1
        IF Y.WB.CAJA GT Y.LIMITE.CAJA THEN
            Y.NO.CUENTA = Y.CTA.CAJA
            Y.MONTO = Y.WB.CAJA
            Y.BENEFICIARIO = 'Caja'
            GOSUB ESCRIBE.REGISTRO
        END
    END

    RETURN
*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'ABC.EMAIL.NOT.CAJA.BOVEDA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.EMAIL.NOTIF = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'LIMITE.CAJA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.LIMITE.CAJA = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'LIMITE.BOVEDA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.LIMITE.BOVEDA = Y.LIST.VALUES<Y.POS.PARAM>
    END

    R.ABC.GENERAL.PARAM = ''
    ERR.PARAM = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,ERR.PARAM)
    IF R.ABC.GENERAL.PARAM THEN
        Y.ASUNTO.EMAIL = R.ABC.GENERAL.PARAM<PBS.GEN.PARAM.MODULO>
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<PBS.GEN.PARAM.NOMB.PARAMETRO>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<PBS.GEN.PARAM.DATO.PARAMETRO>)

        LOCATE 'HORA.CIERRE.CAJA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN     ;*LFCR_NOTFIF_DIA_CIERRE_20250123 - S
            Y.HORA.CIERRE.CAJA = Y.LIST.VALUES<Y.POS.PARAM>
        END

        LOCATE 'ALERTA.DIA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
            Y.STR.ALERTA.DIA = Y.LIST.VALUES<Y.POS.PARAM>
            CHANGE 'Y.HORA' TO Y.HORA.NOTIF IN Y.STR.ALERTA.DIA
        END

        LOCATE 'ALERTA.CIERRE.DIA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
            Y.STR.ALERTA.CIERRE.DIA = Y.LIST.VALUES<Y.POS.PARAM>
        END

        LOCATE Y.VERSION.TT IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
            Y.TIPO.VALIDACION = Y.LIST.VALUES<Y.POS.PARAM>
        END         

        LOCATE "Y.CANAL.EMAIL" IN Y.LIST.PARAMS SETTING POS THEN
            Y.CANAL.EMAIL.LISTA = Y.LIST.VALUES<POS>
            CHANGE ',' TO FM IN Y.CANAL.EMAIL.LISTA
        END ELSE
            Y.CANAL.EMAIL.LISTA = 'VACIO'
        END

        LOCATE "Y.CANAL.ALTERNA" IN Y.LIST.PARAMS SETTING POS THEN
            Y.CANAL.ALTERNA.LISTA = Y.LIST.VALUES<POS>
            CHANGE ',' TO FM IN Y.CANAL.ALTERNA.LISTA
        END ELSE
            Y.CANAL.ALTERNA.LISTA = 'VACIO'
        END

        LOCATE "Y.CANAL.GALILEO" IN Y.LIST.PARAMS SETTING POS THEN
            Y.CANAL.GALILEO.LISTA = Y.LIST.VALUES<POS>
            CHANGE ',' TO FM IN Y.CANAL.GALILEO.LISTA
        END ELSE
            Y.CANAL.GALILEO.LISTA = 'VACIO'
        END

    END


    RETURN

*-------------------------------------------------------------------------------
ESCRIBE.REGISTRO:
*-------------------------------------------------------------------------------

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]
    Y.CADENA.EMAIL = ''       

    GOSUB OBTIENE.ID

    R.DAO = ''
    Y.ERR.DAO = ''
    EB.DataAccess.FRead(FN.DEPT.ACCT.OFFICER, Y.ID.DAO, R.DAO, F.DEPT.ACCT.OFFICER, Y.ERR.DAO)
    IF R.DAO THEN
        Y.NOMBRE.SUCURSAL = R.DAO<ST.Config.DeptAcctOfficer.EbDaoDeliveryPoint>
    END


    IF Y.HORA.VALIDACION LT Y.HORA.CIERRE.CAJA THEN         
        Y.CADENA.EMAIL = Y.STR.ALERTA.DIA
    END ELSE
        Y.CADENA.EMAIL = Y.STR.ALERTA.CIERRE.DIA
    END   


    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>       = Y.CADENA.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.EMAIL.NOTIF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NombreBen> = Y.BENEFICIARIO
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Banco>       = Y.NOMBRE.SUCURSAL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>        = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.NO.REF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI


    Y.CANAL.ENTIDAD = ""

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
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NoticiaGalileo> = 'NO'
    END

*    WRITE REC.ABC.SMS.EMAIL.ENVIAR TO F.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR
    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR,ID.ABC.SMS.EMAIL.ENVIAR,REC.ABC.SMS.EMAIL.ENVIAR)
    RETURN

*-------------------------------------------------------------------------------
OBTIENE.ID:
*-------------------------------------------------------------------------------

    ID.ABC.SMS.EMAIL.ENVIAR  = Y.NO.CUENTA:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

    RETURN


END
