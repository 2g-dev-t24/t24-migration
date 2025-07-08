*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.FILL.INF.CASHIN
*===============================================================================
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates

    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

    RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------

    FN.ABC.COMISIONISTAS = 'F.ABC.COMISIONISTAS'
    F.ABC.COMISIONISTAS = ''
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS,F.ABC.COMISIONISTAS)

    NOM.CAMPOS     = 'ID.COMI'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER',NOM.CAMPOS,POS.CAMP.LOCAL)

    Y.ID.COMI.POS = POS.CAMP.LOCAL<1,1>

    RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.COMISIONISTA = ''
    REC.COMISIONISTA = ''
    Y.ERR.COMISIONISTA = ''

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.COMISIONISTA = Y.LOCAL.REF<1,Y.ID.COMI.POS>

    EB.DataAccess.FRead(FN.ABC.COMISIONISTAS,Y.COMISIONISTA,REC.COMISIONISTA,F.ABC.COMISIONISTAS,Y.ERR.COMISIONISTA)

    IF Y.ERR.COMISIONISTA THEN
        RETURN
    END

    Y.AC.NOMBRE.COMI = ''
    Y.AC.NOMBRE.COMI = REC.COMISIONISTA<AbcTable.AbcComisionistas.NombreComi>

    Y.EXTEND.INFO = 'Deposito en ' : Y.AC.NOMBRE.COMI
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.ExtendInfo,Y.EXTEND.INFO)

    RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

    RETURN

END
