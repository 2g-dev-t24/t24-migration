*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.MOVS.CTA.COMISIONISTA.FIELDS
* ======================================================================

    $USING EB.SystemTables
    $USING EB.Template

    EB.Template.TableDefineid('ABC.MOVS.COMI', EB.Template.T24String)

    EB.Template.TableAddfield("CUSTOMER", EB.Template.T24Customer,EB.Template.FieldMandatory, "")
    EB.Template.FieldSetcheckfile("CUSTOMER")

    EB.Template.TableAddfielddefinition("XX<OPERACION.IN", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-MONTO.IN", '20', 'AMT', '')
    EB.Template.TableAddfielddefinition("XX-FECHA.MOV.IN", '10', 'D', '')
    EB.Template.TableAddfielddefinition("XX-CANCELACION.IN", '20', 'ANY', '')
    EB.Template.TableAddfield("XX-ADMIN.COMIS.IN", EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ADMIN")
    EB.Template.TableAddfield("XX-ID.COMI.IN", EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS")
    EB.Template.TableAddfield("XX>COMI.ESTAB.IN", EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ESTABL")
    EB.Template.TableAddfielddefinition("MONTO.TOTAL.IN", '20', 'AMT', '')

    EB.Template.TableAddfielddefinition("XX<OPERACION.OUT", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-MONTO.OUT", '20', 'AMT', '')
    EB.Template.TableAddfielddefinition("XX-FECHA.MOV.OUT", '10', 'D', '')
    EB.Template.TableAddfielddefinition("XX-CANCELACION.OUT", '20', 'ANY', '')
    EB.Template.TableAddfield("XX-ADMIN.COMIS.OUT", EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ADMIN")
    EB.Template.TableAddfield("XX-ID.COMI.OUT", EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS")
    EB.Template.TableAddfield("XX>COMI.ESTAB.OUT", EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ESTABL")
    EB.Template.TableAddfielddefinition("MONTO.TOTAL.OUT", '20', 'AMT', '')

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

