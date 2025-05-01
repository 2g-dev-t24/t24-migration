* @ValidationCode : MjotMTk2NzEyODI1MTpDcDEyNTI6MTc0NTMzNzMxNTM5NTptYXV1YjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Apr 2025 12:55:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         :
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.CUST.NOEXISTE.PFS
*================================================================================================================
* Rutina que VALIDA SI YA EXISTE UN CLIENTE PERSONA FISICA
*================================================================================================================
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING EB.Updates

    $USING ABC.BP

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

***********
INITIALIZE:
***********

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    Y.NUM.CUSTOMER = EB.SystemTables.getComi()
    Y.MENSAJE = ""
    Y.EXISTE.ERROR = 0
    Y.SECTOR = ""
    R.CUSTOMER = ""

    Y.CLASS.COTI.POS = ""
    EB.Updates.MultiGetLocRef("CUSTOMER","CLASS.COTI",Y.CLASS.COTI.POS)

RETURN

*********
PROCESS:
*********

    EB.DataAccess.FRead(FN.CUSTOMER, Y.NUM.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUST.ERR)

    IF R.CUSTOMER EQ "" THEN
        Y.EXISTE.ERROR = 1
        Y.MENSAJE = " USE OPCION DE ALTA "
    END ELSE
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
        Y.CLASS.COTI = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.CLASS.COTI.POS>

        IF Y.SECTOR GE '1300' AND Y.SECTOR GE '1304' THEN 
            Y.SECTOR = Y.CLASS.COTI
        END

        IF Y.SECTOR EQ 2001 THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "UTILICE LA OPCION DE MANTENIMIENTO PARA PERSONA MORAL"
        END

        IF Y.SECTOR EQ 1100 THEN
            Y.EXISTE.ERROR = 1
            Y.MENSAJE = "UTILICE LA OPCION DE MANTENIMIENTO PARA PERSONA FISICA"
        END
    END

    IF Y.EXISTE.ERROR EQ 1 THEN
        EB.SystemTables.setEtext(Y.MENSAJE)
        EB.SystemTables.setE(EB.SystemTables.getEtext())
        EB.ErrorProcessing.StoreEndError()
    END

    EB.Display.RebuildScreen()
*CALL REFRESH.GUI.OBJECTS

RETURN

END
