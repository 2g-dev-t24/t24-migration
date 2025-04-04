* @ValidationCode : Mjo1MjA3NDY4MTQ6Q3AxMjUyOjE3NDM3MzY3MzkwMzY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2025 00:18:59
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
$PACKAGE AbcAplicaBonifCashin
SUBROUTINE ABC.APLICA.BONIF.CASHIN(ID.REGISTRO.BON)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING EB.Interface
    $USING AbcTable



    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
RETURN

RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------

    Y.ID.BONIFICACION = ''
    Y.CTA.CLIENTE = ''
    REG.BONIFICACION = ''
    Y.MONTO.A.BONIFICAR = ''
    
    FN.ABC.BONIF.CASHIN = AbcAplicaBonifCashin.getFnAbcBonifCashin()
    F.ABC.BONIF.CASHIN = AbcAplicaBonifCashin.getFAbcBonifCashin()
    
    Y.USR = AbcAplicaBonifCashin.getYUsr()
    Y.PWD = AbcAplicaBonifCashin.getYPwd()
    Y.OFS.SOURCE = AbcAplicaBonifCashin.getYOfsSource()
    
    

RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.ID.BONIFICACION = ID.REGISTRO.BON
    Y.CTA.CLIENTE = FIELD(Y.ID.BONIFICACION, ".", 1)
    
    EB.DataAccess.FRead(FN.ABC.BONIF.CASHIN, Y.ID.BONIFICACION, REG.BONIFICACION, F.ABC.BONIF.CASHIN, Y.ERR.BON)
    
    Y.MONTO.A.BONIFICAR = REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.MontoABonificar>

    IF Y.MONTO.A.BONIFICAR NE '' THEN
        GOSUB ARMA.OFS
        GOSUB ENVIA.OFS

        IF Y.RESULT EQ 1 THEN
            GOSUB MARCA.REG.APLICADO
        END
    END

RETURN
*---------------------------------------------------------------
ARMA.OFS:
*---------------------------------------------------------------

    OFS.MSG = ''
    PAYMENT.DETAILS = "BONIFICACION CASH IN"
    OFS.MSG  = "FUNDS.TRANSFER,BONIFICACION.CASH.IN/I/PROCESS//0,"
    OFS.MSG := Y.USR : "/" : Y.PWD : ","
    OFS.MSG := ",DEBIT.AMOUNT::=": Y.MONTO.A.BONIFICAR
    OFS.MSG := ",CREDIT.ACCT.NO::=": Y.CTA.CLIENTE
    OFS.MSG := ",DEBIT.CURRENCY::=MXN"
    OFS.MSG := ",PAYMENT.DETAILS:1:1=": PAYMENT.DETAILS

RETURN
*---------------------------------------------------------------
ENVIA.OFS:
*---------------------------------------------------------------

    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
    EB.Interface.OfsCallBulkManager(options, OFS.MSG, theResponse, txnCommitted)
*
    Y.RESULT = FIELD(theResponse, ",", 1)
    Y.ID.BONIF = FIELD(Y.RESULT,"/",1)
    Y.RESULT = FIELD(Y.RESULT, "/", 3)
    Y.ERR.MSG = FIELD(theResponse, ",", 2)

RETURN
*---------------------------------------------------------------
MARCA.REG.APLICADO:
*---------------------------------------------------------------

    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.Bonificado> = "SI"
    REG.BONIFICACION<AbcTable.AbcBonificacionCashIn.IdBonificacion> = Y.ID.BONIF

    WRITE REG.BONIFICACION TO F.ABC.BONIF.CASHIN, Y.ID.BONIFICACION

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN

END

