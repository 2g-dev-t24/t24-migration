* @ValidationCode : MjotMTE4NDM2Nzk5MzpDcDEyNTI6MTc0Njc1NDY0MDQzNjpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 May 2025 22:37:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
* Version 3 02/06/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.CUS.POST.CODE.LOCALIDAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.SystemTables
    $USING AbcTable
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
******************
INITIALIZE:
******************
    Y.PAIS = "484"
    Y.POST.CODE.CUS = ''

    FN.ABC.LOCALIDADES = "F.ABC.LOCALIDADES"
    F.ABC.LOCALIDADES = ""
    EB.DataAccess.Opf(FN.ABC.LOCALIDADES,F.ABC.LOCALIDADES)
    
    FN.ABC.CODIGO.POSTAL = "F.ABC.CODIGO.POSTAL"
    F.ABC.CODIGO.POSTAL = ""
    EB.DataAccess.Opf(FN.ABC.CODIGO.POSTAL,F.ABC.CODIGO.POSTAL)

    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'L.LOCALIDAD'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)

    Y.POS.LOC = V.FLD.POS<1,1>

RETURN
******************
PROCESS:
******************
    Y.POST.CODE.CUS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusPostCode)
    
    IF (Y.POST.CODE.CUS EQ '') THEN
        RETURN
    END
    
    R.ABC.CODIGO.POSTAL = ''
    
    EB.DataAccess.FRead(FN.ABC.CODIGO.POSTAL, Y.POST.CODE.CUS, R.ABC.CODIGO.POSTAL, F.ABC.CODIGO.POSTAL, Y.ERR.READ)

    Y.MUNICIPIO = Y.PAIS
    Y.MUNICIPIO := R.ABC.CODIGO.POSTAL<AbcTable.AbcCodigoPostal.Municipio>
    
    IF (Y.MUNICIPIO EQ Y.PAIS) THEN
        RETURN
    END
    
    CMD.SEL.LOC = ""
    LIST.ID.LOC = ""
    NUM.REG.LOC = ""
    CMD.SEL.LOC = "SSELECT " : FN.ABC.LOCALIDADES : " WITH @ID LIKE " : DQUOTE(SQUOTE(Y.MUNICIPIO): "..." ) :" BY @ID"
    EB.DataAccess.Readlist(CMD.SEL.LOC,LIST.ID.LOC,"",NUM.REG.LOC,"")

    IF (LIST.ID.LOC) THEN
        Y.LOCALIDAD = LIST.ID.LOC<1>
        Y.LOCAL.REF.CUSTOMER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.LOCAL.REF.CUSTOMER<1,Y.POS.LOC> = Y.LOCALIDAD
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF.CUSTOMER)
    END
    
RETURN
END