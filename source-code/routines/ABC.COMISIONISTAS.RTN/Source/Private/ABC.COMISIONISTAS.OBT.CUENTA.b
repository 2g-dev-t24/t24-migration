* @ValidationCode : MjotMzgyMTA0NTc6Q3AxMjUyOjE3NDQwNTg0ODI5MTk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 07 Apr 2025 17:41:22
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
SUBROUTINE ABC.COMISIONISTAS.OBT.CUENTA(YI.DETAIL)
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
*    YI.DETAIL = "VEC_CTE_2015_11_05_16_46_46-2"
*DEBUG
    FN.ABC.COMISIONISTAS.FILE.DETAIL= "F.ABC.COMISIONISTAS.FILE.DETAIL"
    F.ABC.COMISIONISTAS.FILE.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.FILE.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL)

    FN.ABC.REGISTRO.COMISIONISTAS= "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO.COMISIONISTAS = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS,F.ABC.REGISTRO.COMISIONISTAS)

    Y.CUENTAS = ''

RETURN

*-------------------------------------------------------------------------------
*** <region name= PROCESS>
PROCESS:
***

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.FILE.DETAIL,YI.DETAIL,REC.DETAIL,F.ABC.COMISIONISTAS.FILE.DETAIL,ERR.DETAIL)

    Y.REL.ID = REC.DETAIL<AbcTable.AbcComisionistasFileDetail.IdRelacion>

    Y.VEC.ID = FIELD(Y.REL.ID,"-",1)
    Y.FECHA.V = FIELD(Y.REL.ID,"-",2)

*    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.VEC.ID,REC.REGISTRO,F.ABC.REGISTRO.COMISIONISTAS,ERR.D)
    EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.REL.ID,REC.REGISTRO,F.ABC.REGISTRO.COMISIONISTAS,ERR.D)

    Y.CUENTA = REC.REGISTRO<AbcTable.AbcRegistroComisionistas.NoCuenta>
    Y.FECHA = REC.REGISTRO<AbcTable.AbcRegistroComisionistas.FechaApeCta>

    CONVERT @VM TO @FM IN Y.CUENTA
    CONVERT @VM TO @FM IN Y.FECHA

    Y.NO = DCOUNT(Y.CUENTA, FM)
    FOR Y.NUM = 1 TO Y.NO
        Y.FECHA.CUENTA = FIELD(Y.FECHA,FM,Y.NUM)
        Y.FECHA.T = TRIM(Y.FECHA.CUENTA)
*---CRM SE COMENTA EL IF YA QUE SIEMPRE SE REQUIERE LA CUENTA -------------------
*       IF Y.FECHA.T EQ Y.FECHA.V THEN
        Y.CUENTA.F = FIELD(Y.CUENTA,FM,Y.NUM)
        Y.CUENTAS = TRIM(Y.CUENTA.F)
*       END
*--------------------------------------------------------------------------------
    NEXT Y.NUM
    YI.DETAIL = Y.CUENTAS

RETURN

*-----------------------------------------------------------------------------
*** <region name= FINALIZE>
FINALIZE:
***
RETURN
END

