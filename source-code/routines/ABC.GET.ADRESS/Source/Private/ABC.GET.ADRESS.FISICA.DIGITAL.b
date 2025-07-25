* @ValidationCode : MjoxMjQ3ODE1NDM6Q3AxMjUyOjE3NTAyODU0MzM2OTM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Jun 2025 19:23:53
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
$PACKAGE AbcGetAdress
SUBROUTINE ABC.GET.ADRESS.FISICA.DIGITAL
    
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Display
    $USING ABC.BP
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Desktop
    $USING AbcCusValLoc
    $USING EB.Interface


    GOSUB INITIALIZE
    GOSUB PROCESS
*GOSUB VALIDA.REGISTRO

*    R.NEW(EB.CUS.TOWN.COUNTRY)<1,1> =  Y.CIUDAD


    EB.Display.RebuildScreen()

RETURN

***********
INITIALIZE:
***********
    Y.SEP       = "|"
    Y.CIUDAD    = ""
    Y.CIUDAD.ANT= ""
    Y.SEPA     = "-"
    Y.CD.DESC = ""


    Y.COD.POS = EB.SystemTables.getComi()

RETURN

*********
PROCESS:
*********

    Y.OFS.OPERATION = EB.Interface.getOfsOperation()
    

    Y.CADENA.DIRECCION = ""
    AbcGetAdress.AbcDireccionSepomex(Y.COD.POS, Y.CADENA.DIRECCION)
        

    Y.ESTADO    = FIELD(Y.CADENA.DIRECCION,"|",1)
    Y.CD.DESC   = FIELD(Y.CADENA.DIRECCION,"|",2)
    Y.CIUDAD    = FIELD(Y.CD.DESC,Y.SEPA,1)
    Y.MUNICIPIO = FIELD(Y.CADENA.DIRECCION,"|",3)
    Y.COLONIA   = FIELD(Y.CADENA.DIRECCION,"|",4)
    Y.PAIS      = FIELD(Y.CADENA.DIRECCION,"|",5)

    IF Y.CADENA.DIRECCION EQ "" THEN
        ETEXT = 'El Codigo Postal que ingreso no existe, digite un Codigo Postal valido y presione la tecla de tabulador'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
            
            
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusPostCode,"")
        EB.Display.RebuildScreen()
    END

* Capturo la informacion de la ciudad del domicilio anterior.
    Y.CIUDAD.ANT = EB.SystemTables.getRNew(EB.CUS.TOWN.COUNTRY)<1,2>
    EB.Display.RebuildScreen()
        


    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusCountrySubdivision,Y.ESTADO)
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusDepartment,Y.MUNICIPIO)
*   EB.SystemTables.setRNew(ST.Customer.Customer.EbCusSubDepartment,Y.COLONIA)
        
    Y.CUS.TOWN.COUNTRY = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTownCountry)
        
        
    Y.CUS.TOWN.COUNTRY<1,1> = Y.CIUDAD
    Y.CUS.TOWN.COUNTRY<1,2> = Y.CIUDAD.ANT
      
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTownCountry,Y.CUS.TOWN.COUNTRY)
    EB.SystemTables.setRNew(ST.Customer.Customer.EbCusAddressCountry,Y.PAIS)
 

* Con el valor del Municipio, obtengo el valor de la localidad Banxico.
*CALL ABC.CUS.VAL.LOC(Y.MUNICIPIO)
    AbcCusValLoc.AbcCusValLoc(Y.MUNICIPIO)

    EB.Display.RebuildScreen()

*        CALL REFRESH.GUI.OBJECTS

RETURN

****************
*VALIDA.REGISTRO:
****************
*    Y.VAL.ACTUAL = EB.SystemTables.getComi()
*    Y.ORIGEN = "DIRECCION"
*    ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)

*RETURN
END

