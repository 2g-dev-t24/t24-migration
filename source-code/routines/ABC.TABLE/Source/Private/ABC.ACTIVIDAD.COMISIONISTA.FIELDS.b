$PACKAGE AbcTable
SUBROUTINE ABC.ACTIVIDAD.COMISIONISTA.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ABC.ACT.COMI.ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

	fieldName	= 'ACT.COMI'
	fieldLength = '2'
	fieldType	= ''
	neighbour	= ''
	EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddfield('DESCRIPCION', EB.Template.T24String,'', '')

    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddreservedfield("XX.OVERRIDE")

	EB.Template.TableAddlocalreferencefield('LOCAL.REF')
    EB.Template.TableAddoverridefield()         
    EB.Template.TableSetauditposition()         

END
