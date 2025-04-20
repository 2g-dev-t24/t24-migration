* @ValidationCode : MjoyNjU2ODgzNzk6Q3AxMjUyOjE3NDUxMDQ4NTAxNzU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2025 20:20:50
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
SUBROUTINE ABC.OFS.GET.MNEMONIC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Interface
    $USING EB.Security
    $USING ST.Customer
    $USING EB.DataAccess
    $USING ST.CompanyCreation
    
    IF EB.SystemTables.getROld(ST.Customer.Customer.EbCusInputter) <> '' THEN
        
        GOSUB PROCESS
        
        ABC.BP.AbcRtnFechaMenorHoy()
        
        RETURN
    END

    GOSUB PROCESS
    
    ABC.BP.AbcRtnFechaMenorHoy()
    
    IF EB.Interface.getOfsOperation() NE 'VALIDATE' THEN
        
        ABC.BP.AbcOfsCustFechaNac()
        
    END
RETURN

*-------
PROCESS:
*-------
    TODAY = EB.SystemTables.getToday()
    Y.COMPANY = EB.SystemTables.getIdCompany()
    
    R.COMPANY              = ST.CompanyCreation.Company.Read(Y.COMPANY, COMP.ERR)
    

    
    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusBirthIncorpDate) = '' THEN
        
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusBirthIncorpDate,TODAY)
        
    END
    
    IF EB.SystemTables.getRNew(EB.CUS.NATIONALITY) = '' THEN
        
        Y.COUNTRY = R.COMPANY(ST.CompanyCreation.Company.EbComLocalCountry)[1,2]
    
        EB.SystemTables.setRNew(EB.CUS.NATIONALITY,Y.COUNTRY)
    
    END

    IF EB.SystemTables.getRNew(EB.CUS.RESIDENCE) = '' THEN
        
        Y.COUNTRY = R.COMPANY(ST.CompanyCreation.Company.EbComLocalCountry)[1,2]
        
        EB.SystemTables.setRNew(EB.CUS.RESIDENCE,Y.COUNTRY)
    
    END

*CALL REBUILD.SCREEN
    

RETURN

END

