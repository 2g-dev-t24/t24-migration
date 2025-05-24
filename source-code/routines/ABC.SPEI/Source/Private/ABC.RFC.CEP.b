* @ValidationCode : MjoxNTMwMjkwNjIzOkNwMTI1MjoxNzQ4MTEyNTEyODQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 May 2025 15:48:32
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
$PACKAGE AbcSpei

SUBROUTINE ABC.RFC.CEP
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates


    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

********
PROCESS:
********
    Y.RFC = ''
    Y.NOMBRE = ''
    Y.ID.CUS = ''
    
    Y.ID.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ID.ACCOUNT, Error)

    
    IF R.ACCOUNT THEN
        
        Y.ID.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        
        R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUSTOMER, Error)
        
        
        IF R.CUSTOMER THEN
            

            Y.TAX.ID = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>
            Y.RFC = Y.TAX.ID<1,1>
            
            Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            Y.RFC.CTE = Y.LOCAL.REF<1,Y.POS.RFC.CTE>
            
            EB.SystemTables.setRNew(Y.RFC.CTE,Y.RFC)

            Y.ID.CUS = R.ACCOUNT<AC.AccountOpening.Account.Customer>     ;*AAR-20200130 - S
            
            Y.COMI = Y.ID.CUS:'*1'
            
            AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE)
            
*        CALL VPM.V.CUSTOMER.NAME(Y.COMI,Y.NOMBRE)
            
*Y.NOMBRE = COMI.ENRI
            
            IF LEN(Y.NOMBRE)GT 40 THEN
                Y.NOMBRE=Y.NOMBRE[1,40]
            END
            
            Y.LOCAL.REF<1,Y.POS.FT.CUS.NAME> = Y.NOMBRE
            
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)


        END
    END
RETURN

***********
OPEN.FILES:
***********

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    Y.POS.FT.CUS.NAME = ''
    
    NOM.CAMPOS     = 'L.RFC.BENEF.SPEI':@VM:'L.FT.CUS.NAME'
    POS.CAMP.LOCAL = ""
    
    
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)

    Y.POS.RFC.CTE     = POS.CAMP.LOCAL<1,1>
    Y.POS.FT.CUS.NAME = POS.CAMP.LOCAL<1,2>
    
RETURN

END
