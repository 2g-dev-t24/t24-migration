$PACKAGE AbcTable
SUBROUTINE ABC.CTAS.AUTORIZADAS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.CTAS.AUTORIZADAS')     ;* Full application name including product prefix
    EB.Template.setTableTitle('Cuentas Externas Autorizadas')    ;* Screen title
    EB.Template.setTableStereotype('U')    ;* H, U, L, W or T
    EB.Template.setTableProduct('AC')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CST')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('N')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('VCAU')         ;* Use to create I_F.EB.LOG.PARAMETER
    EB.Template.setTableIdprefix('')       ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')         ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields

RETURN
*-----------------------------------------------------------------------------
END