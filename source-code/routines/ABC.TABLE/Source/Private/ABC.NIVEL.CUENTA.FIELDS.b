*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.NIVEL.CUENTA.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('DESCRIPCION', '60', 'ANY', '')     ;* Add a new field
    EB.Template.TableAddfielddefinition('LIMITE', '20', '', '')   ;* Add a new field
    EB.Template.TableAddfielddefinition('MONEDA', '4', 'ANY', '') ;* Add a new field
    EB.Template.TableAddfielddefinition('VALOR.LIMITE', '30', 'AMT', '')    ;* Add a new field
    EB.Template.TableAddfielddefinition('XX<APLICACION', '60', 'ANY', '')   ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-XX.TRANSACCION.CR', '5', 'ANY', '')       ;* Add a new field
    EB.Template.TableAddfielddefinition('XX>XX.TRANSACCION.DR', '5', 'ANY', '')       ;* Add a new field
    EB.Template.TableAddfielddefinition('XX<APLICACION.REST', '60', 'ANY', '')        ;* Add a new field
    EB.Template.TableAddfielddefinition('XX>XX.TRANSACCION.REST', '5', 'ANY', '')     ;* Add a new field



    FOR Y.AA = 10 TO 1 STEP -1          ;*PARA CADA CAMPO NUEVO SE DEBE DE RESTAR 1

        EB.Template.TableAddreservedfield('RESERVED.' : Y.AA)

    NEXT Y.AA
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END
