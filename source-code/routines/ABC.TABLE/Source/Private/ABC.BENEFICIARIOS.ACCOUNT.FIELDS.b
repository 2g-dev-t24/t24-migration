* @ValidationCode : Mjo1NDA2MzA0OTI6Q3AxMjUyOjE3NTE1MTIwNjQxOTM6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Jul 2025 00:07:44
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

SUBROUTINE ABC.BENEFICIARIOS.ACCOUNT.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('XX<APE.PATERNO'    ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-APE.MATERNO'    ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-NOMBRES'        ,'100'  , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FEC.NAC'        ,'8'    , 'D', '')
    EB.Template.TableAddfielddefinition('XX-PORCENTAJE'     ,'3'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX>EMAIL'          ,'100'  , 'A', '')


    EB.Template.TableSetauditposition()

END
