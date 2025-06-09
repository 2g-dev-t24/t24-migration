* @ValidationCode : Mjo1OTU4NzIyMjA6Q3AxMjUyOjE3NDk0ODk2NDg1OTY6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jun 2025 14:20:48
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
SUBROUTINE ABC.CIUDAD.FIELDS
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


    EB.Template.TableAddfielddefinition('CIUDAD',50, 'A', '')
    EB.Template.TableAddfielddefinition('RANGO1',5, 'A', '')
    EB.Template.TableAddfielddefinition('RANGO2',5, 'A', '')
    EB.Template.TableAddfielddefinition('RANGO3',5, 'A', '')
    EB.Template.TableAddfielddefinition('RANGO4',5, 'A', '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableSetauditposition()

END
