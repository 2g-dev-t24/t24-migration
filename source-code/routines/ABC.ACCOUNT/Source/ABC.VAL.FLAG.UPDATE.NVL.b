* @ValidationCode : MjoxNTExMzQ2Mjg0OkNwMTI1MjoxNzU0NTQxMzk1NjI1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Aug 2025 01:36:35
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
$PACKAGE AbcAccount

SUBROUTINE ABC.VAL.FLAG.UPDATE.NVL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
    
    Y.ID.ACCOUNT = EB.SystemTables.getIdNew()
    
    
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ID.ACCOUNT, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
    
    Y.ID.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    
    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
    
    EB.LocalReferences.GetLocRef('CUSTOMER','SUBE.NVL.DIG',Y.POS.SUBE.NVL.DIG)
    
    Y.LOCAL = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>

    Y.FLAG.SUBE.NVL.DIG = Y.LOCAL<1,Y.POS.SUBE.NVL.DIG>

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    
    IF Y.ERR.CUSTOMER EQ '' THEN
        
        IF Y.FLAG.SUBE.NVL.DIG EQ '' THEN
            ETEXT ='NO ES POSIBLE CREAR LA CUENTA, ACTUALIZAR BANDERA [SUBE.NIVEL.DIGITAL] AL CLIENTE: ':Y.ID.CUSTOMER
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

RETURN

    
END
