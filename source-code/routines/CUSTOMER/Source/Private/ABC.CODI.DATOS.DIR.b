* @ValidationCode : Mjo5ODk0MDM3NjY6Q3AxMjUyOjE3NDQ4MTczNjM1MDk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 12:29:23
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
SUBROUTINE ABC.CODI.DATOS.DIR(DATOS)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcGetAdress
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Display
    
    
    
    GOSUB INICIA
    IF Y.CODIGO.POSTAL AND Y.COLONIA THEN
        GOSUB VALIDA.DATOS
    END ELSE
        DATOS = '-1, NO CONTIENE LOS DATOS NECESARIOS PARA PROCESAR LA CONSULTA'
    END

RETURN

*******
INICIA:
*******

    DATOS = ''
    Y.CODIGO.POSTAL = ''
    Y.COLONIA = ''
    ID.COLONIA = ''
    Y.MESSAGE = ''
    Y.SEP       = "|"
    Y.CIUDAD    = ""
    Y.CIUDAD.ANT= ""
    Y.SEPA     = "-"
    Y.CD.DESC = ""
    
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()
    

    LOCATE "CODIGO.POSTAL" IN SEL.FIELDS<1> SETTING YPOS.CODIGO.POSTAL THEN
        Y.CODIGO.POSTAL = SEL.VALUES<YPOS.CODIGO.POSTAL>
    END

    LOCATE "COLONIA" IN SEL.FIELDS<1> SETTING YPOS.COLONIA THEN
        Y.COLONIA = SEL.VALUES<YPOS.COLONIA>
        Y.COLONIA = OCONV(Y.COLONIA, 'MCU')
        CHANGE @SM TO ' ' IN Y.COLONIA
    END

    YSEP = '|'

RETURN

*************
VALIDA.DATOS:
*************
    ABC.BP.abcIdColonia(Y.CODIGO.POSTAL,Y.COLONIA,ID.COLONIA,Y.MESSAGE)
*   CALL ABC.ID.COLONIA(Y.CODIGO.POSTAL,Y.COLONIA,ID.COLONIA,Y.MESSAGE)

       
    AbcGetAdress.AbcDireccionSepomex(Y.CODIGO.POSTAL, Y.CADENA.DIRECCION)

*CALL PBS.DIRECCION.SEPOMEX(Y.CODIGO.POSTAL, Y.CADENA.DIRECCION)

    Y.ESTADO    = FIELD(Y.CADENA.DIRECCION,Y.SEP,1)
    Y.CD.DESC   = FIELD(Y.CADENA.DIRECCION,Y.SEP,2)
    Y.CIUDAD    = FIELD(Y.CD.DESC,Y.SEPA,1)
    Y.MUNICIPIO = FIELD(Y.CADENA.DIRECCION,Y.SEP,3)
    Y.COLONIA   = FIELD(Y.CADENA.DIRECCION,Y.SEP,4)
    Y.PAIS      = FIELD(Y.CADENA.DIRECCION,Y.SEP,5)

    IF Y.CADENA.DIRECCION EQ "" THEN
        Y.MESSAGE = 'EL CODIGO POSTAL QUE INGRESO NO EXISTE'
        DATOS = '-1':YSEP:'':YSEP:'':YSEP:'':YSEP:'':YSEP:'':YSEP:Y.MESSAGE
    END ELSE
        DATOS = '1':YSEP:ID.COLONIA:YSEP:Y.ESTADO:YSEP:Y.CIUDAD:YSEP:Y.MUNICIPIO:YSEP:Y.PAIS:YSEP:Y.MESSAGE
        PRINT DATOS
    END
*    END

RETURN

END

