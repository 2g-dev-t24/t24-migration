* @ValidationCode : MjotNzM2OTI0Njc4OkNwMTI1MjoxNzUyNTM4NTM3ODI4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2025 21:15:37
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
SUBROUTINE ABC.BONIFICACION.CASH.IN.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ACCT.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield("CUSTOMER", EB.Template.T24Customer, EB.Template.FieldMandatory, "")
    EB.Template.FieldSetcheckfile("CUSTOMER")
    
    
    EB.Template.TableAddfielddefinition("XX<ID.OPERACION", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-MONTO.MOV", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX-ID.OPER.CANCELA", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("XX>FECHA.MOV", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("NUM.OPERACIONES", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("MONTO.TOTAL", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("NUM.OPER.BONIFICAN", '20', 'ANY', '')
    EB.Template.TableAddfielddefinition("MONTO.A.BONIFICAR", '20', 'ANY', '')
    EB.Template.TableAddoptionsfield   ("BONIFICADO", 'SI_NO', '', '')
    EB.Template.TableAddoptionsfield   ("ID.BONIFICACION", '20', 'ANY', '')
    
    EB.Template.TableAddreservedfield("RESERVED.15")
    EB.Template.TableAddreservedfield("RESERVED.14")
    EB.Template.TableAddreservedfield("RESERVED.13")
    EB.Template.TableAddreservedfield("RESERVED.12")
    EB.Template.TableAddreservedfield("RESERVED.11")
    EB.Template.TableAddreservedfield("RESERVED.10")
    EB.Template.TableAddreservedfield("RESERVED.9")
    EB.Template.TableAddreservedfield("RESERVED.8")
    EB.Template.TableAddreservedfield("RESERVED.7")
    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    
    
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()


END
