* @ValidationCode : MjotNjE2NTEzMTI3OkNwMTI1MjoxNzQ0MDYxOTU3ODg4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2025 18:39:17
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
SUBROUTINE ABC.COMISIONISTAS.ARR.OFS(YARR.IDS.DETAIL,Y.ID.APLICACION,ARR.APLICACION.DEP,Y.ENVIO.OFS.APLICACION)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING AbcTable
    $USING AA.Framework
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.Interface



    GOSUB VARIABLES.INICIO
    GOSUB APERTURA.TABLAS
    GOSUB PROCESA.REGISTROS
RETURN

*================
VARIABLES.INICIO:
*================

*   -ID de Parametros a LEER
*    Y.ID.APLICACION =  FIELD(Y.ID.APLICACION,"_",1)
    Y.APLICACION.OFS        = Y.ID.APLICACION
    ARR.CAMPOS.OFS.PARAM    = ""
    Y.ENVIO.OFS.APLICACION  = ""

RETURN

*================
APERTURA.TABLAS:
*================

*   Apertua de Tabla de Parametros
    FN.ABC.COMISIONISTAS.FILE.PARAM = "F.ABC.COMISIONISTAS.FILE.PARAM"
    F.ABC.COMISIONISTAS.FILE.PARAM  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.PARAM,F.ABC.COMISIONISTAS.FILE.PARAM)

*   ApertuRa de Tabla de Detalles
    FN.ABC.COMISIONISTAS.FILE.DETAIL = "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.COMISIONISTAS.FILE.DETAIL  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

*   -Tabla de Relacion de archivos correspondientes a un cliente comisionistas
    FN.ABC.COMISIONISTAS.RELACION = 'F.ABC.COMISIONISTAS.RELACION'
    F.ABC.COMISIONISTAS.RELACION  = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION)

    FN.ABC.COMISIONISTAS.FILE.CONCAT = "F.ABC.COMISIONISTAS.FILE.CONCAT"
    F.ABC.COMISIONISTAS.FILE.CONCAT  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.CONCAT,F.ABC.COMISIONISTAS.FILE.CONCAT)

RETURN
*================
PROCESA.REGISTROS:
*================

    Y.VALOR.VAL = ""          ;*SBS-F&G
    Y.VALOR.VAL2 = ""         ;*SBS-F&G
    Y.TOT.REG.PROCESA = DCOUNT(YARR.IDS.DETAIL,@FM)
    FOR YNO.REG = 1 TO Y.TOT.REG.PROCESA
        Y.ID.DETAIL = YARR.IDS.DETAIL<YNO.REG>
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,Y.ID.DETAIL,R.ABC.COMISIONISTAS,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.COMISIONISTAS.DETAIL)
        IF R.ABC.COMISIONISTAS THEN
            Y.ID.REG.PARAM = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.idParam>

            Y.VALOR.VAL = TRIM(R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.ValorValidacion,13>)    ;*SBS-F&G TRAE EL RESULTADO DE LA VALIDADCION DEL RFC DEL CLIENTE (CLIENTE EXISTENTE)
            Y.VALOR.VAL2 = TRIM(R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.ValorCampo,4>)         ;*SBS-F&G TRAE EL NUMERO DE LA CUENTA DEL CLIENTE SI ES QUE YA EXISTE

            FIND "CLIENTE EXISTENTE" IN Y.VALOR.VAL SETTING AP, VP, SP THEN     ;*SBS-F&G
                IF Y.ID.APLICACION EQ "CUSTOMER" THEN       ;*SBS-F&G
                    Y.APLICA.ARMA.OFS = "NO"      ;*SBS-F&G
                END ;*SBS-F&G
                IF Y.ID.APLICACION EQ "ACCOUNT" AND Y.VALOR.VAL2 EQ "" THEN     ;*SBS-F&G
                    Y.APLICA.ARMA.OFS = "SI"      ;*SBS-F&G
                END  ELSE     ;*SBS-F&G
                    Y.APLICA.ARMA.OFS = "NO"      ;*SBS-F&G
                END ;*SBS-F&G

            END ELSE          ;*SBS-F&G
                Y.APLICA.ARMA.OFS = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.LoadOk>
            END     ;*SBS-F&G

            Y.ID.COMISIONISTAS.RELACION = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.IdRelacion>
            Y.ID.COMISIONISTAS.CONCAT   = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.IdConcat>
            EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.RELACION,Y.ID.COMISIONISTAS.RELACION,R.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION,ERR.COMISIONISTAS.RELACION)
            EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.CONCAT,Y.ID.COMISIONISTAS.CONCAT,R.COMISIONISTAS.CONCAT,F.ABC.COMISIONISTAS.FILE.CONCAT,ERR.COMISIONISTAS.CONCAT)
            IF Y.APLICA.ARMA.OFS = 'NO' THEN
                Y.ENVIO.OFS.APLICACION = ""
                RETURN
            END ELSE
                GOSUB REVISAR.DEPENDENCIA
                IF Y.DEPENDENCIA.VALIDA EQ "SI" THEN
                    GOSUB PARAMETROS.CARGA
                    GOSUB ARMA.CADENA.OFS
                    IF Y.ID.APLICACION EQ "AA.ARRANGEMENT.ACTIVITY" THEN
                        GOSUB ARMA.CADENA.OFS.AA
                    END
                END ELSE
                    Y.ENVIO.OFS.APLICACION = ""
                    RETURN
                END
            END
        END

    NEXT

RETURN
*================
PARAMETROS.CARGA:
*================

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.PARAM,Y.ID.REG.PARAM,R.PARAM.COM.VEC,F.ABC.COMISIONISTAS.FILE.PARAM,ERR.PARAM)
    ARR.CAMPOS.PARAM     = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldName>
    ARR.TABLAS.PARAM     = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldT24Table>
    ARR.NAME.CAMPOS.PARAM= R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldT24OfsName>
    ARR.RUTINAS.CONVERSION = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldRtnConv>

    ARR.APLICACIONES.CARGA = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.OfsAplicacion>
    ARR.VERSIONES.CARGA    = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.OfsVersion>
    FIND Y.ID.APLICACION IN ARR.APLICACIONES.CARGA SETTING AP, VP, SP THEN
        Y.VERSION.CARGA.CTE= R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.OfsVersion><1,VP>
    END
    IF ARR.CAMPOS.PARAM EQ '' THEN

    END
RETURN
*==================
ARMA.CADENA.OFS.AA:
*==================

    TODAY = EB.SystemTables.getToday()
    
    OFSVERSION = Y.ID.APLICACION:",":Y.VERSION.CARGA.CTE
    FUNCT      = "I"
    NO.OF.AUTH = "0"
    ARR.ACTIVITY.ID = ''
    AAA.REQUEST     = ''
    OFS.RECORD      = ''
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActArrangement>       = "NEW"
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActActivity>          = "DEPOSITS-NEW-ARRANGEMENT"
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActEffectiveDate>    = TODAY

    FIND "CUSTOMER" IN R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.Aplicacion> SETTING AP, VP, SP THEN
        Y.VALOR.DATO.DEPEN = R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs><1,VP>
        Y.NUMERO.CLIENTE = Y.VALOR.DATO.DEPEN
    END

    FIND "PRODUCT" IN Y.ENVIO.AA.APLICACION.OFS SETTING APPROD, VPPROD, SPPROD THEN
        Y.VALOR.PRODUCTO.AA = Y.ENVIO.AA.APLICACION.OFS<APPROD>
        Y.VALOR.PRODUCTO.AA = FIELD(Y.VALOR.PRODUCTO.AA,@VM,4)
    END
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActCustomer>          = Y.NUMERO.CLIENTE
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActProduct>           = Y.VALOR.PRODUCTO.AA
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActInitiationType,1> = "USER"
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActCurrency>          = "MXN"

    FIND "ACCOUNT" IN R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.Aplicacion> SETTING AP, VP, SP THEN
        Y.VALOR.DATO.DEPEN = R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs><1,VP>
        Y.NUMERO.CUENTA    = Y.VALOR.DATO.DEPEN
    END

    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActLocalRef,1>       =Y.NUMERO.CUENTA
    
    EB.Foundation.OfsBuildRecord(Y.ID.APLICACION, FUNCT, "PROCESS", OFSVERSION, "", NO.OF.AUTH, ARR.ACTIVITY.ID, AAA.REQUEST, OFS.RECORD)
    
    
    
*    DEBUG
    Y.TOT.REG.FIELD = DCOUNT(Y.ENVIO.AA.APLICACION.OFS,@FM)

    Y.ENVIO.OFS.PROPERTY     ="PROPERTY:1=COMMITMENT"
    Y.NO.COMM = 1

    FOR I.AA = 1 TO Y.TOT.REG.FIELD

        Y.ARR.PROPERTY.AA = Y.ENVIO.AA.APLICACION.OFS<I.AA>
        Y.CAMPO.AA.ARR    = FIELD(Y.ARR.PROPERTY.AA,VM,1)
        IF Y.CAMPO.AA.ARR EQ "PROPERTY" THEN
            Y.PROPERTY.AA     = FIELD(Y.ARR.PROPERTY.AA,VM,2)
            Y.FIELD.NAME.AA   = FIELD(Y.ARR.PROPERTY.AA,VM,3)
            Y.FIELD.VALUE.AA  = FIELD(Y.ARR.PROPERTY.AA,VM,4)
            IF Y.PROPERTY.AA EQ "COMMITMENT" THEN
                Y.ENVIO.OFS.PROPERTY    :=",FIELD.NAME:1:":Y.NO.COMM:"=":Y.FIELD.NAME.AA:",FIELD.VALUE:1:":Y.NO.COMM:"=":Y.FIELD.VALUE.AA
                DISPLAY Y.ENVIO.OFS.PROPERTY      ;*SBS-F&G
                Y.NO.COMM += 1
            END
        END
    NEXT I.AA
    Y.ENVIO.OFS.APLICACION= OFS.RECORD:Y.ENVIO.OFS.PROPERTY
    DISPLAY Y.ENVIO.OFS.APLICACION      ;*SBS-F&G
RETURN
*================
ARMA.CADENA.OFS:
*================

    Y.ENVIO.AA.APLICACION.OFS = ''
    IF R.COMISIONISTAS.CONCAT<AbcTable.AbcComisionistasFileConcat.NombreCampo> EQ '' THEN
        ARR.NOMBRES.CAMPOS     = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.NombreCampo>
        ARR.VALORES.CAMPOS     = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.ValorCampo>
    END ELSE
        ARR.NOMBRES.CAMPOS     = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.NombreCampo>:@VM:R.COMISIONISTAS.CONCAT<AbcTable.AbcComisionistasFileConcat.NombreCampo>
        ARR.VALORES.CAMPOS     = R.ABC.COMISIONISTAS<AbcTable.AbcComisionistasFileDetail.ValorCampo>:@VM:R.COMISIONISTAS.CONCAT<AbcTable.AbcComisionistasFileConcat.ValorCampo>
    END
    Y.TOTAL.CAMPOS         = DCOUNT(ARR.NOMBRES.CAMPOS,@VM)
    FOR Y.NO.CAMPO = 1 TO Y.TOTAL.CAMPOS

        Y.NOMBRE.CAMPO   = FIELD(ARR.NOMBRES.CAMPOS,@VM,Y.NO.CAMPO)
        Y.VALOR.CAMPO    = FIELD(ARR.VALORES.CAMPOS,@VM,Y.NO.CAMPO)

        FIND Y.NOMBRE.CAMPO IN ARR.CAMPOS.PARAM SETTING AP, VP, SP THEN
            Y.TABLAS.CAMPO       = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldT24OfsName><1,VP>
            Y.RUTINA.CONVERSION.CAMPO = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldRtnConv><1,VP>
            Y.TOTAL.TABLAS.CAMPO = DCOUNT(Y.TABLAS.CAMPO,@SM)
            FOR S = 1 TO Y.TOTAL.TABLAS.CAMPO
                Y.ID.APLICACION.OFS.PARAM  = FIELD(Y.TABLAS.CAMPO,@SM,S)
                IF Y.ID.APLICACION.OFS.PARAM EQ Y.APLICACION.OFS THEN
                    Y.NOMBRE.CAMPO.OFS = R.PARAM.COM.VEC<AbcTable.AbcComisionistasFileParam.FieldT24OfsName><1,VP,S>

                    IF Y.RUTINA.CONVERSION.CAMPO NE '' THEN

                        IF Y.RUTINA.CONVERSION.CAMPO[1,1] EQ "@" OR Y.RUTINA.CONVERSION.CAMPO[1,1] EQ '"' THEN
                            Y.TIPO.CONVERSION = Y.RUTINA.CONVERSION.CAMPO[1,1]
                            Y.VALUE.CONVERSION=FIELD(Y.RUTINA.CONVERSION.CAMPO,"@",2)
                        END ELSE
                            Y.TIPO.CONVERSION = FIELD(Y.RUTINA.CONVERSION.CAMPO,'-',1)
                            Y.VALUE.CONVERSION= FIELD(Y.RUTINA.CONVERSION.CAMPO,'-',2)
                        END
                        BEGIN CASE
                            CASE Y.TIPO.CONVERSION = "@"
                                CALL @Y.VALUE.CONVERSION(Y.VALOR.CAMPO)
                            CASE Y.TIPO.CONVERSION = "MAPEA"
                                Y.VALUE.MAPPED = ''
                                Y.ERROR        = ''
                                CALL ABC.GET.MAPPED.VALUE(Y.VALUE.CONVERSION, Y.VALOR.CAMPO, Y.VALUE.MAPPED, Y.ERROR)
                                Y.VALOR.CAMPO = Y.VALUE.MAPPED
                            CASE Y.TIPO.CONVERSION = '"'
                                Y.VALOR.CAMPO = CHANGE(Y.RUTINA.CONVERSION.CAMPO, '"', '')
                        END CASE


                    END
                    IF Y.VALOR.CAMPO EQ 0 OR Y.VALOR.CAMPO EQ '' THEN
                    END ELSE
                        IF Y.ID.APLICACION EQ "AA.ARRANGEMENT.ACTIVITY" THEN
                            Y.CAMPO.ARRR.AA  = FIELD(Y.NOMBRE.CAMPO.OFS,">",1)
                            Y.VALOR.PROPERTY = FIELD(Y.NOMBRE.CAMPO.OFS,">",2)
                            Y.VALOR.FIELD    = FIELD(Y.NOMBRE.CAMPO.OFS,">",3)

                            Y.VALOR.VALUE    = Y.VALOR.CAMPO
                            Y.ENVIO.AA.APLICACION.OFS<-1> = Y.CAMPO.ARRR.AA:@VM:Y.VALOR.PROPERTY:@VM:Y.VALOR.FIELD:@VM:Y.VALOR.VALUE
                        END ELSE
                            IF Y.NOMBRE.CAMPO EQ 'DIR.NUM.INT' THEN
                                Y.ENVIO.OFS.APLICACION:=",":Y.NOMBRE.CAMPO.OFS:":1:2=":Y.VALOR.CAMPO
                            END ELSE
                                Y.ENVIO.OFS.APLICACION:=",":Y.NOMBRE.CAMPO.OFS:":1:1=":Y.VALOR.CAMPO
                            END
                        END

                    END
                END
            NEXT S
        END
    NEXT Y.NO.CAMPO
*
RETURN

*================
REVISAR.DEPENDENCIA:
*================

    Y.DEPENDENCIA.VALIDA = "SI"
    IF ARR.APLICACION.DEP NE '' THEN
        Y.TOT.APLIC.DEP = DCOUNT(ARR.APLICACION.DEP,@FM)
        FOR APLICACIONES.DEP = 1 TO Y.TOT.APLIC.DEP
            Y.ID.APLICACION.DEP = FIELD(ARR.APLICACION.DEP<APLICACIONES.DEP>,@VM,1)
            Y.NOMBRE.CAMPO.DEP  = FIELD(ARR.APLICACION.DEP<APLICACIONES.DEP>,@VM,2)
            FIND Y.ID.APLICACION.DEP IN FIELD(R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.Aplicacion>,"_",1) SETTING AP, VP, SP THEN
                Y.ESTATUS.ID.APLIC = R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs><1,VP>
                Y.VALOR.DATO.DEPEN = R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs><1,VP>
                IF Y.ESTATUS.ID.APLIC EQ "APLICADO" THEN
                    IF Y.ID.APLICACION EQ "AA.ARRANGEMENT.ACTIVITY" THEN
                        IF Y.ID.APLICACION.DEP EQ "FUNDS.TRANSFER" THEN
                        END ELSE
                            Y.ENVIO.OFS.APLICACION:=",":Y.NOMBRE.CAMPO.DEP:":1:1=":Y.VALOR.DATO.DEPEN
                        END
                    END ELSE
                        Y.ENVIO.OFS.APLICACION:=",":Y.NOMBRE.CAMPO.DEP:":1:1=":Y.VALOR.DATO.DEPEN
                    END
                END ELSE
                    Y.ENVIO.OFS.APLICACION = ""
                    Y.DEPENDENCIA.VALIDA = "NO"
                END
            END ELSE
                Y.ENVIO.OFS.APLICACION = ""
                Y.DEPENDENCIA.VALIDA = "NO"
            END
        NEXT APLICACIONES.DEP
    END
RETURN
END

