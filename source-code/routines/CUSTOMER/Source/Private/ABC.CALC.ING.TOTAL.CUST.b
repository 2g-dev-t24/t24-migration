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
    GOSUB VALIDA.REGISTRO
	EB.Display.RebuildScreen()
RETURN

************
INIT:
**********************
    Y.ING.COMI  = EB.SystemTables.getComi()

    Y.APP.LOC = 'CUSTOMER'
    Y.NOM.CAMPOS   = 'TOT.ING':@VM:'ING.SEC'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.NOM.CAMPOS, Y.POS.LOC)

    Y.POS.TOT.ING = Y.POS.LOC<1,1>
    Y.POS.ING.SEC = Y.POS.LOC<1,2>

RETURN

************
PROCESO:
**********************
    IF EB.SystemTables.getAf() EQ ST.Customer.Customer.EbCusLocalRef THEN
        Y.ING.CAMPO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSalary)
        Y.TOT.ING = Y.ING.COMI + Y.ING.CAMPO
        Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.LOCAL.REF<1,Y.POS.TOT.ING>  = Y.TOT.ING
    END

    IF EB.SystemTables.getAf() EQ ST.Customer.Customer.EbCusSalary THEN
        Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.ING.CAMPO = Y.LOCAL.REF<1,Y.POS.ING.SEC>
        Y.TOT.ING = Y.ING.COMI + Y.ING.CAMPO
        Y.LOCAL.REF<1,Y.POS.TOT.ING>  = Y.TOT.ING
    END
RETURN

****************
VALIDA.REGISTRO:
****************
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "INGRESOS"
	CALL ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
