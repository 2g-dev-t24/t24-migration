* @ValidationCode : MjotMTUzNTk4ODM5ODpDcDEyNTI6MTc0MzczNTczNjA3MjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:02:16
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
SUBROUTINE ABC.COMISIONISTAS.RELACION.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.RELACION.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    
    EB.Template.TableAddfield          ('ID.COMISIONISTA'     , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('FECHA.CARGA'         , EB.Template.T24String, '', '')
    EB.Template.TableAddfielddefinition('XX<APLICACION'       ,'50', 'ANY', '')
    EB.Template.TableAddfield          ('XX-XX.ARCHIVOS.LINEA', EB.Template.T24String, '', '')
    
    EB.Template.FieldSetcheckfile("ABC.COMISIONISTAS.FILE.DETAIL")
    
    EB.Template.TableAddfield          ('XX-ESTATUS.OFS'   , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX-ID.T24.OFS'   , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX>RESPUESTA.OFS'   , EB.Template.T24String, '', '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
