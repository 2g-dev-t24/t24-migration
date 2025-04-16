$PACKAGE AbcTable
SUBROUTINE ABC.AA.BULK.AUTHORISE.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("@ID", EB.Template.T24String)
    EB.SystemTables.setIdF('@ID')
    EB.SystemTables.setIdN('40')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------

    fieldName = 'XX.ARRANGEMENT.ID'
    fieldLength = 17
    fieldType<1> = 'ARR'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    
    fieldName = 'CONTADOR'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) 

    EB.Template.TableAddoverridefield()         ;* Add override field
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
    RETURN
END
