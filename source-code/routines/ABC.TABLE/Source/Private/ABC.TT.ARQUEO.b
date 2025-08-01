*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.TT.ARQUEO
* ======================================================================
* Nombre de Programa : ABC.TT.ARQUEO
* Parametros         :
* Objetivo           : Template para registro de los arqueos de efectivo
* Requerimiento      : CORE-1305 Generar alertas para cuando se exceda el límite de efectivo y cuando se hacen arqueos
* Desarrollador      : CAST - FyG-Solutions
* Compania           : 
* Fecha Creacion     : 
* Modificaciones     :
* ======================================================================

* <region name= Inserts>
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
* </region>
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.TT.ARQUEO')        ;* Full application name including product prefix
    EB.Template.setTableTitle('ARQUEO DE EFECTIVO')  ;* Screen title
    EB.Template.setTableStereotype('H')              ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')                ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')               ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('FIN')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')            ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('TT.ARQ')       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')                 ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')         ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')             ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

    RETURN
END
