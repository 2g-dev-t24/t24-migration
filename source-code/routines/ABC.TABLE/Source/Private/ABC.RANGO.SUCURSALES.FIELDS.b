$PACKAGE AbcTable
SUBROUTINE ABC.RANGO.SUCURSALES.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("@ID", EB.Template.T24String)
    EB.SystemTables.setIdF('@ID')
    EB.SystemTables.setIdN('1.1')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------

    fieldName = 'DESCRIPCION'
    fieldLength = '20'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")


    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
