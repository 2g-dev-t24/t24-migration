*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.BIOMETRICOS.FIELDS
*===============================================
* Nombre de Programa:   ABC.PAGOS.DIGITAL
* Objetivo:
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
    $USING ABC.BP
*-----------------------------------------------------------------------------
    ID.F = "IUB"
    ID.T = 'A'
    ID.N = '11'
    EB.Template.TableDefineid("IUB", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'NOMBRE'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'APP'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'APM'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CURP'
    fieldLength = 18
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ID.IDENTIFICACION'
    fieldLength = 30
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.EMISION'
    fieldLength = 8
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.VENCIMIENTO'
    fieldLength = 8
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CELULAR'
    fieldLength = 10
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'EMAIL'
    fieldLength = 50
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'LATITUD'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'LONGITUD'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CIC'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'OCR'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CUC'
    fieldLength = 10
    fieldType = "A"
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('CUSTOMER')

    fieldName = 'EJECUTIVO'
    fieldLength = 35
    fieldType = "A"
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TIPO.ENROLAMIENTO'
    fieldType = "EJECUTIVO_CLIENTE_AMBOS"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)

    fieldName = 'FOLIO.VALIDACION'
    fieldLength = 36
    fieldType = "A"
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'VERIFICADO'
    fieldType = "SI_NO"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)

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

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END
