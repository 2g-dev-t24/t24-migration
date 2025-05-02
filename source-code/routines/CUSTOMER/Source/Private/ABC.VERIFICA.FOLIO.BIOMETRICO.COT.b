*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VERIFICA.FOLIO.BIOMETRICO.COT
*===============================================================================
* Nombre de Programa : ABC.VERIFICA.FOLIO.BIOMETRICO.COT
* Objetivo           : Rutina para marcar como verificados los registros de ABC.BIOMETRICOS
* una vez que han sido utilizados para dar de alta un cotitular. Tambián actualiza el
* campo CUC con el número de cliente
*===============================================================================

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING ABC.BP 

    GOSUB INICIALIZA
    GOSUB PROCESO

    RETURN

***********
INICIALIZA:
***********

    FN.ABC.BIOM = 'F.ABC.BIOMETRICOS'
    F.ABC.BIOM = ''
    EB.DataAccess.Opf(FN.ABC.BIOM, F.ABC.BIOM)

    Y.IUB.BIO = ''
    R.FOL.BIO = ''
    BAND.IUB.VER = ''

    EB.LocalReferences.GetLocRef('CUSTOMER', 'IUB', POS.IUB)

    RETURN

********
PROCESO:
********
    Y.IUB.BIO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,POS.IUB>
    
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

*************
VERIFICA.IUB:
*************

    IF BAND.IUB.VER EQ 'SI' THEN
        R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomVerificado> = 'NO'
        R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomCuc> = ''
    END

    IF BAND.IUB.VER NE 'SI' THEN
        R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomVerificado> = 'SI'
        R.FOL.BIO<ABC.BP.AbcBiometricos.AbcBiomCuc> = EB.SystemTables.getIdNew()
    END

    EB.DataAccess.FWrite(FN.ABC.BIOM, Y.IUB.BIO, R.FOL.BIO)

    BAND.IUB.VER = ''

    RETURN

END
