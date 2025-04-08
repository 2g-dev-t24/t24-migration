*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.LOCALIDAD
*===============================================
* Nombre de Programa:   ABC.LOCALIDAD
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
    $USING ABC.BP
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.LOCALIDAD')      ;* Full application name including product prefix
    EB.Template.setTableTitle('ABC.LOCALIDAD')    ;* Screen title
    EB.Template.setTableStereotype('H')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CUS')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('ABC.LOCALIDAD')     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')         ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('') ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

    RETURN
END
