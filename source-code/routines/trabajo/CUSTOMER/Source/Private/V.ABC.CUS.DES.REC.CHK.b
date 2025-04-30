* @ValidationCode : Mjo3NDU1NDE1NzA6Q3AxMjUyOjE3NDU2MTM0MTkwNDM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2025 17:36:59
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
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE V.ABC.CUS.DES.REC.CHK
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING ABC.BP
	
    GOSUB PROCESS
	EB.Display.RebuildScreen()
RETURN

********
PROCESS:
********
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "DESTINO.RECS"
	ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
