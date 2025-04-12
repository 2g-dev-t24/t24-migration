*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.EMAIL.DOM.TERR.FIELDS
*===============================================
* Nombre de Programa:   ABC.EMAIL.DOM.TERR
* Objetivo:
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
    $USING ABC.BP
*-----------------------------------------------------------------------------
    ID.F = "ID"
    ID.T = 'A'
    ID.N = '4'
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    fieldName = 'COUNTRY.ID'
    fieldLength = 3
    fieldType = "A"
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('COUNTRY')

    fieldName = 'DOMINIO'
    fieldLength = 5
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
