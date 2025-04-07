* @ValidationCode : MjotMTMzNTE1MTU2MzpDcDEyNTI6MTc0NDA1ODI0MzM2MDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2025 17:37:23
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
SUBROUTINE ABC.COMISIONISTAS.OBT.CLIENTE(YI.DETAIL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable


    GOSUB INITIALIZE          ;*
    GOSUB PROCESS   ;*
    GOSUB FINALIZE  ;*

*-------------------------------------------------------------------------------
*** <region name= INITIALIZE>
INITIALIZE:
***

    FN.ABC.COMISIONISTAS.FILE.DETAIL= "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.COMISIONISTAS.FILE.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

    FN.ABC.COMISIONISTAS.RELACION= "F.ABC.COMISIONISTAS.RELACION"
    F.ABC.COMISIONISTAS.RELACION = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.RELACION,F.ABC.COMISIONISTAS.RELACION)

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

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.RELACION,Y.REL.ID,REC.RELACION,F.ABC.COMISIONISTAS.RELACION,ERR.DET)

    Y.VEC.ID = FIELD(Y.REL.ID,"-",1)

*    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.VEC.ID,REC.REGISTRO,F.ABC.REGISTRO.COMISIONISTAS,ERR.D)
    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.REL.ID,REC.REGISTRO,F.ABC.REGISTRO.COMISIONISTAS,ERR.D)

    Y.CLIENTE = REC.REGISTRO<AbcTable.AbcRegistroComisionistas.NoCliente>

    YI.DETAIL = Y.CLIENTE
RETURN

*-----------------------------------------------------------------------------
*** <region name= FINALIZE>
FINALIZE:
***
RETURN
END
