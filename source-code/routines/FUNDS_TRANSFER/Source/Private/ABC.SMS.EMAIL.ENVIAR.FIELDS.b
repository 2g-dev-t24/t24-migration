* @ValidationCode : MjotMjQ3MDQ1ODYyOkNwMTI1MjoxNzQ0Njc5NDY4Mjg0OlVzaWFyaW86LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Apr 2025 20:11:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
.
*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.SMS.EMAIL.ENVIAR.FIELDS
*-----------------------------------------------------------------------------
*ROUTINE NAME: ABC.SMS.EMAIL.ENVIAR.FIELDS
*PROJECT NAME: Notificaciones BI
*DEVELOPED BY: CESAR MIRANDA (FYG)
*--------------------------------------------------------------------------------------------------
*DESCRIPTION       : Definicion de los campos

*---------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date        : 22 APR 2017
* Modified by : CESAR MIRANDA FYG(CAMB)
* Description : se agregan los campos para las notificaciones a Beneficiario de SPEI
*---------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date        : 16 FEB 2018
* Modified by : ISAIAS RODRIGUEZ (IR)
* Description : se agrega el campo de cuenta de cliente
*---------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date        : 19 ABR 2021
* Modified by : CESAR MIRANDA FYG(CAMB)
* Description : se agregan los campos SALDO.CUENTA, y CANAL
*---------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $USING EB.SystemTables
    $USING EB.Template
    $USING ABC.BP
*** </region>
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfield("CUSTOMER", T24_Customer,Field_Mandatory, "")
    EB.Template.FieldSetcheckfile("CUSTOMER")
    EB.Template.TableAddfield("TIPO.EMAIL", T24_String, Field_Mandatory, "")
    EB.Template.TableAddfield("ASUNTO.EMAIL", T24_String, Field_Mandatory, "")
    EB.Template.TableAddfielddefinition("NOMBRE", '80', 'ANY', '')
    EB.Template.TableAddfielddefinition("NOMBRE.EMPRESA", '80', 'ANY', '')
    EB.Template.TableAddfield("STATUS.EMAIL", T24_String, "", "")
    EB.Template.TableAddfielddefinition("EMAIL", '80', 'ANY', '')
    EB.Template.TableAddfielddefinition("NOMBRE.BEN", '80', 'ANY', '')
    EB.Template.TableAddfield("CUENTA", T24_String, "", "")
    EB.Template.TableAddfielddefinition("BANCO", '80', 'ANY', '')
    EB.Template.TableAddfield("MONTO", T24_Numeric, "", "")
    EB.Template.TableAddfielddefinition("HORA", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("FECHA", '10', 'ANY', '')
    EB.Template.TableAddfielddefinition("REFERENCIA", '30', 'ANY', '')
    EB.Template.TableAddfield("CUENTA.CLIENTE", T24_String, "", "")
    EB.Template.TableAddoptionsfield("NOTIFICA.EMAIL","SI_NO", "","")
    EB.Template.TableAddoptionsfield("NOTIFICA.ALTERNA","SI_NO", "","")
    EB.Template.TableAddfield("STATUS.ALTERNA", T24_String, "", "")
    EB.Template.TableAddfield("SALDO.CUENTA", T24_Numeric, "", "")
    EB.Template.TableAddfielddefinition("FECHA.HORA", '22', 'ANY', '')
    EB.Template.TableAddfield("CANAL", T24_Numeric, "", "")
    
    EB.Template.TableAddfielddefinition("PRN", '20', 'ANY', '')
    EB.Template.TableAddoptionsfield("NOTIFICA.GALILEO","SI_NO", "","")
    EB.Template.TableAddfield("STATUS.GALILEO", T24_String, "", "")
    EB.Template.TableAddfielddefinition("EXT.TRANS.ID", '35', 'ANY', '')
    EB.Template.TableAddreservedfield("RESERVED.19")
    EB.Template.TableAddreservedfield("RESERVED.18")
    EB.Template.TableAddreservedfield("RESERVED.17")
    EB.Template.TableAddreservedfield("RESERVED.16")
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
    EB.Template.TableAddlocalreferencefield(neighbour)
    EB.Template.TableAddoverridefield()

*  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*  CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
