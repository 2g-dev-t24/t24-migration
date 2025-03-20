*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.INFO.VAL.CUS.FIELDS
*===============================================
* Nombre de Programa:   ABC.INFO.VAL.CUS
* Objetivo:             Tabla concat que almacenar información para la validación
*===============================================

    $USING EB.SystemTables
    $USING EB.Template
    $USING ABC.BP
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ABC.RFC.ID", EB.Template.T24String) ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('XX<RFC', '13', 'A', '')  ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-CURP', '20', 'A', '') ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-CLIENTE', '11', 'A', '')        ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-GENDER', '10', 'A', '')         ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-DATE.OF.BIRTH', '11', 'A', '')  ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-ESTADO', '2', 'A', '')          ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-SHORT.NAME', '40', 'A', '')     ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-NAME.1', '40', 'A', '')         ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-NAME.2', '40', 'A', '')         ;* Add a new field
    EB.Template.TableAddfielddefinition('XX>NOM.PER.MORAL', '80', 'A', '')  ;* Add a new field

    RETURN
*-----------------------------------------------------------------------------
END
