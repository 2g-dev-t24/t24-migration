*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.INFO.VAL.CUS
*===============================================
* Nombre de Programa:   ABC.INFO.VAL.CUS
* Objetivo:             Tabla concat que almacenar información para la validación
*                       de duplicidad de clientes.
*===============================================

    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
    $USING ABC.BP
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.INFO.VAL.CUS')  ;* Full application name including product prefix
    EB.Template.setTableTitle('Tabla concat info cliente')         ;* Screen title
    EB.Template.setTableStereotype('L')       ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')        ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('INT')     ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('N')       ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')        ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('VAL.CUS') ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')         ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')         ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')         ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

    RETURN
END
