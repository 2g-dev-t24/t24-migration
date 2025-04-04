* @ValidationCode : MjotMTMyNTEzNjEwMDpDcDEyNTI6MTc0MzczNzU3MDI4NzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:32:50
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
    $USING AbcTable
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
    Y.ID.RELACION = R.DETAIL<AbcTable.AbcComisionistasFileDetail.IdRelacion>

    EB.DataAccess.FRead(FN.ABC.RELACION,Y.ID.RELACION,R.RELACION,F.ABC.RELACION,Y.ERR.REL)
    Y.TOT.APLI = DCOUNT(R.RELACION<AbcTable.AbcComisionistasRelacion.Aplicacion>,VM)
    FOR RE = 1 TO Y.TOT.APLI
        R.RELACION1 := FIELD (R.RELACION<AbcTable.AbcComisionistasRelacion.Aplicacion,RE>,"_",1):VM
    NEXT RE

    FIND "AA.ARRANGEMENT.ACTIVITY" IN R.RELACION1 SETTING AP, VP, SP THEN
        Y.ID.T24 = R.RELACION<AbcTable.AbcComisionistasRelacion.IdT24Ofs><1,VP>
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

