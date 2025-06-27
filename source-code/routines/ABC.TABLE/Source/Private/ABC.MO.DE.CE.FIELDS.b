$PACKAGE AbcTable
SUBROUTINE ABC.MO.DE.CE.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdN('2.1')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('DESCRIPCION', '60.1', 'A', '')
    
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
END
