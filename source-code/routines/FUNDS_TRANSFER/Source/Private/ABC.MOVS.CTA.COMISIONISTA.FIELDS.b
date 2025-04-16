* @ValidationCode : MjotMTY4MDkxOTU1NDpDcDEyNTI6MTc0NDM5MzIzMTk4NzpFZGdhcjotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2025 12:40:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.MOVS.CTA.COMISIONISTA.FIELDS
* ======================================================================
* Nombre de Programa : ABC.MOVS.CTA.COMISIONISTA
* Objetivo           : Template para registro de movimientos CashIn por Cuenta y comisionista
* Requerimiento      : Servicios Cashin - Limite CashIn por Cuenta
* Desarrollador      : Alexis Almaraz Robles - FyG-Solutions
* Compania           : ABC Capital
* Fecha Creacion     : 2023/04/04
* Modificaciones     :
* ======================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_DataTypes
    $USING EB.SystemTables
    $USING EB.Template

*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.MOVS.COMI', T24_String)
    EB.Template.TableAddfield("CUSTOMER", T24_Customer,Field_Mandatory, "")
    EB.Template.FieldSetcheckfile("CUSTOMER")
    EB.Template.TableAddfielddefinition("XX<OPERACION.IN", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-MONTO.IN", '20', 'AMT', '')
    EB.Template.TableAddfielddefinition("XX-FECHA.MOV.IN", '10', 'D', '')
    EB.Template.TableAddfielddefinition("XX-CANCELACION.IN", '20', 'ANY', '')
    EB.Template.TableAddfield("XX-ADMIN.COMIS.IN", T24_String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ADMIN")
    EB.Template.TableAddfield("XX-ID.COMI.IN", T24_String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS")
    EB.Template.TableAddfield("XX>COMI.ESTAB.IN", T24_String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ESTABL")
    EB.Template.TableAddfielddefinition("MONTO.TOTAL.IN", '20', 'AMT', '')
    EB.Template.TableAddfielddefinition("XX<OPERACION.OUT", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-MONTO.OUT", '20', 'AMT', '')
    EB.Template.TableAddfielddefinition("XX-FECHA.MOV.OUT", '10', 'D', '')
    EB.Template.TableAddfielddefinition("XX-CANCELACION.OUT", '20', 'ANY', '')
    EB.Template.TableAddfield("XX-ADMIN.COMIS.OUT", T24_String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ADMIN")
    EB.Template.TableAddfield("XX-ID.COMI.OUT", T24_String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS")
    EB.Template.TableAddfield("XX>COMI.ESTAB.OUT", T24_String, '', '')
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.ESTABL")
    EB.Template.TableAddfielddefinition("MONTO.TOTAL.OUT", '20', 'AMT', '')
    EB.Template.TableAddreservedfield('RESERVED.20')
    EB.Template.TableAddreservedfield('RESERVED.19')
    EB.Template.TableAddreservedfield('RESERVED.18')
    EB.Template.TableAddreservedfield('RESERVED.17')
    EB.Template.TableAddreservedfield('RESERVED.16')
    EB.Template.TableAddreservedfield('RESERVED.15')
    EB.Template.TableAddreservedfield('RESERVED.14')
    EB.Template.TableAddreservedfield('RESERVED.13')
    EB.Template.TableAddreservedfield('RESERVED.12')
    EB.Template.TableAddreservedfield('RESERVED.11')
    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.9')
    EB.Template.TableAddreservedfield('RESERVED.8')
    EB.Template.TableAddreservedfield('RESERVED.7')
    EB.Template.TableAddreservedfield('RESERVED.6')
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')
*-----------------------------------------------------------------------------
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------

RETURN

END

