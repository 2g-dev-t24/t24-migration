*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.SMS.EMAIL.TO.SEND.FIELDS
* ======================================================================

    $USING EB.SystemTables
    $USING EB.Template

    EB.Template.TableDefineid('ID', EB.Template.T24String)
    EB.SystemTables.setIdF('KEY')
    EB.SystemTables.setIdN('20.1')
    EB.SystemTables.setIdT('A')

    EB.Template.TableAddfielddefinition("CUSTOMER.ID", '10.10', 'A', '')
    EB.Template.TableAddfielddefinition("DEBIT.ACCT.NO", '11', 'A', '')
    EB.Template.TableAddfielddefinition("CREDIT.ACCT.NO", '18', 'A', '')
    EB.Template.TableAddoptionsfield("TRANS.TYPE", 'AC_ATM_BIAT_BIAI_BIMT_BIMI_BIBT_BIBI_BIAC_BIMC_BIBC_BIAD_BIMD_BIBD_CUEM_CUMO_POS_SPEI_BACE_BMCE_BBCE', '', '')
    EB.Template.TableAddfielddefinition("AMOUNT", '250', 'A', '')
    EB.Template.TableAddfielddefinition("DATE.TIME", "250", 'A', '')
    EB.Template.TableAddfielddefinition("STATUS", '250', 'A', '')
    EB.Template.TableAddfielddefinition("OLD.EMAIL", '80', 'A', '')
    EB.Template.TableAddfielddefinition("OLD.MOVIL", '15', 'A', '')
    EB.Template.TableAddfielddefinition("NEW.EMAIL", '80', 'A', '')
    EB.Template.TableAddfielddefinition("NEW.MOVIL", '15', 'A', '')
    EB.Template.TableAddfielddefinition("XX.CTA.TERCERO", '11', 'A', '')
    EB.Template.TableAddfielddefinition("XX.CTA.INTERBA", '18', 'A', '')
    EB.Template.TableAddfielddefinition("XX.CTA.CREDITO", '18', 'A', '')
    EB.Template.TableAddfielddefinition("XX.CTA.DEBITO", '18', 'A', '')
    EB.Template.TableAddfielddefinition("XX.CTA.CELULAR", '18', 'A', '')
    EB.Template.TableAddfielddefinition("VALUE.DATE", '8', 'D', '')
    EB.Template.TableAddfielddefinition("INPUTTER", '16', 'A', '')
    EB.Template.TableAddfielddefinition("AUTHORISER", '16', 'A', '')
*-----------------------------------------------------------------------------

    RETURN

END