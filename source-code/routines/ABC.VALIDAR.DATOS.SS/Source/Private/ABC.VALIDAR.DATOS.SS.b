* @ValidationCode : MjotNDI3NDgwOTI5OkNwMTI1MjoxNzQzNzg5ODE1NzQ4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 15:03:35
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
$PACKAGE AbcValidarDatosSs
SUBROUTINE ABC.VALIDAR.DATOS.SS(Y.ID.APLICACION,Y.NOMBRE.CAMPO.SS,Y.NOM.CAMPO.TO.MAP,Y.VALOR.CAMPO,Y.MENSAJE.ERROR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Versions
    $USING EB.ErrorProcessing
    $USING EB.API


    GOSUB APERTURA.TABLA
    GOSUB VALIDACIONES.DATO
RETURN

*=============
APERTURA.TABLA:
*=============

*   - Apertura de Tabla de SS para ver los campos validos
    FN.STANDARD.SELECTION = "F.STANDARD.SELECTION"
    F.STANDARD.SELECTION  = ""
    EB.DataAccess.Opf(FN.STANDARD.SELECTION,F.STANDARD.SELECTION)


    Y.MENSAJE.ERROR = ''
    Y.TABLA.LIGADA  = ''


RETURN

*================
VALIDACIONES.DATO:
*================
    Y.ARR.ID.APLICACIONES = Y.ID.APLICACION
    Y.ARR.NOMBRE.CAMPO.SS = Y.NOMBRE.CAMPO.SS
    Y.NOMBRE.ARCH         = Y.NOM.CAMPO.TO.MAP
    Y.TOT.APLICACIONES = DCOUNT(Y.ARR.ID.APLICACIONES,@VM)

    FOR I.SS = 1 TO Y.TOT.APLICACIONES
        Y.ID.APLICACION = FIELD(Y.ARR.ID.APLICACIONES,@VM,I.SS)
        Y.NOMBRE.CAMPO.SS = FIELD(Y.ARR.NOMBRE.CAMPO.SS,@VM,I.SS)

*   Lectura de la tabla de SS
        EB.DataAccess.FRead(FN.STANDARD.SELECTION,Y.ID.APLICACION,R.STANDARD,F.STANDARD.SELECTION,ERR.STANDARD)
        ARR.CAMPOS.APLICACION = R.STANDARD<EB.SystemTables.StandardSelection.SslSysFieldName>

        FIND Y.NOMBRE.CAMPO.SS IN ARR.CAMPOS.APLICACION SETTING APST, AVST, SPST THEN
            Y.TABLA.LIGADA  = R.STANDARD<EB.SystemTables.StandardSelection.SslSysRelFile><1,AVST>
            Y.TIPO.CAMPO.ST = R.STANDARD<EB.SystemTables.StandardSelection.SslSysValProg><1,AVST>
        END ELSE
            ARR.CAMPOS.APLICACION = R.STANDARD<EB.SystemTables.StandardSelection.SslUsrFieldName>
            FIND Y.NOMBRE.CAMPO.SS IN ARR.CAMPOS.APLICACION SETTING APST, AVST, SPST THEN
                Y.TABLA.LIGADA  = R.STANDARD<EB.SystemTables.StandardSelection.SslUsrRelFile><1,AVST>
                Y.TIPO.CAMPO.ST = R.STANDARD<EB.SystemTables.StandardSelection.SslUsrValProg><1,AVST>
            END
        END

        Y.TIPO.VALOR.CAMPO    = FIELD(Y.TIPO.CAMPO.ST,"&",1)
        Y.VALORES.VALIDOS     = FIELD(Y.TIPO.CAMPO.ST,"&",2)
        Y.APLICA.INPUT.CAMPO  = FIELD(Y.TIPO.CAMPO.ST,"&",3)

        IF Y.APLICA.INPUT.CAMPO EQ "NOINPUT" THEN
            Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Campo INHABILITADO"
        END ELSE
            IF Y.TABLA.LIGADA THEN
                FN.TABLA.LIGADA = "F.":Y.TABLA.LIGADA
                F.TABLA.LIGADA  = ""
                EB.DataAccess.Opf(FN.TABLA.LIGADA,F.TABLA.LIGADA)

                R.TABLA.LIGADA  = ''
                ERR.TABLA.LIGADA= ''
                EB.DataAccess.FRead(FN.TABLA.LIGADA,Y.VALOR.CAMPO,R.TABLA.LIGADA,F.TABLA.LIGADA,ERR.TABLA.LIGADA)
                IF ERR.TABLA.LIGADA THEN
                    Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Valor Invalido en Catalogo"
                END
            END ELSE
                Y.TIPO.VALOR.CAMPO = EREPLACE(Y.TIPO.VALOR.CAMPO,'IN2','')
                BEGIN CASE
                    CASE Y.TIPO.VALOR.CAMPO ="AAA" OR Y.TIPO.VALOR.CAMPO EQ "SSS"
                        IF NOT(ALPHA(Y.VALOR.CAMPO))  THEN
                            Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Valor Debe ser ALFABETICO"
                        END
                        IF Y.MENSAJE.ERROR EQ '' THEN
                            CONVERT "_" TO @VM IN Y.VALORES.VALIDOS
                            IF Y.VALORES.VALIDOS NE '' THEN
                                FIND Y.VALOR.CAMPO IN Y.VALORES.VALIDOS SETTING APVAL, AVVAL, SPVAL THEN
                                END ELSE
                                    Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Valor Invalido"
                                END
                            END
                        END
                    CASE Y.TIPO.VALOR.CAMPO ="D"
                        Y.TIPO.DIA = ''
                        Y.ANIO.DIA = Y.VALOR.CAMPO[1,4]
                        Y.REGION.VAL = "MX00":Y.ANIO.DIA

                        
                        EB.API.Awd(Y.REGION.VAL,Y.VALOR.CAMPO,Y.TIPO.DIA)
                        
                        IF Y.TIPO.DIA EQ '' THEN
                            Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Valor Debe ser Fecha Valida"
                        END
                    CASE Y.TIPO.VALOR.CAMPO ="" OR Y.TIPO.VALOR.CAMPO EQ "R" OR Y.TIPO.VALOR.CAMPO EQ "AMT"
                        Y.VALOR.NUMERICO = EREPLACE(Y.VALOR.CAMPO,".","")
                        IF NOT(NUM(Y.VALOR.NUMERICO)) THEN
*                        Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Valor Debe ser Numerico"
                        END
                    CASE 1
                        CONVERT "_" TO @VM IN Y.VALORES.VALIDOS
                        IF Y.VALORES.VALIDOS NE '' THEN
                            FIND Y.VALOR.CAMPO IN Y.VALORES.VALIDOS SETTING APVAL, AVVAL, SPVAL THEN
                            END ELSE
                                Y.MENSAJE.ERROR = "Campo :":Y.NOMBRE.ARCH:" Valor Invalido"
                            END
                        END
                END CASE
            END
        END
    NEXT I.SS
RETURN
END

