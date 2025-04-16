* @ValidationCode : MjozMjU1NTIyMzM6Q3AxMjUyOjE3NDQ1NjkyMTE4MTM6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2025 13:33:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.APLICA.BONIF.CASHIN(ID.REGISTRO.BON)
*===============================================================================
* Nombre de Programa : ABC.APLICA.BONIF.CASHIN
* Objetivo           : Rtn Multithread de aplicacion de FTs de bonificaciones
*                      por depositos CASH IN a cuentas de clientes
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2022-08-16
* Modificaciones:
*===============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_TSA.COMMON
*    $INSERT I_F.ABC.BONIFICACION.CASH.IN
    $INSERT I_ABC.APLI.BONIF.CASHIN.COMMON
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.Foundation
    $USING EB.Interface
    $USING ABC.BP

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

RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.ID.BONIFICACION = ID.REGISTRO.BON
    Y.CTA.CLIENTE = FIELD(Y.ID.BONIFICACION, ".", 1)
    EB.DataAccess.FRead(FN.ABC.BONIF.CASHIN, Y.ID.BONIFICACION, REG.BONIFICACION, F.ABC.BONIF.CASHIN, Y.ERR.BON)
    Y.MONTO.A.BONIFICAR = REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInMontoABonificar>;*REG.BONIFICACION<CASH.IN.MONTO.A.BONIFICAR>

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

*    OFS.MSG = ''
*    PAYMENT.DETAILS = "BONIFICACION CASH IN"
*    OFS.MSG  = "FUNDS.TRANSFER,BONIFICACION.CASH.IN/I/PROCESS//0,"
*    OFS.MSG := Y.USR : "/" : Y.PWD : ","
*    OFS.MSG := ",DEBIT.AMOUNT::=": Y.MONTO.A.BONIFICAR
*    OFS.MSG := ",CREDIT.ACCT.NO::=": Y.CTA.CLIENTE
*    OFS.MSG := ",DEBIT.CURRENCY::=MXN"
*    OFS.MSG := ",PAYMENT.DETAILS:1:1=": PAYMENT.DETAILS

    Y.APLICACION.OFS = 'FUNDS.TRANSFER'
    Y.VERSION = Y.APLICACION.OFS:",BONIFICACION.CASH.IN"
    Y.APL.OFSFUNCTION  = 'I'
    Y.PROCESS = 'PROCESS'
    Y.GTSMODE = ''
    Y.NO.OF.AUTH = '0'
    Y.NEW.REC.ID = ''
    REC.FT.BONI.CASHIN = ''
    Y.OFS.REQUEST = ''
    PAYMENT.DETAILS = "BONIFICACION CASH IN"
    
    REC.FT.BONI.CASHIN<FT.Contract.FundsTransfer.DebitAmount> = Y.MONTO.A.BONIFICAR
    REC.FT.BONI.CASHIN<FT.Contract.FundsTransfer.CreditAcctNo> = Y.CTA.CLIENTE
    REC.FT.BONI.CASHIN<FT.Contract.FundsTransfer.DebitCurrency> = "MXN"
    REC.FT.BONI.CASHIN<FT.Contract.FundsTransfer.PaymentDetails> = PAYMENT.DETAILS
    EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS, Y.APL.OFSFUNCTION, Y.PROCESS, Y.VERSION, Y.GTSMODE, Y.NO.OF.AUTH, Y.NEW.REC.ID, REC.FT.BONI.CASHIN, Y.OFS.REQUEST)

RETURN
*---------------------------------------------------------------
ENVIA.OFS:
*---------------------------------------------------------------

    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
*    CALL OFS.CALL.BULK.MANAGER(options, OFS.MSG, theResponse, txnCommitted)
    EB.Interface.OfsCallBulkManager(OFS.SOURCE, Y.OFS.REQUEST, theResponse, txnCommitted)
    
    Y.RESULT = FIELD(theResponse, ",", 1)
    Y.ID.BONIF = FIELD(Y.RESULT,"/",1)
    Y.RESULT = FIELD(Y.RESULT, "/", 3)
    Y.ERR.MSG = FIELD(theResponse, ",", 2)

RETURN
*---------------------------------------------------------------
MARCA.REG.APLICADO:
*---------------------------------------------------------------

*REG.BONIFICACION<CASH.IN.BONIFICADO> = "SI"||
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInBonificado> = "SI"
*REG.BONIFICACION<CASH.IN.ID.BONIFICACION> = Y.ID.BONIF
    REG.BONIFICACION<ABC.BP.AbcBonificacionCashIn.AbcBonificacionCashInIdBonificacion> = Y.ID.BONIF

*WRITE REG.BONIFICACION TO F.ABC.BONIF.CASHIN, Y.ID.BONIFICACION
*CALL F.WRITE(FN.ABC.BONIF.CASHIN, Y.ID.BONIFICACION, REG.BONIFICACION)
*    EB.DataAccess.FWrite(FN.ABC.BONIF.CASHIN, Y.ID.BONIFICACION, REG.BONIFICACION)
    ABC.BP.AbcBonificacionCashIn.Write(Y.ID.BONIFICACION, REG.BONIFICACION)

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN

END
