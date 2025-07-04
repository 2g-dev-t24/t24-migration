* @ValidationCode : MjotNjEwNzM3Nzk2OkNwMTI1MjoxNzUxNTgwMDk0MTE0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Jul 2025 19:01:34
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
SUBROUTINE ABC.CUENTA.L4.API.FIELDS
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
    EB.Template.TableAddfielddefinition('ACCOUNT'           ,'20'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX<APE.PATERNO'    ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-APE.MATERNO'    ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-NOMBRES'        ,'100'  , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FEC.NAC'        ,'8'    , 'D', '')
    EB.Template.TableAddfielddefinition('XX-PORCENTAJE'     ,'3'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX>EMAIL'          ,'100'  , 'A', '')


    EB.Template.TableSetauditposition()
END
