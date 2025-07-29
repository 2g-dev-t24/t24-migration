* @ValidationCode : Mjo2Mjc3MjU2Mjg6Q3AxMjUyOjE3NTM4MDUxMTM2NjM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 29 Jul 2025 13:05:13
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
$PACKAGE ABC.BP
SUBROUTINE ABC.NOFILE.DAT.PER.CTE(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer
    $USING MXBASE.CustomerRegulatory

    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
    
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
    FN.CUSTOMER.HIS         = 'F.CUSTOMER$HIS'
    F.CUSTOMER.HIS          = ''
    
    EB.DataAccess.Opf(FN.CUSTOMER.HIS, F.CUSTOMER.HIS)

    FN.MXBASE.ADD.CUSTOMER.DETAILS = 'F.MXBASE.ADD.CUSTOMER.DETAILS'
    F.MXBASE.ADD.CUSTOMER.DETAILS = ''
    EB.DataAccess.Opf(FN.MXBASE.ADD.CUSTOMER.DETAILS, F.MXBASE.ADD.CUSTOMER.DETAILS)

    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'L.NOM.PER.MORAL'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)

    Y.L.NOM.PER.MORAL = V.FLD.POS<1,1>


    Y.ID.CUS = ''
    
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "ID" IN SEL.FIELDS SETTING ID.POS THEN
        Y.ID.CUS = SEL.VALUES<ID.POS>
    END

    R.DATA = ''
    Y.SEP = '|'
    ESPACIO = ' '

RETURN

*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------
    Y.SEL.CMD = "SELECT " : FN.CUSTOMER : " WITH @ID EQ ":Y.ID.CUS
    Y.REG.LIST = ''
    Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    
    EB.DataAccess.FRead(FN.CUSTOMER, Y.REG.LIST, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)
    

    IF NOT(R.CUSTOMER) THEN
        EB.DataAccess.FRead(FN.CUSTOMER.HIS, Y.REG.LIST, R.CUSTOMER, F.CUSTOMER.HIS, Y.ERR.CUS)
    END
*    EB.DataAccess.FRead(FN.MXBASE.ADD.CUSTOMER.DETAILS, Y.REG.LIST, R.MXBASE.ADD.CUSTOMER.DETAILS, F.MXBASE.ADD.CUSTOMER.DETAILS, Y.MXBASE.ADD.CUSTOMER.DETAILS)
    
    IF NOT(R.CUSTOMER) THEN
        R.MXBASE.ADD.CUSTOMER.DETAILS = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Read(Y.ID.CUS,Y.ERROR)

        Y.SECTOR          = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
        Y.ID              = Y.ID.CUS

        IF Y.SECTOR LE 2000 THEN
            Y.NAME.2          = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
        END
        IF Y.SECTOR GE 2001 AND Y.SECTOR LE 20214 THEN
        
            Y.NAME.2 = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.L.NOM.PER.MORAL>
        END
    
        IF Y.SECTOR LT 2001 THEN
            Y.APE.PATERNO     =  R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
        END

        IF Y.SECTOR LT 2001 THEN
            Y.NAME.1         = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
        END
    
        Y.TAX.ID          = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>
        Y.LEGAL.DOC.NAME  = R.CUSTOMER<ST.Customer.Customer.EbCusLegalDocName>
        Y.LEGAL.ID        = R.CUSTOMER<ST.Customer.Customer.EbCusLegalId>
        Y.LEGAL.ISS.DATE  = R.CUSTOMER<ST.Customer.Customer.EbCusLegalIssDate>
        Y.LEGAL.EXP.DATE  = R.CUSTOMER<ST.Customer.Customer.EbCusLegalExpDate>

        Y.ACTIVIDAD.ECONO = R.MXBASE.ADD.CUSTOMER.DETAILS<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity>

        Y.ACTIVIDAD.ECONO = FIELD(Y.ACTIVIDAD.ECONO,"*",2)
        Y.OCCUPATION      = R.CUSTOMER<ST.Customer.Customer.EbCusOccupation>
        Y.NATIONALITY     = R.CUSTOMER<ST.Customer.Customer.EbCusNationality>
        Y.DATE.OF.BIRTH   = R.CUSTOMER<ST.Customer.Customer.EbCusDateOfBirth>
        Y.COUNTRY         = R.CUSTOMER<ST.Customer.Customer.EbCusCountry>
        Y.DISTRICT.NAME   = R.CUSTOMER<ST.Customer.Customer.EbCusDistrictName>
        Y.DEPARTMENT      = R.CUSTOMER<ST.Customer.Customer.EbCusSubDepartment>
        Y.STREET          = R.CUSTOMER<ST.Customer.Customer.EbCusStreet>
        Y.ADDRESS         = R.CUSTOMER<ST.Customer.Customer.EbCusAddress>
        Y.DIRECCION       =  Y.STREET : ESPACIO : Y.ADDRESS
        Y.RESIDENCE       = R.CUSTOMER<ST.Customer.Customer.EbCusResidence>
        Y.BUILDING.NUMBER = R.CUSTOMER<ST.Customer.Customer.EbCusBuildingNumber>
        Y.FLAT.NUMBER     = R.CUSTOMER<ST.Customer.Customer.EbCusFlatNumber>
        Y.DIR.COD.POS     = R.CUSTOMER<ST.Customer.Customer.EbCusPostCode>
        Y.TEL.CEL         = R.CUSTOMER<ST.Customer.Customer.EbCusSmsOne>
        Y.GENDER          = R.CUSTOMER<ST.Customer.Customer.EbCusGender>
        Y.EMAIL           = R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>

        GOSUB ARMA.ARREGLO
    END

RETURN


*---------------------------------------------------------------
ARMA.ARREGLO:
*---------------------------------------------------------------
   

*    R.DATA  = Y.SECTOR          : Y.SEP
    R.DATA = Y.ID              : Y.SEP
    R.DATA := Y.NAME.2          : Y.SEP
    R.DATA := Y.APE.PATERNO     : Y.SEP
    R.DATA := Y.NAME.1          : Y.SEP
    R.DATA := Y.TAX.ID          : Y.SEP
    R.DATA := Y.LEGAL.DOC.NAME  : Y.SEP
    R.DATA := Y.LEGAL.ID        : Y.SEP
    R.DATA := Y.LEGAL.ISS.DATE  : Y.SEP
    R.DATA := Y.LEGAL.EXP.DATE  : Y.SEP
    R.DATA := Y.ACTIVIDAD.ECONO : Y.SEP
    R.DATA := Y.OCCUPATION      : Y.SEP
    R.DATA := Y.NATIONALITY     : Y.SEP
    R.DATA := Y.DATE.OF.BIRTH   : Y.SEP
    R.DATA := Y.COUNTRY         : Y.SEP
    R.DATA := Y.DISTRICT.NAME   : Y.SEP
*    R.DATA := Y.DEPARTMENT     : Y.SEP
*    R.DATA := Y.STREET         : Y.SEP
    R.DATA := Y.DEPARTMENT      : Y.SEP
    R.DATA := Y.DIRECCION       : Y.SEP
    R.DATA := Y.RESIDENCE       : Y.SEP
    R.DATA := Y.BUILDING.NUMBER : Y.SEP
    R.DATA := Y.FLAT.NUMBER     : Y.SEP
    R.DATA := Y.DIR.COD.POS     : Y.SEP
    R.DATA := Y.TEL.CEL         : Y.SEP
    R.DATA := Y.GENDER          : Y.SEP
    R.DATA := Y.EMAIL           : Y.SEP

RETURN
*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END



