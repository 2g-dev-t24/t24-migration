* @ValidationCode : MjotMjEzNTMzOTQ2NDpDcDEyNTI6MTc0NDgzNjQ2Mzg1MzptYXV1YjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 17:47:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.E.SEL.COL.EMPLEO(ENQ.PARAM)

    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer

    Y.COD.POST = ""
    
    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'EMP.COD.POS'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)

    Y.POS.DIR.COD.POS.ANT = V.FLD.POS<1,1>
    Y.DIR.COD.POS.ANT = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS.DIR.COD.POS.ANT>

    Y.COD.POST = Y.DIR.COD.POS.ANT

    ENQ.PARAM<2,1> = "CODIGO.POSTAL"
    ENQ.PARAM<3,1> = "EQ"
    ENQ.PARAM<4,1,1> = Y.COD.POST

RETURN
END
