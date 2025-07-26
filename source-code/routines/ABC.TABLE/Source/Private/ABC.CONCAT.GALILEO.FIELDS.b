* @ValidationCode : MjozNjM1MzI0MzY6Q3AxMjUyOjE3NTM0NjA0NDM3MzI6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2025 13:20:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.CONCAT.GALILEO.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("AUTH.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    fieldName = 'ACLK.ID'
    fieldLength = '20'
    fieldType = 'A'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'FT.GENERADO'
    fieldLength = '20'
    fieldType = 'A'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'FECHA'
    fieldLength = '20'
    fieldType = 'D'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'REVE.ID'
    fieldLength = '20'
    fieldType = 'A'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'ESTATUS'
    fieldLength = '20'
    fieldType = 'A'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

RETURN
    
    

END
