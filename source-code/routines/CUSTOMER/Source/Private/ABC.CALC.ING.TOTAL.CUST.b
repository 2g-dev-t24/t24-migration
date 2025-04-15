* @ValidationCode : Mjo1NTY5MDUyNzc6Q3AxMjUyOjE3NDI0OTc4ODMyNzI6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Mar 2025 16:11:23
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
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
*   Descripcion : Calcula el Ingreso Total del Cliente
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.CALC.ING.TOTAL.CUST

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING EB.Updates
    $USING ABC.BP

    GOSUB INIT
    GOSUB PROCESO
	EB.Display.RebuildScreen()
RETURN

************
INIT:
**********************
    Y.ING.COMI  = EB.SystemTables.getComi()

RETURN

**********************
PROCESO:
**********************

    IF EB.SystemTables.getAf() EQ EB.SystemTables.getRNew(ST.Customer.Customer.EbCusAnnualBonus) THEN
        Y.ING.CAMPO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSalary)
        Y.TOT.ING = Y.ING.COMI + Y.ING.CAMPO
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusNetMonthlyIn, Y.TOT.ING)
    END

    IF EB.SystemTables.getAf() EQ EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSalary) THEN
        Y.ING.CAMPO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusAnnualBonus)
        Y.TOT.ING = Y.ING.COMI + Y.ING.CAMPO
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusNetMonthlyIn, Y.TOT.ING)
    END
RETURN

END
