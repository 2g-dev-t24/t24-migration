* @ValidationCode : MjoxNDgxNDI1NjcxOkNwMTI1MjoxNzUxNzQyNTY2NjkwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jul 2025 16:09:26
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
    
    Y.ID.ACCOUNT = EB.SystemTables.getComi()
    
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ID.ACCOUNT, Error)
    
    Y.ID.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    
    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUSTOMER, Error)

    EB.LocalReferences.GetLocRef('CUSTOMER','SUBE.NVL.DIG',Y.POS.SUBE.NVL.DIG)

    Y.FLAG.SUBE.NVL.DIG = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.POS.SUBE.NVL.DIG>

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    IF R.CUSTOMER THEN
        
        IF Y.FLAG.SUBE.NVL.DIG EQ '' THEN
            ETEXT ='NO ES POSIBLE CREAR LA CUENTA, ACTUALIZAR BANDERA [SUBE.NIVEL.DIGITAL] AL CLIENTE: ':Y.ID.CUSTOMER
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

RETURN

    
END
