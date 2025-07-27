* @ValidationCode : MjotMTQzNDQ0MTg4OTpDcDEyNTI6MTc1MzY0MDEzNTA4NzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Jul 2025 15:15:35
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
    $USING AC.AccountOpening
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

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    Y.ID.CUENTA = EB.SystemTables.getIdNew()
    
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ID.CUENTA, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)


    R.AA<AA.Framework.ArrangementActivity.ArrActArrangement> = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= MAP.ACCOUNT>
MAP.BENEFICIARIO:
*** <desc>Mapea los campos de BENEFICIARIO </desc>


    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenApePaterno> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.ApePaterno)
    
    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenApeMaterno> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.ApeMaterno)
    
    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenNombres>    = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Nombres)
    
    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenFecNac>     = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.FecNac)
    
    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenPorcentaje> = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Porcentaje)
    
    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenEmail>      = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.Email)
    
    R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.PregFonTer>    = EB.SystemTables.getRNew(AbcTable.AbcCuentaL4Api.PregFonTer)
    
    Y.LIST.PORCENTAJE = R.BENEFICAIRIO<AbcTable.AbcAcctLclFlds.BenPorcentaje>
    
    Y.NO.VALORES = DCOUNT(Y.LIST.PORCENTAJE,@FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        TOTAL = TOTAL + Y.LIST.PORCENTAJE<Y.AA>
    NEXT Y.AA
    IF (TOTAL NE 100) THEN
        EB.SystemTables.setEtext('El Porcentaje es diferente a 100')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    

RETURN
*** </region>


*-----------------------------------------------------------------------------
CREAR.OFS.ACCOUNT:
*** <desc>Crea y ejecuta el OFS de AA ACTIVITY</desc>
*-----------------------------------------------------------------------------

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'AA.ARRANGEMENT.ACTIVITY'
    Y.OFS.VERSION   = 'AA.ARRANGEMENT.ACTIVITY,ABC.CUENTA.NIVEL.4L'
    Y.ID            = ''
    Y.ID.CUSTOMER   = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.AA,Y.OFS.REQUEST)

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
    Y.OFS.APP       = 'ABC.ACCT.LCL.FLDS'
    Y.OFS.VERSION   = 'ABC.ACCT.LCL.FLDS,ABC.ACCOUNT.API'
    Y.RECORD        = ''
    Y.NO.OF.AUTH    = 0
    Y.OFS.RECORD    = ''
    Y.GTSMODE       = ''
    Error           = ''

    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUENTA,R.BENEFICAIRIO,Y.OFS.REQUEST)
 
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)

    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN




END


