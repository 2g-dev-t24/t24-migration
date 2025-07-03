* @ValidationCode : MjotMTU3MjA0OTA1MTpDcDEyNTI6MTc1MTUwNzc5NzIyOTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jul 2025 22:56:37
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
$PACKAGE ABC.BP
SUBROUTINE ABC.VAL.INPUTTER.DIST
*----------------------------------------------------------------
* Descripcion  : Rutina que valida que el usuario que ingreso no sea
* igual al actual
*----------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer

    FN.CUSTOMER = 'F.CUSTOMER$NAU'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    Y.CUSTOMER.ID = EB.SystemTables.getIdNew()
    IF NOT(Y.CUSTOMER.ID) THEN
        Y.CUSTOMER.ID = EB.SystemTables.getComi()
    END

    EB.DataAccess.FRead(FN.CUSTOMER, Y.CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUS)
    
	Y.INPUTTER = R.CUSTOMER<ST.Customer.Customer.EbCusInputter>
	Y.INPUTTER = FIELD(Y.INPUTTER, '_', 2)
    Y.USER.ID  = EB.SystemTables.getOperator()

    IF Y.INPUTTER EQ Y.USER.ID THEN
        ETEXT = 'Usuario autorizador igual a usuario de ingreso'
        EB.SystemTables.setE(ETEXT)
    END
RETURN
END
