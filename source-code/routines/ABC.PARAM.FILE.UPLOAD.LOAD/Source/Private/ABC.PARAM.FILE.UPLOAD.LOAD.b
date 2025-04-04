* @ValidationCode : Mjo3NDE0OTIwOTE6Q3AxMjUyOjE3NDM3ODIwMzE2Mzc6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 12:53:51
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
$PACKAGE AbcParamFileUploadLoad
SUBROUTINE ABC.PARAM.FILE.UPLOAD.LOAD(Y.ID.ABC.UPLOAD.FILE.PARAM,ARR.RESP.OFS.APLICA)

*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable

    
    DEFFUN ABC.VALIDAR.DATOS.SS()
******************************************************************************

    GOSUB INICIO
    GOSUB APERTURA.TABLAS
    GOSUB LEER.PARAMETROS

RETURN

*=============================================================================
* INICIO DE VARIABLES
*=============================================================================
INICIO:

    TODAY = EB.SystemTables.getToday()
    Y.DATE                            =       TODAY
    Y.YEAR                            =       Y.DATE[1,4]
    Y.MONTH                           =       Y.DATE[5,2]
    Y.DAY                             =       Y.DATE[7,2]
    Y.ARCHIVO.PROCESADO               =       0
    Y.MENSAJE                         =       ""
    ARR.RESP.OFS.APLICA      =       ''
    ARR.RESP.OFS.APLICA.FILE =       ''
RETURN

*=============================================================================
* OPEN TABLES THAT WE WILL USE IN THIS PROCESS
*=============================================================================
APERTURA.TABLAS:

*   -Tabla de Parametros donde se indican los parametros de los Archivos
    FN.ABC.UPLOAD.FILE.PARAM = 'F.ABC.UPLOAD.FILE.PARAM'
    F.ABC.UPLOAD.FILE.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.UPLOAD.FILE.PARAM,F.ABC.UPLOAD.FILE.PARAM)

*   -Tabla de Detalles, se guarda al archivo que se recibe
    FN.ABC.UPLOAD.FILE.DETAIL = 'F.ABC.UPLOAD.FILE.DETAIL'
    F.ABC.UPLOAD.FILE.DETAIL = ''
    EB.DataAccess.Opf(FN.ABC.UPLOAD.FILE.DETAIL,F.ABC.UPLOAD.FILE.DETAIL)

*   -Tabla de Relacion de Lineas que hay en un Archivo
    FN.ABC.UPLOAD.FILE.CONCAT = 'F.ABC.UPLOAD.FILE.CONCAT'
    F.ABC.UPLOAD.FILE.CONCAT = ''
    EB.DataAccess.Opf(FN.ABC.UPLOAD.FILE.CONCAT,F.ABC.UPLOAD.FILE.CONCAT)
    
RETURN

*=============================================================================
* READ PARAMETERS FROM OUR LOCAL TABLE
*=============================================================================
LEER.PARAMETROS:

    R.ABC.UPLOAD.FILE.PARAM = ""
    EB.DataAccess.FRead(FN.ABC.UPLOAD.FILE.PARAM,Y.ID.ABC.UPLOAD.FILE.PARAM,R.ABC.UPLOAD.FILE.PARAM,F.ABC.UPLOAD.FILE.PARAM,Y.ERROR.PARAM)
    IF R.ABC.UPLOAD.FILE.PARAM NE '' THEN

*       - PARAMETROS GENERALES PARA LEER EL ARCHIVO Y DE SEPARACION
        Y.FILE.SEP                      =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpFileInSep>
        Y.FILE.MASK                     =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpFileInMask>
        Y.FILE.PATH                     =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpFileInPath>
        Y.FILE.EXT                      =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpFileInExt>

        Y.LINEA.INICIA.CARGA            =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpLineaInicio>

        Y.FILE.MASK.OUT                 =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpFileOutMask>
        Y.FILE.PATH.OUT                 =       R.ABC.UPLOAD.FILE.PARAM<AbcTable.AbcUploadFileParam.AufpFileOutPath>

        Y.ARR.APLICACIONES.OFS          =      RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.OFS.APLICACION>)

*       - PARAMETROS A NIVEL DE LAYOUT ES DECIR CAMPO, EXISTE UN SET MULTIVALOR POR CADA CAMPO
        Y.ARR.FIELD.NAME        =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.NAME>)
        Y.ARR.FIELD.POS         =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.POS.LAYOUT>)
        Y.ARR.FIELD.MAN         =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.MANDATORY>)
        Y.ARR.FIELD.RTN.VAL     =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.RTN.VAL>)          ;* SE PUEDE REALIZAR SUB VALOR EN CASO DE QUE SE NECESITEN EJECUTAR MAS DE UNA RUTINA POR CAMPO
        Y.ARR.FIELD.RTN.CONV    =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.RTN.CONV>)
        Y.ARR.FIELD.LENGTH      =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.LENGHT>)
        Y.ARR.TIPO.LINEA        =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.TIPO.LINEA>)
        Y.ARR.TABLA.APLICA      =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.T24.TABLE>)
        Y.ARR.CAMPOS.APLICA     =       RAISE(R.ABC.UPLOAD.FILE.PARAM<AUFP.FIELD.T24.OFS.NAME>)
        GOSUB PROCESA.ARCHIVOS
    END ELSE
        Y.MENSAJE<-1>= 'NO EXISTE EL REGISTRO ':Y.ID.ABC.UPLOAD.FILE.PARAM:" EN TABLA ABC.UPLOAD.FILE.PARAM"
    END

RETURN

*=============================================================================
* Leemos el archivo de entrada basandonos en el path y nombre que esta registrado en la tabla de parametros
*=============================================================================
PROCESA.ARCHIVOS:


    DISPLAY 'ACCEDIO A PROCESA.ARCHIVOS:'

    Y.SEL.FILES=''
    Y.LIST.FILES=''
    Y.NO.FILES=''
    Y.SEL.ERR=''

*   - Remplazar Fecha por Today
    Y.FILE.NAME  = Y.FILE.MASK
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'AAAA',Y.YEAR)
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'aaaa',Y.YEAR)
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'MM',Y.MONTH)
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'mm',Y.MONTH)
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'DD',Y.DAY)
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'dd',Y.DAY)
*    Remplazar los guiones por guienes bajos
    Y.FILE.NAME  = EREPLACE(Y.FILE.NAME,'-','-')

    Y.FILE.NAME.OUT  = Y.FILE.MASK.OUT
    Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'AAAA',Y.YEAR)
*   Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'aaaa',Y.YEAR)
    Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'MM',Y.MONTH)
*   Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'mm',Y.MONTH)
    Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'DD',Y.DAY)
*   Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'dd',Y.DAY)
    Y.HORA.ACTUAL.VAL = TIMEDATE()
    Y.HORA    = Y.HORA.ACTUAL.VAL[1,2]
    Y.MINUTO  = Y.HORA.ACTUAL.VAL[4,2]
    Y.SEGUNDO = Y.HORA.ACTUAL.VAL[7,2]
    Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'hh',Y.HORA)
    Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'mm',Y.MINUTO)
    Y.FILE.NAME.OUT  = EREPLACE(Y.FILE.NAME.OUT,'ss',Y.SEGUNDO)

*   - Seleccionamos del path parametrizado todos los archivos que cumplan con el criterio de nombre establecido
    Y.SEL.FILES = "SSELECT " : Y.FILE.PATH : " LIKE " :  Y.FILE.NAME :"...":Y.FILE.EXT
    DISPLAY Y.SEL.FILES
    EB.DataAccess.Readlist(Y.SEL.FILES,Y.LIST.FILES,'',Y.NO.FILES,Y.SEL.ERR)
    DISPLAY Y.LIST.FILES

    IF Y.NO.FILES GT 0 THEN
        DISPLAY "Total de Archivos a Leer: " : Y.NO.FILES
        FOR LOOP.FILES = 1 TO Y.NO.FILES
            Y.FILE.TO.READ  =       Y.LIST.FILES<LOOP.FILES>

            Y.NUM.OF.LINE                      =       0
            Y.NUM.OF.LINE.LEE                  =       0
            ARCHIVO.LINEA                      =       0
            Y.FILE.NAME.NO.EXT                 = Y.FILE.TO.READ
            Y.FILE.NAME.NO.EXT                 =  EREPLACE(Y.FILE.NAME.NO.EXT,Y.FILE.EXT,"")
            Y.ABC.UPLOAD.FILE.CONCAT.ID = Y.FILE.NAME.NO.EXT

            R.ABC.UPLOAD.FILE.CONCAT = ""
            EB.DataAccess.FRead(FN.ABC.UPLOAD.FILE.CONCAT,Y.ABC.UPLOAD.FILE.CONCAT.ID,R.ABC.UPLOAD.FILE.CONCAT,F.ABC.UPLOAD.FILE.CONCAT,Y.AVFC)

*           -Solo en caso de no existir el archivo se continua
            IF R.ABC.UPLOAD.FILE.CONCAT EQ '' THEN
                GOSUB READ.FILE
*            -Actualiza o graba EN TABLA ABC.UPLOAD.FILE.CONCAT
                Y.VALOR.OK.CONCAT = R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileConcat.LoadOk>
                IF Y.VALOR.OK.CONCAT EQ '' THEN
                    R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileConcat.LoadOk> = 'SI'
                END
                WRITE R.ABC.UPLOAD.FILE.CONCAT TO F.ABC.UPLOAD.FILE.CONCAT, Y.ABC.UPLOAD.FILE.CONCAT.ID
                Y.ARCHIVO.PROCESADO += 1
            END ELSE

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


*   - Apertura de Archivo
    OPENSEQ Y.FILE.PATH:"/" :Y.FILE.TO.READ TO FILE.RECORD THEN
        LOOP
            Y.MESSAGE.LOG       =       ""
            Y.MESSAGE.LOG.ERR   =       ""

*           - Lectura de Cada Linea
            READSEQ Y.LINE FROM FILE.RECORD ELSE  RETURN
            Y.NUM.OF.LINE  =       Y.NUM.OF.LINE+1
            YARR.CADENA.CAMPOS.OFS = ''
            YARR.CAMPOS.VALIDAR.OFS= ''

*    - El ID de TABLA ABC.COMISIONISTA.FILE.DETAIL se conforma de el archivo  mas el numero de Linea
            R.ABC.UPLOAD.FILE.DETAIL = ""
            Y.ABC.UPLOAD.FILE.DETAIL.ID = Y.FILE.NAME.NO.EXT:"-":Y.NUM.OF.LINE
            EB.DataAccess.FRead(FN.ABC.UPLOAD.FILE.DETAIL,Y.ABC.UPLOAD.FILE.DETAIL.ID,R.ABC.UPLOAD.FILE.DETAIL,F.ABC.UPLOAD.FILE.DETAIL,Y.ERR.DETAIL)
*               - Convertir Linea de separador parametrizado a FM

            Y.ARR.LINE  =  UTF8(Y.LINE)

            IF Y.ARR.LINE NE '' THEN
                Y.NUM.OF.LINE.LEE  += 1
                CONVERT Y.FILE.SEP TO @FM IN Y.ARR.LINE
                Y.TOTAL.SEPARADORES.LINEA = DCOUNT(Y.ARR.LINE,@FM)
                Y.TOTAL.SEPARADORES.PARAM = DCOUNT(Y.ARR.FIELD.POS,@FM)

*               - Al inicio de cada lectura se guarda el archiov y linea que se LEE
                Y.MSG = Y.FILE.TO.READ : "," : "Line:":Y.NUM.OF.LINE
                Y.MESSAGE.LOG<-1> =Y.MSG

                IF Y.NUM.OF.LINE.LEE EQ Y.LINEA.INICIA.CARGA THEN
                    Y.TIPO.LINEA = "E"
                    Y.CAMPOS.LEER.PARAM = Y.TOTAL.SEPARADORES.LINEA
                END ELSE
                    Y.TIPO.LINEA = "D"
                    Y.CAMPOS.LEER.PARAM = Y.TOTAL.SEPARADORES.LINEA
                END

                Y.CONTADOR.SEPARADORES.LINEA = 0
*               Se inicia con la lectura de cada campo(separador) de cada Linea hasta el numero parametrizado
                FOR Y.LOOP.FIELDS   =       1 TO Y.TOTAL.SEPARADORES.PARAM
*                   -Datos que se guardan por cada Campo
                    Y.CADENA.ERRORES.CAMPO = ''
                    YARR.CAMPOS.VALIDAR.OFS= ''
*                   - Se extraen parametros para la lectura
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

*                   -lEE la posicion del archivo que se encuentra mapeada
                        Y.VALOR.CAMPO.ORG  = TRIM(Y.ARR.LINE<Y.POS.TO.MAP>)
                        Y.VALOR.CAMPO      = Y.VALOR.CAMPO.ORG

*                   - Convertir el Valor del archivo algun dato valido para T24 en caso de haber parametrizado una rutina
*                     solo un parametro de entrada y el mismo de respuesta
                        IF Y.NOM.RUTINA.CONV NE '' THEN
                            IF Y.NOM.RUTINA.CONV[1,1] EQ "@" OR Y.NOM.RUTINA.CONV[1,1] EQ '"' THEN
                                Y.TIPO.CONVERSION = Y.NOM.RUTINA.CONV[1,1]
                                Y.VALUE.CONVERSION=FIELD(Y.NOM.RUTINA.CONV,"@",2)
                            END ELSE
                                Y.TIPO.CONVERSION = FIELD(Y.NOM.RUTINA.CONV,'-',1)
                                Y.VALUE.CONVERSION= FIELD(Y.NOM.RUTINA.CONV,'-',2)
                            END
                            BEGIN CASE
                                CASE Y.TIPO.CONVERSION = "@"
                                    CALL @Y.VALUE.CONVERSION(Y.VALOR.CAMPO)
                                CASE Y.TIPO.CONVERSION = "MAPEA"
                                    Y.VALUE.MAPPED = ''
                                    Y.ERROR        = ''
                                    CALL ABC.GET.MAPPED.VALUE(Y.VALUE.CONVERSION, Y.VALOR.CAMPO, Y.VALUE.MAPPED, Y.ERROR)
                                    Y.VALOR.CAMPO = Y.VALUE.MAPPED
                                    IF Y.ERROR THEN
                                        Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : Y.ERROR
                                        INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                        Y.MESSAGE.LOG<-1> =Y.MSG
                                        Y.MESSAGE.LOG.ERR = "SI"
                                    END
                                CASE Y.TIPO.CONVERSION = '"'
                                    Y.VALOR.CAMPO = CHANGE(Y.NOM.RUTINA.CONV, '"', '')

                            END CASE

                        END

*                   - Validacion de OBLIGATORIO
                        IF Y.VALOR.CAMPO EQ "" AND Y.MANDATORY.Y.N EQ "Y" THEN
                            Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : "Obligatorio"
                            INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                            Y.MESSAGE.LOG<-1> =Y.MSG
                            Y.MESSAGE.LOG.ERR = "SI"
                        END ELSE

*                       - Validacion de LONGITUD mayor a la paramtrizada
                            IF LEN(Y.VALOR.CAMPO) GT Y.FIELD.LENGTH THEN
                                Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : "Demasiados caracteres"
                                INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                Y.MESSAGE.LOG<-1> =Y.MSG
                                Y.MESSAGE.LOG.ERR = "SI"
                            END
                        END

*                   - Validacion por medio de una FUNCION donde se revisa caracteristicas que pueda aceptar el Campo en base a
*                     la aplicacion en donde se aplicara el OFS
                        Y.TOT.TABLAS.APLICA = DCOUNT(Y.ARR.TABLA.APLICA<Y.LOOP.FIELDS>,@SM)
                        FOR I.SM = 1 TO Y.TOT.TABLAS.APLICA
                            Y.ID.APLICACION   = FIELD(Y.ARR.TABLA.APLICA<Y.LOOP.FIELDS>,@SM,I.SM)
                            Y.NOMBRE.CAMPO.SS = FIELD(Y.ARR.CAMPOS.APLICA<Y.LOOP.FIELDS>,@SM,I.SM)
                            Y.MENSAJE.ERROR   = ''

                            YARR.CAMPOS.VALIDAR.OFS<-1> = Y.ID.APLICACION :@VM:Y.NOMBRE.CAMPO.SS :@VM:Y.VALOR.CAMPO
*                    - En caso de NO existir datos en el archivo no se valida nada
                            IF Y.VALOR.CAMPO EQ "" OR Y.VALOR.CAMPO EQ 0 THEN
                            END ELSE
                                Y.MENSAJE.ERROR =  ABC.VALIDAR.DATOS.SS(Y.ID.APLICACION,Y.NOMBRE.CAMPO.SS,Y.NOM.CAMPO.TO.MAP,Y.VALOR.CAMPO,Y.MENSAJE.ERROR)
                                IF Y.MENSAJE.ERROR NE '' THEN
                                    INS Y.MENSAJE.ERROR BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                    Y.MESSAGE.LOG<-1> =Y.MENSAJE.ERROR
                                    Y.MESSAGE.LOG.ERR = "SI"
                                END
                            END
                        NEXT I.SM

*      - Validacion por medio de Rutinas ligadas en tabla ABC.UPLOAD.FILE.PARAM
                        IF Y.NAME.RUTINA.VAL NE "" THEN
*                          CONVERT VM TO FM IN Y.NAME.RUTINA.VAL
                            CONVERT @SM TO @FM IN Y.NAME.RUTINA.VAL
                            Y.TOTAL.RTN.VAL = DCOUNT(Y.NAME.RUTINA.VAL,@FM)
                            Y.ARR.MSJ.CAMPO = ''
                            FOR I.RTN = 1 TO Y.TOTAL.RTN.VAL
                                Y.ACT.RTN.VAL = Y.NAME.RUTINA.VAL<I.RTN>
                                Y.MENSAJE.ERROR = ''

                                CALL @Y.ACT.RTN.VAL(YARR.CADENA.CAMPOS.OFS,YARR.CAMPOS.VALIDAR.OFS,Y.MENSAJE.ERROR)
                                IF Y.MENSAJE.ERROR NE '' THEN
                                    Y.ARR.MSJ.CAMPO := Y.MENSAJE.ERROR :" ":
                                END
                            NEXT I.RTN
                            Y.MENSAJE.ERROR = Y.ARR.MSJ.CAMPO
                            IF Y.MENSAJE.ERROR NE '' THEN
                                INS Y.MENSAJE.ERROR BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                                Y.MESSAGE.LOG<-1> = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," :Y.MENSAJE.ERROR
                                Y.MESSAGE.LOG.ERR = "SI"
                            END
                        END

*                   - Se busca que no existan comas (,) debido a que implicarian errores en el OFS
                        FIND "," IN Y.VALOR.CAMPO SETTING APVALOR, AVVALOR, SPVALOR THEN
                            Y.MSG = ",Campo:" : Y.NOM.CAMPO.TO.MAP : "," : "Invalido, Contiene comas(,)"
                            INS Y.MSG BEFORE Y.CADENA.ERRORES.CAMPO<-1>
                            Y.MESSAGE.LOG<-1> =Y.MSG
                            Y.MESSAGE.LOG.ERR = "SI"
                        END

                        CONVERT @FM TO "," IN Y.CADENA.ERRORES.CAMPO
                        IF Y.TIPO.LINEA EQ "D" THEN
                            R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.NombreCampo,Y.CONTADOR.SEPARADORES.LINEA>     = Y.NOM.CAMPO.TO.MAP
                            R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.ValorCampo,Y.CONTADOR.SEPARADORES.LINEA>      = Y.VALOR.CAMPO.ORG
                            R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.ValorValidacion,Y.CONTADOR.SEPARADORES.LINEA> = Y.CADENA.ERRORES.CAMPO
                        END ELSE
                            R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileConcat.NombreCampo,Y.CONTADOR.SEPARADORES.LINEA>     = Y.NOM.CAMPO.TO.MAP
                            R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileConcat.ValorCampo,Y.CONTADOR.SEPARADORES.LINEA>      = Y.VALOR.CAMPO.ORG
                            R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileConcat.ValorValidacion,Y.CONTADOR.SEPARADORES.LINEA> = Y.CADENA.ERRORES.CAMPO
                        END
                        YARR.CADENA.CAMPOS.OFS<-1> = YARR.CAMPOS.VALIDAR.OFS
                    END
                NEXT Y.LOOP.FIELDS


                IF Y.MESSAGE.LOG.ERR THEN
                    Y.MESSAGE.LOG.ERR =Y.MESSAGE.LOG
                    CONVERT @FM TO @VM IN Y.MESSAGE.LOG.ERR
                    IF Y.TIPO.LINEA EQ "D" THEN
                        R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.LoadOk> = "NO"
                    END ELSE
                        R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileDetail.LoadOk> = "NO"
                    END
                    ARR.LOG.VALIDACION <-1>= Y.MESSAGE.LOG
                END ELSE
                    IF Y.TIPO.LINEA EQ "D" THEN
                        R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.LoadOk> = "SI"
                    END ELSE
                        R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileDetail.LoadOk> = "SI"
                    END
                    ARR.LOG.VALIDACION<-1>=Y.MESSAGE.LOG
                    ARR.LOG.VALIDACION<-1>= "OK"
                END

                ARR.LOG.VALIDACION<-1>= " "

                IF Y.TIPO.LINEA EQ "D" THEN

                    ARCHIVO.LINEA = ARCHIVO.LINEA + 1
                    R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.IdParam>    = Y.ID.ABC.UPLOAD.FILE.PARAM
                    R.ABC.UPLOAD.FILE.DETAIL<AbcTable.AbcUploadFileDetail.IdConcat>   = Y.ABC.UPLOAD.FILE.CONCAT.ID

                    Y.RESP.OFS = ''
                    IF Y.MESSAGE.LOG.ERR EQ '' THEN

                        Y.RESP.OFS = ''
                        ARR.RESP.OFS.APLICA<-1> = "Procesando Archivo - Linea  :  ":Y.ABC.UPLOAD.FILE.DETAIL.ID
                        ARR.RESP.OFS.APLICA.FILE<-1> = "Procesando Archivo - Linea  :  ":Y.ABC.UPLOAD.FILE.DETAIL.ID
                        CALL ABC.GRAL.APLICA.OFS(R.ABC.UPLOAD.FILE.DETAIL,Y.RESP.OFS)
                        ARR.RESP.OFS.APLICA.FILE<-1> = Y.RESP.OFS
                        ARR.RESP.OFS.APLICA<-1> =Y.RESP.OFS
                    END
*               - Escribe el registro en la tabla ABC.UPLOAD.FILE.DETAIL ( un registro equivale a una linea)

                    WRITE R.ABC.UPLOAD.FILE.DETAIL TO F.ABC.UPLOAD.FILE.DETAIL, Y.ABC.UPLOAD.FILE.DETAIL.ID

*               - Valida que el arreglo de CONCAT no contenga aun la Linea que se lee

                    LOCATE Y.ABC.UPLOAD.FILE.DETAIL.ID IN R.ABC.UPLOAD.FILE.CONCAT SETTING Y.POS.CONCAT THEN
                    END ELSE
                        R.ABC.UPLOAD.FILE.CONCAT<AbcTable.AbcUploadFileConcat.ArchivoLinea,ARCHIVO.LINEA> = Y.ABC.UPLOAD.FILE.DETAIL.ID
                    END
                END
            END
            Y.LINE = ''
        REPEAT

    END
RETURN


*=============================================================================
*Proseso de escritura de archivo LOG
*=============================================================================
FINALIZA:

*   Escribe un LOG de Carga
    OPEN Y.FILE.PATH.OUT TO F.RUTA.ARCHIVO ELSE Y.RESPUESTA.ESCRIBE = "ERROR AL ESCRIBIR"
    WRITE ARR.RESP.OFS.APLICA.FILE TO F.RUTA.ARCHIVO,Y.FILE.NAME.OUT
RETURN
END
