* @ValidationCode : Mjo4Njg3MjQ1MjE6Q3AxMjUyOjE3NDQzMDU2MjcxMTA6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2025 12:20:27
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
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.MOVS.CTA.COMISIONISTA
* ======================================================================
* Nombre de Programa : ABC.MOVS.CTA.COMISIONISTA
* Objetivo           : Template para registro de movimientos CashIn por Cuenta y comisionista
* Requerimiento      : Servicios Cashin - Limite CashIn por Cuenta
* Desarrollador      : Alexis Almaraz Robles - FyG-Solutions
* Compania           : ABC Capital
* Fecha Creacion     : 2023/04/04
* Modificaciones     :
* ======================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_Table
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    Table.name              = 'ABC.MOVS.CTA.COMISIONISTA'   ;* Full application name including product prefix
    Table.title             = 'Movimientos CashIn Comisionistas'      ;* Screen title
    Table.stereotype        = 'H'       ;* H, U, L, W or T
    Table.product           = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct        = ''        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'CUS'     ;* As per FILE.CONTROL
    Table.systemClearFile   = 'Y'       ;* As per FILE.CONTROL
    Table.relatedFiles      = ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix      = 'MOVS.AC.COMI'      ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''        ;* Space delimeted list of blocked functions
    Table.trigger           = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN

END

