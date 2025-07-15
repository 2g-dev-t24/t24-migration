* @ValidationCode : MjotMTIyMDA0MDgxOkNwMTI1MjoxNzUyNTM5OTY1NTY4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2025 21:39:25
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
* @AbcComisionistasAdmin : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.COMISIONISTAS.ADMIN.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.COMI.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    
    EB.Template.TableAddfield          ('FEC.MOV', EB.Template.T24String,  '', '')
    
    EB.Template.TableAddfielddefinition('CLAVE.ENTIDAD'             ,'6', 'ANY', '')
    EB.Template.TableAddfielddefinition('CLAVE.FORMULARIO'          ,'4', 'ANY', '')
    EB.Template.TableAddoptionsfield   ('TIPO.MOVIMIENTO','ALTA_BAJA_ACTUALIZACION_', '','')
    EB.Template.TableAddfielddefinition('ID.ADMINISTRADOR','24', 'ANY', '')
    EB.Template.TableAddfielddefinition('NOMBRE.ADMIN'               ,'100', 'ANY', '')
    EB.Template.TableAddfielddefinition('RFC'                 ,'13', 'ANY', '')
    EB.Template.TableAddoptionsfield   ('PER.JURI.ADMIN','_FISICA_MORAL', '','')
    EB.Template.TableAddfielddefinition('CAUSA.BAJA'                ,'1', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.CAUSA.BAJA')
    EB.Template.TableAddfielddefinition('LOCALIDAD'          ,'75', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.LOCALIDADES')
    EB.Template.TableAddfielddefinition('MUNICIPIO'          ,'75', 'ANY', '')
    EB.Template.TableAddfielddefinition('COD.POSTAL'         ,'10', 'ANY', '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
