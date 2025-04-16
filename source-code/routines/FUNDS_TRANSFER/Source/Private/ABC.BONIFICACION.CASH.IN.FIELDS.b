* @ValidationCode : MjotMjA4Mzc4MDc2ODpDcDEyNTI6MTc0NDM5MjU3MDgzODpFZGdhcjotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 12:29:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------

SUBROUTINE ABC.BONIFICACION.CASH.IN.FIELDS
*===============================================
* Nombre de Programa:   ABC.BONIFICACION.CASH.IN
* Objetivo:
* Desarrollador:        Luis Fernando Cruz - FyG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       02-AGO-2022
* Modificaciones:
*===============================================
* <region name= Inserts>
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
* </region>
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ACCT.ID", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfield("CUSTOMER", T24_Customer,Field_Mandatory, "")
    EB.Template.FieldSetcheckfile("CUSTOMER")
    EB.Template.TableAddfielddefinition("XX<ID.OPERACION", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-MONTO.MOV", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-ID.OPER.CANCELA", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX>FECHA.MOV", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("NUM.OPERACIONES", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("MONTO.TOTAL", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("NUM.OPER.BONIFICAN", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("MONTO.A.BONIFICAR", '20', 'ANY', '')
    EB.Template.TableAddoptionsfield("BONIFICADO", 'SI_NO', '', '')
    EB.Template.TableAddfielddefinition("ID.BONIFICACION", '20', 'ANY', '')
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
    EB.Template.TableAddlocalreferencefield(neighbour)
    EB.Template.TableAddoverridefield()

*  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*  CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
