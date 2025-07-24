* @ValidationCode : MjotMTA1NDUxOTY5ODpDcDEyNTI6MTc1MzMxMjg5MzM2NTpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Jul 2025 20:21:33
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

SUBROUTINE ABC.TARJETAS.MC.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)

    fieldName = 'PRN'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ESTATUS'
    fieldType = "ACTIVA_BLOQUEADA_CANCELADA_EXPIRADA_"
    fieldType := "SOLICITADA_DESHABILITADA_PERDIDA_REGRESADA"
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldType, '', neighbour)

    fieldName = 'PRODUCTO'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile ('ABC.PRODUCTOS.GALILEO':FM:ABC.PROD.NOMBRE.PROD:FM:'L.A')

    fieldName = 'PROGRAMA'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ID.SOLICITUD' ;* ID
    fieldLength = 35
    fieldType = 'A'
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

