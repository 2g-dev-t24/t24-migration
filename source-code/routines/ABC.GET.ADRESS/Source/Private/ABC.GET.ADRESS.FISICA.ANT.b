* @ValidationCode : MjotMTQ4NDEyMzI5ODpDcDEyNTI6MTc0NDY2NDAxOTYzNzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Apr 2025 17:53:39
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
SUBROUTINE ABC.GET.ADRESS.FISICA.ANT
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

    Y.COMI = EB.SystemTables.getComi()
    
    IF Y.COMI NE "" THEN
        GOSUB INITIALIZE
        GOSUB PROCESS
* GOSUB VALIDA.REGISTRO
    END



    EB.Display.RebuildScreen()
RETURN

***********
INITIALIZE:
***********
    Y.SEP      = "|"
    Y.SEPA     = "-"
    Y.CD.DESC = ""
    LREF.TABLE = "CUSTOMER"
    
    LREF.FIELD = "ABC.CD.EDO.ANT"  : @VM
*    LREF.FIELD := "DIR.CIUDAD.ANT"  : VM
    LREF.FIELD := "ABC.DEL.MUN.ANT" : @VM
    LREF.FIELD := "ABC.COLONIA.ANT" : @VM
    LREF.FIELD := "ABC.PAIS.ANT"    : @VM
    LREF.POS = ""

    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)


    Y.POS.DIR.CD.EDO   = LREF.POS<1,1>
*    Y.POS.DIR.CIUDAD   = LREF.POS<1,2>
    Y.POS.DIR.DEL.MUNI = LREF.POS<1,2>
    Y.POS.DIR.COLONIA  = LREF.POS<1,3>
    Y.POS.DIR.PAIS     = LREF.POS<1,4>

    Y.COD.POS = Y.COMI
    IF LEN(Y.COD.POS) LT 5 THEN
        Y.COD.POS = "0" : Y.COD.POS
    END
RETURN

*********
PROCESS:
*********

    Y.MESSAGE = EB.SystemTables.getMessage()
    
    IF Y.MESSAGE EQ 'VAL' THEN
        RETURN
    END ELSE

        Y.CADENA.DIRECCION = ''
        AbcGetAdress.AbcDireccionSepomex(Y.COD.POS, Y.CADENA.DIRECCION)

        Y.ESTADO    = FIELD(Y.CADENA.DIRECCION, "|", 1)
        Y.CD.DESC   = FIELD(Y.CADENA.DIRECCION, "|", 2)
        Y.CIUDAD    = FIELD(Y.CD.DESC,Y.SEPA,1)
        Y.MUNICIPIO = FIELD(Y.CADENA.DIRECCION, "|", 3)
        Y.COLONIA   = FIELD(Y.CADENA.DIRECCION, "|", 4)
        Y.PAIS      = FIELD(Y.CADENA.DIRECCION, "|", 5)

        IF Y.CADENA.DIRECCION EQ "" THEN
            ETEXT = 'El Codigo Postal que ingreso no existe, digite un Codigo Postal valido y presione la tecla de tabulador'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusPostCode,"")
            EB.Display.RebuildScreen()
        END

        Y.CAMPOS.LOCALES = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.CD.EDO>  = Y.ESTADO
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.DEL.MUNI>= Y.MUNICIPIO
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.COLONIA> = Y.COLONIA
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.PAIS>    = Y.PAIS
        
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.CAMPOS.LOCALES)
        
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusTownCountry,Y.CIUDAD)

        EB.Display.RebuildScreen()
        
*AbcCusValLoc.AbcCusValLoc(Y.MUNICIPIO)
*CALL REFRESH.GUI.OBJECTS
    END

RETURN

****************
*VALIDA.REGISTRO:
****************
*Y.VAL.ACTUAL = EB.SystemTables.getComi()
* Y.ORIGEN = "DIRECCION"
    
* ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)

*RETURN
END
