*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.VALIDA.TELLER.FOL.VAL
*===============================================================================
* Nombre de Programa : ABC.VALIDA.TELLER.FOL.VAL
* Objetivo           : Rutina para validar el registro de FOLIO.VALIDACION en
* ABC.VALIDACION.BIOMETRICOS, para versiones de TELLER
* Desarrollador      : 
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING TT.Contract
    $USING ABC.BP
    $USING EB.ErrorProcessing
    
    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    EB.DataAccess.Opf(FN.TELLER, F.TELLER)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    EB.DataAccess.Opf(FN.TELLER.HIS, F.TELLER.HIS)

    EB.LocalReferences.GetLocRef('TELLER', 'FOL.VALIDACION', POS.FOL.VAL)

    Y.ACC.CUS = ''
    Y.FOL.VAL = ''
    Y.MONT.TR = ''

    RETURN

*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

    IF INDEX('R',EB.SystemTables.getVFunction(),1) THEN
        Y.ID.TT = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.TELLER, Y.ID.TT, REC.TT, F.TELLER, ERR.TT)
        IF ERR.TT THEN
            Y.ID.TT.HIS = Y.ID.TT : ";1"
            EB.DataAccess.FRead(FN.TELLER.HIS, Y.ID.FT.HIS, REC.TT, F.TELLER.HIS, ERR.TT)
        END
        Y.ACC.CUS = REC.TT<TT.Contract.Teller.TeAccountOne>
        Y.FOL.VAL = REC.TT<TT.Contract.Teller.TeLocalRef, POS.FOL.VAL>
    END ELSE

        Y.FOL.VAL = R.NEW(TT.Contract.Teller.TeLocalRef)<1, POS.FOL.VAL>
        Y.ACC.CUS = R.NEW(TT.Contract.Teller.TeAccountOne)
        Y.MONT.TR = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    END

    Y.DATOS<-1> = Y.ACC.CUS
    Y.DATOS<-1> = Y.FOL.VAL
    Y.DATOS<-1> = Y.MONT.TR


    EB.SystemTables.setAf(TT.Contract.Teller.TeLocalRef) ; EB.SystemTables.setAv(POS.FOL.VAL) ;  EB.SystemTables.setAs(0)
    ABC.BP.AbcValidaVerificaFolio(Y.DATOS, Y.ERROR)
    IF Y.ERROR NE '' THEN
        E = Y.ERROR
        EB.SystemTables.setE(Y.ERROR)
        EB.ErrorProcessing.Err()
    END

    RETURN
