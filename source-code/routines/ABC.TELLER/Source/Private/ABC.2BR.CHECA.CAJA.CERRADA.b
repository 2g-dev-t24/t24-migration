*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.CHECA.CAJA.CERRADA
*
*
*    First Release :
*    Developed for : 
*    Developed by  :
*
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract

*************************************************************************
*INICIALIZA
*************************************************************************
     TELLER.ID= EB.SystemTables.getComi()
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID = ""
    EB.DataAccess.Opf(FN.TELLER.ID, F.TELLER.ID)

*************************************************************************
*PROCESA
*************************************************************************

    EB.DataAccess.FRead(FN.TELLER.ID,TELLER.ID,R.TELLER.ID,F.TELLER.ID,ERR.DETAIL)
    Y.ESTADO = ''
    IF R.TELLER.ID THEN
        Y.ESTADO = R.TELLER.ID<TT.Contract.TellerId.TidStatus>
    END

     IF Y.ESTADO EQ "CLOSE" THEN
        EB.SystemTables.setE("CAJA YA CERRADA")
     END

END
