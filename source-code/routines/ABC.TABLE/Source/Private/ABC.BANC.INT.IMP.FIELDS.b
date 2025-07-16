*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.BANC.INT.IMP.FIELDS
* ======================================================================

    $USING EB.SystemTables
    $USING EB.Template

    EB.Template.TableDefineid('ID', EB.Template.T24String)
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdN('19')
    EB.SystemTables.setIdT('A')

    EB.Template.TableAddoptionsfield("EST.CONT", 'N_S', '', '')
    EB.Template.TableAddoptionsfield("EST.IMP.CONT", 'R', '', '')
    EB.Template.TableAddfielddefinition("XX<ID.CTA", '18.11', 'A', '')
    EB.Template.TableAddoptionsfield("XX-TIPO.CTA", 'CUENTA_CLABE_TARJETA DE CREDITO_TARJETA DEBITO_CELULAR', '', '')
    EB.Template.TableAddfielddefinition("XX-BANCO", '3', '', '')
    EB.Template.TableAddoptionsfield("XX-STATUS", "ACTIVA_INACTIVA", '', '')
    EB.Template.TableAddfielddefinition("XX-ALIAS", '50', 'A', '')
    EB.Template.TableAddfielddefinition("XX-BENEFICIARIO", '80.5', 'A', '')
    EB.Template.TableAddfielddefinition("XX-RFC", '13', 'A', '')
    EB.Template.TableAddfielddefinition("XX-EMAIL", '30', 'A', '')
    EB.Template.TableAddfielddefinition("XX-MOVIL", '10', 'A', '')
    EB.Template.TableAddoptionsfield("XX>TIP.MOD", 'A_B_M', '', '')

    EB.Template.TableAddreservedfield('RESERVED.20')
    EB.Template.TableAddreservedfield('RESERVED.19')
    EB.Template.TableAddreservedfield('RESERVED.18')
    EB.Template.TableAddreservedfield('RESERVED.17')
    EB.Template.TableAddreservedfield('RESERVED.16')
    EB.Template.TableAddreservedfield('RESERVED.15')
    EB.Template.TableAddreservedfield('RESERVED.14')
    EB.Template.TableAddreservedfield('RESERVED.13')
    EB.Template.TableAddreservedfield('RESERVED.12')
    EB.Template.TableAddreservedfield('RESERVED.11')
    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.9')
    EB.Template.TableAddreservedfield('RESERVED.8')
    EB.Template.TableAddreservedfield('RESERVED.7')
    EB.Template.TableAddreservedfield('RESERVED.6')
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')

*-----------------------------------------------------------------------------
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------

    RETURN

END
