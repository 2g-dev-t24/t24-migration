* @ValidationCode : MjotMjEyNDA0MDk3ODpDcDEyNTI6MTc0NDgxNjA4MDU1MTpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Apr 2025 12:08:00
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
SUBROUTINE ABC.COLONIA.FIELDS
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


    EB.Template.TableAddfielddefinition("COLONIA", '60', 'A', '')

    EB.Template.TableAddfield("TIPO.ASENT", EB.Template.T24String, EB.Template.FieldNoInput, "")
    EB.Template.FieldSetcheckfile("ABC.TIPO.ASENTAMIENTO")
    
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    
    EB.Template.TableSetauditposition()


END
