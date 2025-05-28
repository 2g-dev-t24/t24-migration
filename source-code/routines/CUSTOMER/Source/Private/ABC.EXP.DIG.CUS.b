* @ValidationCode : MjotMTIwMDgyMTAwOTpDcDEyNTI6MTc0ODAyODk2OTUwODptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2025 16:36:09
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
* Tipo Rutina  : Validation
* CREACION     : 04 - May - 2020
* DESCRIPCION  : Valida si cliente tiene o no expediente digital
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

    Y.ID.CUSTOMER = EB.SystemTables.getComi()

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
    Y.ERR.CUSTOMER = ''
    EB.DataAccess.FRead(FN.CUSTOMER,Y.ID.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUSTOMER)
    IF Y.ERR.CUSTOMER EQ '' THEN
        Y.EXPEDIENTE.DIGI = UPCASE(R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,YPOS.EXPEDIENTE.DIGI>)
        IF Y.EXPEDIENTE.DIGI NE 'SI' THEN
            ETEXT = 'El cliente no tiene expediente digital'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

RETURN
*----------*
END
