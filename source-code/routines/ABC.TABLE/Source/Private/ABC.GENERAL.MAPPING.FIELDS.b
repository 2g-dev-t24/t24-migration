* @ValidationCode : Mjo5MTczODYwNjk6Q3AxMjUyOjE3NDQwNjMwNjc5NzA6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2025 18:57:47
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
SUBROUTINE ABC.GENERAL.MAPPING.FIELDS
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


    EB.Template.TableAddfielddefinition('DESCRIPCION', '100.1', 'A', '')
    EB.Template.TableAddfielddefinition('XX<VALOR.ENTRADA', '65', 'A', '')
    EB.Template.TableAddfielddefinition('XX-DESC.ENTRADA', '200', 'A', '')
    EB.Template.TableAddfielddefinition('XX-VALOR.T24.MAPEO', '65', 'A', '')
    EB.Template.TableAddfielddefinition('XX-DESC.T24', '200', 'A', '')
    EB.Template.TableAddfielddefinition('XX>RESERVADO01', '65', 'A', '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.7")
    EB.Template.TableAddreservedfield("RESERVED.8")
    EB.Template.TableAddreservedfield("RESERVED.9")
    EB.Template.TableAddreservedfield("RESERVED.10")
    EB.Template.TableAddreservedfield("RESERVED.11")
    EB.Template.TableAddreservedfield("RESERVED.12")
    EB.Template.TableAddreservedfield("RESERVED.13")
    EB.Template.TableAddreservedfield("RESERVED.14")
    EB.Template.TableAddreservedfield("RESERVED.15")
    
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
END
