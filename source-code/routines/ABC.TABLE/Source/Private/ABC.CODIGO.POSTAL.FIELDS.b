* @ValidationCode : MjotMTA3NTI0NzEzOkNwMTI1MjoxNzQ0NjM1Mjc3OTMxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Apr 2025 09:54:37
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
SUBROUTINE ABC.CODIGO.POSTAL.FIELDS
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


    EB.Template.TableAddfielddefinition('ESTADO',2, 'A', '')
    EB.Template.FieldSetcheckfile('ABC.ESTADO')
    
    EB.Template.TableAddfielddefinition('CIUDAD',4, 'A', '')
    EB.Template.FieldSetcheckfile('ABC.CIUDAD')
    
    EB.Template.TableAddfielddefinition('MUNICIPIO',5, 'A', '')
    EB.Template.FieldSetcheckfile('ABC.MUNICIPIO')
    
    EB.Template.TableAddfielddefinition('XX.COLONIA',17, 'A', '')
    EB.Template.FieldSetcheckfile('ABC.COLONIA')


END
