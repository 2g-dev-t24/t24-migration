* @ValidationCode : MjoxNDUyMzg3NjAxOkNwMTI1MjoxNzQ1NTkyOTM4MTY0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2025 11:55:38
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
*   Fecha: Mayo 2015
*   Autor: Omar Basabe.
*
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.CUS.VALIDA.GENERICO

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.Display
	
    GOSUB PROCESS
	EB.Display.RebuildScreen()
RETURN

****************
PROCESS:
****************
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "GENERICO"
	ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
