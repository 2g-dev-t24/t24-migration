* @ValidationCode : MjoxMzYzNjU4NzkyOkNwMTI1MjoxNzUxNTk1MDk4Mjc5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Jul 2025 23:11:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.SMS.EMAIL.ENVIAR.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield('CUSTOMER', EB.Template.T24Customer,EB.Template.FieldMandatory, '')
    EB.Template.FieldSetcheckfile("CUSTOMER")
    
    EB.Template.TableAddfield('TIPO.EMAIL', EB.Template.T24String,EB.Template.FieldMandatory, '')
    
    EB.Template.TableAddfield('ASUNTO.EMAIL"', EB.Template.T24String,EB.Template.FieldMandatory, '')
    
    EB.Template.TableAddfielddefinition('NOMBRE' ,'80', 'A', '')
    
    EB.Template.TableAddfielddefinition('NOMBRE.EMPRESA' ,'80', 'A', '')
    
    EB.Template.TableAddfield('STATUS.EMAIL', EB.Template.T24String,'', '')
    
    EB.Template.TableAddfielddefinition('EMAIL' ,'80', 'A', '')
    
    EB.Template.TableAddfielddefinition('NOMBRE.BEN' ,'80', 'A', '')
    
    EB.Template.TableAddfield('CUENTA', EB.Template.T24String,'', '')
    
    EB.Template.TableAddfielddefinition('BANCO' ,'80', 'A', '')
    
    EB.Template.TableAddfield('MONTO', EB.Template.T24Numeric,'', '')
    
    EB.Template.TableAddfielddefinition('HORA' ,'10', 'A', '')
    
    EB.Template.TableAddfielddefinition('FECHA' ,'10', 'A', '')
    
    EB.Template.TableAddfielddefinition('REFERENCIA' ,'30', 'A', '')
    
    EB.Template.TableAddfield('CUENTA.CLIENTE', EB.Template.T24String,'', '')
    
    EB.Template.TableAddoptionsfield('NOTIFICA.EMAIL', "SI_NO", '', '')
    
    EB.Template.TableAddoptionsfield('NOTIFICA.ALTERNA', "SI_NO", '', '')
    
    EB.Template.TableAddfield('STATUS.ALTERNA', EB.Template.T24String,'', '')
    
    EB.Template.TableAddfield('SALDO.CUENTA', EB.Template.T24Numeric,'', '')
    
    EB.Template.TableAddfielddefinition('FECHA.HORA' ,'22', 'A', '')
    
    EB.Template.TableAddfield('CANAL', EB.Template.T24Numeric,'', '')

    EB.Template.TableAddfielddefinition('PRN' ,'20', 'A', '')

    EB.Template.TableAddoptionsfield('NOTIFICA.GALILEO', "SI_NO", '', '')
    
    EB.Template.TableAddfield('STATUS.GALILEO', EB.Template.T24String,'', '')

    EB.Template.TableAddfielddefinition('EXT.TRANS.ID' ,'35', 'A', '')

    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------

END
