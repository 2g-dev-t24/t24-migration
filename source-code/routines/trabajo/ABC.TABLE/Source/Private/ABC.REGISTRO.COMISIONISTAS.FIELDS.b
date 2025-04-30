* @ValidationCode : MjoxNTE1NTY5NDpDcDEyNTI6MTc0MzczNTc2MDU5MTpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:02:40
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
SUBROUTINE ABC.REGISTRO.COMISIONISTAS.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.REG.COMISIONISTAS.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    
    EB.Template.TableAddfield          ('ID_COMISIONISTA'      , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('NO.CLIENTE'           , EB.Template.T24String, fieldType, '')
    EB.Template.TableAddoptionsfield   ("AUTORIZACION.CTE","SI_NO", "","")
    EB.Template.TableAddfield          ('COMENTARIOS'          , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX<NO.CUENTA'         , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX-NO.FT'             , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX-NO.INV.CTA'        , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX-FECHA.ALTA'        , EB.Template.T24Date  , '', '')
    EB.Template.TableAddfield          ('XX-FECHA.APE.CTA'     , EB.Template.T24Date  , '', '')
    EB.Template.TableAddfield          ('XX-FECHA.INV'         , EB.Template.T24Date  , '', '')
    EB.Template.TableAddfield          ('XX-FECHA.VENCIMIENTO' , EB.Template.T24Date  , '', '')
    EB.Template.TableAddfield          ('XX-NOMBRE.ARCHIVO'    , EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield          ('XX>RECHAZO'           , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('COMISIONISTA'         , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('SUCURSAL'             , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('PLAZA'                , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('APLICA.CARGA'         , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('MOTIVO.RECHAZO'       , EB.Template.T24String, '', '')
    
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
