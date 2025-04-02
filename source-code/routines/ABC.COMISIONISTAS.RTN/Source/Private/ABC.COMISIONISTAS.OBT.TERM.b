* @ValidationCode : MjozNDU0NTI0MDY6Q3AxMjUyOjE3NDM2MzE1OTk5MDQ6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Apr 2025 19:06:39
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
SUBROUTINE ABC.COMISIONISTAS.OBT.TERM(YI.DETAIL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.API
    $USING AbcComisionistasFileDetail
    $USING AbcRegistroComisionistas
    $USING AbcComisionistasRelacion
    $USING AA.PaymentSchedule


    GOSUB INICIA
    GOSUB PROCESA

*******
INICIA:

    Y.ID = ""
    Y.ID = YI.DETAIL

    FN.AA.DETAILS = "F.AA.ACCOUNT.DETAILS"
    F.AA.DETAILS = ""
    EB.DataAccess.Opf(FN.AA.DETAILS,F.AA.DETAILS)

    FN.ABC.DETAIL= "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.DETAIL,F.ABC.DETAIL)

    FN.ABC.REGISTRO = "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO,F.ABC.REGISTRO)

    FN.ABC.RELACION = "F.ABC.COMISIONISTAS.RELACION"
    F.ABC.RELACION = ""
    EB.DataAccess.Opf(FN.ABC.RELACION,F.ABC.RELACION)

RETURN
*******
 
*******
PROCESA:

    EB.DataAccess.FRead(FN.ABC.DETAIL,Y.ID,R.DETAIL,F.ABC.DETAIL,Y.ERR.F.DETAIL)
    Y.ID.RELACION = R.DETAIL<AbcComisionistasFileDetail.AbcComisionistasFileDetail.IdRelacion>

    EB.DataAccess.FRead(FN.ABC.RELACION,Y.ID.RELACION,R.RELACION,F.ABC.RELACION,Y.ERR.REL)
    Y.TOT.APLI = DCOUNT(R.RELACION<AbcComisionistasRelacion.AbcComisionistasRelacion.Aplicacion>,VM)
    FOR RE = 1 TO Y.TOT.APLI
        R.RELACION1 := FIELD (R.RELACION<AbcComisionistasRelacion.AbcComisionistasRelacion.Aplicacion,RE>,"_",1):VM
    NEXT RE

    FIND "AA.ARRANGEMENT.ACTIVITY" IN R.RELACION1 SETTING AP, VP, SP THEN
        Y.ID.T24 = R.RELACION<AbcComisionistasRelacion.AbcComisionistasRelacion.IdT24Ofs><1,VP>
    END

*---CRM SI NO TRAE INFORMACION --------------
    IF Y.ID.T24 EQ '' THEN
        YI.DETAIL = '0000'
    END ELSE
*--------------------------------------------
        EB.DataAccess.FRead(FN.AA.DETAILS,Y.ID.T24,R.DETAILS,F.AA.DETAILS,Y.ERR.AA)
        Y.VALUE.DATE = R.DETAILS<AA.PaymentSchedule.AccountDetails.AdValueDate>          ;*FECHA INICIO
        Y.MATURITY.DATE = R.DETAILS<AA.PaymentSchedule.AccountDetails.AdMaturityDate>    ;* FECHA DE VENCIMIENTO
        Y.NO.DIAS = "C"
        EB.API.Cdd('',Y.VALUE.DATE,Y.MATURITY.DATE,Y.NO.DIAS)
        YI.DETAIL = Y.NO.DIAS
    END


RETURN
*******
END

