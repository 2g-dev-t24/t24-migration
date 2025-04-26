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
*    IF R.OLD(EB.CUS.INPUTTER) <> '' THEN
        GOSUB PROCESS
        CALL VPM.RTN.FECHA.MENOR.HOY
        RETURN
*    END

*------ Main Processing Section
    GOSUB PROCESS
*       ABC.BP.AbcRtnFechaMenorHoy
    IF EB.SystemTables.getMessage() NE 'VAL' THEN
*      ABC.BP.AbcVCustFechaNac
    END
    RETURN

*-------
PROCESS:
*-------



    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusBirthIncorpDate)  = '' THEN
      TODAY = EB.SystemTables.getToday()
      EB.SystemTables.setRNew(ST.Customer.Customer.EbCusBirthIncorpDate,TODAY)
    END

    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusNationality) = '' THEN 
*      R.NEW(EB.CUS.NATIONALITY) = R.COMPANY(EB.COM.LOCAL.COUNTRY)[1,2]
    END

    IF EB.SystemTables.getRNew(ST.Customer.Customer.EbCusResidence) = '' THEN
*      R.NEW(EB.CUS.RESIDENCE) = R.COMPANY(EB.COM.LOCAL.COUNTRY)[1,2]
    END 

    EB.Display.RebuildScreen()

    RETURN

END
