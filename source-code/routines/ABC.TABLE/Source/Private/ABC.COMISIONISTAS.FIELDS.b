* @ValidationCode : MjotMTcwMjM1OTk3OkNwMTI1MjoxNzQzNzM1NzA4NDk5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:01:48
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
SUBROUTINE ABC.COMISIONISTAS.FIELDS
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
    EB.Template.TableAddoptionsfield   ('OP.ADMIN','_SI_NO', '','')
    EB.Template.TableAddfielddefinition('ID.ADMINISTRADOR'          ,'24', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.COMISIONISTAS.ADMIN')
    EB.Template.FieldSetcheckfile      ("FILE.CONTROL")
    EB.Template.TableAddfielddefinition('RFC.ADMIN'                 ,'13', 'ANY', '')
    EB.Template.TableAddoptionsfield   ('TIPO.MOVIMIENTO','ALTA_BAJA_ACTUALIZACION_', '','')
    EB.Template.TableAddfielddefinition('ID.COMISIONISTA'           ,'24', 'ANY', '')
    EB.Template.TableAddfielddefinition('NOMBRE.COMI'               ,'100', 'ANY', '')
    EB.Template.TableAddfielddefinition('RFC.COMISIONISTA'          ,'13', 'ANY', '')
    EB.Template.TableAddoptionsfield   ('PER.JURI.COMI','_FISICA_MORAL', '','')
    EB.Template.TableAddfielddefinition('ACT.COMI'                  ,'2', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.ACTIVIDAD.COMISIONISTA')
    EB.Template.TableAddfielddefinition('OP.CONTRATADAS'            ,'5', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.OPERACIONES.CONTRATADAS')
    EB.Template.TableAddfielddefinition('CAUSA.BAJA'                ,'1', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.CAUSA.BAJA')
    EB.Template.TableAddfielddefinition('LOCALIDAD'          ,'75', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('VPM.LOCALIDAD')
    EB.Template.TableAddfielddefinition('MUNICIPIO'          ,'75', 'ANY', '')
    EB.Template.TableAddfielddefinition('COD.POSTAL'         ,'10', 'ANY', '')
    
    
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
