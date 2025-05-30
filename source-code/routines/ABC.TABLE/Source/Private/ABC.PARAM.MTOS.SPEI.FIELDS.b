$PACKAGE AbcParamMtosSpei
SUBROUTINE ABC.PARAM.MTOS.SPEI.FIELDS

*---------------------------------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)         ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'MONEDA'
    fieldLength = '4'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('CURRENCY':FM:EB.CUR.CCY.NAME:FM:'L')

    fieldName = 'XX<DEPARTAMENTO'
    fieldLength = '35'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile('DEPT.ACCT.OFFICER':FM:EB.DAO.NAME:FM:'L')

    fieldName = 'XX-MONTO'
    fieldLength = '20'
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>ESTATUS'
    EB.Template.TableAddoptionsfield(fieldName,'ACTIVA_INACTIVA', '','')

    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

    
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------