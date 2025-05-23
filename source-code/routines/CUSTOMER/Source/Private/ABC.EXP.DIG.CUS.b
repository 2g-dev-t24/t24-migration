* @ValidationCode : Mjo3NjM1NzgzOTA6Q3AxMjUyOjE3NDc5NzAwNzA4NDc6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2025 00:14:30
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
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.EXP.DIG.CUS
*----------------------------------------------------
* AUTOR        : Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Tipo Rutina  : Input
* CREACI�N     : 04 - May - 2020
* DESCRIPCION  : Asigna al campo EXPEDIENTE.DIG de CUSTOMER, el valor SI
* ------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AA.Framework
    GOSUB INICIO
    GOSUB OPEN.FILES
    GOSUB PROCESA

RETURN

*----------*
INICIO:
*----------*

    Y.ID.CUSTOMER = EB.SystemTables.getRNew(AA.Framework.Arrangement.ArrCustomer)

RETURN

*----------*
OPEN.FILES:
*----------*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    EB.Updates.MultiGetLocRef("CUSTOMER","EXPEDIENTE.DIGI",YPOS.EXPEDIENTE.DIGI)

RETURN

*----------*
PROCESA:
*----------*

    EB.DataAccess.FRead(FN.CUSTOMER,Y.ID.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUSTOMER)
    IF Y.ERR.CUSTOMER EQ '' THEN
        Y.EXPEDIENTE.DIGI = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,YPOS.EXPEDIENTE.DIGI>
        IF Y.EXPEDIENTE.DIGI NE 'SI'THEN
            ETEXT = 'El cliente no tiene expediente digital'
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            EB.ErrorProcessing.Err()
        END
    END

RETURN
*----------*
END
