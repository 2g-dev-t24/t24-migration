* @ValidationCode : Mjo0NTg3NDUyODE6Q3AxMjUyOjE3NDM3MzU2NDEzNTU6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:00:41
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
SUBROUTINE ABC.ATM.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('CLAVE.PUNTO.TRANS','12','A','')
    EB.Template.TableAddfielddefinition('DENOM.PUNTO.TRANS','100', 'A', '')
    
    EB.Template.TableAddfieldwitheblookup('CLAVE.TIPO.TRANS', 'CLAVE.TIP.PUNTO.TRANS', '')
    EB.Template.TableAddfieldwitheblookup('CLAVE.SITUACION','CLAVE.SITUACION' , '')
    
    EB.Template.TableAddfielddefinition('FECHA.SITUACION','8', 'D', '')
    EB.Template.TableAddfielddefinition('DIR.CALLE','100', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.NUM.EXT','6', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.NUM.INT','5', 'A', '')
    EB.Template.TableAddfielddefinition('COLONIA.CNBV','8', 'A', '')
    EB.Template.TableAddfielddefinition('LOCALIDAD.BANXICO','4', 'A', '')
    EB.Template.TableAddfielddefinition('LOCALIDAD.CNBV','14', 'A', '')
    EB.Template.TableAddfielddefinition('MUNICIPIO.CNBV','5', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.ESTADO','5', 'A', '')
    
    EB.Template.FieldSetcheckfile('VPM.ESTADO')
    
    EB.Template.TableAddfielddefinition('DIR.CODPOS','5', 'A', '')
    EB.Template.TableAddfielddefinition('LATITUD','10', 'A', '')
    EB.Template.TableAddfielddefinition('LONGITUD','11', 'A', '')
    EB.Template.TableAddfielddefinition('HORARIO.CAJERO','12', 'A', '')
    EB.Template.TableAddfielddefinition('COMISION.RETIRO','3', 'A', '')
    EB.Template.TableAddfielddefinition('COMISION.CONSULTA','3', 'A', '')
    EB.Template.TableAddfielddefinition('CRITERIO.COMISION','5', 'A', '')
    
    EB.Template.TableAddfieldwitheblookup('TIPO.ACCESO','TIPO.ACCESO','')
    EB.Template.TableAddfieldwitheblookup('DISPLENSA.BAJA','DISPENSA.BAJA','')
    
    EB.Template.TableAddfielddefinition('IVA','10', 'A', '')
    EB.Template.TableAddfielddefinition('XX<DENOMINACION','10', 'A', '')
    EB.Template.TableAddfielddefinition('XX>POSICION','10', 'A', '')
    
    
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

    EB.Template.TableSetauditposition()

END
