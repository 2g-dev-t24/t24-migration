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
    EB.Template.TableDefineId("ABC.RFC.ID", EB.Template.T24String) ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddFieldDefinition('XX<RFC', '13', 'A', '')  ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-CURP', '20', 'A', '') ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-CLIENTE', '11', 'A', '')        ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-GENDER', '10', 'A', '')         ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-DATE.OF.BIRTH', '11', 'A', '')  ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-ESTADO', '2', 'A', '')          ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-SHORT.NAME', '40', 'A', '')     ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-NAME.1', '40', 'A', '')         ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX-NAME.2', '40', 'A', '')         ;* Add a new field
    EB.Template.TableAddFieldDefinition('XX>NOM.PER.MORAL', '80', 'A', '')  ;* Add a new field

    RETURN
*-----------------------------------------------------------------------------
END
