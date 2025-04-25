$PACKAGE AbcTable
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.COMPRA.INSTRUMENTO.FIELDS
* ======================================================================

$USING EB.SystemTables
$USING EB.Template

    EB.Template.TableDefineid('ABC.COM.INS.ID', EB.Template.T24String)
    EB.Template.TableAddfield('INSTRUMENTO', EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.INSTRUMENTO.GUBERNAMENTAL")
    EB.Template.TableAddfield('TRANSACCION', EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("CATEGORY")
    EB.Template.TableAddfield('INSTITUCION', EB.Template.T24Customer, '', '')
    EB.Template.FieldSetcheckfile("CUSTOMER")
    EB.Template.TableAddfielddefinition('MONTO', '20', 'ANY', '')
    EB.Template.TableAddfielddefinition('TASA', '10', 'ANY', '')
    EB.Template.TableAddfield('PLAZO', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddfield('EXT', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddfield('PACTO', EB.Template.T24String, '', '')
    EB.Template.TableAddfield('CONFIRMO', EB.Template.T24String, '', '')
    EB.Template.TableAddfield('OPERO.CONTRAPARTE', EB.Template.T24String, '', '')
    EB.Template.TableAddfield('CONFIRMO.CONTRAPAR', EB.Template.T24String, '', '')
    EB.Template.TableAddfield('XX<ID.TRANSACCION', EB.Template.T24String, '', '')
    EB.Template.TableAddfield('XX>STATUS.ID.TRANSAC', EB.Template.T24String, '', '')
    EB.Template.TableAddfield('AC.SYS.LIQ', EB.Template.T24Account, '', '')
    EB.Template.FieldSetcheckfile("ACCOUNT")
    EB.Template.TableAddfield('ASIGNACIONES', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddfielddefinition('PRECIO', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('TITULOS', '35', '', '')
    EB.Template.TableAddfielddefinition('EMISORA', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('SERIE', '35', 'ANY', '')
*-----------------------------------------------------------------------------
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------

END
