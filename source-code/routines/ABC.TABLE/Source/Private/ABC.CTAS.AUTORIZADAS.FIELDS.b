$PACKAGE AbcTable
SUBROUTINE ABC.CTAS.AUTORIZADAS.FIELDS

*---------------------------------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('XX<APE.PATERNO','35', 'A', '')
    EB.Template.TableAddfielddefinition('XX-APE.MATERNO','35', 'A', '')
    EB.Template.TableAddfielddefinition('XX-NOMBRE','35', 'A', '')
    EB.Template.TableAddfielddefinition('XX-RFC','13', 'A', '')
    EB.Template.TableAddfielddefinition('XX-CURP','18', 'A', '')
    EB.Template.TableAddfielddefinition('XX>CTA.CLABE','18', 'A', '')

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END