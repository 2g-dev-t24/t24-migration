* @ValidationCode : MjotMTIxNjU2MDQ1NDpDcDEyNTI6MTc1MjYzMDQ1MDc2MzptYXVyaWNpby5sb3BlejotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jul 2025 22:47:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.PARAM.PROCESO.FIELDS

*---------------------------------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)         ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName       = 'XX<APLICACION'
    fieldLength     = '35.5.C'
    fieldType<2>    = 'ABC.AA.PRE.PROCESS_FUNDS.TRANSFER'
    neighbour       = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName       = 'XX-CATEGORIA'
    fieldLength     = '6'
    fieldType       = 'A'
    neighbour       = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('CATEGORY':FM:EB.CAT.SHORT.NAME:FM:'L')

    fieldName       = 'XX-HORA.INI'
    fieldLength     = '8.1.C'
    fieldType       = 'A'
    fieldType<4>    = '##:##:##'
    neighbour       = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName       = 'XX-HORA.FIN'
    fieldLength     = '8.1.C'
    fieldType       = 'A'
    fieldType<4>    = '##:##:##'
    neighbour       = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName       = 'XX-NARRATIVA'
    fieldLength     = '35.5.C'
    fieldType       = 'A'
    neighbour       = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName       = 'XX>ESTATUS'
    fieldLength     = '6.6.C'
    fieldType       = ''
    fieldType<2>    = 'ACTIVA_INACTIVA'
    neighbour       = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------