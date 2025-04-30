* @ValidationCode : Mjo5NzU4NDUzOTM6Q3AxMjUyOjE3NDU3ODQ4NTY0MTk6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2025 17:14:16
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
    
    EB.Template.TableSetauditposition()


END
