* @ValidationCode : MjotNzM0Njg5MDg4OkNwMTI1MjoxNzQ0ODM3MzAwNTUzOm1hdXViOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 18:01:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauub
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.NOF.GET.COLONIA(R.DATA)
***********************************************************
*       Rutina que trae el nombre de la Colonia a Partir del Cod. Pos.
***********************************************************
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING AbcTable
    $USING ABC.BP

    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

**********
INIT.VARS:
**********
    IN.NUM.CTA   = ''
    LIST.CTA     = ''
    IN.NUM.CTA   = ''
    IN.ID.FILTRO = ''
    Y.SEP        = "*"
RETURN

***********
OPEN.FILES:
***********
    FN.ABC.CODIGO.POSTAL = 'F.ABC.CODIGO.POSTAL'
    F.ABC.CODIGO.POSTAL = ''
    EB.DataAccess.Opf(FN.ABC.CODIGO.POSTAL, F.ABC.CODIGO.POSTAL)

    FN.ABC.COLONIA = 'F.ABC.COLONIA'
    F.ABC.COLONIA = ''
    EB.DataAccess.Opf(FN.ABC.COLONIA, F.ABC.COLONIA)

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()
RETURN

********
PROCESS:
********

    LOCATE "CODIGO.POSTAL" IN SEL.FIELDS SETTING CP.POS THEN
        Y.COD.POS = SEL.VALUES<CP.POS>
        Y.COD.POST = Y.COD.POS
    END

    R.DATA = ""
    Y.CADENA.SALIDA = ""

    EB.DataAccess.FRead(FN.ABC.CODIGO.POSTAL, Y.COD.POST, R.ADRESS, F.ABC.CODIGO.POSTAL, ERR.COD.POS)
    
    IF R.ADRESS NE "" THEN
        R.ID.COLONIA  = R.ADRESS<AbcTable.AbcCodigoPostal.Colonia>
        Y.CANT.COL = DCOUNT(R.ID.COLONIA,@VM)
        
        FOR I = 1 TO Y.CANT.COL
            Y.ID.COL = FIELD(R.ID.COLONIA, @VM, I)
            EB.DataAccess.FRead(FN.ABC.COLONIA, Y.ID.COL, R.COLONIA, F.ABC.COLONIA, ERR.COL.POS)
            Y.COL.DESC = R.COLONIA<AbcTable.AbcColonia.Colonia>
            Y.CADENA.SALIDA = Y.ID.COL : Y.SEP : Y.COL.DESC : Y.SEP
            R.DATA<-1> = Y.CADENA.SALIDA
        NEXT I
    END

RETURN

END
