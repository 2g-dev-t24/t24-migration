* @ValidationCode : MjotMTgzNTYyNzYyNzpDcDEyNTI6MTc1NDI3NTAwMTI3MzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Aug 2025 23:36:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE ABC.BP

SUBROUTINE ABC.E.EXTRACT.NAME
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
     
    $USING ST.Customer
    $USING EB.Reports
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ESPACIO    = " "
    Y.CUST.NO    = EB.Reports.getOData()
    Y.DOUBLE.ESP = "  "

    Y.CLIENTE.REC = ST.Customer.Customer.Read(Y.CUST.NO, ERR)
    
    Y.APELLIDO.P = Y.CLIENTE.REC<ST.Customer.Customer.EbCusShortName>
    Y.APELLIDO.M = Y.CLIENTE.REC<ST.Customer.Customer.EbCusNameOne>
    Y.NOMBRE.1 = Y.CLIENTE.REC<ST.Customer.Customer.EbCusNameTwo>
    Y.CUS.REF = Y.CLIENTE.REC<ST.Customer.Customer.EbCusLocalRef>
    
    Y.APP = "CUSTOMER"
    Y.FLD = "CLASSIFICATION"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    Y.CLASSIFICATION.POS = Y.POS.FLD<1,1>

    Y.CLASSIFICATION = Y.CUS.REF<1,Y.CLASSIFICATION.POS>

    IF Y.CLASSIFICATION = 1 OR Y.CLASSIFICATION = 2 THEN

        Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@VM,Y.ESPACIO)
        Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@FM,Y.ESPACIO)
        Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,Y.DOUBLE.ESP,Y.ESPACIO)

        Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

        Y.NAME  = Y.APELLIDO.P: Y.ESPACIO
        Y.NAME := Y.APELLIDO.M: Y.ESPACIO
        Y.NAME := Y.NOMBRE.1

    END ELSE
        IF Y.CLASSIFICATION = 3 THEN
            Y.NAME = Y.APELLIDO.P
        END ELSE
            IF Y.CLASSIFICATION = 4 OR Y.CLASSIFICATION = 5 THEN
                Y.NAME = Y.APELLIDO.P
            END
        END
    END

    EB.Reports.setOData(Y.NAME)
    
RETURN
*-----------------------------------------------------------------------------
END