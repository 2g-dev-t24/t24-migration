*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.EMAIL.SMS.PARAMETER.FIELDS
* ======================================================================

    $USING EB.SystemTables
    $USING EB.Template

    EB.Template.TableDefineid('ID', EB.Template.T24String)
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdN('6.6.C')
    EB.SystemTables.setIdT('A')

    EB.Template.TableAddfielddefinition("OFS.SOURCE", '15.3.C', 'A', '')
    EB.Template.TableAddfielddefinition("NUM.MENSAJE", '4.1', '', '')
    EB.Template.TableAddoptionsfield("SMS.ACTIVO", 'N_S', '', '')
    EB.Template.TableAddfielddefinition("BANK.ID", '3..C', '', '')
    EB.Template.TableAddfielddefinition("BANK.CUST", '10..C', '', '')
    EB.Template.TableAddfielddefinition("BANK.NAME", "100..C", 'A', '')
    EB.Template.TableAddoptionsfield("XX<TRAN.TYPE", 'AC_ATM_BIAT_BIAI_BIMT_BIMI_BIBT_BIBI_BIAC_BIMC_BIBC_BIAD_BIMD_BIBD_CUEM_CUMO_POS_SPEI_BACE_BMCE_BBCE', '', '')
    EB.Template.TableAddfielddefinition("XX-XX.TRANSACTION", '4..C', 'A', '')
    EB.Template.TableAddfielddefinition("XX>SUBJECT", '150.10', 'A', '')
    EB.Template.TableAddfielddefinition("PHONE.1", '20.3', 'A', '')
    EB.Template.TableAddfielddefinition("PHONE.2", '20.3', 'A', '')
    EB.Template.TableAddoptionsfield("XX<TRAN.TYPE.2", 'AC_ATM_BIAT_BIAI_BIMT_BIMI_BIBT_BIBI_BIAC_BIMC_BIBC_BIAD_BIMD_BIBD_CUEM_CUMO_POS_SPEI_BACE_BMCE_BBCE', '', '')
    EB.Template.TableAddfielddefinition("XX>ENV.CAMBIO.EST", 'N_S', '', '')
    EB.Template.TableAddfielddefinition("EMAIL.USUARIO", '80', 'A', '')
    EB.Template.TableAddfielddefinition("EMAIL.OPERACION", '80.7', 'A', '')
    fieldName = 'XX<EMAIL.ACC.MIN'
    fieldLength = '2.1.C'
    fieldType<1> = 'A'
    fieldType<3> = 'NOEXPAND'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.TableAddfielddefinition("XX-EMAIL.DOM.MIN", '2.1.C', 'A', '')
    EB.Template.TableAddfielddefinition("XX>EMAIL.MAX.DOT", '1.1.C', 'A', '')
    EB.Template.TableAddfielddefinition("XX.VAL.GEN.DOM", '5.4', 'A', '')
    EB.Template.TableAddfielddefinition("INVALID.CHAR", '60', 'ANY', '')

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
