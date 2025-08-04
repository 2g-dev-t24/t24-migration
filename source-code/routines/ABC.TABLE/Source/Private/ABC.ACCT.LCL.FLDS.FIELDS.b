* @ValidationCode : MjotNjEzNTYzNjUyOkNwMTI1MjoxNzU0MzE5ODc2NjI4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Aug 2025 12:04:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.ACCT.LCL.FLDS.FIELDS
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
    EB.Template.TableAddfielddefinition('XX.OBSERVACIONES'    ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('CELULAR'             ,'10'   , 'A', '')
    EB.Template.TableAddoptionsfield   ("XX.PARENTESCO"       ,'PADRE_MADRE_HIJO(A)_ABUELO(A)_NIETO(A)_HERMANO(A)_TIO(A)_PRIMO(A)_SOBRINO(A)_ESPOSO(A)_SUEGRO(A)_CU?ADO(A)_AMIGO(A)_COMPADRE/COMADRE_MISMO CLIENTE_EMPRESA RELACIONADA_SOC EMP RELACIONADA', '', '')
    EB.Template.TableAddoptionsfield   ('XX.USO.PRETEND.CTA'  ,'Administracion de gastos e ingresos_Ahorro_Concentracion Fondos_Credito_Cuenta Inversion_Otros'   , 'A', '')
    EB.Template.TableAddfielddefinition('USO.PRETEND.OTR'     ,'60'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('PROCEDEN.RECURS'     ,'Comisiones_Dividendos_Fideicomisos_Herencia_Honorarios_Inversion_Otro_Partidas Presupuestales_Premios_Regal?as_Rentas_Sueldos_Venta de Activos_Venta de Productos/Servicios'   , 'A', '')
    EB.Template.TableAddfielddefinition('PROCEDEN.OTR'        ,'60'   , 'A', '')

    EB.Template.TableAddfielddefinition('XX<DEPO.APRX.CTA'    ,'50'   ,'AMTLCCY', '')
    EB.Template.TableAddoptionsfield   ('XX>DEPO.TIPO'        ,'Cheques,Efectivos,Trasferencia'   , 'A', '')

    EB.Template.TableAddfielddefinition('DEPO.MONTO.APRX'     ,'3'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.MONTO.MENSUAL")

    EB.Template.TableAddfielddefinition('XX<RETI.APRX.CTA'    ,'3'   , 'AMTLCCY', '')
    EB.Template.TableAddoptionsfield   ('XX>RETI.TIPO'        ,'Cheques,Efectivos,Trasferencia'   , 'A', '')

    EB.Template.TableAddfielddefinition('RETI.MONTO.CTA'      ,'50'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.MONTO.MENSUAL")
    
    EB.Template.TableAddoptionsfield   ('ACCESO.INTERNET'     ,'SI_NO'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('INTERESES.TIT'       ,'SI_NO'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX.COMBINA.FIRMAS'   ,'35'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('CON.SIN.INT'         ,'CUENTA CON INTERESES_CUENTA SIN INTERESES'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('EXENTO.IMPUESTO'     ,'SI_NO'   , 'A', '')
    EB.Template.TableAddfielddefinition('BLOQ.EMBARGO'        ,'15'   , 'A', '')
    
*****************************************************************************
*  BENEFICIARIO                                                             *
*****************************************************************************
    EB.Template.TableAddfielddefinition('XX<BEN.APE.PATERNO'    ,'50'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.APE.MATERNO'    ,'50'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.NOMBRES'        ,'100'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.TELEFONO'       ,'10'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.PORCENTAJE'     ,'5'     , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.RFC'            ,'5'     , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.CURP'           ,'18'    , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-BEN.IDENTIFICA'     ,'Credencial para Votar_Pasaporte Vigente_C�dula Profesional_Forma Migratoria FM2_Forma Migratoria FM3'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.NRO.IDENTI'     ,'25'    , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-PARENTESCO.BEN'     ,'PADRE_MADRE_HIJO(A)_ABUELO(A)_NIETO(A)_HERMANO(A)_TIO(A)_PRIMO(A)_SOBRINO(A)_ESPOSO(A)_SUEGRO(A)_CU?ADO(A)_AMIGO(A)_COMPADRE/COMADRE_MISMO CLIENTE_EMPRESA RELACIONADA_SOC EMP RELACIONADA', '', '')
    EB.Template.TableAddfielddefinition('XX-BEN.PAIS.NAC'       ,'9'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-BEN.FEC.NAC'        ,'8'     , 'D', '')
    EB.Template.TableAddfielddefinition('XX-BEN.NACIONAL'       ,'8'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-BEN.CALLE'          ,'65'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.NUM.EXT'        ,'10'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.NUM.INT'        ,'10'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.ESTADO'         ,'2'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ESTADO")
    EB.Template.TableAddfielddefinition('XX-BEN.MUNICIPIO'      ,'5'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.MUNICIPIO")
    EB.Template.TableAddfielddefinition('XX-BEN.COLONIA'        ,'15'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.COLONIA")
    EB.Template.TableAddfielddefinition('XX-BEN.CIUDAD'         ,'8'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CIUDAD")
    EB.Template.TableAddfielddefinition('XX-BEN.COD.POS'        ,'8'     , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.PAIS'           ,'9'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-BEN.TEL.CEL'        ,'13'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.EMAIL'             ,'65'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.NOM.EMP'        ,'65'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-BEN.PROF.PUES'      ,'65'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX>BEN.OCUP.ACT'       ,'8'     , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.OCUPACION")
    
*****************************************************************************
*  PER                                                             *
*****************************************************************************
    EB.Template.TableAddfielddefinition('XX<PER.AUT.NOMBRE'     ,'50'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.APE.PAT'    ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.APE.MAT'    ,'35'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-PER.AUT.TIP.FIR'    ,'A_B_C'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.RFC'        ,'13'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.CURP'       ,'18'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-PER.AUT.IDENTIF'    ,'1_2_3_4_5'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.NRO.IDE'    ,'25'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PARENT.TER.AUT'     ,'20'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.PAIS.NA'    ,'50'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfield          ('XX-PER.AUT.FEC.NAC'    ,EB.Template.T24Date   , '','')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.NACI'       ,'9'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-PER.AUT.CALLE'       ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.NUM.EXT'    ,'10'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.NUM.INT'    ,'10'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.ESTADO'     ,'50'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ESTADO")
    EB.Template.TableAddfielddefinition('XX-PER.AUT.MUN'        ,'5'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.MUNICIPIO")
    EB.Template.TableAddfielddefinition('XX-PER.AUT.COL'        ,'15'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.COLONIA")
    EB.Template.TableAddfielddefinition('XX-PER.AUT.CD'         ,'4'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CIUDAD")
    EB.Template.TableAddfielddefinition('XX-PER.AUT.CP'         ,'5'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.PAIS'       ,'9'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-PER.AUT.TEL'        ,'20'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.TEL.CEL'    ,'20'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.EMAIL'      ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.NOM.EMP'    ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.PRO.PUE'    ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-PER.AUT.OCU.ACT'    ,'3'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.OCUPACION")
    EB.Template.TableAddfielddefinition('XX>PER.AUT.ACT.ECO'    ,'7'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ACTIVIDAD.ECONOMICA")
    
*****************************************************************************
*  FACU                                                             *
*****************************************************************************
    EB.Template.TableAddfielddefinition('XX<FACU.NUM.ESC.CO'    ,'20'   , 'A', '')
    EB.Template.TableAddfield          ('XX-FACU.FEC.ESC.CO'    ,EB.Template.T24Date   , '','')
    EB.Template.TableAddfielddefinition('XX-FACU.NOM.NOTAR'     ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.NUM.NOTAR'     ,'15'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.ENT.NOTAR'     ,'3'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ESTADO")
    EB.Template.TableAddfielddefinition('XX-FACU.ENT.REG'       ,'50'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ESTADO")
    EB.Template.TableAddfielddefinition('XX-FACU.NUM.REG'       ,'15'   , 'A', '')
    EB.Template.TableAddfield          ('XX-FACU.FEC.REG'       ,EB.Template.T24Date   , '','')
    EB.Template.TableAddfielddefinition('XX-FACU.RFC.REG'       ,'13'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.CURP.REG'      ,'18'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.NACI.REG'      ,'9'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfield          ('XX-FACU.FEC.NAC'       ,EB.Template.T24Date   , '','')
    EB.Template.TableAddfielddefinition('XX-FACU.TEL'           ,'25'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.PAIS.NAC'      ,'9'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-FACU.STATUS'        ,'25'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.NOMBRE'        ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.APE.PATERN'    ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.APE.MATERN'    ,'35'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-FACU.IDENTIFICA'    ,'1_2_3_4_5'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.NRO.IDENTI'    ,'25'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-FACU.TIPO.FIRMA'    ,'A_B_C'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FACU.TEL.CEL'       ,'25'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX>FACU.EMAIL'       ,'65'   , 'A', '')
  
*****************************************************************************
*  COT                                                             *
*****************************************************************************
    
    EB.Template.TableAddfielddefinition('XX<COT.APE.PATERNO'    ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.APE.MATERNO'    ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.NOMBRE'         ,'35'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.RFC'            ,'13'   , 'A', '')
    EB.Template.TableAddfield          ('XX-COT.NACIMIENTO'     ,EB.Template.T24Date   , '','')
    EB.Template.TableAddfielddefinition('XX-COT.ASIG.INT'       ,'5'    , 'AMTLCCY', '')
    EB.Template.TableAddfielddefinition('XX-COT.CURP'           ,'18'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-COT.IDENTIFICAC'    ,'1_2_3_4_5'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.NRO.IDENTIF'    ,'25'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-COT.TIPO.FIRMA'     ,'A_B_C'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX-PARENTESCO.COT'     ,'PADRE_MADRE_HIJO(A)_ABUELO(A)_NIETO(A)_HERMANO(A)_TIO(A)_PRIMO(A)_SOBRINO(A)_ESPOSO(A)_SUEGRO(A)_CU?ADO(A)_AMIGO(A)_COMPADRE/COMADRE_MISMO CLIENTE_EMPRESA RELACIONADA_SOC EMP RELACIONADA', '', '')
    EB.Template.TableAddfielddefinition('XX-COT.PAIS.NAC'       ,'9'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-COT.NACIONAL'       ,'9'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-COT.CALLE'          ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.NUM.EXT'        ,'10'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.NUM.INT'        ,'10'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.ESTADO'         ,'50'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ESTADO")
    EB.Template.TableAddfielddefinition('XX-COT.MUNICIPIO'      ,'5'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.MUNICIPIO")
    EB.Template.TableAddfielddefinition('XX-COT.COLONIA'        ,'15'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.COLONIA")
    EB.Template.TableAddfielddefinition('XX-COT.CIUDAD'         ,'4'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CIUDAD")
    EB.Template.TableAddfielddefinition('XX-COT.COD.POS'        ,'5'    , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.PAIS'           ,'9'   , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfielddefinition('XX-COT.TEL'            ,'20'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.TEL.CEL'        ,'20'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.EMAIL'          ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.NOM.EMP'        ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.PROF.PUES'      ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX-COT.OCUP.ACT'       ,'65'   , 'A', '')
    EB.Template.TableAddfielddefinition('XX>COT.ACT.ECO'        ,'7'    , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.ACTIVIDAD.ECONOMICA")
    
    
*****************************************************************************
*  OTROS                                                             *
*****************************************************************************
    EB.Template.TableAddoptionsfield   ('PLD.FUN.PUB'        ,'SI_NO'   , 'A', '')
    EB.Template.TableAddfielddefinition('PLD.FUN.PUB.ESP'    ,'65'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('PLD.ACC.BAN'        ,'SI_NO'   , 'A', '')
    EB.Template.TableAddfielddefinition('PLD.ACC.BAN.ESP'    ,'65'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('PREG.FON.TER'       ,'SI_NO'   , 'A', '')
    EB.Template.TableAddfielddefinition('AP.PAT.FON.TER'     ,'50'      , 'A', '')
    EB.Template.TableAddfielddefinition('AP.MAT.FON.TER'     ,'50'      , 'A', '')
    EB.Template.TableAddfielddefinition('PR.NOM.FON.TER'     ,'50'      , 'A', '')
    EB.Template.TableAddfielddefinition('SEG.NOM.FON.TER'    ,'50'      , 'A', '')
    EB.Template.TableAddfielddefinition('TER.NOM.FON.TER'    ,'50'      , 'A', '')
    EB.Template.TableAddfielddefinition('NAC.FON.TER'        ,'9'       , 'A', '')
    EB.Template.FieldSetcheckfile      ("COUNTRY")
    EB.Template.TableAddfield          ('FEC.NAC.FON.TER'    ,EB.Template.T24Date   , '','')
    EB.Template.TableAddfielddefinition('ACT.DES.FON.TER'    ,'65'      , 'A', '')
    EB.Template.TableAddfielddefinition('CALLE.FON.TER'      ,'65'      , 'A', '')
    EB.Template.TableAddfielddefinition('NUM.EXT.FON.TER'    ,'10'      , 'A', '')
    EB.Template.TableAddfielddefinition('NUM.INT.FON.TER'    ,'10'      , 'A', '')
    EB.Template.TableAddfielddefinition('EST.FON.TER'        ,'50'      , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CIUDAD")
    EB.Template.TableAddfielddefinition('DEL.MUN.FON.TER'    ,'50'      , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.MUNICIPIO")
    EB.Template.TableAddfielddefinition('COL.FON.TER'        ,'15'      , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.COLONIA")
    EB.Template.TableAddfielddefinition('CIUDAD.FON.TER'     ,'50'      , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CIUDAD")
    EB.Template.TableAddfielddefinition('CP.FON.TER'         ,'8'       , 'A', '')
    EB.Template.TableAddfielddefinition('TEL.FON.TER'        ,'20'      , 'A', '')
    EB.Template.TableAddfielddefinition('EMAIL.FON.TER'      ,'65'      , 'ANY', '')
    EB.Template.TableAddfielddefinition('CURP.FON.TER'       ,'18'      , 'A', '')
    EB.Template.TableAddfielddefinition('RFC.FON.TER'        ,'15'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('TIP.ID.FON.TER'     ,'1_2_3_4_5'   , 'A', '')
    EB.Template.TableAddfielddefinition('NUM.ID.FON.TER'     ,'20'      , 'A', '')
    EB.Template.TableAddfielddefinition('NO.DEPOSITOS'       ,'2'       , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CATAG.RANGOS")
    EB.Template.TableAddfielddefinition('NO.RETIROS'         ,'2'       , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.CATAG.RANGOS")
    EB.Template.TableAddfielddefinition('DEST.RECUR'         ,'50'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('TIT.TIPO.FIRMA'     ,'A_B_C'   , 'A', '')
    EB.Template.TableAddfield          ('GPO.CLUB.AHORRO'    ,EB.Template.T24String   , EB.Template.FieldNoInput, '')
    EB.Template.TableAddfielddefinition('AA.ORG.CON.DATE'    ,'10'      , 'A', '')
    EB.Template.TableAddfielddefinition('AA.ORG.MAT.DATE'    ,'10'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('FIDUCIARIA'         ,'SI'      , 'A', '')
    EB.Template.TableAddfielddefinition('FOLIO.CIERRE'       ,'20'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('REGIMEN.CUENTA'     ,'CI_CS_CM', 'A', '')
    EB.Template.TableAddfielddefinition('PROM.ENLACE'        ,'50'      , 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.PROM.ENLACE")
    EB.Template.TableAddfielddefinition('CUENTA.LINK'        ,'15'      , 'A', '')
    EB.Template.TableAddoptionsfield   ('FINTECH'            ,'SI'      , 'A', '')
    EB.Template.TableAddfielddefinition('BALANCE.ID'         ,'35'      , 'A', '')
    EB.Template.TableAddfielddefinition('TIT.PORC'           ,'3'       , 'A', '')
***mirar local table 3370
    EB.Template.TableAddfielddefinition('XX<ID.COTI'         ,'10'      , 'A', '')
***mirar
    EB.Template.TableAddfielddefinition('XX-ASIG.INT.COTI'   ,'5'       , 'AMT', '')
    EB.Template.TableAddoptionsfield   ('XX-PARENTESCO.COTI' ,'PADRE_MADRE_HIJO(A)_ABUELO(A)_NIETO(A)_HERMANO(A)_TIO(A)_PRIMO(A)_SOBRINO(A)_ESPOSO(A)_SUEGRO(A)_CU?ADO(A)_AMIGO(A)_COMPADRE/COMADRE_MISMO CLIENTE_EMPRESA RELACIONADA_SOC EMP RELACIONADA', '', '')
    EB.Template.TableAddoptionsfield   ('XX>TIPO.FIRMA.COTI' ,'A_B_C'   , 'A', '')
    EB.Template.TableAddoptionsfield   ('UPDATE.NIVEL'       ,'CAMBIO.N4', 'A', '')
    EB.Template.TableAddfielddefinition('FECHA.UPD.NVL'    ,'15'   , 'A', '')

    EB.Template.TableAddfielddefinition('CUSTOMER'        ,EB.Template.T24Customer      , '', '')
    EB.Template.FieldSetcheckfile      ("CUSTOMER")
    EB.Template.TableAddfielddefinition('MONEDA'        ,EB.Template.T24String      , '', '')
    EB.Template.FieldSetcheckfile      ("CURRENCY")
    EB.Template.TableAddfielddefinition('ROL'        ,EB.Template.T24String      , '', '')
    EB.Template.FieldSetcheckfile      ("AA.CUSTOMER.ROLE")
    EB.Template.TableAddfielddefinition('CREATE.DATE'        ,'8'      , 'D', '')
    EB.Template.TableAddfielddefinition('PRODUCTO'        ,EB.Template.T24String      , '', '')
    EB.Template.FieldSetcheckfile      ("AA.PRODUCT")
    
    EB.Template.TableAddfielddefinition('CURRENCY','3', 'A', '')
    EB.Template.FieldSetcheckfile      ("CURRENCY")
    
    EB.Template.TableAddfielddefinition('CATEGORY','6', '', '')
    EB.Template.FieldSetcheckfile      ("CATEGORY")
    
    EB.Template.TableAddoptionsfield   ('CLASSIFICATION'     ,'Persona Fisica_Fisica con Actividad Empresarial_Persona Moral_Fideicomiso_Mandato_Cotitular'   , 'A', '')
    
    EB.Template.TableAddfielddefinition('ACCOUNT.OFFICER',EB.Template.T24String, '', '')
    EB.Template.FieldSetcheckfile      ("DEPT.ACCT.OFFICER")
    
    EB.Template.TableAddfield          ('OPENING.DATE',EB.Template.T24Date, '','')
    
    EB.Template.TableAddfielddefinition('ACCOUNT.TITLE.1','35', 'A', '')
    EB.Template.TableAddfielddefinition('ACCOUNT.TITLE.2','35', 'A', '')
    
    EB.Template.TableAddfielddefinition('CLABE','18'      , 'A', '')

    EB.Template.TableAddfielddefinition('XX.POSTING.RESTRICT',EB.Template.T24Numeric, '', '')
    EB.Template.FieldSetcheckfile      ("POSTING.RESTRICT")
 
    EB.Template.TableAddfield          ('VALUE.DATE',EB.Template.T24Date, '','')
    
    EB.Template.TableAddfielddefinition('INACTIV.MARKER','1', 'A', '')
    
    EB.Template.TableAddfielddefinition('NIVEL','35', 'A', '')
    EB.Template.FieldSetcheckfile      ("ABC.NIVEL.CUENTA")

    EB.Template.TableAddreservedfield('RESERVED.40')
    EB.Template.TableAddreservedfield('RESERVED.39')
    EB.Template.TableAddreservedfield('RESERVED.38')
    EB.Template.TableAddreservedfield('RESERVED.37')
    EB.Template.TableAddreservedfield('RESERVED.36')
    EB.Template.TableAddreservedfield('RESERVED.35')
    EB.Template.TableAddreservedfield('RESERVED.34')
    EB.Template.TableAddreservedfield('RESERVED.33')
    EB.Template.TableAddreservedfield('RESERVED.32')
    EB.Template.TableAddreservedfield('RESERVED.31')
    EB.Template.TableAddreservedfield('RESERVED.30')
    EB.Template.TableAddreservedfield('RESERVED.29')
    EB.Template.TableAddreservedfield('RESERVED.28')
    EB.Template.TableAddreservedfield('RESERVED.27')
    EB.Template.TableAddreservedfield('RESERVED.26')
    EB.Template.TableAddreservedfield('RESERVED.25')
    EB.Template.TableAddreservedfield('RESERVED.24')
    EB.Template.TableAddreservedfield('RESERVED.23')
    EB.Template.TableAddreservedfield('RESERVED.22')
    EB.Template.TableAddreservedfield('RESERVED.21')
    EB.Template.TableAddreservedfield('RESERVED.20')
    EB.Template.TableAddreservedfield('RESERVED.19')
    EB.Template.TableAddreservedfield('RESERVED.18')
    EB.Template.TableAddreservedfield('RESERVED.17')
    EB.Template.TableAddreservedfield('RESERVED.16')
    EB.Template.TableAddreservedfield('RESERVED.15')
    EB.Template.TableAddreservedfield('RESERVED.14')
    EB.Template.TableAddreservedfield('RESERVED.13')
    EB.Template.TableAddreservedfield('RESERVED.12')
    EB.Template.TableAddreservedfield('RESERVED.11')
    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.9')
    EB.Template.TableAddreservedfield('RESERVED.8')
    EB.Template.TableAddreservedfield('RESERVED.7')
    EB.Template.TableAddreservedfield('RESERVED.6')
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')

    EB.Template.TableAddoverridefield()

    EB.Template.TableSetauditposition()



END

