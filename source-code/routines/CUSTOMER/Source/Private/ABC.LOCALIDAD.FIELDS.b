*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.LOCALIDAD.FIELDS
*===============================================
* Nombre de Programa:   
* Objetivo:
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
    $USING ABC.BP
*-----------------------------------------------------------------------------
    ID.F = "ID.CODE"
    ID.T = 'A'
    ID.N = '12'
    EB.Template.TableDefineid("ID.CODE", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'ID.DESCRIPTION'
    fieldLength = 100
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

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
