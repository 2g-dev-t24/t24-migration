* @ValidationCode : MjozNTE3MzA3MDU6Q3AxMjUyOjE3NTE5MTUzMjA4ODk6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Jul 2025 16:08:40
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
    $USING EB.DataAccess
    $USING MXBASE.CustomerRegulatory

    Y.ID = EB.SystemTables.getComi()
    
    FN.MXBASE.ADD.CUSTOMER.DETAILS  = 'F.MXBASE.ADD.CUSTOMER.DETAILS$NAU'
    F.MXBASE.ADD.CUSTOMER.DETAILS   = ''
    
    EB.DataAccess.Opf(FN.MXBASE.ADD.CUSTOMER.DETAILS, F.MXBASE.ADD.CUSTOMER.DETAILS)
    
    EB.DataAccess.FRead(FN.MXBASE.ADD.CUSTOMER.DETAILS, Y.ID, R.MXBASE.ADD.CUSTOMER.DETAILS, F.MXBASE.ADD.CUSTOMER.DETAILS, Y.ERR)
    
    Y.INPUTTER = R.MXBASE.ADD.CUSTOMER.DETAILS<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Inputter>

	Y.INPUTTER = FIELD(Y.INPUTTER, '_', 2)
    Y.USER.ID  = EB.SystemTables.getOperator()

    IF Y.INPUTTER EQ Y.USER.ID THEN
        ETEXT = 'Usuario autorizador igual a usuario de ingreso'
        EB.SystemTables.setE(ETEXT)
    END
RETURN
END