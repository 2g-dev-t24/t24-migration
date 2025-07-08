*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.MOVS.CTA.NIVEL2.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", T24_String)         ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfield("CUSTOMER", T24_Customer,Field_Mandatory, "")
    EB.Template.FieldSetcheckfile("CUSTOMER")
    EB.Template.TableAddfielddefinition("FECHA.INI", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("FECHA.FIN", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX<ID.OPERACION", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-FECHA.MOV", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX>MONTO.MOV", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("MONTO.TOTAL", '20', 'ANY', '')
    EB.Template.TableAddreservedfield("RESERVED.10")
    EB.Template.TableAddreservedfield("RESERVED.9")
    EB.Template.TableAddreservedfield("RESERVED.8")
    EB.Template.TableAddreservedfield("RESERVED.7")
    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
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
