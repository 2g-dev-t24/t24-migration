* @ValidationCode : MjotNDgxODY1Njc5OkNwMTI1MjoxNzUxOTExOTM1ODc5Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Jul 2025 15:12:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.MXB.INP.DIST
*----------------------------------------------------------------
* Descripcion  : Rutina que valida que el usuario que ingreso no sea
* igual al actual
*----------------------------------------------------------------

    $USING EB.SystemTables
    $USING MXBASE.CustomerRegulatory

    
    Y.INPUTTER = EB.SystemTables.getRNew(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Inputter)
    
    IF NOT(Y.INPUTTER) THEN
        Y.INPUTTER = EB.SystemTables.getRNewLast(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Inputter)
    END

	Y.INPUTTER = FIELD(Y.INPUTTER, '_', 2)
    Y.USER.ID  = EB.SystemTables.getOperator()

    IF Y.INPUTTER EQ Y.USER.ID THEN
        ETEXT = 'Usuario autorizador igual a usuario de ingreso'
        EB.SystemTables.setE(ETEXT)
    END
RETURN
END