* @ValidationCode : MjoxNTYzOTIwMTQ1OkNwMTI1MjoxNzQzNzc5ODEyNzA2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 12:16:52
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
SUBROUTINE ABC.COMISIONISTAS.ESTABL.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID.COMI.ESTABL", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield  ('FEC.MOV'                   ,EB.Template.T24Date,   '', '')
    EB.Template.TableAddfielddefinition('CLAVE.ENTIDAD'             ,'6', 'ANY', '')
    EB.Template.TableAddfielddefinition('CLAVE.FORMULARIO'          ,'4', 'ANY', '')
    EB.Template.TableAddfielddefinition('ID.COMISIONISTA'           ,'24','ANY', '')
    EB.Template.FieldSetcheckfile('ABC.COMISIONISTAS')
    EB.Template.TableAddfielddefinition('RFC.COMISIONISTA'          ,'13', 'ANY', '')
    EB.Template.TableAddoptionsfield('TIPO.MOVIMIENTO','ALTA_BAJA_ACTUALIZACION_', '','')
    EB.Template.TableAddfielddefinition('CLAVE.MODUL.ESTABL'        ,'22', 'ANY', '')
    EB.Template.TableAddfielddefinition('LOC.MODUL.ESTABL'          ,'12', 'ANY', '')
    EB.Template.TableAddfielddefinition('CAUSA.BAJA'                ,'1', 'ANY', '')
    EB.Template.FieldSetcheckfile('ABC.CAUSA.BAJA')
    EB.Template.TableAddfielddefinition('MUNI.MODULO.ESTABL'        ,'5', 'ANY', '')
    EB.Template.TableAddfielddefinition('EDO.MODULO.ESTABL'         ,'3', 'ANY', '')
    EB.Template.TableAddfielddefinition('NOMBRE.ESTABL'           ,'100','ANY', '')
    EB.Template.TableAddfielddefinition('CALLE'           ,'75','ANY', '')
    EB.Template.TableAddfielddefinition('NUM.EXT'           ,'10','ANY', '')
    EB.Template.TableAddfielddefinition('NUM.INT'           ,'10','ANY', '')
    EB.Template.TableAddfielddefinition('COLONIA'           ,'75','ANY', '')
    EB.Template.TableAddfielddefinition('COD.POSTAL'           ,'10','ANY', '')
    EB.Template.TableAddfielddefinition('GEOLOCALIZACION'           ,'100','ANY', '')


    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.3")

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
