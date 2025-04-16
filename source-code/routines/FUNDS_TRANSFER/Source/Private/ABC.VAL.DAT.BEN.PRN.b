* @ValidationCode : MjoyMTM0Nzg0ODc6Q3AxMjUyOjE3NDQ0MTg2NjcxOTY6VXNpYXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2025 19:44:27
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
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VAL.DAT.BEN.PRN
*-----------------------------------------------------------------------------
* Creado por  : C�sar Miranda (FYG)
* Fecha       : 24/Marzo/2021
* Descripcion : Rutina para validar las cuentas de operacion provenientes
*               de cuentas PRN
*------------------------------------------------------------------------
*CARGADA A VERSIONES:
*-------------------------------------------------------------------------------
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN
*FUNDS.TRANSFER,ABC.TRASPASO.DIGITAL
*FUNDS.TRANSFER,ABC.TRASPASO.EXPRESS.PRN.2
*===============================================================================
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AC.Config
    $USING EB.Updates
    $USING EB.ErrorProcessing

*    CALL GET.LOC.REF("FUNDS.TRANSFER","RFC.BENEF.SPEI",Y.POS.RFC.BEN)
*    CALL GET.LOC.REF("FUNDS.TRANSFER","TIPO.CTA.BEN",Y.POS.TIPO.CTA.BEN)
    Y.NOMBRE.APP<-1> = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO<1,1> = "RFC.BENEF.SPEI"
    Y.NOMBRE.CAMPO<1,2> = "TIPO.CTA.BEN"
    R.POS.CAMPO = ''
    Y.POS.EXT.TRANS.ID = ''
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    Y.POS.RFC.BEN = R.POS.CAMPO<1, 1>
    Y.POS.TIPO.CTA.BEN = R.POS.CAMPO<1, 2>

    Y.FT.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.RFC.BENEF.SPEI = Y.FT.LOCAL.REF<1, Y.POS.RFC.BEN> ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.RFC.BEN>
    Y.TIPO.CTA.BEN = Y.FT.LOCAL.REF<1, Y.POS.TIPO.CTA.BEN> ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.TIPO.CTA.BEN>
    Y.PAYMENT.DETAILS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails) ;*R.NEW(FT.PAYMENT.DETAILS)

    IF Y.PAYMENT.DETAILS EQ '' THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.PaymentDetails) ;*AF = FT.PAYMENT.DETAILS
        EB.SystemTables.setEtext("NO EXISTE INFORMACION SOBRE EL NOMBRE DEL BENEFICIARIO") ;*ETEXT = "NO EXISTE INFORMACION SOBRE EL NOMBRE DEL BENEFICIARIO"
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        IF Y.RFC.BENEF.SPEI EQ '' THEN
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef) ;*AF = FT.LOCAL.REF
            EB.SystemTables.setEtext("NO EXISTE INFORMACION SOBRE EL RFC DEL BENEFICIARIO") ;*ETEXT = "NO EXISTE INFORMACION SOBRE EL RFC DEL BENEFICIARIO"
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            IF Y.TIPO.CTA.BEN EQ '' THEN
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef) ;*AF = FT.LOCAL.REF
                EB.SystemTables.setEtext("NO EXISTE INFORMACION SOBRE EL TIPO DE CUENTA DEL BENEFICIARIO") ;*ETEXT = "NO EXISTE INFORMACION SOBRE EL TIPO DE CUENTA DEL BENEFICIARIO"
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END

RETURN

END
