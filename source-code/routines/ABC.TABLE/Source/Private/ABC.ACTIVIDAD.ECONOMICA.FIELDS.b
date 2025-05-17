$PACKAGE AbcTable
SUBROUTINE ABC.ACTIVIDAD.ECONOMICA.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    ID.F = "ID"
    ID.T = 'A'
    ID.N = '7.1'
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    fieldName = 'DESCRIPTION'
    fieldLength = '200'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'VULNERABLE'
    fieldType = "SI_NO"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)
    
    fieldName = 'SECTOR.ECONOMICO'
    fieldLength = '5'
    fieldType = ""
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('SECTOR.ECONOMICO')

    fieldName = 'PROHIB.OPERAR'
    fieldType = "SI_NO"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)

    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddlocalreferencefield(neighbour)
    EB.Template.TableAddoverridefield()
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------





END
