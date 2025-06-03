* @ValidationCode : MjotMTYzMzI4MTQxNDpDcDEyNTI6MTc0ODYyNjMwNjAwNjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 30 May 2025 14:31:46
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
SUBROUTINE ABC.CUSTOMER.FIS.NV4.API.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('OTHER.NATIONALITY','100', 'A', '')
    EB.Template.TableAddfielddefinition('NATIONALITY'      ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('TAX.ID'           ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DOM.FISC'         ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('REG.FISCAL'       ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('USO.CFDI'         ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('IUB'              ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.DOC.NAME'   ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.ID'         ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.ISS.DATE'   ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LEGAL.EXP.DATE'   ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('COMP.DOM'         ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('STREET'           ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ADDRESS.1'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ADDRESS.2'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('POST.CODE'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.COLONIA'      ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('TOWN.COUNTRY'     ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.CD.EDO'       ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('COUNTRY'          ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('LOCALIDAD'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ACTIVIDAD.ECONO'  ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('PROFESION'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ORIGEN.RECURSOS'  ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('DESTINO.RECURS'   ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('PLD.FUN.PUB'      ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('PUESTO.ULT.ANIO'  ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('REL.PERSONA.EXP'  ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('NOM.PER.POL.EXP'  ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('TIPO.PER.POL.EXP' ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('CANAL'            ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('ID.CUSTOMER'      ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('RESIDENCE'        ,'100', 'A', '')
    EB.Template.TableAddfielddefinition('TIPO.EMP.OTRO'    ,'100', 'A', '')
    
END
