* @ValidationCode : MjoxMjEzOTQ1ODM1OkNwMTI1MjoxNzUxNTk1MjkzNTQxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jul 2025 23:14:53
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
$PACKAGE AbcAccountApi

SUBROUTINE ABC.CUENTA.L4.API.RTN
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
    $USING AA.Framework
    $USING AbcTable
    $USING EB.Updates
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    
    
    GOSUB MAP.ACCOUNT ; *Mapea los campos de AA ACTIVITY
    GOSUB MAP.BENEFICIARIO ; *Mapeo BENEFICIARIO
    GOSUB CREAR.OFS.ACCOUNT ; *Crea y ejecuta el OFS de AA ACTIVITY
    GOSUB CREAR.OFS.BENEFICIARIO ; *Crea y ejecuta el OFS de BENEICIARIO

*-----------------------------------------------------------------------------

*** <region name= MAP.ACCOUNT>
MAP.ACCOUNT:
*** <desc>Mapea los campos de AA ACTIVITY </desc>

    R.ACCOUNT<AA.Framework.Arrangement.ArrProperty> = 'BALANCE'
    
    R.ACCOUNT<AA.Framework.ArrangementActivity.ArrActActivity> = 'ACCOUNTS-CHANGE.PRODUCT-ARRANGEMENT'
    
    R.ACCOUNT<AA.Framework.ArrangementActivity.ArrActArrangement> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Account)
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= MAP.ACCOUNT>
MAP.BENEFICIARIO:
*** <desc>Mapea los campos de BENEFICIARIO </desc>

    
    R.BENEFICAIRIO<AbcTable.AbcBeneficiariosAccount.ApePaterno> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.ApePaterno)
    
    R.BENEFICAIRIO<AbcTable.AbcBeneficiariosAccount.ApeMaterno> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.ApeMaterno)
    
    R.BENEFICAIRIO<AbcTable.AbcBeneficiariosAccount.Nombres>    = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Nombres)
    
    R.BENEFICAIRIO<AbcTable.AbcBeneficiariosAccount.FecNac>     = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.FecNac)
    
    R.BENEFICAIRIO<AbcTable.AbcBeneficiariosAccount.Porcentaje> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Porcentaje)
    
    R.BENEFICAIRIO<AbcTable.AbcBeneficiariosAccount.Email>      = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Email)
    

RETURN
*** </region>


*-----------------------------------------------------------------------------
CREAR.OFS.ACCOUNT:
*** <desc>Crea y ejecuta el OFS de AA ACTIVITY</desc>
*-----------------------------------------------------------------------------

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'AA.ARRANGEMENT.ACTIVITY'
    Y.OFS.VERSION   = 'AA.ARRANGEMENT.ACTIVITY,ABC.ACCOUNT.API'
    Y.ID            = ''
    Y.ID.CUSTOMER   = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.ACCOUNT,Y.OFS.REQUEST)

    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN


*-----------------------------------------------------------------------------
CREAR.OFS.BENEFICIARIO:
*** <desc>Crea y ejecuta el OFS de BENEICIARIO</desc>
*-----------------------------------------------------------------------------
    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'ABC.BENEFICIARIOS.ACCOUNT'
    Y.OFS.VERSION   = 'ABC.BENEFICIARIOS.ACCOUNT,ABC.ACCOUNT.API'
    Y.RECORD        = ''
    Y.NO.OF.AUTH    = 0
    Y.OFS.RECORD    = ''
    Y.GTSMODE       = ''
    Error           = ''

    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.BENEFICAIRIO,Y.OFS.REQUEST)
 
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)

    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN




END


