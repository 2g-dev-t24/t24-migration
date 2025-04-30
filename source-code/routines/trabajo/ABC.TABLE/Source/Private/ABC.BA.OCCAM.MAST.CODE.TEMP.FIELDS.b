* @ValidationCode : MjoxNTI0NTU5MDMyOkNwMTI1MjoxNzQ0ODI2OTE1NDU5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 15:08:35
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
SUBROUTINE ABC.BA.OCCAM.MAST.CODE.TEMP.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    
    EB.Template.TableAddfielddefinition('FEC.CREACION'            ,'6', 'D', '')
    EB.Template.TableAddfielddefinition('FEC.ENVIO'               ,'4', 'D', '')
    EB.Template.TableAddfielddefinition('XX<TIPO.ARCH'            ,'24', 'A', '')
    EB.Template.TableAddfielddefinition('XX-CODIGO'               ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('XX>DESC.ARCH'            ,'13', 'A', '')
    
    EB.Template.TableSetauditposition()

END


