$PACKAGE AbcTable
SUBROUTINE ABC.CLUB.INVST.ACCOUNT.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ACCOUNT.NO", EB.Template.T24String)
    EB.SystemTables.setIdN('19')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------

	fieldName	= 'XX.ARRANGEMENT.ID'
	fieldLength = '35'
	fieldType	= 'ARR'
	neighbour	= ''
	EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

	fieldName	= 'TOTAL.AMT'
	fieldLength = '25'
	fieldType	= 'AMT'
	neighbour	= ''
	EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

	EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()         
    EB.Template.TableSetauditposition()         

END
