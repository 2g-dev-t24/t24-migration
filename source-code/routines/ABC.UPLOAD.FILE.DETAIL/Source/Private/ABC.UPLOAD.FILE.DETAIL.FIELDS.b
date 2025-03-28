* @ValidationCode : MjotMTM5NTg3MjE1NjpDcDEyNTI6MTc0MzE5MzM4NDY5NTpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Mar 2025 17:23:04
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
$PACKAGE AbcUploadFileDetail
SUBROUTINE ABC.UPLOAD.FILE.DETAIL.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.DETAIL.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield          ('ID.PARAM'   , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('ID.CONCAT'  , EB.Template.T24String, '', '')

    
    EB.Template.TableAddfield          ('XX<NOMBRE.CAMPO'    , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX-VALOR.VALIDACION', EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX>VALOR.CAMPO'     , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('LOAD.OK'            , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX.ARCHIVO.LINEA'   , EB.Template.T24String, '', '')
    
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
