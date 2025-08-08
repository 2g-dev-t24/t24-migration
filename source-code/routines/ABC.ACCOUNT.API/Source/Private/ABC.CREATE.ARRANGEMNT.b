* @ValidationCode : MjotMTY4ODI1NzM3NDpDcDEyNTI6MTc1NDYyMjc0OTE0MzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Aug 2025 00:12:29
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


SUBROUTINE ABC.CREATE.ARRANGEMNT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
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
    GOSUB CREAR.OFS.ACCOUNT ; *Crea y ejecuta el OFS de AA ACTIVITY

*-----------------------------------------------------------------------------

*** <region name= MAP.ACCOUNT>
MAP.ACCOUNT:
*** <desc>Mapea los campos de AA ACTIVITY </desc>

    Y.ID.CUENTA = EB.SystemTables.getIdNew()
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    IF (Y.V.FUNCTION EQ 'A') THEN
        R.AA<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ID.CUENTA
        GOSUB OBTENER.PRODUCTO
    
    
        R.AA<AA.Framework.ArrangementActivity.ArrActActivity>       = 'ACCOUNTS-NEW-ARRANGEMENT'
        R.AA<AA.Framework.ArrangementActivity.ArrActCurrency>       = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Currency)
        R.AA<AA.Framework.ArrangementActivity.ArrActCustomer>       = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
        R.AA<AA.Framework.ArrangementActivity.ArrActCustomerRole>   = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Rol)
    END
RETURN

*-----------------------------------------------------------------------------
OBTENER.PRODUCTO:
*-----------------------------------------------------------------------------
    
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    
    
    Y.PARAM.ID = 'ABC.PRODUCT.ACCT'
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el parámetro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    Y.CATAGORY = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Category)
    
    LOCATE Y.CATAGORY IN Y.LIST.PARAMS SETTING Y.POS.CATEGORY ELSE
        ETEXT = 'Categoría ':Y.CATAGORY:' no encontrada en la lista de parámetros'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    R.AA<AA.Framework.ArrangementActivity.ArrActProduct> = Y.LIST.VALUES<Y.POS.CATEGORY>
       
RETURN
*-----------------------------------------------------------------------------
CREAR.OFS.ACCOUNT:
*** <desc>Crea y ejecuta el OFS de AA ACTIVITY</desc>
*-----------------------------------------------------------------------------

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'AA.ARRANGEMENT.ACTIVITY'
    Y.OFS.VERSION   = 'AA.ARRANGEMENT.ACTIVITY,AA.API'
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

END
