* @ValidationCode : MjotNTk5NzkxNDg2OkNwMTI1MjoxNzQzNTMwMjEyMTI5Om1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Apr 2025 11:56:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*===============================================================================
* <Rating>-30</Rating>
*===============================================================================
SUBROUTINE ABC.VAL.DEFAULT.RFC
*===============================================================================
* Nombre de Programa :  ABC.VAL.DEFAULT.RFC
* Objetivo           :  Rutina para ingresar el valor por default para el campo de RFC.BENEF.SPEI en caso de no ingresar ninguno
* Requerimiento      :  Proyecto ABC Digital
* Desarrollador      :  Alexis Almaraz Robles - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  23/Junio/2020
*===============================================================================
* Modificaciones:
*===============================================================================
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
    $USING EB.Display
    

    $USING ABC.BP

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.RFC.BENEF.SPEI = ''
    Y.POS.RFC.BENEF.SPEI = ''
    Y.VAL.DEF.RFC = 'ND'
    CALL GET.LOC.REF("FUNDS.TRANSFER","RFC.BENEF.SPEI",Y.POS.RFC.BENEF.SPEI)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    Y.RFC.BENEF.SPEI = R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI>
    IF Y.RFC.BENEF.SPEI EQ "" THEN
        R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BENEF.SPEI> = Y.VAL.DEF.RFC
*        EB.SystemTables.setRNew(FT.Contract , Y.INSERT)
        EB.Display.RebuildScreen()
    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
