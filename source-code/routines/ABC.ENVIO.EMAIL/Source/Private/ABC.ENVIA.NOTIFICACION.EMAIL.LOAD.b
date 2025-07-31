* @ValidationCode : Mjo2Mzg2NTMxNDA6Q3AxMjUyOjE3NTM5MjMyNDUxODg6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 30 Jul 2025 21:54:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcEnvioEmail

SUBROUTINE ABC.ENVIA.NOTIFICACION.EMAIL.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING ABC.BP
    
    GOSUB INICIALIZA
    GOSUB FINALIZA

RETURN

***********
INICIALIZA:
***********

    FN.CLIENTE   = 'F.CUSTOMER'
    F.CLIENTE   = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
    
    FN.SS        = 'F.STANDARD.SELECTION'
    F.SS        = ''
    EB.DataAccess.Opf(FN.SS,F.SS)
    
    FN.SMS.EMAIL = 'F.ABC.SMS.EMAIL.ENVIAR'
    F.SMS.EMAIL = ''
    EB.DataAccess.Opf(FN.SMS.EMAIL,F.SMS.EMAIL)
    
    FN.CUENTAS.D = 'F.ABC.CUENTAS.DESTINO'
    F.CUENTAS.D = ''
    EB.DataAccess.Opf(FN.CUENTAS.D,F.CUENTAS.D)

    YSEP = '|'

    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")
    TODAY = EB.SystemTables.getToday()
    Y.DATE = TODAY[3,6]

    Y.SALTO = CHAR(10)

    Y.ID.NOTIF.EMAIL.PARAM = 'ENVIA.NOTIF.EMAIL.PARAM'      ;*LFCR_20231222_HTML - S
    Y.LIST.PARAMS.HTML = '' ; Y.LIST.VALUES.HTML = ''
  
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.NOTIF.EMAIL.PARAM, Y.LIST.PARAMS.HTML, Y.LIST.VALUES.HTML)
    
    LOCATE "RUTA.HTML" IN Y.LIST.PARAMS.HTML SETTING POS THEN
        Y.RUTA.HTML = Y.LIST.VALUES.HTML<POS>
    END   ;* LFCR_20231222_HTML - E

    Y.RAZON.SOCIAL.ARG = "FULL" ; Y.RAZON.SOCIAL = ''
    
    ABC.BP.AbcGetRazonSocial(Y.RAZON.SOCIAL.ARG)

    Y.RAZON.SOCIAL = Y.RAZON.SOCIAL.ARG

    AbcEnvioEmail.setFnCliente(FN.CLIENTE)
    AbcEnvioEmail.setFCliente(F.CLIENTE)
    AbcEnvioEmail.setFnSs(FN.SS)
    AbcEnvioEmail.setFSs(F.SS)
    AbcEnvioEmail.setFnSmsEmail(FN.SMS.EMAIL)
    AbcEnvioEmail.setFSmsEmail(F.SMS.EMAIL)
    AbcEnvioEmail.setFnCuentasD(FN.CUENTAS.D)
    AbcEnvioEmail.setFCuentasD(F.CUENTAS.D)
    AbcEnvioEmail.setYSep(YSEP)
    AbcEnvioEmail.setFechaFile(FECHA.FILE)
    AbcEnvioEmail.setYDate(Y.DATE)
    AbcEnvioEmail.setYSalto(Y.SALTO)
    AbcEnvioEmail.setYRutaHtml(Y.RUTA.HTML)
    AbcEnvioEmail.setYRazonSocial(Y.RAZON.SOCIAL)

RETURN

*********
FINALIZA:
*********

RETURN

END
