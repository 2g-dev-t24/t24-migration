* @ValidationCode : MjotNzAwNjEyNjgwOkNwMTI1MjoxNzUzNDY0OTcwODUxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Jul 2025 14:36:10
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

SUBROUTINE ABC.TEMP.GENE.FT.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id

    EB.Template.TableAddfielddefinition('DEBIT.AMOUNT'              ,'25'   , 'AMT', '')
    
    EB.Template.TableAddfield          ('FT.GENERADO'               ,EB.Template.T24String      , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('STATUS'                    ,EB.Template.T24String      , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('MSG.ERROR'                 ,EB.Template.T24BigString   , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('FEC.REVERSA'               ,EB.Template.T24String      , EB.Template.FieldNoInput, '')
    
    EB.Template.TableAddfielddefinition('ORIG.AMOUNT'               ,'18'   , 'AMT', '')
    EB.Template.TableAddfielddefinition('ORIG.CURRENCY'             ,'3'    , 'CCY', '')
    EB.Template.TableAddfielddefinition('COMISION'                  ,'18'   , 'AMT', '')
    
    EB.Template.TableAddfield          ('TIPO.CAMB'                 ,EB.Template.T24String      , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('PORC.FLUC'                 ,EB.Template.T24String      , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('MONTO.PERDIDA'             ,EB.Template.T24BigString   , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('AUTH.ID'                   ,EB.Template.T24String      , EB.Template.FieldNoInput, '')
    
    EB.Template.TableAddfielddefinition('ORIG.AUTH.ID'              ,'25'   , 'A', '')
    EB.Template.TableAddfielddefinition('MONTO.REV.PARCIAL'         ,'25'   , 'AMT', '')
    
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')
    
    EB.Template.TableSetauditposition()
END
