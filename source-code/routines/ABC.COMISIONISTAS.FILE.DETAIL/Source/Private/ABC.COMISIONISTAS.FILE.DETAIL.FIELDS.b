* @ValidationCode : Mjo2ODQxNTI1MjQ6Q3AxMjUyOjE3NDMyODg4NTQ0MjQ6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Mar 2025 19:54:14
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
$PACKAGE AbcComisionistasFileDetail
SUBROUTINE ABC.COMISIONISTAS.FILE.DETAIL.FIELDS
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

    
    EB.Template.TableAddfield          ('ID.PARAM'     , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('ID.RELACION'         , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('ID.CONCAT'       ,'50', 'ANY', '')
    EB.Template.TableAddfield          ('XX<NOMBRE.CAMPO', EB.Template.T24String, '', '')
    
    EB.Template.TableAddfield          ('XX-VALOR.VALIDACION'   , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX>VALOR.CAMPO'   , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('LOAD.OK'   , EB.Template.T24String, '', '')
    EB.Template.TableAddfield          ('XX.LOAD.ERRORS'   , EB.Template.T24String, '', '')
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
