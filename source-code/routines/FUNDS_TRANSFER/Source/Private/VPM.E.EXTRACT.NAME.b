* @ValidationCode : Mjo1MTY4NzA4MTA6Q3AxMjUyOjE3NDQ3NDI2MzI1OTI6bWFyY286LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Apr 2025 13:43:52
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
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.E.EXTRACT.NAME

    ;* $INSERT I_COMMON  ;* Not Used anymore
    ;* $INSERT I_EQUATE  ;* Not Used anymore
    ;* $INSERT I_ENQUIRY.COMMON  ;* Not Used anymore
    ;* $INSERT I_F.CUSTOMER  ;* Not Used anymore
    ;* $INSERT I_F.ACCOUNT  ;* Not Used anymore
    
    $USING EB.Updates
    $USING EB.Reports
    $USING ST.Customer
    $USING ABC.BP

*-----------------------------------------------------------------------------
* Modificado por : Jesus Andres Rivera Equiuha
* Fecha          : 13/Marzo/2015
* Descripcion    : Se cambio la llamada directa a los campos locales,
*                  por la funcion que regresa la posicion del campo local
*                  proporcionando el nombre del campo
*-----------------------------------------------------------------------
* Omar Basabe
* 25-Jnun-2015
* Se eliminan los campos locales, para la optencion del nombre.
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------
    Y.ESPACIO    = " "
    Y.CUST.NO    = EB.Reports.getOData()
    Y.DOUBLE.ESP = "  "
 
*ITSS-SINDHU-START
   ;* FN.CLIENTE = "F.CUSTOMER" ; F.CLIENTE = "" ; EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
*    CALL DBR("CUSTOMER":FM:EB.CUS.SHORT.NAME,Y.CUST.NO,Y.APELLIDO.P)
*    CALL DBR("CUSTOMER":FM:EB.CUS.NAME.1,Y.CUST.NO,Y.APELLIDO.M)

*    CALL DBR("CUSTOMER":FM:EB.CUS.NAME.2,Y.CUST.NO,Y.NOMBRE.1)
*    CALL DBR("CUSTOMER":FM:EB.CUS.LOCAL.REF,Y.CUST.NO,Y.CUS.REF)

    ;*EB.DataAccess.FRead(FN.CLIENTE, Y.CUST.NO, Y.CLIENTE.REC, F.CLIENTE, ERR)
    Y.CLIENTE.REC = ST.Customer.Customer.Read(Y.CUST.NO,ERR)
    Y.APELLIDO.P = Y.CLIENTE.REC<ST.Customer.Customer.EbCusShortName>
    Y.APELLIDO.M = Y.CLIENTE.REC<ST.Customer.Customer.EbCusNameOne>
    Y.NOMBRE.1 = Y.CLIENTE.REC<ST.Customer.Customer.EbCusNameTwo>
    Y.CUS.REF = Y.CLIENTE.REC<ST.Customer.Customer.EbCusLocalRef>
*ITSS-SINDHU-END
*    CALL GET.LOC.REF("CUSTOMER","FORMER.NAME",Y.NOMBRE2.POS)
*    CALL GET.LOC.REF("CUSTOMER","NOMBRE.3",Y.NOMBRE3.POS)
* MADM compentisation UALA 2025
*    CALL GET.LOC.REF("CUSTOMER","CLASSIFICATION",Y.CLASSIFICATION.POS)
    applications     = ""
    fields           = ""
    applications<1>  = "CUSTOMER"
    fields<1,1>      = "CLASSIFICATION"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    Y.CLASSIFICATION.POS = field_Positions<1,1>

*    Y.NOMBRE.2 = Y.CUS.REF<1,Y.NOMBRE2.POS>
*    Y.NOMBRE.3 = Y.CUS.REF<1,Y.NOMBRE3.POS>
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

END

