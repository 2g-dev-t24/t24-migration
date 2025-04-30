* @ValidationCode : MjoxOTg1ODM5NDMwOkNwMTI1MjoxNzQ1NDIyMjUyNDI0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Apr 2025 12:30:52
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

$PACKAGE AbcCusValLoc
SUBROUTINE ABC.CUS.VAL.LOC(Y.MUNI)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    


*    IF MESSAGE = 'VAL' THEN RETURN

    GOSUB INITIALIZE
    GOSUB PROCESS


RETURN

***********
INITIALIZE:
******************
    Y.PAIS = "484"

    FN.LOC = "F.ABC.LOCALIDADES"
    F.LOC = ""
    EB.DataAccess.Opf(FN.LOC,F.LOC)


    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'L.LOCALIDAD'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)

    POS.LOC = V.FLD.POS<1,1>

    
RETURN

***********
PROCESS:
******************
    Y.LOCALIDAD = ""
* Tomando como base el valor del Municipio, realizo el Select a la tabla VPM.LOCALIDAD
    CMD.SEL.LOC = ""
    LIST.ID.LOC = ""
    NUM.REG.LOC = ""
    CMD.SEL.LOC = "SSELECT " : FN.LOC : " WITH @ID LIKE " : DQUOTE(SQUOTE(Y.PAIS: Y.MUNI): "..." ) :" BY @ID"  ; * ITSS - ANJALI - Added DQUOTE / SQUOTE

    EB.DataAccess.Readlist(CMD.SEL.LOC,LIST.ID.LOC,"",NUM.REG.LOC,"")

    IF NUM.REG.LOC GE 1 THEN

        Y.LOCALIDAD = LIST.ID.LOC<1>
        
        Y.LOCAL.REF.CUSTOMER = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.LOCAL.REF.CUSTOMER<1,POS.LOC> = Y.LOCALIDAD
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.LOCAL.REF.CUSTOMER)

    END ELSE

        ETEXT = "EL MUNICIPIO NO TIENE ALGUNA LOCALIDAD PARA ESE MUNICIPIO"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()

    END

RETURN
END

