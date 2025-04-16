* @ValidationCode : MjotMjU5MDk5NjUxOkNwMTI1MjoxNzQ0MjQ1NTA1NDcwOlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2025 19:38:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>83</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE V.FT.GIC.DB.ACCT
*-----------------------------------------------------------------------
*
* This subroutine has to be Attached to the teller APPLICATION so that
* the currency will default to the accounts currency
*-----------------------------------------------------------------------------
* Modificado por : Jesus Andres Rivera Equiuha
* Fecha          : 13/Marzo/2015
* Descripcion    : Se cambio la llamada directa a los campos locales,
*                  por la funcion que regresa la posicion del campo local
*                  proporcionando el nombre del campo
*-----------------------------------------------------------------------
*
*       Revision History

*       First Release : 21/Apr/2008
*       Developed by :  Jorge Ortega
*       Description :   Get the Full Name of the client to show in FT version
*------------------------------------------------------------------------

*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*    $INSERT I_F.ACCOUNT
*    $INSERT I_F.FUNDS.TRANSFER


*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER
    $USING EB.API
    $USING EB.Display
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING ABC.BP
*------ Main Processing Section

    GOSUB PROCESS

RETURN
*
*-------
PROCESS:
*-------
    Y.MESSAGE = EB.SystemTables.getMessage()
    IF Y.MESSAGE = 'VAL' THEN RETURN
*
    YR.ACCOUNT = EB.SystemTables.getComi() ;*COMI

*CALL DBR('ACCOUNT':FM:AC.CUSTOMER,YR.ACCOUNT,Y.CUSTOMER)
    FN.CUENTA = 'F.ACCOUNT'
    FV.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, FV.CUENTA)
    
    REG.CUENTA = ''
    Y.CUSTOMER = ''
    REG.CUENTA = AC.AccountOpening.Account.Read(YR.ACCOUNT, ERR.CTA)
    Y.CUSTOMER = REG.CUENTA<AC.AccountOpening.Account.Customer>

*CALL GET.LOC.REF("FUNDS.TRANSFER","FT.DB.CUS.NAME",FT.DB.CUS.NAME.POS)
    Y.APP.LOC = 'FUNDS.TRANSFER'
    Y.FIELD.LOC = 'FT.DB.CUS.NAME'
    FT.DB.CUS.NAME.POS = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FIELD.LOC, FT.DB.CUS.NAME.POS)

*La variable COMI es utilizada por la rutina VPM.V.CUSTOMER.NAME para buscar al cliente
*COMI = Y.CUSTOMER
    EB.SystemTables.setComi(Y.CUSTOMER)
    ABC.BP.vpmVCustomerName()

    Y.NOM.CLIENTE = EB.SystemTables.getComiEnri() ;*COMI.ENRI
*R.NEW(FT.ORDERING.CUST)<1,1> = Y.NOM.CLIENTE
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.OrderingCust, Y.NOM.CLIENTE)
*COMI = YR.ACCOUNT
    EB.SystemTables.setComi(YR.ACCOUNT)
    
*Devolvemos el valor que tra�a COMI
*    COMI = YR.ACCOUNT
*
;*CALL REBUILD.SCREEN
    EB.Display.RebuildScreen()

RETURN
*
END
