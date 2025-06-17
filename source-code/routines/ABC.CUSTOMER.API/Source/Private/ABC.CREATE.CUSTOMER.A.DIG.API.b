* @ValidationCode : Mjo0ODkxMjM2NTA6Q3AxMjUyOjE3NDc4NjYxODc5MTk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 May 2025 19:23:07
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
$PACKAGE AbcCustomerApi

SUBROUTINE ABC.CREATE.CUSTOMER.A.DIG.API
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING EB.Interface
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Updates
    $USING MXBASE.CustomerRegulatory
    $USING EB.Foundation
    $USING EB.TransactionControl
    $USING EB.ErrorProcessing
    
    
    GOSUB CARGAR.LOCAL.FIELDS ; *obtiene los campos locales de CUSTOMER
    GOSUB MAP.CUSTOMER ; *Mapea los campos de CUSTOMER enviados en la request
    GOSUB MAP.MXBASE ; *Mapeo campos MXBASE
    GOSUB CREAR.OFS.CUSTOMER ; *Crea y ejecuta el OFS de CUSTOMER
    GOSUB CREAR.OFS.MXBASE ; *Crea y ejecuta el OFS de MXBASE


*-----------------------------------------------------------------------------
MAP.CUSTOMER:
*** <desc>Mapea los campos de CUSTOMER enviados en la request </desc>
*-----------------------------------------------------------------------------

    R.CUSTOMER = ''
    R.CUSTOMER<ST.Customer.Customer.EbCusShortName>             = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.shortName)
    R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>               = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.name1)
    R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>               = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.name2)
    R.CUSTOMER<ST.Customer.Customer.EbCusDateOfBirth>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.dateOfBirth)
    R.CUSTOMER<ST.Customer.Customer.EbCusDistrictName>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.lugNac)
    R.CUSTOMER<ST.Customer.Customer.EbCusGender>                = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.gender)
    R.CUSTOMER<ST.Customer.Customer.EbCusExternCusId>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.externCusId)
    R.CUSTOMER<ST.Customer.Customer.EbCusSmsOne>                = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.sms1)
    R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>              = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.email1)
    R.CUSTOMER<ST.Customer.Customer.EbCusStreet>                = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.street)
    R.CUSTOMER<ST.Customer.Customer.EbCusBuildingNumber>        = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.address11)
    R.CUSTOMER<ST.Customer.Customer.EbCusFlatNumber>            = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.address12)
    R.CUSTOMER<ST.Customer.Customer.EbCusPostCode>              = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.postCode)
    R.CUSTOMER<ST.Customer.Customer.EbCusSubDepartment>         = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.dirColonia)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalDocName>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.legaDocName)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalId>               = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.legalId)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalIssDate>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.legalIssDate)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalExpDate>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.legalExpDate)
    R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>                 = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.taxId)
    R.CUSTOMER<ST.Customer.Customer.EbCusOccupation>            = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.occupation)
    R.CUSTOMER<ST.Customer.Customer.EbCusOtherNationality>      = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.otherNationality)
    R.CUSTOMER<ST.Customer.Customer.EbCusNationality>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.nationality)
    R.CUSTOMER<ST.Customer.Customer.EbCusDistrictName>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.lugNac)

    R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>              = Y.LOCAL.REF

   

RETURN
*-----------------------------------------------------------------------------
CARGAR.LOCAL.FIELDS:
*** <desc>obtiene los campos locales de CUSTOMER </desc>
*-----------------------------------------------------------------------------

    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'L.DOM.FISC' : @VM : 'L.USO.CFDI' : @VM : 'L.CANAL'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)
    
    Y.POS.L.DOM.FISC        = V.FLD.POS<1,1>
    Y.POS.L.USO.CFDI        = V.FLD.POS<1,2>
    Y.POS.L.CANAL           = V.FLD.POS<1,3>
    

    Y.LOCAL.REF         = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    
    Y.LOCAL.REF<1,Y.POS.L.DOM.FISC>     = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.domFisc)
    Y.LOCAL.REF<1,Y.POS.L.USO.CFDI>     = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.usoCfdi)
    Y.LOCAL.REF<1,Y.POS.L.CANAL>        = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.canal)
  
    

RETURN

*-----------------------------------------------------------------------------
MAP.MXBASE:
*** <desc>Mapeo campos MXBASE </desc>
*-----------------------------------------------------------------------------
    R.MAP.MXBASE = ''
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.SatTaxRegime>     = 'SAT.TAX.REGIME*':EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.regFiscal)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity > = 'BANXICO.ECO.ACTIVITY*':EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.actividadEcono)
    

RETURN

*-----------------------------------------------------------------------------
CREAR.OFS.CUSTOMER:
*** <desc>Crea y ejecuta el OFS de CUSTOMER </desc>
*-----------------------------------------------------------------------------

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'CUSTOMER'
    Y.OFS.VERSION   = 'CUSTOMER,ABC.API.ALTA.DIGITAL.1.0.0'
    Y.ID            = ''
    Y.ID.CUSTOMER   = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    
    GOSUB OBTENER.ID.CUSTOMER ; *Genera un nuevo id de customer para poder  guardarlo en la tabla como resultado
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.CUSTOMER,Y.OFS.REQUEST)

    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.idCustomer, Y.ID.CUSTOMER)
    END
RETURN


*-----------------------------------------------------------------------------
CREAR.OFS.MXBASE:
*** <desc>Crea y ejecuta el OFS de MXBASE </desc>
*-----------------------------------------------------------------------------
    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'MXBASE.ADD.CUSTOMER.DETAILS'
    Y.OFS.VERSION   = 'MXBASE.ADD.CUSTOMER.DETAILS,ABC.API.ALTA.DIGITAL.1.0.0'
    Y.RECORD        = ''
    Y.NO.OF.AUTH    = 0
    Y.OFS.RECORD    = ''
    Y.GTSMODE       = ''
    Error           = ''
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.MAP.MXBASE,Y.OFS.REQUEST)
 
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)

    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN




*-----------------------------------------------------------------------------
OBTENER.ID.CUSTOMER:
*** <desc>Genera un nuevo id de customer para poder  guardarlo en la tabla como resultado </desc>
*-----------------------------------------------------------------------------


    Y.FULL.NAME     = EB.SystemTables.getFullFname()
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    Y.PGM           = EB.SystemTables.getPgmType()
    Y.ID.CONCATFILE = EB.SystemTables.getIdConcatfile()
    Y.SAVE.COMI     = EB.SystemTables.getComi()
    Y.APPLICATION   = EB.SystemTables.getApplication()
    
    EB.SystemTables.setFullFname('FBNK.CUSTOMER')
    EB.SystemTables.setVFunction('I')
    EB.SystemTables.setPgmType('.IDA')
    EB.SystemTables.setIdConcatfile('')
    EB.SystemTables.setComi('')
    EB.SystemTables.setApplication('CUSTOMER')
    
    EB.TransactionControl.GetNextId('','F')

    Y.ID.CUSTOMER        = EB.SystemTables.getComi()
    EB.SystemTables.setFullFname(Y.FULL.NAME)
    EB.SystemTables.setVFunction(Y.V.FUNCTION)
    EB.SystemTables.setPgmType(Y.PGM)
    EB.SystemTables.setIdConcatfile(Y.ID.CONCATFILE)
    EB.SystemTables.setComi(Y.SAVE.COMI)
    EB.SystemTables.setApplication(Y.APPLICATION)

RETURN
*** </region>

END

