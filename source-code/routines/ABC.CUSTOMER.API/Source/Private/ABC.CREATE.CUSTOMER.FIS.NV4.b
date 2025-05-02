* @ValidationCode : MjotOTkwNjQ5ODk2OkNwMTI1MjoxNzQ2MjA5MDE2MDgxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2025 15:03:36
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
SUBROUTINE ABC.CREATE.CUSTOMER.FIS.NV4
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
    
    GOSUB CARGAR.LOCAL.FIELDS ; *obtiene los campos locales de CUSTOMER
    GOSUB MAP.CUSTOMER ; *Mapea los campos de CUSTOMER enviados en la request
    GOSUB MAP.MXBASE ; *Mapeo campos MXBASE
    GOSUB CREAR.OFS.CUSTOMER ; *Crea y ejecuta el OFS de CUSTOMER
    GOSUB CREAR.OFS.MXBASE ; *Crea y ejecuta el OFS de MXBASE
   
RETURN
*-----------------------------------------------------------------------------
MAP.CUSTOMER:
*** <desc>Mapea los campos de CUSTOMER enviados en la request </desc>
*-----------------------------------------------------------------------------

    R.CUSTOMER = ''
    R.CUSTOMER<ST.Customer.Customer.EbCusOtherNationality>      = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.OtherNationality)
    R.CUSTOMER<ST.Customer.Customer.EbCusNationality>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Nationality)
    R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>                 = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.TaxId)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalDocName>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.LegalDocName)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalId>               = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.LegalId)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalIssDate>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.LegalIssDate)
    R.CUSTOMER<ST.Customer.Customer.EbCusLegalExpDate>          = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.LegalExpDate)
    R.CUSTOMER<ST.Customer.Customer.EbCusAddressType>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.CompDom)
    R.CUSTOMER<ST.Customer.Customer.EbCusStreet>                = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Street)
    R.CUSTOMER<ST.Customer.Customer.EbCusBuildingNumber>        = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Address1)
    R.CUSTOMER<ST.Customer.Customer.EbCusFlatNumber>            = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Address2)
    R.CUSTOMER<ST.Customer.Customer.EbCusPostCode>              = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.PostCode)
    R.CUSTOMER<ST.Customer.Customer.EbCusSubDepartment>         = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.DirColonia)
    R.CUSTOMER<ST.Customer.Customer.EbCusTownCountry>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.TownCountry)
    R.CUSTOMER<ST.Customer.Customer.EbCusCountrySubdivision>    = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.DirCdEdo)
    R.CUSTOMER<ST.Customer.Customer.EbCusAddressCountry>        = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Country)
    R.CUSTOMER<ST.Customer.Customer.EbCusJobTitle>              = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Profesion)
    R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>              = Y.LOCAL.REF
    
*    R.CUSTOMER<ST.Customer.Acti> = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.ActividadEcono) ??????
RETURN


*-----------------------------------------------------------------------------
MAP.MXBASE:
*** <desc>Mapeo campos MXBASE </desc>
*-----------------------------------------------------------------------------
    R.MAP.MXBASE = ''
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.SourceRec>        = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.OrigenRecursos)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.AccountPurpose>   = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.DestinoRecurs)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Comments>         = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.PldFunPub)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.JobPosition>      = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.PuestoUltAnio)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.RelationClient>   = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.RelPersonaExp)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Others>           = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.NomPerPolExp)
    R.MAP.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.SatTaxRegimeCode> = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.RegFiscal)
*    R.MAP.MXBASE<MXBASE.CustomerRegulatory.> = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.OrigenRecursos)
    

RETURN



*-----------------------------------------------------------------------------
CARGAR.LOCAL.FIELDS:
*** <desc>obtiene los campos locales de CUSTOMER </desc>
*-----------------------------------------------------------------------------

    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'L.DOM.FISC' : @VM : 'L.USO.CFDI' : @VM : 'IUB' : @VM : 'L.LOCALIDAD' : @VM : 'L.CANAL'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)
    
    Y.POS.L.DOM.FISC    = V.FLD.POS<1,1>
    Y.POS.L.USO.CFDI    = V.FLD.POS<1,2>
    Y.POS.IUB           = V.FLD.POS<1,3>
    Y.POS.L.LOCALIDAD   = V.FLD.POS<1,4>
    Y.POS.L.CANAL       = V.FLD.POS<1,5>

    Y.LOCAL.REF         = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    
    Y.LOCAL.REF<1,Y.POS.L.DOM.FISC>  = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.DomFisc)
    Y.LOCAL.REF<1,Y.POS.L.USO.CFDI>  = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.UsoCfdi)
    Y.LOCAL.REF<1,Y.POS.IUB>         = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Iub)
    Y.LOCAL.REF<1,Y.POS.L.LOCALIDAD> = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Localidad)
    Y.LOCAL.REF<1,Y.POS.L.CANAL>     = EB.SystemTables.getRNew(AbcTable.AbcCustomerFisicaNv4Api.Canal)

RETURN

*-----------------------------------------------------------------------------
CREAR.OFS.CUSTOMER:
*** <desc>Crea y ejecuta el OFS de CUSTOMER </desc>
*-----------------------------------------------------------------------------

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'CUSTOMER'
    Y.OFS.VERSION   = 'CUSTOMER,ALTA.DIGITAL'
    Y.ID            = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    
    GOSUB OBTENER.ID.CUSTOMER ; *Genera un nuevo id de customer para poder  guardarlo en la tabla como resultado
    
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.CUSTOMER,Y.OFS.REQUEST)

    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)

RETURN


*-----------------------------------------------------------------------------
CREAR.OFS.MXBASE:
*** <desc>Crea y ejecuta el OFS de MXBASE </desc>
*-----------------------------------------------------------------------------
    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'MXBASE.ADD.CUSTOMER.DETAILS'
    Y.OFS.VERSION   = 'MXBASE.ADD.CUSTOMER.DETAILS,ALTA.DIGITAL'
    Y.ID            = ''
    Y.RECORD        = ''
    Y.NO.OF.AUTH    = 0
    Y.OFS.RECORD    = ''
    Y.GTSMODE       = ''
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.MAP.MXBASE,Y.OFS.REQUEST)

    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)



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

END






