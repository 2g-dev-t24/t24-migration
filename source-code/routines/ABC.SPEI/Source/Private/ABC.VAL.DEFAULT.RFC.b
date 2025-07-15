$PACKAGE AbcSpei
SUBROUTINE ABC.VAL.DEFAULT.RFC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* 2020-06-23 - Creación original (Alexis Almaraz Robles)
* 2024-06-10 - Migración a formato .b y modernización
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Updates
    $USING FT.Contract
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    Y.RFC.BENEF.SPEI = ''
    Y.POS.RFC.BENEF.SPEI = ''
    Y.VAL.DEF.RFC = 'ND'
    Y.NOMBRE.APP = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "RFC.BENEF.SPEI"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    Y.POS.RFC.BENEF.SPEI = R.POS.CAMPO<1,1>
    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.RFC.BENEF.SPEI = Y.LOCAL.REF<1,Y.POS.RFC.BENEF.SPEI>
    IF Y.RFC.BENEF.SPEI EQ "" THEN
        Y.LOCAL.REF<1,Y.POS.RFC.BENEF.SPEI> = Y.VAL.DEF.RFC
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
        EB.Display.RebuildScreen()
    END
    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
    RETURN

END 