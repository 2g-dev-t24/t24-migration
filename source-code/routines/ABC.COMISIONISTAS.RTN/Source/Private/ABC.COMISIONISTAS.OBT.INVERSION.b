* @ValidationCode : MjoyMDgwNDM5NDUxOkNwMTI1MjoxNzQzNzgxNzgwMDAyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 12:49:40
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
SUBROUTINE ABC.COMISIONISTAS.OBT.INVERSION(YI.DETAIL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable


    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

*-------------------------------------------------------------------------------
*** <region name= INITIALIZE>
INITIALIZE:
***

    FN.ABC.COMISIONISTAS.FILE.DETAIL= "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.COMISIONISTAS.FILE.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

    FN.ABC.REGISTRO.COMISIONISTAS= "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO.COMISIONISTAS = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS,F.ABC.REGISTRO.COMISIONISTAS)
RETURN

*-------------------------------------------------------------------------------
*** <region name= PROCESS>
PROCESS:
***

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,YI.DETAIL,REC.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAIL)
    Y.REL.ID = REC.DETAIL<AbcTable.AbcComisionistasFileDetail.IdRelacion>

    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.REL.ID,REC.REGISTRO,F.ABC.REGISTRO.COMISIONISTAS,ERR.D)
    Y.NO.INV.CTA = REC.REGISTRO<AbcTable.AbcRegistroComisionistas.NoInvCta>
    Y.NOMBRE.ARCHIVO = REC.REGISTRO<AbcTable.AbcRegistroComisionistas.NombreArchivo>

    CONVERT @VM TO @FM IN Y.NO.INV.CTA
    CONVERT @VM TO @FM IN Y.NOMBRE.ARCHIVO

    FIND YI.DETAIL IN Y.NOMBRE.ARCHIVO SETTING AP, VP, SP THEN
        Y.INV.CTA = Y.NO.INV.CTA<AP>
    END
    YI.DETAIL = Y.INV.CTA

RETURN

*-----------------------------------------------------------------------------
*** <region name= FINALIZE>
FINALIZE:
***
RETURN
END
