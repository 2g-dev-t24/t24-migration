$PACKAGE AbcSpei
SUBROUTINE ABC.VALIDA.LEN.CTA.BEN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* 2020-06-10 - Creación original (Alexis Almaraz Robles)
* 2024-06-10 - Migración a formato .b y modernización
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING EB.Updates

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    Y.CTA.BENEF = EB.SystemTables.getComi()
    Y.LEN.CTA.BENEF = ''
    Y.POS.TIPO.CTA.BEN = ''
    Y.TIPO.CTA.BENEF = ''
    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    Y.NOMBRE.APP = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "TIPO.CTA.BEN"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    Y.POS.TIPO.CTA.BEN = R.POS.CAMPO<1,1>
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.TIPO.CTA.BENEF = Y.LOCAL.REF<1,Y.POS.TIPO.CTA.BEN>
    Y.LEN.CTA.BENEF = LEN(TRIM(Y.CTA.BENEF))

    BEGIN CASE
    CASE Y.TIPO.CTA.BENEF EQ 40
        IF Y.LEN.CTA.BENEF NE 18 THEN
            ETEXT = 'Longitud invalida para el tipo de cuenta ':Y.TIPO.CTA.BENEF
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    CASE Y.TIPO.CTA.BENEF EQ 10
        IF Y.LEN.CTA.BENEF NE 10 THEN
            ETEXT = 'Longitud invalida para el tipo de cuenta ':Y.TIPO.CTA.BENEF
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    CASE Y.TIPO.CTA.BENEF EQ 3
        IF Y.LEN.CTA.BENEF NE 16 THEN
            ETEXT = 'Longitud invalida para el tipo de cuenta ':Y.TIPO.CTA.BENEF
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    CASE OTHERWISE
        ETEXT = 'Tipo de cuenta invalida ':Y.TIPO.CTA.BENEF
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END CASE
    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
    RETURN

END 