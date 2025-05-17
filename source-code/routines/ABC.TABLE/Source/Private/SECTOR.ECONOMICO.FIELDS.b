*-----------------------------------------------------------------------------
$PACKAGE AbcTable
SUBROUTINE SECTOR.ECONOMICO.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    ID.F = "ID"
    ID.T = ''
    ID.N = '5.5'
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'DESCRIPTION'
    fieldLength = '150'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
END