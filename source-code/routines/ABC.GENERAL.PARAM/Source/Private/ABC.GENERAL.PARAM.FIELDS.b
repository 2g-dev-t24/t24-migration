* @ValidationCode : MjoxMDM4NjQ0NjU0OkNwMTI1MjoxNzQzNzIyOTAyMzY5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Apr 2025 20:28:22
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
$PACKAGE AbcGeneralParam
SUBROUTINE ABC.GENERAL.PARAM.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.REG.COMISIONISTAS.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------


    EB.Template.TableAddfielddefinition('MODULO', '100.1', 'A', '')
    EB.Template.TableAddfielddefinition('XX<NOMB.PARAMETRO', '80.1', 'A', '')
    EB.Template.TableAddfielddefinition('XX-DATO.PARAMETRO', '80.1', 'A', '')
    EB.Template.TableAddfielddefinition('XX>COMENTARIO', '100.1', 'A', '')
    
    EB.Template.TableSetauditposition()

END
END
