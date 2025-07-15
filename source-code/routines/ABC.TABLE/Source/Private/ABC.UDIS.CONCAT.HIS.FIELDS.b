* @ValidationCode : Mjo1Mzc1OTg2MTI6Q3AxMjUyOjE3NTIyNDI2NzU1MjI6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jul 2025 11:04:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.UDIS.CONCAT.HIS.FIELDS
    
    
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------


    EB.Template.TableAddfielddefinition('PERIODO'           ,50, 'A'    , '')
    EB.Template.TableAddfielddefinition('TOTAL.UDIS'        ,30, 'AMT'  , '')
    EB.Template.TableAddfielddefinition('TOTAL.LCY'         ,30, 'AMT'  , '')
    EB.Template.TableAddfielddefinition('XX-DETALLE.TXN'    ,50, 'A'    , '')
    EB.Template.TableAddfielddefinition('FEC.ULT.MOV'       ,10, 'D'    , '')

END