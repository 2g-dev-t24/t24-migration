* @ValidationCode : MjotMTQyNDQzODE2ODpDcDEyNTI6MTc0NDczMDMxMDU3MDpFZGdhcjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Apr 2025 10:18:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.COMISIONISTAS
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here.
* @PATRICIA SOSA
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 29/09/15 - EN_10003543
*            New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_Table
* </region>
*-----------------------------------------------------------------------------
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.COMISIONISTAS');* Full application name including product prefix
    EB.Template.setTableTitle('Template para Comisionistas')   ;* Screen title
    EB.Template.setTableStereotype('H')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CUS')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('AC')     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')         ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('') ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
