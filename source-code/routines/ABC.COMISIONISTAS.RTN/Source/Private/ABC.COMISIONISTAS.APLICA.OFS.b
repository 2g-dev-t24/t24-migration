* @ValidationCode : MjotOTA4MjM4NTU3OkNwMTI1MjoxNzQ0MDUzNTMwNDE4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2025 16:18:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcComisionistasRtn
SUBROUTINE ABC.COMISIONISTAS.APLICA.OFS(Y.CLIENTE.COMISIONISTA,Y.FECHA.PROCESO,Y.APLICACION.OFS,ARR.APLICACION.DEP,Y.MENSAJE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING AbcTable
    $USING ST.Customer
    $USING EB.Security
    $USING FT.Contract
    $USING AA.PaymentSchedule
    $USING EB.Interface
    $USING EB.Updates
    $USING EB.TransactionControl


    GOSUB VARIABLES.INICIO
    GOSUB APERTURA.TABLAS
    GOSUB REGISTROS.PROSESAR
RETURN


*================
VARIABLES.INICIO:
*================

*--------
    Y.FUNCION.OFS          = "I"
    Y.OPERACION.OFS        = "PROCESS"
    Y.NOMBRE.COMISIONISTA  = Y.CLIENTE.COMISIONISTA
    ARR.CAMPOS.OFS.PARAM   = ""
    Y.ENVIO.OFS.APLICACION = ""
    Y.REG.PROCESADOS.OFS   = 0

*---CRM CAMPO DE ACTIVIDAD ECONOMICA 05 OCTUBRE 2016 SOLO SI ES CLIENTE NUEVO ---------------------
    Y.VAL.ACTI.ECONO       = ''
    TODAY = EB.SystemTables.getToday()
*-----------------------------------------------------------------------------------------------------

RETURN

*================
APERTURA.TABLAS:
*================

*   Apertua de Tabla de Parametros
    FN.ABC.COMISIONISTAS.FILE.PARAM = "F.ABC.COMISIONISTAS.FILE.PARAM"
    F.ABC.COMISIONISTAS.FILE.PARAM  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.PARAM,F.ABC.COMISIONISTAS.FILE.PARAM)

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER  = ""
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ABC.VEC.CUS.ACC = "F.ABC.VEC.CUS.ACC"
    F.ABC.VEC.CUS.ACC  = ""
    EB.DataAccess.Opf(FN.ABC.VEC.CUS.ACC,F.ABC.VEC.CUS.ACC)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

*   ApertuRa de Tabla de Detalles
    FN.ABC.COMISIONISTAS.FILE.DETAIL = "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.COMISIONISTAS.FILE.DETAIL  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

*   Apertua de Tabla de Detalles Concat
    FN.ABC.COMISIONISTAS.FILE.DETAIL.CON = "F.ABC.COMISIONISTAS.FILE.CONCAT"
    F.ABC.COMISIONISTAS.FILE.DETAIL.CON  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL.CON,F.ABC.COMISIONISTAS.FILE.DETAIL.CON)

*    -TABLA DE COMISIONISTAS
    FN.ABC.REGISTRO.COMISIONISTAS = "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO.COMISIONISTAS  = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS,F.ABC.REGISTRO.COMISIONISTAS)

*   -Tabla de Relacion de archivos correspondientes a un cliente comisionistas
    FN.ABC.COMISIONISTAS.RELACION = 'F.ABC.COMISIONISTAS.RELACION'
    F.ABC.COMISIONISTAS.RELACION  = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION)

*   -Tabla de Usuarios
    FN.USER = "F.USER"
    F.USER  = ""
    EB.DataAccess.Opf(FN.USER,F.USER)

*   -Tabla de Inversiones

*******SBS-F&G Tabla con detalles de AA
    FN.AA.ACT.DETAILS = "F.AA.ACCOUNT.DETAILS"    ;*SBS-F&G
    F.AA.ACT.DETAILS = ""     ;*SBS-F&G
    EB.DataAccess.Opf(FN.AA.ACT.DETAILS,F.AA.ACT.DETAILS)  ;*SBS-F&G

*---CRM CAMPO DE ACTIVIDAD ECONOMICA 05 OCTUBRE 2016 SOLO SI ES CLIENTE NUEVO ---------------------
    F.ABC.GENERAL.MAPPING  = ''
    FN.ABC.GENERAL.MAPPING = 'F.ABC.GENERAL.MAPPING'
    EB.DataAccess.Opf(FN.ABC.GENERAL.MAPPING,F.ABC.GENERAL.MAPPING)
*-----------------------------------------------------------------------------------------------------

RETURN
*================
REGISTROS.PROSESAR:
*================

*   -Lista de Registros cargados en determinada Fecha
    SELECT.CMD.COMISIONISTAS.PROCESAR = "SSELECT " : FN.ABC.COMISIONISTAS.RELACION : " WITH  ID.COMISIONISTA EQ " :  DQUOTE(Y.NOMBRE.COMISIONISTA)  ; * ITSS - ANJALI - Added DQUOTE
    SELECT.CMD.COMISIONISTAS.PROCESAR := " AND FECHA.CARGA EQ ":DQUOTE(Y.FECHA.PROCESO): " AND ESTATUS.OFS LIKE ":DQUOTE("...'NO.APLICADO'...")  ; * ITSS - ANJALI - Added DQUOTE
    DISPLAY SELECT.CMD.COMISIONISTAS.PROCESAR     ;*SBS-F&G
    EB.DataAccess.Readlist(SELECT.CMD.COMISIONISTAS.PROCESAR,Y.LIST.REG.RELACION,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
    DISPLAY "PROCESANDO LISTA DE REGISTROS ":Y.LIST.REG.RELACION
    DISPLAY "TOTAL DE REGISTROS PROCESA ":Y.NO.REGISTROS
    FOR I.REG = 1 TO Y.NO.REGISTROS
*---CRM DEBUG
        YARR.ARCHIVOS.APLICACION = ''
        R.COMISIONISTAS.RELACION = ''
        R.COMISIONISTAS.RELACION1= ''
        Y.ENVIO.OFS.APLICACION   = ''
        R.REGISTRO.COMISIONISTA  = ''
        YARR.IDS.DETAIL          = ''
        Y.ID.COMISIONISTAS.RELACION = Y.LIST.REG.RELACION<I.REG>
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.RELACION,Y.ID.COMISIONISTAS.RELACION,R.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION,ERR.COMISIONISTAS.RELACION)
        Y.TOT.APLICACION =DCOUNT(R.COMISIONISTAS.RELACION<ACR.APLICACION>,VM)
        FOR REC = 1 TO Y.TOT.APLICACION
            Y.APLICACION.VALIDA = R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,REC>
            R.COMISIONISTAS.RELACION1 := FIELD (R.COMISIONISTAS.RELACION<ACR.APLICACION,REC>,"_",1):FM
        NEXT REC

        Y.TOT.APLICACION =DCOUNT(R.COMISIONISTAS.RELACION<ACR.APLICACION>,VM)   ;*IR*
        FOR AVSS = 1 TO Y.TOT.APLICACION          ;*IR*
            Y.APLICACION.VALIDA = R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,AVSS>          ;*IR*

            IF Y.APLICACION.VALIDA EQ "APLICADO" OR Y.APLICACION.OFS NE R.COMISIONISTAS.RELACION1<AVSS> THEN
            END ELSE
                Y.ID.REGISTRO.COMISIONISTA  = FIELD(Y.ID.COMISIONISTAS.RELACION,"-",1)
                EB.DataAccess.FRead(FN.ABC.VEC.CUS.ACC,Y.ID.REGISTRO.COMISIONISTA,R.VEC.CUS.ACC,F.ABC.VEC.CUS.ACC,ERR.VEC.CUS.ACC)
                EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION,R.REGISTRO.COMISIONISTA,F.ABC.REGISTRO.COMISIONISTAS,ERR.COMISIONISTA)
                Y.POS.WRITE = AVSS
                IF Y.APLICACION.OFS EQ "CUSTOMER" AND R.VEC.CUS.ACC<AbcTable.AbcRegistroComisionistas.NoCliente> NE '' THEN
                    GOSUB ACTUALIZA.CLIENTE
                END ELSE
                    IF Y.APLICACION.OFS EQ "ACCOUNT" AND R.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCuenta> NE '' THEN
                        GOSUB ACTUALIZA.CUENTA
                    END ELSE
                        IF R.REGISTRO.COMISIONISTA NE '' AND Y.APLICACION.OFS EQ "CUSTOMER" THEN
                            Y.RESPONSE.CODE.ENV    = 1
                            Y.ID.REG.OFS.APLICADO  = R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NoCliente>
                            Y.CADENA.OFS.ENVIA.CTE = "CLIENTE EXISTENTE"
                            Y.TOT.ARCH.APLICACION = DCOUNT(R.COMISIONISTAS.RELACION<ACR.ARCHIVOS.LINEA,AVSS>,@SM)
                            FOR YNO.ARCH = 1 TO Y.TOT.ARCH.APLICACION
                                Y.ID.REGISTRO.DETAIL = R.COMISIONISTAS.RELACION<ACR.ARCHIVOS.LINEA,AVSS,YNO.ARCH>
                                EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,Y.ID.REGISTRO.DETAIL,R.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAI)
                                Y.ESTATUS.ACTUAL.REG = R.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk>
                                R.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = "SI"
                                WRITE R.DETAIL TO F.ABC.COMISIONISTAS.FILE.DETAIL, Y.ID.REGISTRO.DETAIL
                            NEXT YNO.ARCH
                            GOSUB ACTUALIZA.REG
                        END ELSE
                            Y.APLICA.CARGA.COMISIONISTA =  R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.AutorizacionCte>
                            IF Y.APLICA.CARGA.COMISIONISTA EQ "NO" THEN
                            END ELSE
                                Y.REG.PROCESADOS.OFS += 1
                                Y.TOT.ARCH.APLICACION = DCOUNT(R.COMISIONISTAS.RELACION<ACR.ARCHIVOS.LINEA,AVSS>,@SM)
                                FOR YNO.ARCH = 1 TO Y.TOT.ARCH.APLICACION
                                    Y.ID.DETAIL = ''
                                    Y.ID.DETAIL = R.COMISIONISTAS.RELACION<ACR.ARCHIVOS.LINEA,AVSS,YNO.ARCH>
                                    IF Y.APLICACION.OFS EQ "CUSTOMER" OR Y.APLICACION.OFS EQ "ACCOUNT" THEN
                                        Y.ID.DETAIL.ARCH = FIELD(Y.ID.DETAIL,"_",2)

                                        IF Y.ID.DETAIL.ARCH EQ 'CTE' THEN
                                            Y.ID.FILES.DETAIL.CTE<-1>  =Y.ID.DETAIL
                                        END
                                        IF Y.ID.DETAIL.ARCH EQ 'DIR' THEN
                                            Y.ID.FILES.DETAIL.DIR<-1>  =Y.ID.DETAIL
                                        END
                                    END ELSE
                                        YARR.IDS.DETAIL<-1> = Y.ID.DETAIL
                                    END
                                NEXT YNO.ARCH
                                IF Y.APLICACION.OFS EQ "CUSTOMER" OR Y.APLICACION.OFS EQ "ACCOUNT" THEN
                                    Y.TOTAL.ARCH.CTE = DCOUNT(Y.ID.FILES.DETAIL.CTE,FM)
                                    Y.TOTAL.ARCH.DIR = DCOUNT(Y.ID.FILES.DETAIL.DIR,FM)
                                    Y.ARCH.VEC.CTE = Y.ID.FILES.DETAIL.CTE<Y.TOTAL.ARCH.CTE>
                                    Y.ARCH.VEC.DIR = Y.ID.FILES.DETAIL.DIR<Y.TOTAL.ARCH.DIR>
                                    YARR.IDS.DETAIL = Y.ARCH.VEC.CTE:FM:Y.ARCH.VEC.DIR
                                END

                                EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,YARR.IDS.DETAIL<1>,R.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAI)
                                ARR.CAMPOS.DETAIL = R.DETAIL<AbcTable.AbcComisionistasFileDetail.NombreCampo>
                                ARR.VALORES.DETAIL= R.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo>

*---CRM 05 OCTUBRE 2016 CUANDO SE DA DE ALTA UN NUEVO CLIENTE SE VERIFICA QUE LA ACTIVIDAD ECONOMICA EXISTA DE LO CONTRARIO INGRESAR 9999999
                                IF Y.APLICACION.OFS EQ "CUSTOMER" THEN
*---CRM DEBUG
                                    FIND "ACTIVIDAD.ECONO" IN ARR.CAMPOS.DETAIL SETTING APX, VPX, SPX THEN
                                        Y.ACTI.ECONO      = R.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo><1,VPX>
                                        R.GRAL.MAPPING    = ''
                                        Y.ID.GRAL.MAPPING = 'ACTIVIDADECONOMICA'
                                        EB.DataAccess.FRead(FN.ABC.GENERAL.MAPPING,Y.ID.GRAL.MAPPING,R.GRAL.MAPPING,F.ABC.GENERAL.MAPPING,Y.ERR.GRAL.MAPPING)
                                        IF R.GRAL.MAPPING THEN
                                            Y.LIST.VALOR.ENTRADA   = RAISE(R.GRAL.MAPPING<GRAL.MAP.VALOR.ENTRADA>)
                                            Y.LIST.VALOR.T24.MAPEO = RAISE(R.GRAL.MAPPING<GRAL.MAP.VALOR.T24.MAPEO>)
                                            LOCATE Y.ACTI.ECONO IN Y.LIST.VALOR.ENTRADA SETTING Y.POS.ACTI THEN
                                                Y.VAL.ACTI.ECONO = Y.LIST.VALOR.T24.MAPEO<Y.POS.ACTI>
                                            END ELSE
                                                Y.ID.PARAM = R.DETAIL<AbcTable.AbcUploadFileDetail.IdParam>
                                                EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.PARAM,Y.ID.PARAM,REC.PARAM,F.ABC.COMISIONISTAS.FILE.PARAM,ERR.PARAM)
                                                Y.FIELDS.NAME = REC.PARAM<AbcTable.AbcComisionistasFileParam.FieldName>
                                                FIND "ACTIVIDAD.ECONO" IN Y.FIELDS.NAME SETTING AP1, VP1, SP1 THEN
                                                    Y.VALUE.ACTI.ECONO= REC.PARAM<AbcTable.AbcComisionistasFileParam.FieldRtnConv><1,VP1>
                                                    Y.VAL.ACTI.ECONO = FIELD(Y.VALUE.ACTI.ECONO,'-',3)
                                                END
                                            END
                                        END
                                    END
                                END
*-------------------------------------------------------------------------------------------------------------------------------------

                                CALL ABC.COMISIONISTAS.ARR.OFS(YARR.IDS.DETAIL,Y.APLICACION.OFS,ARR.APLICACION.DEP,Y.ENVIO.OFS.APLICACION)
*---CRM DEBUG
                                IF Y.ENVIO.OFS.APLICACION NE '' THEN
                                    IF Y.APLICACION.OFS EQ "AA.ARRANGEMENT.ACTIVITY" THEN
*******                                DEBUG
                                        options = ''

                                        options<1> = "AA.COB"
                                        EB.Interface.OfsCallBulkManager(options,Y.ENVIO.OFS.APLICACION,theResponse,txnCommitted)
                                        
                                        Y.ID.REG.OFS.APLICADO.AA  = TRIM(FIELD(theResponse, '/', 1))
                                        Y.ID.REG.OFS.APLICADO.AA  = EREPLACE(Y.ID.REG.OFS.APLICADO.AA,'<requests>',"")
                                        Y.ID.REG.OFS.APLICADO.AA  = Y.ID.REG.OFS.APLICADO.AA[10,18]

                                        CRT txnCommitted
                                        RES = theResponse
                                        OFS.PROP = ''
                                        CONVERT ',' TO @FM IN RES
                                        AA.ARRANGEMENT.ID=FIELD (RES<2>,'=',2,1)
                                        Y.CADENA.OFS.ENVIA.CTE = theResponse
                                        IF txnCommitted EQ 1 THEN
                                            Y.RESPONSE.CODE.ENV = 1
*******SBS-F&G Se cambia la asignacion de variable para que se tome el ID del AA que se generB
                                            Y.ID.REG.OFS.APLICADO = AA.ARRANGEMENT.ID     ;*SBS-F&G TOMA EL ID DEL ARRANGEMENT
                                        END
                                        GOSUB ACTUALIZA.REG
                                    END ELSE
                                        Y.ID.REG.PARAM = R.DETAIL<AbcTable.AbcComisionistasFileDetail.idParam>
                                        GOSUB PARAMETROS.CARGA
                                        GOSUB APLICACION.OFS
                                    END
                                END
                            END
                        END
                    END
                END
            END
        NEXT AVSS
    NEXT I.REG
    Y.MENSAJE  = "SE PROCESARON " :Y.REG.PROCESADOS.OFS :" REGISTROS DE ":Y.APLICACION.OFS

RETURN

*================
PARAMETROS.CARGA:
*================

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.PARAM,Y.ID.REG.PARAM,R.PARAM.ABC.COM,F.ABC.COMISIONISTAS.FILE.PARAM,ERR.PARAM)

    ARR.APLICACIONES.CARGA = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsAplicacion>
    ARR.VERSIONES.CARGA    = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsVersion>
    FIND Y.APLICACION.OFS IN ARR.APLICACIONES.CARGA SETTING AP, VP, SP THEN
        Y.VERSION.CARGA.CTE= R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsVersion><1,VP>
    END
    Y.ID.USER.OFS          = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsUsr>
    Y.ID.USER.OFS.AUT      = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsUsrAut>

    EB.DataAccess.FRead(FN.USER,Y.ID.USER.OFS,R.USUARIO.OFS,F.USER,ERR.USER)
    Y.USER.SIGN.ON         = R.USUARIO.OFS<EB.Security.User.UseSignOnName>

    EB.DataAccess.FRead(FN.USER,Y.ID.USER.OFS.AUT,R.USUARIO.OFS,F.USER,ERR.USER)
    Y.USER.SIGN.ON.AUT     = R.USUARIO.OFS<EB.Security.User.UseSignOnName>

    Y.USER.PASSWORD        = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsPwd>
    Y.USER.PASSWORD.AUT    = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsPwdAut>
    Y.ID.OFS.SOURCE        = R.PARAM.ABC.COM<AbcTable.AbcComisionistasFileParam.OfsSource>

RETURN

*================
APLICACION.OFS:
*================

    Y.CADENA.OPERACION.OFS = Y.APLICACION.OFS:","
    Y.CADENA.OPCION.OFS    = Y.VERSION.CARGA.CTE:"/":Y.FUNCION.OFS:"/":Y.OPERACION.OFS:","
    Y.CADENA.USER.OFS      = Y.USER.SIGN.ON:"/":Y.USER.PASSWORD:","
    Y.ENVIO.OFS.ID.REG     = ""

    Y.CADENA.OFS.ENVIA.CTE  = Y.CADENA.OPERACION.OFS
    Y.CADENA.OFS.ENVIA.CTE := Y.CADENA.OPCION.OFS
    Y.CADENA.OFS.ENVIA.CTE := Y.CADENA.USER.OFS
    Y.CADENA.OFS.ENVIA.CTE := Y.ENVIO.OFS.ID.REG

*---CRM 05 OCTUBRE 2016 CUANDO SE DA DE ALTA UN NUEVO CLIENTE SE VERIFICA QUE LA ACTIVIDAD ECONOMICA EXISTA DE LO CONTRARIO INGRESAR 9999999
    IF Y.APLICACION.OFS = 'CUSTOMER' THEN
        Y.CAD.VERIFICA = Y.ENVIO.OFS.APLICACION
        CONVERT ':' TO @VM IN Y.CAD.VERIFICA
        CONVERT '=' TO @VM IN Y.CAD.VERIFICA
        CONVERT ',' TO @VM IN Y.CAD.VERIFICA
        FIND "ACTIVIDAD.ECONO" IN Y.CAD.VERIFICA SETTING APY, VPY, SPY THEN
*
        END ELSE
            Y.ENVIO.OFS.APLICACION := ',ACTIVIDAD.ECONO:1:1=':Y.VAL.ACTI.ECONO
        END
    END
*-------------------------------------------------------------------------------------------------------------------------------------
    IF Y.APLICACION.OFS = 'CUSTOMER' THEN
        EB.Updates.MultiGetLocRef("CUSTOMER","ID.COMISIONISTA",Y.ID.COMI)
*CALL GET.LOCAL.REFM("CUSTOMER","ID.COMISIONISTA",Y.ID.COMI)
        Y.CADENA.OFS.ENVIA.CTE := Y.ENVIO.OFS.APLICACION : ",LOCAL.REF:": Y.ID.COMI :":1=": Y.ID.REGISTRO.COMISIONISTA
    END ELSE
        Y.CADENA.OFS.ENVIA.CTE := Y.ENVIO.OFS.APLICACION
    END

    DISPLAY "CADENA DE OFS ENVIADO " : Y.CADENA.OFS.ENVIA.CTE
    Y.CADENA.ORG.ENVIADA = Y.CADENA.OFS.ENVIA.CTE
    
    EB.Interface.OfsBulkManager(Y.ID.OFS.SOURCE,Y.CADENA.OFS.ENVIA.CTE)
    
    
    EB.TransactionControl.JournalUpdate("")
    DISPLAY "CADENA DE OFS RECIBIDO " : Y.CADENA.OFS.ENVIA.CTE
    Y.ID.REG.OFS.APLICADO = TRIM(FIELD(Y.CADENA.OFS.ENVIA.CTE, '/', 1))
    Y.RESPONSE.CODE.ENV = TRIM(FIELD(Y.CADENA.OFS.ENVIA.CTE, '/', 3))
    Y.RESPONSE.CODE.ENV = TRIM(FIELD(Y.RESPONSE.CODE.ENV,",",1))
*DEBUG
    Y.ID.CUENTA = TRIM(FIELD(Y.CADENA.OFS.ENVIA.CTE, '/', 3))
    Y.ID.CUENTA = TRIM(FIELD(Y.ID.CUENTA, ',', 3))
    Y.ID.CUENTA = TRIM(FIELD(Y.ID.CUENTA, '=', 2))

    GOSUB ACTUALIZA.REG

RETURN

* ==============
ACTUALIZA.REG:
*=============

    IF Y.RESPONSE.CODE.ENV EQ '1' THEN
        DISPLAY "APLICADO"
        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,Y.POS.WRITE> = Y.ID.REG.OFS.APLICADO
        DISPLAY Y.ID.REG.OFS.APLICADO   ;*SBS-F&G
        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,Y.POS.WRITE>    = "APLICADO"
        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,Y.POS.WRITE> = Y.CADENA.OFS.ENVIA.CTE
        GOSUB ACTUALIZA.COMISIONISTA
        GOSUB ESCRIBE.TABLA.CONCAT
    END ELSE
        IF Y.APLICACION.OFS EQ "AA.ARRANGEMENT.ACTIVITY" THEN
            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,Y.POS.WRITE>    = "PENDIENTE"
        END ELSE
            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,Y.POS.WRITE>    = "FALLIDO"
        END
        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,Y.POS.WRITE>  = Y.CADENA.OFS.ENVIA.CTE
        DISPLAY "FALLIDO ":Y.CADENA.OFS.ENVIA.CTE
    END
    WRITE R.COMISIONISTAS.RELACION TO F.ABC.COMISIONISTAS.RELACION, Y.ID.COMISIONISTAS.RELACION
RETURN

* ==============
ESCRIBE.TABLA.CONCAT:
*=============
    IF Y.RESPONSE.CODE.ENV EQ '1' THEN
        EB.DataAccess.FRead(FN.ABC.VEC.CUS.ACC,Y.ID.REGISTRO.COMISIONISTA,R.ABC.VEC.CUS.ACC,F.ABC.VEC.CUS.ACC,ERR.ABC.VEC.CUS.ACC)

        IF Y.APLICACION.OFS EQ "CUSTOMER" THEN
            R.ABC.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCliente> = Y.ID.REG.OFS.APLICADO
*R.ABC.VEC.CUS.ACC<VCA.NO.CUENTA> = R.ABC.VEC.CUS.ACC<VCA.NO.CUENTA>

        END
        IF Y.APLICACION.OFS EQ "ACCOUNT" THEN
            Y.ID.CLIENTE = R.ABC.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCliente>
*R.ABC.VEC.CUS.ACC<VCA.NO.CLIENTE> = R.ABC.VEC.CUS.ACC<VCA.NO.CLIENTE>
            R.ABC.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCuenta>  = Y.ID.REG.OFS.APLICADO
        END
    END

    WRITE R.ABC.VEC.CUS.ACC TO F.ABC.VEC.CUS.ACC,Y.ID.REGISTRO.COMISIONISTA
    EB.TransactionControl.JournalUpdate("")
RETURN


* ==============
ACTUALIZA.CLIENTE:
*=============
    ARR.COMI.RELACION=R.COMISIONISTAS.RELACION
    ARR.COMI.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,1>= "APLICADO"
    ARR.COMI.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,1> = R.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCliente>
    ARR.COMI.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,1> = "CLIENTE EXISTENTE"
    WRITE ARR.COMI.RELACION TO F.ABC.COMISIONISTAS.RELACION, Y.ID.COMISIONISTAS.RELACION

    Y.TOT.ARCH.APLICACION = DCOUNT(R.COMISIONISTAS.RELACION<ACR.ARCHIVOS.LINEA,AVSS>,@SM)
    FOR YNO.ARCH = 1 TO Y.TOT.ARCH.APLICACION
        Y.ID.REGISTRO.DETAIL = R.COMISIONISTAS.RELACION<ACR.ARCHIVOS.LINEA,AVSS,YNO.ARCH>
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,Y.ID.REGISTRO.DETAIL,R.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAI)
        Y.ESTATUS.ACTUAL.REG = R.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk>
        R.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = "SI"
        WRITE R.DETAIL TO F.ABC.COMISIONISTAS.FILE.DETAIL, Y.ID.REGISTRO.DETAIL
    NEXT YNO.ARCH

    ARR.REG.COMI=R.REGISTRO.COMISIONISTA
    ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.IdComisionista> = Y.ID.REGISTRO.COMISIONISTA
    ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoCliente>  = R.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCliente>
    ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.Comisionista>= Y.NOMBRE.COMISIONISTA
    WRITE ARR.REG.COMI TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION

RETURN

* ==============
ACTUALIZA.CUENTA:
*=============
    ARR.COMI.RELACION=R.COMISIONISTAS.RELACION
    ARR.COMI.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,2>= "APLICADO"
    ARR.COMI.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,2> = R.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCuenta>
    ARR.COMI.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,2> = "CUENTA EXISTENTE"
    WRITE ARR.COMI.RELACION TO F.ABC.COMISIONISTAS.RELACION, Y.ID.COMISIONISTAS.RELACION

    
    ARR.REG.COMI=R.REGISTRO.COMISIONISTA
    ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoCuenta> = R.VEC.CUS.ACC<AbcTable.AbcVecCusAcc.NoCuenta>
    ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.FechaApeCta> = TODAY
    WRITE ARR.REG.COMI TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION

RETURN

*=======================
ACTUALIZA.COMISIONISTA:
*=======================

*    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.REGISTRO.COMISIONISTA,R.REGISTRO.COMISIONISTA,F.ABC.REGISTRO.COMISIONISTAS,ERR.COMISIONISTA)
    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION,R.REGISTRO.COMISIONISTA,F.ABC.REGISTRO.COMISIONISTAS,ERR.COMISIONISTA)
    IF R.REGISTRO.COMISIONISTA THEN
        Y.TOT.REG.COM = DCOUNT(R.REGISTRO.COMISIONISTA<ARC.NO.CUENTA>,@VM)
        Y.POS.ESCRIBE = Y.TOT.REG.COM

        IF Y.APLICACION.OFS EQ "ACCOUNT" THEN
            IF R.REGISTRO.COMISIONISTA<ARC.NO.CUENTA,Y.TOT.REG.COM> NE '' THEN
                Y.POS.ESCRIBE = Y.POS.ESCRIBE + 1
            END
            R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NoCuenta,Y.POS.ESCRIBE> = Y.ID.REG.OFS.APLICADO
            R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.FechaApeCta,Y.POS.ESCRIBE> = TODAY
        END
        IF Y.APLICACION.OFS EQ "FUNDS.TRANSFER" THEN
            Y.TOT.REG.COM = DCOUNT(R.REGISTRO.COMISIONISTA<ARC.NO.FT>,@VM)
            Y.POS.ESCRIBE = Y.TOT.REG.COM
            IF R.REGISTRO.COMISIONISTA<ARC.NO.FT,Y.TOT.REG.COM> NE '' THEN
                Y.POS.ESCRIBE = Y.POS.ESCRIBE + 1
            END
            R.REGISTRO.COMISIONISTA<ARC.NO.FT,Y.POS.ESCRIBE> = Y.ID.REG.OFS.APLICADO
            Y.POS.INV = DCOUNT (YARR.IDS.DETAIL,@FM)
            R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NombreArchivo,Y.POS.ESCRIBE> = YARR.IDS.DETAIL<Y.POS.INV>
            IF R.REGISTRO.COMISIONISTA<ARC.NO.CUENTA,Y.POS.ESCRIBE> EQ '' THEN
                EB.DataAccess.FRead(FN.FUNDS.TRANSFER,Y.ID.REG.OFS.APLICADO,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR.FUNDS.TRANSFER)
                Y.ACCOUNT = R.FUNDS.TRANSFER<FT.Contract.FundsTransfer.CreditAcctNo>
                R.REGISTRO.COMISIONISTA<ARC.NO.CUENTA,Y.POS.ESCRIBE> = Y.ACCOUNT

                EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
                R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.FechaApeCta,Y.POS.ESCRIBE> = R.ACCOUNT<AC.AccountOpening.ACCOUNTEVENT.accountOpeningDate>

            END
        END
        IF Y.APLICACION.OFS EQ "AA.ARRANGEMENT.ACTIVITY" THEN
            Y.TOT.REG.COM = DCOUNT(R.REGISTRO.COMISIONISTA<ARC.NO.INV.CTA>,@VM)
            Y.POS.ESCRIBE = Y.TOT.REG.COM
            IF R.REGISTRO.COMISIONISTA<ARC.NO.INV.CTA,Y.TOT.REG.COM> NE '' THEN
                Y.POS.ESCRIBE = Y.POS.ESCRIBE + 1
            END
            R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NoInvCta,Y.POS.ESCRIBE> = Y.ID.REG.OFS.APLICADO
            R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.FechaInv,Y.POS.ESCRIBE> = TODAY
            Y.SOL1 = YARR.IDS.DETAIL    ;*SBS-F&G
            Y.SOL2 = YARR.IDS.DETAIL<1> ;*SBS-F&G


*---CRM 06 OCTUBRE 2016 CUANDO TIENE 2 O MAS CORTES DE CUPON EL NOMBRE DEL ARCHIVO NO LO INGRESABA EN LA POSICION CORRECTA
*-------------------------------------------------------------------------------------------------------------------------

            EB.DataAccess.FRead(FN.AA.ACT.DETAILS,Y.ID.REG.OFS.APLICADO,R.INVERSION,F.AA.ACT.DETAILS,ERR.INVER)       ;*SBS-F&G
            Y.FECHA.VENCIMIENTO = R.INVERSION<AA.PaymentSchedule.AccountDetails.AdMaturityDate>    ;*SBS-F&G

*---CRM 06 OCTUBRE 2016 CUANDO TIENE 2 O MAS CORTES DE CUPON LA FECHA DE VENCIMIENTO NO LO INGRESABA EN LA POSICION CORRECTA
            R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.FechaVencimiento,Y.POS.ESCRIBE> = Y.FECHA.VENCIMIENTO
*-------------------------------------------------------------------------------------------------------------------------

        END
    END ELSE
        R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NoCliente>  = Y.ID.REG.OFS.APLICADO
        R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.Comisionista>= Y.NOMBRE.COMISIONISTA
        R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.IdComisionista> = Y.ID.REGISTRO.COMISIONISTA
    END
    FIND "SUCURSAL-COMISIONISTA" IN ARR.CAMPOS.DETAIL SETTING APSUC, AVSUC, SPSUC THEN
        R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.Sucursal> = ARR.VALORES.DETAIL<1,AVSUC>
    END
    FIND "PLAZA-COMISIONISTA" IN ARR.CAMPOS.DETAIL SETTING APPL, AVPL, SPPL THEN
        R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.Plaza> = ARR.VALORES.DETAIL<1,AVPL>
    END
    WRITE R.REGISTRO.COMISIONISTA TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION

RETURN

END
