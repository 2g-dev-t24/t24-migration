* @ValidationCode : MjotMzk2NTE4NTI0OkNwMTI1MjoxNzQzNzM1Nzg1NDk5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:03:05
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
SUBROUTINE ABC.UPLOAD.FILE.PARAM.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.PARAM.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    
    EB.Template.TableAddfield          ('DESCRIPCION', EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('FILE.IN.PATH', EB.Template.T24BigString, EB.Template.FieldMandatory, '')
    EB.Template.TableAddfielddefinition('FILE.IN.MASK', '65'         , 'ANY'          , '')
    EB.Template.TableAddfielddefinition('FILE.IN.SEP', '2'          , 'ANY'          , '')
    EB.Template.TableAddfield          ('FILE.IN.EXT', EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfield          ('LINEA.INICIO', EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('FILE.OUT.PATH', EB.Template.T24BigString, EB.Template.FieldMandatory, '')
    EB.Template.TableAddfielddefinition('FILE.OUT.MASK', '65'         , 'ANY'          , '')
    EB.Template.TableAddfield          ('OFS.APLICACION', EB.Template.T24String   , ''             , '')
    EB.Template.FieldSetcheckfile("FILE.CONTROL")
    EB.Template.TableAddfield          ('FIELD.NAME.CRIT', EB.Template.T24String  , ''             , '')
    EB.Template.TableAddfield          ('XX<VALUE.CRITERION', EB.Template.T24String  , ''             , '')
    EB.Template.TableAddfield          ('XX>OFS.VERSION', EB.Template.T24String   , ''             , '')
    EB.Template.FieldSetcheckfile      ("VERSION")
    EB.Template.TableAddfield          ('OFS.SOURCE', EB.Template.T24String   , ''             , '')
    EB.Template.FieldSetcheckfile      ("OFS.SOURCE")
    EB.Template.TableAddfield          ('OFS.USR', EB.Template.T24String   , EB.Template.FieldMandatory,'')
    EB.Template.FieldSetcheckfile      ("USER")
    EB.Template.TableAddfield          ('OFS.PWD', EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('OFS.USR.AUT', EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.FieldSetcheckfile      ("USER")
    EB.Template.TableAddfield          ('OFS.PWD.AUT', EB.Template.T24String   , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('ID.REG.T24', EB.Template.T24String   , ''             , '')
    EB.Template.TableAddfield          ('XX<FIELD.NAME', EB.Template.T24String  , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('XX-FIELD.POS.LAYOUT', EB.Template.T24String  , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('XX-FIELD.LENGHT', EB.Template.T24String  , EB.Template.FieldMandatory, '')
    EB.Template.TableAddfield          ('XX-TIPO.LINEA', EB.Template.T24String  , EB.Template.FieldMandatory, '')
    EB.Template.TableAddoptionsfield   ("XX-FIELD.MANDATORY", 'Y_N'       , ''             , '')
    EB.Template.TableAddfield          ('XX-XX.FIELD.RTN.VAL', EB.Template.T24String  , ''             , '')
    EB.Template.TableAddfield          ('XX-XX.FIELD.RTN.CONV', EB.Template.T24String  , ''             , '')
    EB.Template.TableAddfield          ('XX-XX<FIELD.T24.TABLE', EB.Template.T24String  , ''             , '')
    EB.Template.FieldSetcheckfile      ("FILE.CONTROL")
    EB.Template.TableAddfield          ('XX>XX>FIELD.T24.OFS.NAME', EB.Template.T24String  , ''             , '')
    
    
    EB.Template.TableAddreservedfield("RESERVED.1")
    
    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
