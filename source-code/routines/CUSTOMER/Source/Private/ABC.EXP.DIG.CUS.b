* @ValidationCode : MjotMjAyNjgyNzY3MjpDcDEyNTI6MTc0Nzk2MDg1MjgwMTptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 May 2025 21:40:52
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
    $USING AA.Account
    
    GOSUB INICIO
    GOSUB OPEN.FILES
    GOSUB PROCESA

RETURN

*----------*
INICIO:
*----------*

    Y.ID.CUSTOMER = EB.SystemTables.getRNew(AA.Account.Account.AcCustomerReference)

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
