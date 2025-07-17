* @ValidationCode : MjotMTI0ODk3NDM2MzpDcDEyNTI6MTc1MjcxNTU2OTQwMDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jul 2025 22:26:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcTeller

SUBROUTINE ABC.2BR.VAL.NARR
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess

    $USING TT.Contract
    $USING AbcTable
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE

    IF NOT(R.ABC.GENERAL.PARAM) THEN
        RETURN
    END

    GOSUB VALIDATE
    
RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    
    Y.PARAM.ID = "ABC.2BR.PARAM.DEP.EFE"
    R.ABC.GENERAL.PARAM = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.DATOS.PARAM = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el parametro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
RETURN
*-----------------------------------------------------------------------------
VALIDATE:
*-----------------------------------------------------------------------------
    YCUENTA.INGRESADA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
    LOCATE YCUENTA.INGRESADA IN Y.DATOS.PARAM SETTING YPOSICION ELSE
        YPOSICION = 0
    END

    IF NOT(YPOSICION) THEN
        RETURN
    END

    COMI = EB.SystemTables.getComi()
    IF NOT(COMI) THEN
        ETEXT = "NARRATIVA ES OBLIGATORIA PARA LA CUENTA"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    YPOSICION.RUTINA = YPOSICION + 1
    YRUTINA.A.LLAMAR = Y.DATOS.PARAM<YPOSICION.RUTINA>

    IF YRUTINA.A.LLAMAR THEN
        R.RUTINA.A.LLAMAR = ""
        R.RUTINA.A.LLAMAR = EB.SystemTables.Api.Read(YRUTINA.A.LLAMAR, API.ERR)
    
        IF (R.RUTINA.A.LLAMAR EQ '') THEN
            RETURN
        END
    
        YNARRATIVA = EB.SystemTables.getComi()
        EB.SystemTables.CallBasicRoutine(YRUTINA.A.LLAMAR, YNARRATIVA, '')
        IF YNARRATIVA THEN
            ETEXT = YNARRATIVA
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END