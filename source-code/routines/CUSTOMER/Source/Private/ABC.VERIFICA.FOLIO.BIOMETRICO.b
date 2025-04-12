*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VERIFICA.FOLIO.BIOMETRICO
*===============================================================================
* Nombre de Programa : ABC.VERIFICA.FOLIO.BIOMETRICO
* Objetivo           : Rutina para marcar como verificados los registros de ABC.BIOMETRICOS
* una vez que han sido utilizados para dar de alta un cliente
*===============================================================================

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING ABC.BP
    $USING EB.LocalReferences

    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    FN.ABC.BIOM = 'F.ABC.BIOMETRICOS'
    F.ABC.BIOM = ''
    EB.DataAccess.Opf(FN.ABC.BIOM, F.ABC.BIOM)


    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'IUB'
    V.FLD.POS  = ''

    EB.LocalReferences.GetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)
    POS.IUB = V.FLD.POS<1,1>

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.IUB.BIO = Y.LOCAL.REF<1,POS.IUB>
    Y.FNCTION = EB.SystemTables.getVFunction()

    EB.DataAccess.FRead(FN.ABC.BIOM, Y.IUB.BIO, R.FOL.BIO, F.ABC.BIOM, ERR.FOL)
    Y.STA.IUB =  R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomVerificado>


    BEGIN CASE

    CASE Y.FNCTION EQ 'D'
        BAND.IUB.VER = Y.STA.IUB
        GOSUB VERIFICA.IUB

    CASE Y.FNCTION EQ 'I'
        BANDE.IUB.VER = ''
        GOSUB VERIFICA.IUB
    END CASE

    RETURN

*---------------------------------------------------------------
VERIFICA.IUB:
*---------------------------------------------------------------
*    EB.SystemTables.setTSequ(BAND.IUB.VER)
*    EB.ErrorProcessing.Err()
    IF BAND.IUB.VER EQ 'SI' THEN
        R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomVerificado> = 'NO'
    END

    IF BAND.IUB.VER NE 'SI' THEN
        R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomVerificado> = 'SI'
    END
*    WRITE R.FOL.BIO TO F.ABC.BIOM, Y.IUB.BIO
    EB.DataAccess.FWrite(FN.ABC.BIOM, Y.IUB.BIO, R.FOL.BIO)
    BAND.IUB.VER = ''

    RETURN
END