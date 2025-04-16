* @ValidationCode : MjoxMDMwOTczMjQxOkNwMTI1MjoxNzQ0MzE1OTY0MTQ2OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2025 15:12:44
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
$PACKAGE ABC.BP
*===============================================================================
* <Rating>-50</Rating>
*===============================================================================
SUBROUTINE ABC.VAL.LIMIT.MOVS.AC.COMI(Y.ID.MOVS.AC.COMI,Y.MONTO.TRANS,Y.MONTO.LIMIT.PARAM,Y.ID.NEW.FT,Y.ID.ADMIN,Y.ID.COMI,Y.ID.ESTAB,Y.CLIENTE)
*===============================================================================
* Nombre de Programa :  ABC.VAL.LIMIT.MOVS.AC.COMI
* Objetivo           :  Rutina para validar monto limite a comisionistas
* Requerimiento      :  Servicios Cashin - Limite Comisionistas
* Desarrollador      :  Alexis Almaraz Robles - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  10/Abril/2023
*===============================================================================
* Modificaciones:
*===============================================================================

*    $INSERT GLOBUS.BP I_COMMON
*    $INSERT GLOBUS.BP I_EQUATE
*    $INSERT ../T24_BP I_F.CURRENCY
*    $INSERT ABC.BP I_F.ABC.MOVS.CTA.COMISIONISTA
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.ErrorProcessing
    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.MONTO.ACUMULADO = 0
    Y.FECHA.MOVI = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

*    FN.ABC.MOVS.CTA.COMISIONISTA = "F.ABC.MOVS.CTA.COMISIONISTA"
*    F.ABC.MOVS.CTA.COMISIONISTA  = ""
*    CALL OPF(FN.ABC.MOVS.CTA.COMISIONISTA,F.ABC.MOVS.CTA.COMISIONISTA)
*
*    FN.CURRENCY = "F.CURRENCY"
*    F.CURRENCY = ""
*    CALL OPF(FN.CURRENCY, F.CURRENCY)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    GOSUB GET.MONTO.ACUMULA

    Y.MONTO.VAL.COMI.IN = Y.MONTO.ACUMULADO.IN + Y.MONTO.TRANS
    Y.MONTO.PERMI.IN = Y.MONTO.LIMIT.PARAM - Y.MONTO.ACUMULADO.IN

    IF Y.MONTO.VAL.COMI.IN GT Y.MONTO.LIMIT.PARAM THEN
        EB.SystemTables.setEtext("EL MONTO DE LA TRANSACCION SUPERA EL LIMITE PERMITIDO EN CASHIN. SE PERMITE UN MONTO MAXIMO DE ":Y.MONTO.PERMI.IN:" MXN")
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        Y.MOVS.IN = R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaOperacionIn>      ;*R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.OPERACION.IN>
        Y.NO.MOVS.IN = DCOUNT(Y.MOVS.IN,VM)

*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.CUSTOMER> = Y.CLIENTE
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaCustomer> = Y.CLIENTE
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.OPERACION.IN, Y.NO.MOVS.IN+1> = Y.ID.NEW.FT
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaOperacionIn,Y.NO.MOVS.IN+1> = Y.ID.NEW.FT
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.MONTO.IN, Y.NO.MOVS.IN+1> = Y.MONTO.TRANS
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaMontoIn, Y.NO.MOVS.IN+1> = Y.MONTO.TRANS
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.FECHA.MOV.IN, Y.NO.MOVS.IN+1> = Y.FECHA.MOVI
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaFechaMovIn, Y.NO.MOVS.IN+1> = Y.FECHA.MOVI
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.ADMIN.COMIS.IN, Y.NO.MOVS.IN+1> = Y.ID.ADMIN
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaAdminComisIn, Y.NO.MOVS.IN+1> = Y.ID.ADMIN
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.ID.COMI.IN, Y.NO.MOVS.IN+1> = Y.ID.COMI
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaIdComiIn, Y.NO.MOVS.IN+1> = Y.ID.COMI
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.COMI.ESTAB.IN, Y.NO.MOVS.IN+1> = Y.ID.ESTAB
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaComiEstabIn, Y.NO.MOVS.IN+1> = Y.ID.ESTAB
*        R.ABC.MOVS.CTA.COMISIONISTA<MOVS.AC.COMI.MONTO.TOTAL.IN> = Y.MONTO.VAL.COMI.IN
        R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaMontoIn> = Y.MONTO.VAL.COMI.IN

*        WRITE R.ABC.MOVS.CTA.COMISIONISTA TO F.ABC.MOVS.CTA.COMISIONISTA, Y.ID.MOVS.AC.COMI
        ABC.BP.AbcMovsCtaComisionista.Write(Y.ID.MOVS.AC.COMI, R.ABC.MOVS.CTA.COMISIONISTA)
    END

RETURN

*-------------------------------------------------------------------------------
GET.MONTO.ACUMULA:
*-------------------------------------------------------------------------------

    R.ABC.MOVS.CTA.COMISIONISTA = ''
    Y.ERR.MOVS.AC.COMI = ''
    Y.MONTO.ACUMULADO.IN = ''
*    CALL F.READ(FN.ABC.MOVS.CTA.COMISIONISTA, Y.ID.MOVS.AC.COMI, R.ABC.MOVS.CTA.COMISIONISTA, F.ABC.MOVS.CTA.COMISIONISTA, Y.ERR.MOVS.AC.COMI)
    ABC.BP.AbcMovsCtaComisionista.Read(Y.ID.MOVS.AC.COMI, Y.ERR.MOVS.AC.COMI)
    IF R.ABC.MOVS.CTA.COMISIONISTA THEN
        Y.MONTO.ACUMULADO.IN = R.ABC.MOVS.CTA.COMISIONISTA<ABC.BP.AbcMovsCtaComisionista.AbcMovsCtaComisionistaMontoTotalIn>      ;*<MOVS.AC.COMI.MONTO.TOTAL.IN>
    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
