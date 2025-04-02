* @ValidationCode : MjoxODE0NDcxOTU0OkNwMTI1MjoxNzQzNjI2MTQ2OTYxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Apr 2025 17:35:46
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
$PACKAGE AbcComisionistasAdmin
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
    EB.Template.FieldSetcheckfile      ('ABC.CAUSA.BAJA')
    EB.Template.TableAddfielddefinition('LOCALIDAD'          ,'75', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('VPM.LOCALIDAD')
    EB.Template.TableAddfielddefinition('MUNICIPIO'          ,'75', 'ANY', '')
    EB.Template.TableAddfielddefinition('COD.POSTAL'         ,'10', 'ANY', '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
