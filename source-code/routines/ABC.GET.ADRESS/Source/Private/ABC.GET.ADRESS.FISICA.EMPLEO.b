* @ValidationCode : Mjo3MTQ1ODkzODc6Q3AxMjUyOjE3NDQ2NjQwNzg2MzM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Apr 2025 17:54:38
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
SUBROUTINE ABC.GET.ADRESS.FISICA.EMPLEO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
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
*   GOSUB VALIDA.REGISTRO
    EB.Display.RebuildScreen()
RETURN

***********
INITIALIZE:
***********
    Y.SEP      = "|"
    LREF.TABLE = "CUSTOMER"
    LREF.FIELD = ""
    LREF.FIELD := "EMP.ENTIDAD"  : @VM
    LREF.FIELD := "EMP.CIUDAD"   : @VM
    LREF.FIELD := "EMP.DEL.MUNI" : @VM
    LREF.FIELD := "EMP.COL"      : @VM
    LREF.FIELD := "EMP.PAIS"     : @VM
    LREF.POS = ""

    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)

    Y.POS.DIR.CD.EDO   = LREF.POS<1,1>
    Y.POS.DIR.CIUDAD   = LREF.POS<1,2>
    Y.POS.DIR.DEL.MUNI = LREF.POS<1,3>
    Y.POS.DIR.COLONIA  = LREF.POS<1,4>
    Y.POS.DIR.PAIS     = LREF.POS<1,5>
    
    Y.COD.POS = EB.SystemTables.getComi()
    
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

        Y.ESTADO    = FIELD(Y.CADENA.DIRECCION, Y.SEP, 1)
        Y.CD.COMP   = FIELD(Y.CADENA.DIRECCION, Y.SEP, 2)
        Y.CIUDAD    = FIELD(Y.CD.COMP, "-", 1)
        Y.MUNICIPIO = FIELD(Y.CADENA.DIRECCION, Y.SEP, 3)
        Y.COLONIA   = FIELD(Y.CADENA.DIRECCION, Y.SEP, 4)
        Y.PAIS      = FIELD(Y.CADENA.DIRECCION, Y.SEP, 5)

        IF Y.CADENA.DIRECCION EQ "" THEN
            ETEXT = 'El Codigo Postal que ingreso no existe, digite un Codigo Postal valido y presione la tecla de tabulador'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            
            EB.SystemTables.setRNew(ST.Customer.Customer.EbCusPostCode,"")
            EB.Display.RebuildScreen()
        END
    
        Y.CAMPOS.LOCALES = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)

        Y.CAMPOS.LOCALES<1,Y.POS.DIR.CD.EDO>   = Y.ESTADO
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.DEL.MUNI> = Y.MUNICIPIO
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.CIUDAD>   = Y.CIUDAD

        Y.CAMPOS.LOCALES<1,Y.POS.DIR.COLONIA>  = Y.COLONIA
        Y.CAMPOS.LOCALES<1,Y.POS.DIR.PAIS>     = Y.PAIS
        
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.CAMPOS.LOCALES)

        

        EB.Display.RebuildScreen()
*CALL REFRESH.GUI.OBJECTS
    END
RETURN

****************
*VALIDA.REGISTRO:
****************
*    Y.VAL.ACTUAL = EB.SystemTables.getComi()
*    Y.ORIGEN = "DIRECCION"
*    ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
*RETURN
END

