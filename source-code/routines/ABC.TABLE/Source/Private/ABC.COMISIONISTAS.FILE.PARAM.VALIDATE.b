* @ValidationCode : MjoxMjQ4ODk2NzQ1OkNwMTI1MjoxNzQzNzg4NDE3MzYzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 14:40:17
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
$PACKAGE AbcTable
SUBROUTINE ABC.COMISIONISTAS.FILE.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Versions
    $USING EB.ErrorProcessing
    


    FN.VERSION = "F.VERSION"
    F.VERSION  = ""
    EB.DataAccess.Opf(FN.VERSION,F.VERSION)

*   Apertura de Tabla de SS para ver los campos validos
    FN.STANDARD.SELECTION = "F.STANDARD.SELECTION"
    F.STANDARD.SELECTION  = ""
    EB.DataAccess.Opf(FN.STANDARD.SELECTION,F.STANDARD.SELECTION)

*   -Validacion de Rutas

    Y.ARR.RUTA.VALIDAR = EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.FileInPath) : @FM : EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.FileOutPath)
    FOR I.RUTAS = 1 TO 2
        Y.RUTA.VALIDAR = Y.ARR.RUTA.VALIDAR<I.RUTAS>
        OPEN Y.RUTA.VALIDAR TO F.RUTA ELSE
            ETEXT = "Ruta Invalida"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()

        END
        Y.TOT.CHAR = LEN(Y.RUTA.VALIDAR)
        IF Y.RUTA.VALIDAR[Y.TOT.CHAR,1] = "/" THEN
            ETEXT = "Eliminar diagonal (/) Final"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            
        END
    NEXT I.RUTAS

*   -Validacion de aplicacionnes para OFS

    Y.ARR.VERSIONES.OFS = EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.OfsVersion)
    Y.TOT.VERSIONES.OFS = DCOUNT(Y.ARR.VERSIONES.OFS,@VM)
    FOR I.VERSION = 1 TO Y.TOT.VERSIONES.OFS

        Y.ID.APLICACION    = EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.OfsAplicacion)<1,I.VERSION>
        Y.ID.VERSION       = EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.OfsVersion)<1,I.VERSION>
        Y.VERSION.COMPLETA = Y.ID.APLICACION:",":Y.ID.VERSION
        ERR.VERSION.CARGA = ''
        EB.DataAccess.FRead(FN.VERSION,Y.VERSION.COMPLETA,R.VERSION.CARGA,F.VERSION,ERR.VERSION.CARGA)
        IF ERR.VERSION.CARGA THEN
            ETEXT = "Version INVALIDA"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    NEXT I.VERSION

    Y.ARR.CAMPO.OFS.NAME = EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.FieldT24OfsName)
    Y.TOT.CAMPO.OFS.NAME = DCOUNT(Y.ARR.CAMPO.OFS.NAME,@VM)
    FOR I.CAMPOS = 1 TO Y.TOT.CAMPO.OFS.NAME
        Y.ARR.SUB.CAMPOS    = FIELD(Y.ARR.CAMPO.OFS.NAME,@VM,I.CAMPOS)
        Y.ARR.SUB.CAMPOS    = FIELD(Y.ARR.SUB.CAMPOS,">",1)
        IF Y.ARR.SUB.CAMPOS NE '' THEN
            Y.TOT.SUB.CAMPOS = DCOUNT(Y.ARR.SUB.CAMPOS,@SM)
            FOR I.SUB = 1 TO Y.TOT.SUB.CAMPOS

                Y.APLICACION.OFS = EB.SystemTables.getRNew(AbcTable.AbcComisionistasFileParam.FieldT24Table)<1,I.CAMPOS,I.SUB>
                Y.CAMPO.OFS      = FIELD(EB.SystemTables.getRNew(AbcTable.AbcUploadFileParam.AufpFieldT24OfsName)<1,I.CAMPOS,I.SUB>,">",1)
                EB.DataAccess.FRead(FN.STANDARD.SELECTION,Y.APLICACION.OFS,R.STANDARD,F.STANDARD.SELECTION,ERR.STANDARD)

*               -Validar campos CORE de TABLA

                ARR.CAMPOS.APLICACION = R.STANDARD<EB.SystemTables.StandardSelection.SslSysFieldName>
                FIND Y.CAMPO.OFS IN ARR.CAMPOS.APLICACION SETTING APST, AVST, SPST THEN
                END ELSE

*                   - Validar campos LOCALES de TABLA
                    ARR.CAMPOS.APLICACION.LOC = R.STANDARD<EB.SystemTables.StandardSelection.SslUsrFieldName>
                    FIND Y.CAMPO.OFS IN ARR.CAMPOS.APLICACION.LOC SETTING APST, AVST, SPST THEN
                    END ELSE
                        ETEXT= "Campo  INVALIDO para TABLA"
                        EB.SystemTables.setEtext(ETEXT)
                        EB.ErrorProcessing.StoreEndError()
                    END
                END
            NEXT I.SUB
        END
    NEXT I.CAMPOS
RETURN
END

