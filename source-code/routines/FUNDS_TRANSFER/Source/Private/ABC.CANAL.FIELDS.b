* @ValidationCode : Mjo4MzYwNTk5Mjc6Q3AxMjUyOjE3NDQ0MTkxODU4ODU6RWRnYXI6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2025 19:53:05
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

*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.CANAL.FIELDS
*===============================================
* Nombre de Programa:   ABC.CANAL.FIELDS
* Objetivo:             Tabla para parametrizar el canal de donde proviene la
*      peticion.
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC CAPITAL
* Fecha Creacion:       30 - Abr - 2020
* Modificaciones:
*===============================================
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_DataTypes
    $USING EB.Template
*** </region>
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("TABLE.NAME.ID", T24_Numeric)       ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('DESCRIPCION', '60', 'ANY', '')     ;* Add a new field
    EB.Template.TableAddfielddefinition('XX.USUARIO', '40', 'ANY', '')      ;* Add a new field
    EB.Template.TableAddfielddefinition('MNEMONIC', '10', 'ANY', '')        ;* Add a new field

    FOR Y.AA = 10 TO 1 STEP -1          ;*PARA CADA CAMPO NUEVO SE DEBE DE RESTAR 1

        EB.Template.TableAddreservedfield('RESERVED.' : Y.AA)

    NEXT Y.AA
*CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
