* @ValidationCode : MjoxNjI5MjU0NzAwOkNwMTI1MjoxNzQzNzgxMDI5NjMwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 12:37:09
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
SUBROUTINE ABC.COMISIONISTAS.FILE.LAYOUT.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ABC.LAYOUT.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfield  ('NOMBRE.LAYOUT'       , EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield  ('FILE.IN.PATH'        , T24_BigString, EB.Template.FieldMandatory, '')
    EB.Template.TableAddfielddefinition('FILE.IN.MASK'        , '65'         , 'ANY'          , '')
    EB.Template.TableAddfielddefinition('FILE.IN.SEP'         ,  '2'         , 'ANY'          , '')
    EB.Template.TableAddfield('FILE.IN.EXT'         , EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfield('APLICACION'          , EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.FieldSetcheckfile("FILE.CONTROL")
    EB.Template.TableAddfield('XX<CAMPO.CRITERIO'   , EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfield ('XX-OPERADOR.CRITERIO', EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfielddefinition('XX>VALOR.CRITERIO'   , '65'         , 'ANY'          , '')
    EB.Template.TableAddfield('XX<POSICION'         , EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfield('XX-ENCABEZADO'       , EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfield('XX-LONGITUD'         , EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfielddefinition('XX-CAMPO'            , '50'         , 'ANY'          , '')
    EB.Template.TableAddfielddefinition('XX-XX.CONVERSION'    , '65'         , 'ANY'          , '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.3")

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()


END
