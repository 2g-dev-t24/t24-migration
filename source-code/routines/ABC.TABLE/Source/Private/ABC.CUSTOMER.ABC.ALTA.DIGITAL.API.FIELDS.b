* @ValidationCode : MjotMjA2NjY0NTQ2NzpDcDEyNTI6MTc0NjEyNjg4NzI1MjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 May 2025 16:14:47
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
SUBROUTINE ABC.CUSTOMER.ABC.ALTA.DIGITAL.API.FIELDS
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

    
    EB.Template.TableAddfielddefinition('SHORT.NAME'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('NAME.1'            ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('NAME.2'            ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DATE.OF.BIRTH'     ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LUG.NAC'           ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('GENDER'            ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('EXTERN.CUS.ID'     ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('SMS.1'             ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('EMAIL.1'           ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('STREET'            ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ADDRESS.1.1'       ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ADDRESS.1.2'       ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('POST.CODE'         ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.COLONIA'       ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.DOC.NAME'    ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.ID'          ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.ISS.DATE'    ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.EXP.DATE'    ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('TAX.ID'            ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DOM.FISC'          ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('USO.CFDI'          ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('CANAL'             ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('REG.FISCAL'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ID.CUSTOMER'       ,'100', 'A', '')
    EB.Template.TableSetauditposition()
    
END

