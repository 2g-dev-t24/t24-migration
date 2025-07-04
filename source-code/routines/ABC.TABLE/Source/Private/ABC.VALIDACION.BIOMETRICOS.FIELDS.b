* @ValidationCode : MjotMTQ2MzU3NzcwNjpDcDEyNTI6MTc0NTk2NDEyNjA0MjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Apr 2025 19:02:06
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
SUBROUTINE ABC.VALIDACION.BIOMETRICOS.FIELDS
*===============================================
* Nombre de Programa:   ABC.VALIDACION.BIOMETRICOS.FIELDS
* Objetivo:
* Desarrollador:
* Compania:
* Fecha Creacion:
*===============================================

    $USING EB.Template
    $USING EB.SystemTables

*-----------------------------------------------------------------------------

 
    EB.Template.TableDefineid("ID", EB.Template.T24BigString)
*-----------------------------------------------------------------------------

    fieldName = 'CUC'
    fieldLength = 10
    fieldType = "A"
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('CUSTOMER')
    
    fieldName = 'RESPUESTA'
    fieldType = "TRUE_FALSE"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)


    fieldName = 'VERIFICADO'
    fieldType = "SI_NO"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)

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
    EB.Template.TableSetauditposition()


RETURN
*-----------------------------------------------------------------------------
END
