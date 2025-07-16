* @ValidationCode : MjotMTA0ODc2MTczODpDcDEyNTI6MTc1MjYyODA4MjU3NjptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Jul 2025 22:08:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VALIDA.NOT.SPEI.ESPECIAL
*===============================================================================
* Nombre de Programa : ABC.VALIDA.NOT.SPEI.ESPECIAL
* Objetivo           : @ID-RTN para versiones de SPEI normal que valida si una txn
*       es de SPEI especial(FOL.VALIDACION EQ ESP) no permita abrirlo
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2021-04-06
* Modificaciones:
*===============================================================================

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING FT.Contract
    $USING EB.ErrorProcessing
    $USING EB.SystemTables

    GOSUB INICIALIZA
    GOSUB VALIDA
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    EB.DataAccess.Opf(FN.FT.NAU, F.FT.NAU)
    
    YAPP            = 'FUNDS.TRANSFER'
    YFIELD          = 'FOL.VALIDACION'
    POS.FOL.VAL     = ''
    EB.LocalReferences.GetLocRef(YAPP, YFIELD, POS.FOL.VAL)

RETURN
*---------------------------------------------------------------
VALIDA:
*---------------------------------------------------------------

    Y.ID.FT = ''
    R.FT = ''
    Y.FOL.REG = ''

    Y.ID.FT = EB.SystemTables.getComi()

    EB.DataAccess.FRead(FN.FT.NAU, Y.ID.FT, R.FT, F.FT.NAU, FT.ERR)
    IF R.FT NE "" THEN
        Y.FOL.REG = R.FT<FT.Contract.FundsTransfer.LocalRef, POS.FOL.VAL>
        IF Y.FOL.REG EQ "ESP" THEN
            E = "TRANSACCION SPEI ESPECIAL, UTILIZAR OPCION DE AUTORIZACION ESPECIAL"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END
    END

RETURN
