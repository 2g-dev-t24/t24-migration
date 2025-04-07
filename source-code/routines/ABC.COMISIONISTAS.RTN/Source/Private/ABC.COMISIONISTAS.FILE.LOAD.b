* @ValidationCode : MjoxODIyMzA4ODA4OkNwMTI1MjoxNzQ0MDQ5MDk4NzQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2025 15:04:58
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
SUBROUTINE ABC.COMISIONISTAS.FILE.LOAD(Y.ID.COMISIONISTA,Y.MENSAJE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING AbcValidarDatosSs
    $USING EB.DataAccess
    $USING AbcTable
    $USING ST.Customer
    $USING EB.Security
    
    AbcValidarDatosSs.AbcValidarDatosSs(YIdAplicacion,YNombreCamposSs,YNomCampoToMap,YValorCampo,YMensajeError)
*DEFFUN ABC.VALIDAR.DATOS.SS()

    GOSUB INICIO
    GOSUB APERTURA.TABLAS
    GOSUB REGISTROS.PROCESAR

RETURN

*=============================================================================
* INICIO DE VARIABLES
*=============================================================================
INICIO:
    TODAY = EB.SystemTables.getToday()
    Y.DATE              = TODAY
    Y.YEAR              = Y.DATE[1,4]
    Y.MONTH             = Y.DATE[5,2]
    Y.DAY               = Y.DATE[7,2]
    Y.ARCHIVO.PROCESADO = 0
    Y.MENSAJE           = ""
    Y.BAN.CTE.EXITENTE  = "CLIENTE EXISTENTE"     ;* SBS-F&G
    Y.CTE.EXITENTE.ABC  = "CLIENTE EXISTENTE DE ABC CAPITAL"
    Y.LOG.FILE.NAME.COLONIA = "LOG_COLONIAS ":TIMEDATE():".txt"

RETURN

*=============================================================================
* OPEN TABLES THAT WE WILL USE IN THIS PROCESS
*=============================================================================
APERTURA.TABLAS:

*---Tabla de Parametros donde se indican los parametros de los Archivos
    FN.ABC.COMISIONISTAS.FILE.PARAM = 'F.ABC.COMISIONISTAS.FILE.PARAM'
    F.ABC.COMISIONISTAS.FILE.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.PARAM,F.ABC.COMISIONISTAS.FILE.PARAM)

*---Tabla de Detalles, se guarda al archivo que se recibe del comisionista
    FN.ABC.COMISIONISTAS.FILE.DETAIL = 'F.ABC.COMISIONISTAS.FILE.DETAIL'
    F.ABC.COMISIONISTAS.FILE.DETAIL = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

*---Tabla de Relacion de Lineas que hay en un Archivo
    FN.ABC.COMISIONISTAS.FILE.CONCAT = 'F.ABC.COMISIONISTAS.FILE.CONCAT'
    F.ABC.COMISIONISTAS.FILE.CONCAT = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.CONCAT,F.ABC.COMISIONISTAS.FILE.CONCAT)

*---Tabla de Relacion de archivos correspondientes a un cliente comisionistas
    FN.ABC.COMISIONISTAS.RELACION = 'F.ABC.COMISIONISTAS.RELACION'
    F.ABC.COMISIONISTAS.RELACION  = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION)

*    -TABLA DE COMISIONISTAS
    FN.ABC.REGISTRO.COMISIONISTAS = "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO.COMISIONISTAS  = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS,F.ABC.REGISTRO.COMISIONISTAS)

*---CRM CAMPO DE ACTIVIDAD ECONOMICA 05 OCTUBRE 2016 SOLO SI ES CLIENTE NUEVO ---------------------
    F.ABC.GENERAL.MAPPING  = ''
    FN.ABC.GENERAL.MAPPING = 'F.ABC.GENERAL.MAPPING'
    EB.DataAccess.Opf(FN.ABC.GENERAL.MAPPING,F.ABC.GENERAL.MAPPING)
*-----------------------------------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'          ;*AAR-20191016 - S
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.USER = 'F.USER'
    F.USER   = ''
    EB.DataAccess.Opf(FN.USER, F.USER) ;*AAR-20191016 - E

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM   = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

RETURN

*=============================================================================
* SELECT SOBRE LOS REGISTROS QUE PUEDEN EXISTIR DEL COMISIONISTA A PROCESAR
*=============================================================================
REGISTROS.PROCESAR:

*---Select de archivos que se encuentran parametrizados para un comisionista en Especifico
    COMANDO.SELECT.REG = "SSELECT " :FN.ABC.COMISIONISTAS.FILE.PARAM:" WITH NOM.COMISIONISTA EQ ": DQUOTE(Y.ID.COMISIONISTA)  ; * ITSS - ANJALI - Added DQUOTE
    EB.DataAccess.Readlist(COMANDO.SELECT.REG,Y.LIST.REGISTRO,'',Y.NO.REGISTRO,Y.SEL.ERR.REG)

    IF Y.NO.REGISTRO EQ 0 THEN
        Y.MENSAJE<-1> = "No existen registros parametrizados"
    END ELSE
        FOR I.CONTADOR = 1 TO Y.NO.REGISTRO
            ARR.LOG.VALIDACION   =''
            Y.RESPUESTA.ESCRIBE  = ''
            Y.ID.ABC.COMISIONISTAS.FILE.PARAM = Y.LIST.REGISTRO<I.CONTADOR>
            GOSUB LEER.PARAMETROS
        NEXT I.CONTADOR
        Y.MENSAJE<-1> = "Se Validaron ":Y.ARCHIVO.PROCESADO:" Archivos"
    END

RETURN

*=============================================================================
* READ PARAMETERS FROM OUR LOCAL TABLE
*=============================================================================
LEER.PARAMETROS:

    R.ABC.GENERAL.PARAM = ''
    Y.ERR.GRAL.PARAM = ''
    Y.ID.GRAL.PARAM = 'USER.T24.PROCESOS'
    Y.NOMBRE.PARAM = ''
    Y.OFS.SESSION = ''
    Y.POS.AF = ''
    Y.POS.AV = ''
    Y.POS.AS = ''

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.ID.GRAL.PARAM, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.GRAL.PARAM)
    IF R.ABC.GENERAL.PARAM THEN
        Y.NOMBRE.PARAM = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>
        FIND 'OFS.SESSION' IN Y.NOMBRE.PARAM SETTING Y.POS.AF, Y.POS.AV, Y.POS.AS THEN
            Y.OFS.SESSION = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro,Y.POS.AV>
        END
    END

    R.ABC.COMISIONISTAS.FILE.PARAM = ""
    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.PARAM,Y.ID.ABC.COMISIONISTAS.FILE.PARAM,R.ABC.COMISIONISTAS.FILE.PARAM,F.ABC.COMISIONISTAS.FILE.PARAM,Y.ERROR.PARAM)
    IF R.ABC.COMISIONISTAS.FILE.PARAM NE '' THEN

*---PARAMETROS GENERALES PARA LEER EL ARCHIVO Y DE SEPARACION
        Y.FILE.SEP             = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileInSep>
        Y.FILE.MASK            = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileInMask>
        Y.FILE.PATH            = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileInPath>
        Y.FILE.EXT             = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileInExt>
        Y.LINEA.INICIA.CARGA   = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.LineaInicio>
        Y.FILE.PREFIX          = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldPrefix>
        Y.FILE.SEP.OUT         = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileOutSep>
        Y.FILE.MASK.OUT        = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileOutMask>
        Y.FILE.PATH.OUT        = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileOutPath>
        Y.FILE.EXT.OUT         = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileOutExt>
        Y.TOT.FIELDS.PARAM     = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FileInTotFields>   ;* total de campos por linea (archivo)
        Y.ARR.APLICACIONES.OFS = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.OfsAplicacion>)
*        Y.ARR.APLICACIONES.OFS =  FIELD(Y.ARR.APLICACIONES.OFS,"_",1)

*---PARAMETROS A NIVEL DE LAYOUT ES DECIR CAMPO, EXISTE UN SET MULTIVALOR POR CADA CAMPO
        Y.ARR.FIELD.NAME       = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldName>)
        Y.ARR.FIELD.POS        = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldPosLayout>)
        Y.ARR.FIELD.MAN        = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldMandatory>)
        Y.ARR.FIELD.RTN.VAL    = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldRtnVal>) ;* SE PUEDE REALIZAR SUB VALOR EN CASO DE QUE SE NECESITEN EJECUTAR MAS DE UNA RUTINA POR CAMPO
        Y.ARR.FIELD.RTN.CONV   = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldRtnConv>)
        Y.ARR.FIELD.LENGTH     = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldLenght>)
        Y.ARR.TIPO.LINEA       = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.TipoLinea>)
        Y.ARR.TABLA.APLICA     = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldT24Table>)
        Y.ARR.CAMPOS.APLICA    = RAISE(R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.FieldT24OfsName>)
        GOSUB PROCESA.ARCHIVOS
    END ELSE
        Y.MENSAJE<-1> = 'NO EXISTE EL REGISTRO ':Y.ID.ABC.COMISIONISTAS.FILE.PARAM:" EN TABLA ABC.COMISIONISTAS.FILE.PARAM"
    END

RETURN

*=============================================================================
* Leemos el archivo de entrada basandonos en el path y nombre que esta registrado en la tabla de parametros
*=============================================================================
PROCESA.ARCHIVOS:



    Y.SEL.FILES  = ''
    Y.LIST.FILES = ''
    Y.NO.FILES   = ''
    Y.SEL.ERR    = ''

*---Remplazar Fecha por Today
    Y.FILE.NAME = Y.FILE.MASK
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'AAAA',Y.YEAR)
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'aaaa',Y.YEAR)
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'MM',Y.MONTH)
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'mm',Y.MONTH)
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'DD',Y.DAY)
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'dd',Y.DAY)

*---Remplazar los guiones por guienes bajos
    Y.FILE.NAME = EREPLACE(Y.FILE.NAME,'-','_')

    Y.FILE.NAME.OUT = Y.FILE.MASK.OUT
    Y.FILE.NAME.OUT = EREPLACE(Y.FILE.NAME.OUT,'AAAA',Y.YEAR)
    Y.FILE.NAME.OUT = EREPLACE(Y.FILE.NAME.OUT,'aaaa',Y.YEAR)
    Y.FILE.NAME.OUT = EREPLACE(Y.FILE.NAME.OUT,'MM',Y.MONTH)
    Y.FILE.NAME.OUT = EREPLACE(Y.FILE.NAME.OUT,'mm',Y.MONTH)
    Y.FILE.NAME.OUT = EREPLACE(Y.FILE.NAME.OUT,'DD',Y.DAY)
    Y.FILE.NAME.OUT = EREPLACE(Y.FILE.NAME.OUT,'dd',Y.DAY)

*---Seleccionamos del path parametrizado todos los archivos que cumplan con el criterio de nombre establecido
    Y.SEL.FILES = "SSELECT " : Y.FILE.PATH : " LIKE " :  DQUOTE(SQUOTE(Y.FILE.NAME):"...":SQUOTE(Y.FILE.EXT))  ; * ITSS - ANJALI - Added DQUOTE
    EB.DataAccess.Readlist(Y.SEL.FILES,Y.LIST.FILES,'',Y.NO.FILES,Y.SEL.ERR)

    IF Y.NO.FILES GT 0 THEN
        FOR LOOP.FILES = 1 TO Y.NO.FILES
            Y.FILE.TO.READ                     = Y.LIST.FILES<LOOP.FILES>
            Y.NUM.OF.LINE                      = 0
            Y.NUM.OF.LINE.LEE                  = 0
            ARCHIVO.LINEA                      = 0
            Y.FILE.NAME.NO.EXT                 = Y.FILE.TO.READ
            Y.FILE.NAME.NO.EXT                 = EREPLACE(Y.FILE.NAME.NO.EXT,Y.FILE.EXT,"")
            Y.ABC.COMISIONISTAS.FILE.CONCAT.ID = Y.FILE.NAME.NO.EXT

            R.ABC.COMISIONISTAS.FILE.CONCAT = ""
            EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.CONCAT,Y.ABC.COMISIONISTAS.FILE.CONCAT.ID,R.ABC.COMISIONISTAS.FILE.CONCAT,F.ABC.COMISIONISTAS.FILE.CONCAT,Y.AVFC)

*---Solo en caso de no existir el archivo se continua
            IF R.ABC.COMISIONISTAS.FILE.CONCAT EQ '' THEN
                GOSUB READ.FILE
*---Actualiza o graba EN TABLA ABC.COMISIONISTAS.FILE.CONCAT
                Y.VALOR.OK.CONCAT = R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.LoadOk>
                IF Y.VALOR.OK.CONCAT EQ '' THEN
                    R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.LoadOk> = 'SI'
                END
                EB.DataAccess.FWrite(FN.ABC.COMISIONISTAS.FILE.CONCAT,Y.ABC.COMISIONISTAS.FILE.CONCAT.ID,R.ABC.COMISIONISTAS.FILE.CONCAT)
*WRITE R.ABC.COMISIONISTAS.FILE.CONCAT TO F.ABC.COMISIONISTAS.FILE.CONCAT, Y.ABC.COMISIONISTAS.FILE.CONCAT.ID
                Y.ARCHIVO.PROCESADO += 1
            END ELSE
                Y.MENSAJE<-1> = 'Archivo Vacio ' : Y.FILE.TO.READ
            END

            COMMAND = 'mv ' :Y.FILE.PATH:"/":Y.FILE.TO.READ:' ':Y.FILE.PATH:"/Procesado/":Y.FILE.TO.READ
            EXECUTE COMMAND CAPTURING Y.RESPUESTA
        NEXT LOOP.FILES
    END ELSE
        TEXT =  'NO EXISTEN ARCHIVOS ':Y.FILE.MASK:' EN EL DIRECTORIO'
    END

    GOSUB FINALIZA

RETURN

*=============================================================================
* Lee el contenido de cada archivo que se encontro en el path configurado; los archivos encontrados son el resultado del SELECT al directorio
*=============================================================================
READ.FILE:

*---Apertura de Archivo
*   EXECUTE "sh dos2unix -c":Y.FILE.PATH::"/" :Y.FILE.TO.READ

    OPENSEQ Y.FILE.PATH:"/" :Y.FILE.TO.READ TO FILE.RECORD THEN
        LOOP
            Y.MESSAGE.LOG     = ""
            Y.MESSAGE.LOG.ERR = ""
            Y.VALOR.VAL       = ""      ;*SBS-F&G

*---Lectura de Cada Linea
            READSEQ Y.LINE FROM FILE.RECORD ELSE  RETURN
            Y.NUM.OF.LINE           = Y.NUM.OF.LINE+1
            YARR.CADENA.CAMPOS.OFS  = ''
            YARR.CAMPOS.VALIDAR.OFS = ''

*---El ID de TABLA ABC.COMISIONISTA.FILE.DETAIL se conforma de el archivo  mas el numero de Linea
            R.ABC.COMISIONISTAS.FILE.DETAIL = ""
            Y.ABC.COMISIONISTAS.FILE.DETAIL.ID = Y.FILE.NAME.NO.EXT:"-":Y.NUM.OF.LINE

            EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,Y.ABC.COMISIONISTAS.FILE.DETAIL.ID,R.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,Y.ERR.DETAIL)

*---Convertir Linea de separador parametrizado a FM
            Y.ARR.LINE = UTF8(Y.LINE)
            IF Y.ARR.LINE NE '' THEN
                Y.NUM.OF.LINE.LEE  += 1
                CONVERT Y.FILE.SEP TO FM IN Y.ARR.LINE
                Y.TOTAL.SEPARADORES.LINEA = DCOUNT(Y.ARR.LINE,@FM)
                Y.TOTAL.SEPARADORES.PARAM = DCOUNT(Y.ARR.FIELD.POS,@FM)

*---Al inicio de cada lectura se guarda el archio y linea que se LEE
                Y.MSG = Y.FILE.TO.READ : "," : "Line:":Y.NUM.OF.LINE
                Y.MESSAGE.LOG<-1> = Y.MSG

                IF Y.NUM.OF.LINE.LEE EQ Y.LINEA.INICIA.CARGA THEN
                    Y.TIPO.LINEA = "E"
                    Y.CAMPOS.LEER.PARAM = Y.TOTAL.SEPARADORES.LINEA
                END ELSE
                    Y.TIPO.LINEA = "D"
                    Y.CAMPOS.LEER.PARAM = Y.TOT.FIELDS.PARAM
                END

*---CRM CAMPO DE ACTIVIDAD ECONOMICA 30 SEPTIEMBRE 2016---------------------
                Y.BANDE.ACTI.ECONO = 0
*---------------------------------------------------------------------------

                Y.CONTADOR.SEPARADORES.LINEA = 0
*---Se inicia con la lectura de cada campo(separador) de cada Linea hasta el numero parametrizado
                FOR Y.LOOP.FIELDS = 1 TO Y.TOTAL.SEPARADORES.PARAM
*---Datos que se guardan por cada Campo
                    Y.CADENA.ERRORES.CAMPO = ''
                    YARR.CAMPOS.VALIDAR.OFS= ''
*---Se extraen parametros para la lectura
                    Y.POS.TO.MAP       = Y.ARR.FIELD.POS<Y.LOOP.FIELDS>
                    Y.NOM.CAMPO.TO.MAP = Y.ARR.FIELD.NAME<Y.LOOP.FIELDS>
                    Y.MANDATORY.Y.N    = Y.ARR.FIELD.MAN<Y.LOOP.FIELDS>
                    Y.FIELD.LENGTH     = Y.ARR.FIELD.LENGTH<Y.LOOP.FIELDS>
                    Y.TIPO.ACT.LINEA   = Y.ARR.TIPO.LINEA<Y.LOOP.FIELDS>
                    Y.NAME.RUTINA.VAL  = RAISE(Y.ARR.FIELD.RTN.VAL<Y.LOOP.FIELDS>)
                    Y.NOM.RUTINA.CONV  = RAISE(Y.ARR.FIELD.RTN.CONV<Y.LOOP.FIELDS>)

                    IF Y.TIPO.LINEA EQ Y.TIPO.ACT.LINEA THEN
                        Y.CONTADOR.SEPARADORES.LINEA = Y.CONTADOR.SEPARADORES.LINEA + 1
                        IF Y.CONTADOR.SEPARADORES.LINEA GT Y.CAMPOS.LEER.PARAM THEN
                            BREAK
                        END

*---Lee la posicion del archivo que se encuentra mapeada
                        Y.VALOR.CAMPO.ORG = TRIM(Y.ARR.LINE<Y.POS.TO.MAP>)
                        Y.VALOR.CAMPO     = Y.VALOR.CAMPO.ORG

*.........IR............................................................................................
                        IF Y.NOM.CAMPO.TO.MAP EQ "LUG.NAC" AND Y.VALOR.CAMPO EQ "NE" THEN
                            Y.VALOR.NAC = TRIM(Y.ARR.LINE<Y.POS.TO.MAP-1>)
                            IF Y.VALOR.NAC EQ "MX" THEN
                                Y.VALOR.CAMPO = '33'
                                Y.VALOR.CAMPO.ORG ='33'
                            END
                        END
                        IF Y.NOM.CAMPO.TO.MAP EQ "SHORT.NAME" AND Y.VALOR.CAMPO EQ '' THEN
                            Y.VALOR.NAME.1 = TRIM(Y.ARR.LINE<Y.POS.TO.MAP+1>)
                            IF Y.VALOR.NAME.1 NE '' THEN
                                Y.VALOR.CAMPO = '...'
                                Y.VALOR.CAMPO.ORG ='...'
                            END
                        END

                        IF Y.NOM.CAMPO.TO.MAP EQ "NAME.1" AND Y.VALOR.CAMPO EQ '' THEN
                            Y.VALOR.SHORT.NAME = TRIM(Y.ARR.LINE<Y.POS.TO.MAP-1>)
                            IF Y.VALOR.SHORT.NAME NE '' THEN
                                Y.VALOR.CAMPO = '...'
                                Y.VALOR.CAMPO.ORG ='...'
                            END
                        END
                        IF Y.NOM.CAMPO.TO.MAP EQ 'DIR.COD.POS' THEN
                            Y.VALOR.CAMPO =FMT(Y.VALOR.CAMPO,"5'0'R")
                            Y.VALOR.CAMPO.ORG =Y.VALOR.CAMPO
                            CODIGO.POSTAL=Y.VALOR.CAMPO
                        END

*---Campo que indicara el Numero del Comisinista para tabla de Relacion
                        IF Y.NOM.CAMPO.TO.MAP EQ "CLIENTE-COMISIONISTA" THEN
                            Y.ID.COMISIONISTAS = Y.VALOR.CAMPO
                        END

                        IF Y.NOM.CAMPO.TO.MAP EQ 'PLAZO' THEN
                            CALL ABC.VALIDA.PLAZO(Y.VALOR.CAMPO.ORG)
                        END
*---Convertir el Valor del archivo algun dato valido para T24 en caso de haber parametrizado una rutina
*---solo un parametro de entrada y el mismo de respuesta

                        IF Y.NOM.RUTINA.CONV NE '' THEN
                            IF Y.NOM.RUTINA.CONV[1,1] EQ "@" OR Y.NOM.RUTINA.CONV[1,1] EQ '"' THEN
                                Y.TIPO.CONVERSION = Y.NOM.RUTINA.CONV[1,1]
                                Y.VALUE.CONVERSION=FIELD(Y.NOM.RUTINA.CONV,"@",2)
                            END ELSE
                                Y.TIPO.CONVERSION  = FIELD(Y.NOM.RUTINA.CONV,'-',1)
                                Y.VALUE.CONVERSION = FIELD(Y.NOM.RUTINA.CONV,'-',2)
                            END
                            BEGIN CASE
                                CASE Y.TIPO.CONVERSION = "@"
                                    CALL @Y.VALUE.CONVERSION(Y.VALOR.CAMPO)
                                CASE Y.TIPO.CONVERSION = "MAPEA"
                                    Y.VALUE.MAPPED = ''
                                    Y.ERROR        = ''

                                    CALL ABC.GET.MAPPED.VALUE(Y.VALUE.CONVERSION, Y.VALOR.CAMPO, Y.VALUE.MAPPED, Y.ERROR)
                                    Y.VALOR.CAMPO = Y.VALUE.MAPPED

                                    IF Y.ERROR NE '' OR Y.VALOR.CAMPO.ORG EQ '9999999' THEN
*---CRM CAMPO DE ACTIVIDAD ECONOMICA 05 OCTUBRE 2016 SOLO SI ES CLIENTE NUEVO ---------------------
                                        IF Y.VALUE.CONVERSION = 'ACTIVIDADECONOMICA' THEN
                                            IF Y.VALUE.MAPPED EQ '' AND Y.ERROR[1,16] EQ 'VALOR NO MAPEADO' OR Y.VALOR.CAMPO.ORG EQ '9999999' THEN
                                                Y.VALOR.CAMPO = FIELD(Y.NOM.RUTINA.CONV,'-',3)
                                                Y.VALOR.CAMPO.ORG =Y.VALOR.CAMPO
                                                Y.ERROR = ''
                                            END
*                                       Y.BANDE.ACTI.ECONO = 1
                                        END ELSE
                                            Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : Y.ERROR
                                            INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                            Y.MESSAGE.LOG<-1>  = Y.MSG
                                            Y.MESSAGE.LOG.ERR  = "SI"
                                        END
                                    END
*-----------------------------------------------------------------------------------------------------
                                CASE Y.TIPO.CONVERSION = '"'
                                    Y.VALOR.CAMPO = CHANGE(Y.NOM.RUTINA.CONV, '"', '')
                            END CASE
                        END

*---Validacion de OBLIGATORIO
                        IF Y.VALOR.CAMPO EQ "" AND Y.MANDATORY.Y.N EQ "Y" THEN
                            Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : "Obligatorio"
                            INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                            Y.MESSAGE.LOG<-1> = Y.MSG
                            Y.MESSAGE.LOG.ERR = "SI"
                        END ELSE

*---Validacion de LONGITUD mayor a la paramtrizada
                            IF LEN(Y.VALOR.CAMPO) GT Y.FIELD.LENGTH THEN
                                Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : "Demasiados caracteres"
                                INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                Y.MESSAGE.LOG<-1> = Y.MSG
                                Y.MESSAGE.LOG.ERR = "SI"
                            END
                        END

*---Validacion por medio de una FUNCION donde se revisa caracteristicas que pueda aceptar el Campo en base a
*---la aplicacion en donde se aplicara el OFS

                        Y.TOT.TABLAS.APLICA = DCOUNT(Y.ARR.TABLA.APLICA<Y.LOOP.FIELDS>,@SM)
                        FOR I.SM = 1 TO Y.TOT.TABLAS.APLICA
                            Y.ID.APLICACION   = FIELD(Y.ARR.TABLA.APLICA<Y.LOOP.FIELDS>,@SM,I.SM)
                            Y.NOMBRE.CAMPO.SS = FIELD(Y.ARR.CAMPOS.APLICA<Y.LOOP.FIELDS>,@SM,I.SM)
                            Y.MENSAJE.ERROR   = ''
                            YARR.CAMPOS.VALIDAR.OFS<-1> = Y.ID.APLICACION :@VM:Y.NOMBRE.CAMPO.SS :@VM:Y.VALOR.CAMPO
*---En caso de NO existir datos en el archivo no se valida nada
                            IF Y.VALOR.CAMPO EQ "" OR Y.VALOR.CAMPO EQ 0 THEN
                            END ELSE
*---CRM CAMPO DE ACTIVIDAD ECONOMICA 30 SEPTIEMBRE 2016 SOLO SI ES CLIENTE NUEVO ---------------------

                                IF Y.NOM.CAMPO.TO.MAP EQ 'DIR.COLONIA' THEN
                                    Y.MESSAGES = ''
                                    Y.MESSAGE.DISPLAY = ''
                                    Y.MESSAGE = ''
                                    NOMBRE.COLONIA=Y.VALOR.CAMPO

                                    YI.NUMERO.LINEA =TRIM(FIELD(YI.DETAIL,"-",2))
                                    YI.NUMERO.LINEA.CTE = YI.NUMERO.LINEA+1
                                    YI.DETAIL = TRIM(EREPLACE(YI.DETAIL, "DIR", "CTE"))
                                    YI.DETAIL = TRIM(EREPLACE(YI.DETAIL,"-":YI.NUMERO.LINEA , ""))
                                    YI.DETAIL =YI.DETAIL:"-":YI.NUMERO.LINEA.CTE
                                    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,YI.DETAIL,REC.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAIL)
                                    Y.VALIDACIONES = REC.DETAIL<ACD.VALOR.VALIDACION>
                                    CONVERT @VM TO " " IN Y.VALIDACIONES
                                    IF Y.VALIDACIONES NE "CLIENTE EXISTENTE" THEN
                                        FINDSTR "CP NO EXISTE" IN R.ABC.COMISIONISTAS.FILE.DETAIL SETTING Ap, Vp THEN
                                        END ELSE
                                            CALL ABC.ID.COLONIA(CODIGO.POSTAL,NOMBRE.COLONIA,ID.COLONIA,Y.MESSAGE)
                                            Y.MESSAGE.DISPLAY = FIELD(Y.MESSAGE,',',1)
                                            Y.VALOR.CAMPO =ID.COLONIA
                                            Y.VALOR.CAMPO.ORG = ID.COLONIA
                                            IF Y.MESSAGE.DISPLAY NE '' THEN
                                                YI.DETAIL =Y.ABC.COMISIONISTAS.FILE.DETAIL.ID
                                                Y.MESSAGES = " COMISIONISTA: ":Y.ID.COMISIONISTAS:" CP ":CODIGO.POSTAL:" ":Y.MESSAGE.DISPLAY
                                                Y.MENSAJE<-1> = Y.MESSAGES
                                                ARR.LOG.VAL.COLONIA<-1> = " COMISIONISTA ":Y.ID.COMISIONISTAS:" ":Y.MESSAGE
                                            END
                                        END
                                    END ELSE
                                        Y.VALOR.CAMPO ='05035271052472'
                                        Y.VALOR.CAMPO.ORG = '05035271052472'
                                    END
                                END


                                Y.MENSAJE.ERROR = AbcValidarDatosSs.AbcValidarDatosSs(Y.ID.APLICACION,Y.NOMBRE.CAMPO.SS,Y.NOM.CAMPO.TO.MAP,Y.VALOR.CAMPO,Y.MENSAJE.ERROR)
                                IF Y.MENSAJE.ERROR NE '' THEN
                                    INS Y.MENSAJE.ERROR BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                    Y.MESSAGE.LOG<-1> = Y.MENSAJE.ERROR
                                    Y.MESSAGE.LOG.ERR = "SI"
                                END
*                                END
*-----------------------------------------------------------------------------------------------------
                            END
                        NEXT I.SM

*---Validacion por medio de Rutinas ligadas en tabla ABC.COMISIONISTAS.FILE.PARAM
                        IF Y.NAME.RUTINA.VAL NE "" THEN
                            CONVERT @VM TO @FM IN Y.NAME.RUTINA.VAL
                            CONVERT @SM TO @FM IN Y.NAME.RUTINA.VAL
                            Y.TOTAL.RTN.VAL = DCOUNT(Y.NAME.RUTINA.VAL,@FM)
                            Y.ARR.MSJ.CAMPO = ''
                            FOR I.RTN = 1 TO Y.TOTAL.RTN.VAL
                                Y.ACT.RTN.VAL = Y.NAME.RUTINA.VAL<I.RTN>
                                Y.MENSAJE.ERROR = ''
*---CUANDO SE TRATA DEL RFC.CTE AQUI REALIZA EL LLAMADO A LA RUTINA DE VALIDACION DE CLIENTE EXISTENTE

                                IF Y.ACT.RTN.VAL NE 'ABC.VALIDACION.CTE.EXISTENTE' THEN
                                    CALL @Y.ACT.RTN.VAL(YARR.CADENA.CAMPOS.OFS,YARR.CAMPOS.VALIDAR.OFS,Y.MENSAJE.ERROR)
                                END ELSE
                                    CALL ABC.VALIDACION.CTE.EXISTENTE(YARR.CADENA.CAMPOS.OFS,YARR.CAMPOS.VALIDAR.OFS,Y.MENSAJE.ERROR,Y.ARR.DATOS.CTE)
                                END
                                IF Y.MENSAJE.ERROR NE '' THEN
                                    Y.ARR.MSJ.CAMPO := Y.MENSAJE.ERROR :" ":

*---CUANDO SE ACTIVA LA BANDERA DE CLIENTE EXISTENTE SE BUSCA EL ID DE DICHO CLIENTE ASI COMO SU NUMERO DE CUENTA
*---PARA EVITAR QUE LE ASIGNEN UN NUEVO NUMERO
                                    IF Y.MENSAJE.ERROR EQ Y.BAN.CTE.EXITENTE THEN         ;* SBS -F&G 09/01/2016
                                        R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3> = FIELD(YARR.CAMPOS.VALIDAR.OFS,@VM,4) ;* SBS-F&G Asigna cliente ya existente
                                        R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,4> = FIELD(YARR.CAMPOS.VALIDAR.OFS,@VM,5) ;* SBS-F&G Asigna cuenta ya existente
                                    END ;* SBS-F&G

                                END
                            NEXT I.RTN
                            Y.MENSAJE.ERROR = Y.ARR.MSJ.CAMPO
                            IF Y.MENSAJE.ERROR NE '' THEN
                                INS Y.MENSAJE.ERROR BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                Y.MESSAGE.LOG<-1> = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," :Y.MENSAJE.ERROR
                                Y.MESSAGE.LOG.ERR = "SI"
                            END
                        END

*---Se busca que no existan comas (,) debido a que implicarian errores en el OFS
                        FIND "," IN Y.VALOR.CAMPO SETTING APVALOR, AVVALOR, SPVALOR THEN
                            Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : "Invalido, Contiene comas(,)"
                            INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                            Y.MESSAGE.LOG<-1> = Y.MSG
                            Y.MESSAGE.LOG.ERR = "SI"
                        END

                        CONVERT FM TO Y.FILE.SEP.OUT IN Y.CADENA.ERRORES.CAMPO
                        IF Y.TIPO.LINEA EQ "D" THEN
                            R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.NombreCampo,Y.CONTADOR.SEPARADORES.LINEA>     = Y.NOM.CAMPO.TO.MAP
                            R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,Y.CONTADOR.SEPARADORES.LINEA>      = Y.VALOR.CAMPO.ORG
                            R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorValidacion,Y.CONTADOR.SEPARADORES.LINEA> = Y.CADENA.ERRORES.CAMPO
                        END ELSE
                            R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.NombreCampo,Y.CONTADOR.SEPARADORES.LINEA>     = Y.NOM.CAMPO.TO.MAP
                            R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.ValorCampo,Y.CONTADOR.SEPARADORES.LINEA>      = Y.VALOR.CAMPO.ORG
                            R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.ValorValidacion,Y.CONTADOR.SEPARADORES.LINEA> = Y.CADENA.ERRORES.CAMPO
                        END
                        YARR.CADENA.CAMPOS.OFS<-1> = YARR.CAMPOS.VALIDAR.OFS
                    END
                NEXT Y.LOOP.FIELDS

                IF Y.MESSAGE.LOG.ERR THEN
                    Y.MESSAGE.LOG.ERR = Y.MESSAGE.LOG
                    CONVERT @FM TO @VM IN Y.MESSAGE.LOG.ERR
                    IF Y.TIPO.LINEA EQ "D" THEN
                        Y.VALOR.VAL =  TRIM(R.ABC.COMISIONISTAS.FILE.DETAIL<ACD.VALOR.VALIDACION,13>)         ;* SBS-F&G

                        IF Y.VALOR.VAL = Y.BAN.CTE.EXITENTE THEN      ;*SBS-F&G 09/01/2016
                            R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = "SI" ;*SBS-F&G 09/01/2016
                        END ELSE        ;*SBS-F&G 09/01/2016
*---CRM CAMPO DE ACTIVIDAD ECONOMICA 05 OCTUBRE 2016 SOLO SI ES CLIENTE NUEVO ---------------------
                            IF Y.BANDE.ACTI.ECONO = 1 THEN
                                R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = "SI"
                            END ELSE
                                R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = "NO"       ;*SBS-F&G 09/01/2016
                            END
*-----------------------------------------------------------------------------------------------------
                        END   ;*SBS-F&G 09/01/2016
*******                        R.ABC.COMISIONISTAS.FILE.DETAIL<ACD.LOAD.OK> = "NO"
                    END ELSE
                        R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.LoadOk> = "NO"
                    END
                    ARR.LOG.VALIDACION<-1> = Y.MESSAGE.LOG
                END ELSE
                    IF Y.TIPO.LINEA EQ "D" THEN
                        R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = "SI"
                    END ELSE
                        R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.LoadOk> = "SI"
                    END
                    ARR.LOG.VALIDACION<-1> = Y.MESSAGE.LOG
                    ARR.LOG.VALIDACION<-1> = "OK"
                END

                ARR.LOG.VALIDACION<-1> = " "
                IF Y.TIPO.LINEA EQ "E" THEN
                    Y.ID.INVERSION  = FIELD(Y.ARR.LINE,FM,7)
                END

                IF Y.TIPO.LINEA EQ "D" THEN
                    ARCHIVO.LINEA = ARCHIVO.LINEA + 1
                    IF Y.ABC.COMISIONISTAS.FILE.DETAIL.ID[1,8] EQ "VEC_DIR_" THEN

                        Y.CONCAT.ID = CHANGE(Y.ABC.COMISIONISTAS.FILE.DETAIL.ID,'DIR','CTE')
                        Y.CONCAT.ID = FIELD(Y.CONCAT.ID,'-',1)
                        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.CONCAT,Y.CONCAT.ID,R.FILE.CONCAT,F.ABC.COMISIONISTAS.FILE.CONCAT,ERR.FILE.CONCAT)
                        FIND 'ID-EMISION' IN R.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.NombreCampo> SETTING AP, AV, SP THEN
                            Y.ID.INVERSION = R.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.ValorCampo,AV>
                        END
                    END

                    Y.ID.COMISIONISTAS.RELACION = Y.ID.COMISIONISTAS:"-":Y.ID.INVERSION
                    R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.idParam>    = Y.ID.ABC.COMISIONISTAS.FILE.PARAM
                    R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.IdRelacion> = Y.ID.COMISIONISTAS.RELACION
                    R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.IdConcat>   = Y.ABC.COMISIONISTAS.FILE.CONCAT.ID

*---Escribe el registro en la tabla ABC.COMISIONISTAS.FILE.DETAIL ( un registro equivale a una linea)
                    WRITE R.ABC.COMISIONISTAS.FILE.DETAIL TO F.ABC.COMISIONISTAS.FILE.DETAIL, Y.ABC.COMISIONISTAS.FILE.DETAIL.ID

*---Valida que el arreglo de CONCAT no contenga aun la Linea que se lee
                    LOCATE Y.ABC.COMISIONISTAS.FILE.DETAIL.ID IN R.ABC.COMISIONISTAS.FILE.CONCAT SETTING Y.POS.CONCAT THEN
                    END ELSE
                        R.ABC.COMISIONISTAS.FILE.CONCAT<AbcTable.AbcComisionistasFileConcat.ArchivoLinea,ARCHIVO.LINEA> = Y.ABC.COMISIONISTAS.FILE.DETAIL.ID
                    END
                    GOSUB RELACION.CTE.COMISIONISTA
                END
            END
            Y.LINE = ''
        REPEAT
    END

RETURN

*=============================================================================
*Al terminar el proceso se busca en ABC.COMISIONISTAS.RELACION y se Escribe
*=============================================================================
RELACION.CTE.COMISIONISTA:
    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.RELACION,Y.ID.COMISIONISTAS.RELACION,R.COM.REL,F.ABC.COMISIONISTAS.RELACION,ERR.COM.REL)
    IF Y.ABC.COMISIONISTAS.FILE.DETAIL.ID[1,8] EQ "VEC_INV_" AND R.COM.REL EQ '' THEN
        Y.ID.REGISTRO.COMISIONISTA = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,2>
        Y.ID.CLIENTE = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3>
        Y.ID.CUENTA  = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,4>
        Y.DATOS =Y.ID.COMISIONISTAS.RELACION:"|":Y.ID.REGISTRO.COMISIONISTA:"|":Y.ID.CLIENTE:"|":Y.ID.CUENTA
        CALL ABC.ACT.REG.COMI(Y.DATOS)
    END

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.RELACION,Y.ID.COMISIONISTAS.RELACION,R.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION,ERR.COMISIONISTAS.RELACION)

    IF R.COMISIONISTAS.RELACION EQ '' THEN
        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdComisionista> = Y.ID.COMISIONISTA
    END
    R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.FechaCarga>     = Y.DATE
    Y.NUM.APLICACIONES = DCOUNT(R.COMISIONISTAS.RELACION<ACR.APLICACION>,@VM)
    Y.NUM.APLICACIONES.OFS.PARAM = DCOUNT(Y.ARR.APLICACIONES.OFS,@FM)

    FOR INO.SS = 1 TO Y.NUM.APLICACIONES.OFS.PARAM
        Y.APLICACION.OFS = Y.ARR.APLICACIONES.OFS<INO.SS>

        IF Y.ABC.COMISIONISTAS.FILE.DETAIL.ID[1,8] EQ "VEC_CTE_" THEN ;*SBS-F&G
            IF Y.VALOR.VAL = Y.BAN.CTE.EXITENTE AND Y.APLICACION.OFS EQ "CUSTOMER" THEN   ;*SBS-F&G ASIGNA EL NUMERO DE CLIENTE YA EXISTENTE
*                 R.COMISIONISTAS.RELACION<ACR.ESTATUS.OFS,INO.SS>   = "APLICADO" ;*SBS-F&G
*                 R.COMISIONISTAS.RELACION<ACR.ID.T24.OFS,INO.SS>    =  R.ABC.COMISIONISTAS.FILE.DETAIL<ACD.VALOR.CAMPO,3>
*                 R.COMISIONISTAS.RELACION<ACR.RESPUESTA.OFS,INO.SS> = Y.BAN.CTE.EXITENTE   ;*SBS-F&G

                Y.CUSTOMER.EXIS = ''    ;*AAR-20191016 - S
                R.CUSTOMER = ''
                Y.ERR.CUS = ''
                Y.CUSTOMER.STATUS = ''
                Y.CUSTOMER.EXIS = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3>
                EB.DataAccess.FRead(FN.CUSTOMER, Y.CUSTOMER.EXIS, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)
                IF R.CUSTOMER THEN
                    Y.CUSTOMER.STATUS = R.CUSTOMER<ST.Customer.Customer.EbCusCustomerStatus>
                    IF Y.CUSTOMER.STATUS EQ 2 THEN
                        GOSUB UPDATE.CUSTOMER.STATUS        ;*AAR-20191016 - S-E
                        IF Y.RESPONSE.OFS EQ 1 THEN
                            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,INO.SS>   = "APLICADO"
                            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,INO.SS>    =  R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3>
                            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,INO.SS> = Y.BAN.CTE.EXITENTE
                        END ELSE
                            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,INO.SS>   =  "ERROR AL ACTIVAR CLIENTE EXISTENTE"
                            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,INO.SS>    =  R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3>
                            R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,INO.SS> = theResponse
                        END
                    END ELSE
                        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,INO.SS>   = "APLICADO"
                        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,INO.SS>    =  R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3>
                        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,INO.SS> = Y.BAN.CTE.EXITENTE
                    END
                END ;*AAR-20191016 - E

                GOSUB ACTUALIZA.COMISIONISTA
            END     ;*SBS-F&G
            IF Y.VALOR.VAL = Y.CTE.EXITENTE.ABC AND Y.APLICACION.OFS EQ "CUSTOMER" THEN
                R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,INO.SS>   = "RECHAZADO CLIENTE ABC"
            END


            IF Y.VALOR.VAL = Y.BAN.CTE.EXITENTE AND Y.APLICACION.OFS EQ "ACCOUNT" THEN    ;*SBS-F&G
                IF R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,4> NE "" THEN          ;*SBS-F&G
                    R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,INO.SS>   = "APLICADO"       ;*SBS-F&G
                    R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs,INO.SS>    = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,4>       ;*SBS-F&G SE ASIGNA EL NUMERO DE CUENTA YA CREADA
                    R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs,INO.SS> = "CUENTA EXISTENTE"         ;*SBS-F&G
                    GOSUB ACTUALIZA.COMISIONISTA
                END ;*SBS-F&G
            END     ;*SBS-F&G
            IF Y.VALOR.VAL = Y.CTE.EXITENTE.ABC AND Y.APLICACION.OFS EQ "ACCOUNT" THEN
                R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,INO.SS>   = "RECHAZADO CUENTA ABC"
            END
        END         ;*SBS-F&G

        FIND Y.APLICACION.OFS IN R.COMISIONISTAS.RELACION<ACR.APLICACION> SETTING APSS, AVSS, SPSS THEN
            AVSS.WRITE = AVSS
        END ELSE
            AVSS.WRITE = DCOUNT(R.COMISIONISTAS.RELACION<ACR.APLICACION>,@VM) + 1

            IF Y.APLICACION.OFS EQ "CUSTOMER" OR Y.APLICACION.OFS EQ "ACCOUNT" THEN
                R.COMISIONISTAS.RELACION<ACR.APLICACION,AVSS.WRITE> = Y.APLICACION.OFS
                IF R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,AVSS.WRITE> EQ '' THEN
                    R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,AVSS.WRITE>    = "NO.APLICADO"
                END
            END ELSE
                R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.Aplicacion,AVSS.WRITE> = Y.APLICACION.OFS:'_':Y.ABC.COMISIONISTAS.FILE.DETAIL.ID
                R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,AVSS.WRITE>    = "VALIDANDO.MONTO"
            END
        END
        Y.TOT.ARCH.APLICACION = DCOUNT(R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.ArchivosLinea,AVSS.WRITE>,@SM)
        YPOS.SM.WRITE = Y.TOT.ARCH.APLICACION + 1
        R.COMISIONISTAS.RELACION<AbcTable.AbcComisionistasRelacion.ArchivosLinea,AVSS.WRITE,YPOS.SM.WRITE> = Y.ABC.COMISIONISTAS.FILE.DETAIL.ID
    NEXT INO.SS

*---ESCRIBE EN LA TABLA ABC.COMISIONISTAS.RELACION
    WRITE R.COMISIONISTAS.RELACION TO F.ABC.COMISIONISTAS.RELACION, Y.ID.COMISIONISTAS.RELACION
    CALL JOURNAL.UPDATE("")
    R.COMISIONISTAS.RELACION = ''

RETURN

ACTUALIZA.COMISIONISTA:

    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION,R.REGISTRO.COMISIONISTA,F.ABC.REGISTRO.COMISIONISTAS,ERR.COMISIONISTA)
    Y.NOMBRE.COMISIONISTA =''
    ARR.REG.COMI = ''
    Y.CUSTOMER = ''
    Y.ACCOUNT =''
    Y.CUSTOMER = R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NoCliente>
    Y.ACCOUNT= R.REGISTRO.COMISIONISTA<AbcTable.AbcRegistroComisionistas.NoCuenta>

    IF Y.APLICACION.OFS EQ "CUSTOMER" THEN

        IF Y.CUSTOMER EQ '' THEN
            ARR.REG.COMI=R.REGISTRO.COMISIONISTA
            Y.NOMBRE.COMISIONISTA = FIELD(Y.ID.COMISIONISTAS.RELACION,"-",1)
            ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoCliente>  = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,3>
            ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.IdComisionista>= Y.NOMBRE.COMISIONISTA
            ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.Comisionista>= 'VECTOR'
            WRITE ARR.REG.COMI TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION
            CALL JOURNAL.UPDATE("")
        END
    END

    IF Y.APLICACION.OFS EQ "ACCOUNT" THEN

        IF Y.ACCOUNT EQ '' THEN
            ARR.REG.COMI=R.REGISTRO.COMISIONISTA
            ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoCuenta> = R.ABC.COMISIONISTAS.FILE.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorCampo,4>
            ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.FechaApeCta> = TODAY
            WRITE ARR.REG.COMI TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.COMISIONISTAS.RELACION
            CALL JOURNAL.UPDATE("")
        END
    END



RETURN


* =================
UPDATE.CUSTOMER.STATUS:
*==================

    Y.USR.OFS.PARAM = ''
    Y.PASS.OFS.PARAM = ''
    Y.OFS.SOURCE.PARAM = ''
    R.USER = ''
    Y.ERR.USER = ''
    Y.USUARIO.OFS = ''

    Y.USR.OFS.PARAM        = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.OfsUsr>
    Y.PASS.OFS.PARAM      = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.OfsPwd>
    Y.OFS.SOURCE.PARAM = R.ABC.COMISIONISTAS.FILE.PARAM<AbcTable.AbcComisionistasFileParam.OfsSource>

    EB.DataAccess.FRead(FN.USER, Y.USR.OFS.PARAM, R.USER, F.USER, Y.ERR.USER)
    IF R.USER THEN
        Y.USUARIO.OFS =  R.USER<EB.Security.User.UseSignOnName>
    END

    OFS.MSG = ''
    Y.AUTH    = 0
    OFS.MSG = "CUSTOMER,/I/PROCESS//" : Y.AUTH : "," : Y.USUARIO.OFS:"/":Y.PASS.OFS.PARAM:",": Y.CUSTOMER.EXIS
    OFS.MSG:= ",CUSTOMER.STATUS:1:1=1"

    theResponse = ''
    txnCommitted = ''
*    options<1> = Y.OFS.SOURCE.PARAM
*    CALL OFS.CALL.BULK.MANAGER(options,OFS.MSG,theResponse,txnCommitted)
    CALL OFS.GLOBUS.MANAGER(Y.OFS.SESSION,OFS.MSG)

    Y.ID.SEND.OFS     = ''
    Y.RESPONSE.OFS = ''
*     Y.ID.SEND.OFS    =  TRIM(FIELD(theResponse, '/', 1))
*     Y.RESPONSE.OFS = TRIM(FIELD(theResponse, '/', 3))
*     Y.RESPONSE.OFS = TRIM(FIELD(Y.RESPONSE.OFS,",",1))
    Y.ID.SEND.OFS    =  TRIM(FIELD(OFS.MSG, '/', 1))
    Y.RESPONSE.OFS = TRIM(FIELD(OFS.MSG, '/', 3))
    Y.RESPONSE.OFS = TRIM(FIELD(Y.RESPONSE.OFS,",",1))

RETURN

*=============================================================================
*Proseso de escritura de archivo LOG
*=============================================================================
FINALIZA:

*---Escribe un LOG de Carga
    OPEN Y.FILE.PATH.OUT TO F.RUTA.ARCHIVO ELSE Y.RESPUESTA.ESCRIBE = "ERROR AL ESCRIBIR"
    WRITE ARR.LOG.VALIDACION TO F.RUTA.ARCHIVO,Y.FILE.NAME.OUT
*---LOG COLONIAS
    IF ARR.LOG.VAL.COLONIA NE '' THEN
        Y.FILE.PATH.OUT.COLONIAS = Y.FILE.PATH.OUT:'/LOG_COLONIAS'
        OPEN Y.FILE.PATH.OUT.COLONIAS TO F.RUTA.ARCHIVO.COLONIA ELSE Y.RESPUESTA.ESCRIBE = "ERROR AL ESCRIBIR"
        WRITE ARR.LOG.VAL.COLONIA TO F.RUTA.ARCHIVO.COLONIA,Y.LOG.FILE.NAME.COLONIA
    END

RETURN

END

