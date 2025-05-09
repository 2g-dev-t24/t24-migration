* @ValidationCode : MjotNjAxOTA5NjEzOkNwMTI1MjoxNzQ1Mjc3NjQ2NDkyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2025 20:20:46
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
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.EDO.CURP
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING EB.Interface
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.Updates
    
    GOSUB INIT
    GOSUB OPEN.FILES

    Y.LUG.NAC = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,Y.POS.BIRTH.PROV>

    IF Y.LUG.NAC NE '' THEN
        Y.LUG.NAC.CURP = Y.CURP[12,2]
        IF Y.LUG.NAC.CURP EQ '' THEN
            ETEXT = "LA CLAVE DE LA ENTIDAD DE NACIMIENTO NO ES VALIDA"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            IF Y.LUG.NAC.CURP NE Y.LUG.NAC THEN 
                ETEXT = "LA ENTIDAD DE NACIMIENTO DEL CURP NO COINCIDE CON EL ESTADO DE NACIMIENTO"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END ELSE
        ETEXT = "FAVOR DE LLENAR EL ESTADO DE NACIMIENTO"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN

***********
OPEN.FILES:
***********

    FN.ABC.ESTADO = 'F.ABC.ESTADO'
    F.ABC.ESTADO = ''
    EB.DataAccess.Opf(FN.ABC.ESTADO,F.ABC.ESTADO)

RETURN

*****
INIT:
*****
    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'BIRTH.PROVINCE'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, Y.POS.LUG.NAC)
    Y.POS.BIRTH.PROV = Y.POS.LUG.NAC<1,1> 
    
    Y.CURP = EB.SystemTables.getComi()
    
RETURN

END
