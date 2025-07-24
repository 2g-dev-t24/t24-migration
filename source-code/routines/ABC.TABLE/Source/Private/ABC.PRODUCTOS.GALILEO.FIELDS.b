* @ValidationCode : MjoyMDgxOTQzNzkzOkNwMTI1MjoxNzUzMzEzOTYxNTkyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Jul 2025 20:39:21
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

SUBROUTINE ABC.PRODUCTOS.GALILEO.FIELDS
    
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("PROD.ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    fieldName = 'NOMBRE.PROD'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NOMB.CORTO'
    fieldLength = 10
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DESCRIPCION'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ID.PROGRAMA'
    fieldLength = 15
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NOM.PROGRAMA'
    fieldLength = 30
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddreservedfield("RESERVED.17")
    EB.Template.TableAddreservedfield("RESERVED.16")
    EB.Template.TableAddreservedfield("RESERVED.15")
    EB.Template.TableAddreservedfield("RESERVED.14")
    EB.Template.TableAddreservedfield("RESERVED.13")
    EB.Template.TableAddreservedfield("RESERVED.12")
    EB.Template.TableAddreservedfield("RESERVED.11")
    EB.Template.TableAddreservedfield("RESERVED.10")
    EB.Template.TableAddreservedfield("RESERVED.9")
    EB.Template.TableAddreservedfield("RESERVED.8")
    EB.Template.TableAddreservedfield("RESERVED.7")
    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
