* @ValidationCode : MjotNjE5MTg1OTAwOkNwMTI1MjoxNzQ0NzI1NDExOTc4OkVkZ2FyOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Apr 2025 08:56:51
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
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------

SUBROUTINE ABC.COMISIONISTAS.FIELDS

* ======================================================================
* Nombre de Programa : ABC.COMISIONISTAS
* Parametros         :
* Objetivo           :
* Desarrollador      : ISAIAS RODRIGUEZ - Fyg Solutions
* Compa�ia           : ABC
* Fecha Creacion     : 2017/02/09
* Modificaciones     :
* ======================================================================

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_DataTypes
    $USING EB.Template

    EB.Template.TableDefineid('ABC.COMI.ID', T24_String)          ;* Define Table id

    EB.Template.TableAddfield          ('FEC.MOV'                   , T24_Date,  '', '')
    EB.Template.TableAddfielddefinition          ('CLAVE.ENTIDAD'             ,'6', 'ANY', '')
    EB.Template.TableAddfielddefinition          ('CLAVE.FORMULARIO'          ,'4', 'ANY', '')
    EB.Template.TableAddoptionsfield   ('OP.ADMIN','_SI_NO', '','')
    EB.Template.TableAddfielddefinition          ('ID.ADMINISTRADOR'          ,'24', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.COMISIONISTAS.ADMIN')
    EB.Template.TableAddfielddefinition         ('RFC.ADMIN'                 ,'13', 'ANY', '')
    EB.Template.TableAddoptionsfield             ('TIPO.MOVIMIENTO','ALTA_BAJA_ACTUALIZACION_', '','')
    EB.Template.TableAddfielddefinition          ('ID.COMISIONISTA'           ,'24', 'ANY', '')
    EB.Template.TableAddfielddefinition          ('NOMBRE.COMI'               ,'100', 'ANY', '')
    EB.Template.TableAddfielddefinition          ('RFC.COMISIONISTA'          ,'13', 'ANY', '')
    EB.Template.TableAddoptionsfield   ('PER.JURI.COMI','_FISICA_MORAL', '','')
    EB.Template.TableAddfielddefinition         ('ACT.COMI'                  ,'2', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.ACTIVIDAD.COMISIONISTA')
    EB.Template.TableAddfielddefinition          ('OP.CONTRATADAS'            ,'5', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.OPERACIONES.CONTRATADAS')
    EB.Template.TableAddfielddefinition          ('CAUSA.BAJA'                ,'1', 'ANY', '')
    EB.Template.FieldSetcheckfile      ('ABC.CAUSA.BAJA')

*Campos agregados 27/03/2024 esanchezg
    EB.Template.TableAddfielddefinition          ('LOCALIDAD'          ,'75', 'ANY', '')
    EB.Template.FieldSetcheckfile('VPM.LOCALIDAD');
    EB.Template.TableAddfielddefinition          ('MUNICIPIO'          ,'75', 'ANY', '')
    EB.Template.TableAddfielddefinition          ('COD.POSTAL'         ,'10', 'ANY', '')

    EB.Template.TableAddreservedfield('RESERVED.1')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.3')
*-----------------------------------------------------------------------------
    EB.Template.TableAddlocalreferencefield('LOCAL.REF')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------


RETURN
END
