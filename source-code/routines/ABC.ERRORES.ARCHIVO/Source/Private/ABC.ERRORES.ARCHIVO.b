* @ValidationCode : MjoyMDI1ODQ1MDQ1OkNwMTI1MjoxNzQzNzM3NjEyNDA0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:33:32
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
$PACKAGE AbcErroresArchivo
SUBROUTINE ABC.ERRORES.ARCHIVO(YI.DETAIL)

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

    
    FN.ABC.COMISIONISTAS.FILE.DETAIL= "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.COMISIONISTAS.FILE.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

    FN.ABC.REGISTRO.COMISIONISTAS = "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO.COMISIONISTAS  = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS,F.ABC.REGISTRO.COMISIONISTAS)

    FN.ABC.COMISIONISTAS.RELACION = "F.ABC.COMISIONISTAS.RELACION"    ;* MGS F&G 20190612
    F.ABC.COMISIONISTAS.RELACION  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION)

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,YI.DETAIL,REC.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAIL)

    FINDSTR 'CTE' IN YI.DETAIL SETTING App, Vpp THEN
        YI.DETAIL.DIR =YI.DETAIL
        YI.NUMERO.LINEA =TRIM(FIELD(YI.DETAIL.DIR,"-",2))
        YI.NUMERO.LINEA.DIR = YI.NUMERO.LINEA-1
        YI.DETAIL.DIR = TRIM(EREPLACE(YI.DETAIL.DIR, "CTE", "DIR"))
        YI.DETAIL.DIR = TRIM(EREPLACE(YI.DETAIL.DIR,"-":YI.NUMERO.LINEA , ""))
        YI.DETAIL.DIR =YI.DETAIL.DIR:"-":YI.NUMERO.LINEA.DIR
        Y.ID.RELACION = REC.DETAIL<AbcTable.AbcComisionistasFileDetail.IdRelacion>         ;*MGS F&G
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,YI.DETAIL.DIR,REC.DETAIL.DIR,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAIL.DIR)
    END

    Y.VALIDACIONES = REC.DETAIL<AbcTable.AbcComisionistasFileDetail.ValorValidacion>
    Y.ERRORES.OFS  = REC.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadErrors>
    Y.APLICO.CARGA = REC.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk>
    Y.VALIDACIONES.DIR = REC.DETAIL.DIR<AbcTable.AbcComisionistasFileDetail.ValorValidacion>
    Y.ERRORES.OFS.DIR  = REC.DETAIL.DIR<AbcTable.AbcComisionistasFileDetail.LoadErrors>
    Y.APLICO.CARGA.DIR = REC.DETAIL.DIR<AbcTable.AbcComisionistasFileDetail.LoadOk>
    YID.CLIENTE.VEC= REC.DETAIL<AbcTable.AbcComisionistasFileDetail.IdRelacion>
    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,YID.CLIENTE.VEC,REC.CLIENTE.VEC,F.ABC.REGISTRO.COMISIONISTAS,ERR.CLIENTE.VEC)
*    IF YI.DETAIL EQ "VEC_CTE_20190401_121558-13" THEN DEBUG
    Y.ID.COM.FILE.DET = YI.DETAIL
    IF Vpp EQ '' THEN
        GOSUB DATO.RETORNO
    END ELSE
        IF  Y.APLICO.CARGA EQ "SI" AND Y.APLICO.CARGA.DIR EQ "SI" THEN
            GOSUB DATO.RETORNO
        END ELSE
            GOSUB FORMAT.CADENA
            IF 'CLIENTE EXISTENTE' EQ Y.VALIDACIONES AND Y.VALIDACIONES.DIR NE '' THEN
                YI.DETAIL = TRIM(Y.VALIDACIONES : " " :Y.ERRORES.OFS)
            END ELSE
                YI.DETAIL = TRIM(Y.VALIDACIONES : " " :Y.ERRORES.OFS:" ":Y.VALIDACIONES.DIR:" ":Y.ERRORES.OFS.DIR)
            END
        END
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.RELACION,Y.ID.RELACION,REC.RELACION,F.ABC.COMISIONISTAS.RELACION,ERR.RELACION)
        Y.ESTATUS = REC.RELACION<AbcTable.AbcComisionistasRelacion.EstatusOfs,1>
        IF Y.ESTATUS EQ 'FALLIDO' THEN
            Y.RES.OFS = REC.RELACION<AbcTable.AbcComisionistasRelacion.RespuestaOfs>
            Y.RESP    = FIELD(Y.RES.OFS, '/',4)
            REC.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadOk> = 'NO'
            REC.DETAIL<AbcTable.AbcComisionistasFileDetail.LoadErrors> = Y.RESP
            WRITE REC.DETAIL TO F.ABC.COMISIONISTAS.FILE.DETAIL,Y.ID.COM.FILE.DET
            YI.DETAIL = Y.RESP
        END
    END
RETURN

DATO.RETORNO:
    IF Y.APLICO.CARGA EQ "SI" THEN
        Y.AUTORIZA.CTE = REC.CLIENTE.VEC<AbcTable.AbcRegistroComisionistas.AutorizacionCte>
        IF Y.AUTORIZA.CTE EQ 'NO' THEN
            YI.DETAIL  = "RECHAZADO POR PLD"
        END ELSE
            GOSUB FORMAT.CADENA
            IF 'CLIENTE EXISTENTE' EQ Y.VALIDACIONES AND Y.VALIDACIONES.DIR NE '' THEN
                YI.DETAIL = TRIM(Y.VALIDACIONES : " " :Y.ERRORES.OFS)
            END ELSE
                YI.DETAIL = TRIM(Y.VALIDACIONES : " " :Y.ERRORES.OFS:" ":Y.VALIDACIONES.DIR:" ":Y.ERRORES.OFS.DIR)
            END
        END
    END ELSE
        GOSUB FORMAT.CADENA

        Y.CTE = REC.CLIENTE.VEC<AbcTable.AbcRegistroComisionistas.NoCliente>

        IF Y.CTE NE '' THEN
            IF Y.AUTORIZA.CTE EQ 'NO' THEN
                YI.DETAIL = "RECHAZADO POR PLD"
            END ELSE
                Y.ERRORES.OFS = ''
                Y.VALIDACIONES = ''
                Y.ERRORES.OFS.DIR = ''
                Y.VALIDACIONES.DIR = ''
            END
        END ELSE
            GOSUB FORMAT.CADENA
        END
        IF 'CLIENTE EXISTENTE' EQ Y.VALIDACIONES AND Y.VALIDACIONES.DIR NE '' THEN
            YI.DETAIL = TRIM(Y.VALIDACIONES : " " :Y.ERRORES.OFS)
        END ELSE
            YI.DETAIL = TRIM(Y.VALIDACIONES : " " :Y.ERRORES.OFS:" ":Y.VALIDACIONES.DIR:" ":Y.ERRORES.OFS.DIR)
        END
    END
RETURN


FORMAT.CADENA:
*luis    CONVERT VM TO " " IN Y.VALIDACIONES
*luis    CONVERT VM TO " " IN Y.ERRORES.OFS
*luis    CONVERT VM TO " " IN Y.VALIDACIONES.DIR
*luis    CONVERT VM TO " " IN Y.ERRORES.OFS.DIR
    Y.ERRORES.OFS  = TRIM(Y.ERRORES.OFS)
    Y.VALIDACIONES = TRIM(Y.VALIDACIONES)
    Y.ERRORES.OFS.DIR  = TRIM(Y.ERRORES.OFS.DIR)
    Y.VALIDACIONES.DIR = TRIM(Y.VALIDACIONES.DIR)
RETURN

END
