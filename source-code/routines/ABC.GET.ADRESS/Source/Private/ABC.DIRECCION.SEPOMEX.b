* @ValidationCode : MjotMTkxMzI5NTM0MTpDcDEyNTI6MTc0NDY2Mzk0OTgwNDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Apr 2025 17:52:29
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
$PACKAGE AbcGetAdress
SUBROUTINE ABC.DIRECCION.SEPOMEX(Y.COD.POST,Y.CAD.SALIDA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING AbcTable
    $USING EB.DataAccess
    
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*********
OPEN.FILES:
***********
    Y.SEP = "|"

    FN.ABC.CODIGO.POSTAL = 'F.ABC.CODIGO.POSTAL'
    F.ABC.CODIGO.POSTAL = ''
    EB.DataAccess.Opf(FN.ABC.CODIGO.POSTAL, F.ABC.CODIGO.POSTAL)

    FN.ABC.CIUDAD = 'F.ABC.CIUDAD'
    F.ABC.CIUDAD = ''
    EB.DataAccess.Opf(FN.ABC.CIUDAD, F.ABC.CIUDAD)

RETURN

*********
PROCESS:
*********
    Y.COD.POST = FMT(Y.COD.POST,"5'0'R")
    EB.DataAccess.FRead(FN.ABC.CODIGO.POSTAL, Y.COD.POST, R.ADRESS, F.ABC.CODIGO.POSTAL, ERR.COD.POS)
    IF R.ADRESS EQ '' THEN
        Y.CAD.SALIDA = ""
    END ELSE
        Y.ID.EDO  = R.ADRESS<AbcTable.AbcCodigoPostal.Estado>
        IF Y.ID.EDO GT 0 AND Y.ID.EDO LE 32 THEN
            Y.ID.PAIS = "MX"
        END
        Y.ID.CD   = R.ADRESS<AbcTable.AbcCodigoPostal.Ciudad>

        EB.DataAccess.FRead(FN.ABC.CIUDAD, Y.ID.CD, R.CD, F.ABC.CIUDAD, ERR.CD.POS)
        Y.CD.DESC = R.CD<AbcTable.AbcCiudad.Ciudad>

        Y.ID.MPIO = R.ADRESS<AbcTable.AbcCodigoPostal.Municipio>
        Y.ID.COL  = R.ADRESS<AbcTable.AbcCodigoPostal.Colonia>

        Y.CANT.COL = DCOUNT(Y.ID.COL,@VM)
        IF Y.CANT.COL GT 1 THEN
            Y.ID.COL = ""
        END
        Y.CAD.SALIDA = Y.ID.EDO : Y.SEP : Y.ID.CD : "-" : Y.CD.DESC : Y.SEP : Y.ID.MPIO : Y.SEP : Y.ID.COL : Y.SEP : Y.ID.PAIS
    END
RETURN
END

