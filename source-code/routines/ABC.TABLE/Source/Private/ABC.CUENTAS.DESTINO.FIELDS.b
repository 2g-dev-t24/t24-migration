$PACKAGE AbcTable
SUBROUTINE ABC.CUENTAS.DESTINO.FIELDS

*---------------------------------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    ID.F = "ID"
    ID.T = "A"
    ID.N = "29"
    EB.Template.TableDefineid("ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    EB.Template.TableAddoptionsfield('TIPO.CTA','CUENTA_CLABE_TARJETA DE CREDITO_TARJETA DEBITO_CELULAR', '','')
    EB.Template.TableAddfielddefinition('BANCO', '5', 'ACC', '')
    EB.Template.FieldSetcheckfile("ABC.BANCOS":FM:ABC.BANCOS.BANCO:FM:'A.')
    EB.Template.TableAddoptionsfield('STATUS','ACTIVA_INACTIVA', '','')
    EB.Template.TableAddfielddefinition('ALIAS','50', '', '')
    EB.Template.TableAddfielddefinition('BENEFICIARIO','80', 'A', '')
    EB.Template.TableAddfielddefinition('RFC','13', 'A', '')
    EB.Template.TableAddfielddefinition('EMAIL','70', 'ANY', '')
    EB.Template.TableAddfielddefinition('MOVIL','10', 'A', '')
    EB.Template.TableAddfield("TIP.VERSION", EB.Template.T24String, EB.Template.FieldNoInput, "")
    EB.Template.TableAddfielddefinition('CURP','18', 'A', '')
    EB.Template.TableAddfielddefinition('FECHA.HORA.AUT','15', 'A', '')
    EB.Template.TableAddoptionsfield('VALIDAR','SI_NO', '','')

    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

	EB.Template.TableAddlocalreferencefield('LOCAL.REF')
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END