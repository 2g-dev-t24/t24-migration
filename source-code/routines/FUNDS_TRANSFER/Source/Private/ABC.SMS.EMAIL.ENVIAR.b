* @ValidationCode : MjotNjgwOTE3Njg5OkNwMTI1MjoxNzQ0Njc4MDIwNDkyOlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Apr 2025 19:47:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
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
SUBROUTINE ABC.SMS.EMAIL.ENVIAR
*--------------------------------------------------------------------------------------------------
* ROUTINE NAME: ABC.SMS.EMAIL.ENVIAR
* PROJECT NAME: Notificaciones BI
* DEVELOPED BY: CESAR MIRANDA (FYG)
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* 22/04/17 -
*            New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $USING EB.SystemTables
    $USING EB.Template
    $USING ABC.BP
* </region>
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.SMS.EMAIL.ENVIAR')      ;* Full application name including product prefix
    EB.Template.setTableTitle('Notificaciones por Enviar')    ;* Screen title
    EB.Template.setTableStereotype('H')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CUS')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('ABC.EMA')     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')         ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('') ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
