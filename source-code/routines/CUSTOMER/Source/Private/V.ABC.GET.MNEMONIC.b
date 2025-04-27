$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
    SUBROUTINE V.ABC.GET.MNEMONIC
*------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING ABC.BP
    $USING EB.Display
    $USING ST.CompanyCreation
    
    IF IF EB.SystemTables.getROld(ST.Customer.Customer.EbCusInputter) <> '' THEN
        GOSUB PROCESS
        ABC.BP.AbcRtnFechaMenorHoy()
        RETURN
    END

*------ Main Processing Section
    GOSUB PROCESS
       ABC.BP.AbcRtnFechaMenorHoy()
    IF EB.SystemTables.getMessage() NE 'VAL' THEN
       ABC.BP.AbcVCustFechaNac()
    END
    RETURN

*-------
PROCESS:
*-------


    Y.COMPANY = EB.SystemTables.getIdCompany()
    R.COMPANY              = ST.CompanyCreation.Company.Read(Y.COMPANY, COMP.ERR)

    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusBirthIncorpDate)  = '' THEN
      TODAY = EB.SystemTables.getToday()
      EB.SystemTables.setRNew(ST.Customer.Customer.EbCusBirthIncorpDate,TODAY)
    END
    Y.COUNTRY = R.COMPANY(ST.CompanyCreation.Company.EbComLocalCountry)[1,2] 
    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNationality) = '' THEN
      EB.SystemTables.setRNew(ST.Customer.Customer.EbCusNationality,Y.COUNTRY)
    END

    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusResidence) = '' THEN
      EB.SystemTables.setRNew(ST.Customer.Customer.EbCusResidence,Y.COUNTRY)
    END 

    EB.Display.RebuildScreen()

    RETURN

END
