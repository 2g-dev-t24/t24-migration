* @ValidationCode : Mjo3NDkxMzEzMDE6Q3AxMjUyOjE3NDQ0MDcyMTY4OTk6RWRnYXI6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2025 16:33:36
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
SUBROUTINE ABC.UPLOAD.FILE.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Programador   :  Salvador Sot Mendoza
* Fecha         :  Noviembre del 2015
* Descripcion   :  TEMPLATE para parametrizacion de carga de archivos
*
*-----------------------------------------------------------------------------

*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_DataTypes

    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Interface
    $USING ABC.BP
    
    
    EB.Template.TableDefineid('ABC.PARAM.ID', T24_String)         ;* Define Table id
    EB.Template.TableAddfield          ('DESCRIPCION'        , T24_String   , Field_Mandatory, '')
    EB.Template.TableAddfield          ('FILE.IN.PATH'       , T24_BigString, Field_Mandatory, '')
    EB.Template.TableAddfielddefinition('FILE.IN.MASK'       , '65'         , 'ANY'          , '')
    EB.Template.TableAddfielddefinition('FILE.IN.SEP'        , '2'          , 'ANY'          , '')
    EB.Template.TableAddfield          ('FILE.IN.EXT'        , T24_String   , ''             , '')
    EB.Template.TableAddfield          ('LINEA.INICIO'       , T24_String   , Field_Mandatory, '')

    EB.Template.TableAddfield          ('FILE.OUT.PATH'      , T24_BigString, Field_Mandatory, '')
    EB.Template.TableAddfielddefinition('FILE.OUT.MASK'      , '65'         , 'ANY'          , '')

    EB.Template.TableAddfield          ('OFS.APLICACION'  , T24_String   , ''             , '')
    EB.Template.FieldSetcheckfile      ("FILE.CONTROL")
    EB.Template.TableAddfield          ('FIELD.NAME.CRIT'   , T24_String  , ''             , '')
    EB.Template.TableAddfield          ('XX<VALUE.CRITERION'   , T24_String  , ''             , '')
    EB.Template.TableAddfield          ('XX>OFS.VERSION'     , T24_String   , ''             , '')
    EB.Template.FieldSetcheckfile      ("VERSION")

    EB.Template.TableAddfield          ('OFS.SOURCE'         , T24_String   , ''             , '')
    EB.Template.FieldSetcheckfile      ("OFS.SOURCE")

    EB.Template.TableAddfield          ('OFS.USR'            , T24_String   , Field_Mandatory,'')
    EB.Template.FieldSetcheckfile      ("USER")
    EB.Template.TableAddfield          ('OFS.PWD'            , T24_String   , Field_Mandatory, '')
    EB.Template.TableAddfield          ('OFS.USR.AUT'        , T24_String   , Field_Mandatory, '')
    EB.Template.FieldSetcheckfile      ("USER")
    EB.Template.TableAddfield          ('OFS.PWD.AUT'        , T24_String   , Field_Mandatory, '')

    EB.Template.TableAddfield          ('ID.REG.T24'        , T24_String   , ''             , '')

*   -Cadenas de parametrizacion de multivalores

    EB.Template.TableAddfield          ('XX<FIELD.NAME'           , T24_String  , Field_Mandatory, '')
    EB.Template.TableAddfield          ('XX-FIELD.POS.LAYOUT'     , T24_String  , Field_Mandatory, '')
    EB.Template.TableAddfield          ('XX-FIELD.LENGHT'         , T24_String  , Field_Mandatory, '')
    EB.Template.TableAddfield          ('XX-TIPO.LINEA'           , T24_String  , Field_Mandatory, '')
    EB.Template.TableAddoptionsfield   ("XX-FIELD.MANDATORY"      , 'Y_N'       , ''             , '')
    EB.Template.TableAddfield          ('XX-XX.FIELD.RTN.VAL'     , T24_String  , ''             , '')
    EB.Template.TableAddfield          ('XX-XX.FIELD.RTN.CONV'    , T24_String  , ''             , '')
    EB.Template.TableAddfield          ('XX-XX<FIELD.T24.TABLE'   , T24_String  , ''             , '')
    EB.Template.FieldSetcheckfile      ("FILE.CONTROL")
    EB.Template.TableAddfield          ('XX>XX>FIELD.T24.OFS.NAME', T24_String  , ''             , '')

    EB.Template.TableAddreservedfield('RESERVED.1')

*-----------------------------------------------------------------------------
    EB.Template.TableAddlocalreferencefield('LOCAL.REF')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------


RETURN
END
