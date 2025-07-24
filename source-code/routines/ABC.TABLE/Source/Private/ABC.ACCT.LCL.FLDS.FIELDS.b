$PACKAGE AbcTable

SUBROUTINE ABC.ACCT.LCL.FLDS.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('XX<APE.PATERNO'    ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-APE.MATERNO'    ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-NOMBRES'        ,'100'  , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FEC.NAC'        ,'8'    , 'D', '')
    EB.Template.TableAddfielddefinition('XX-PORCENTAJE'     ,'3'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX>EMAIL'          ,'100'  , 'A', '')

    fieldName = 'PREG.FON.TER'
    fieldType = "SI_NO"
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, fieldType, '', neighbour)


    EB.Template.TableSetauditposition()

END
