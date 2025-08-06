*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.VALIDA.BOVEDA.CAJERO

******************************************************************
*  
*
******************************************************************

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING EB.ErrorProcessing

**************MAIN PROCESS

    GOSUB INICIALIZA

    GOSUB VALIDA.SUCURSAL

    RETURN

**************
INICIALIZA:
**************
    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    RETURN

******************
VALIDA.SUCURSAL:
******************
    Y.OPERADOR = EB.SystemTables.getOperator()

    Y.CAJERO.DESTINO = EB.SystemTables.getComi()

    LOOP
    WHILE LEN(Y.CAJERO.DESTINO) LT 4
        Y.CAJERO.DESTINO = "0":Y.CAJERO.DESTINO
    REPEAT

    
    EB.DataAccess.FRead(FN.TELLER.ID,Y.CAJERO.DESTINO,R.TELLER.ID,F.TELLER.ID,ERR.DETAIL)
    IF R.TELLER.ID THEN 
        Y.USUARIO.DESTINO = R.TELLER.ID<TT.Contract.TellerId.TidStatus>
    END

    EB.DataAccess.FRead(FN.USER,Y.USUARIO.DESTINO,R.USER,F.USER,ERR.DETAIL)
    IF R.USER THEN
        Y.SUCURSAL.DESTINO = R.USER<EB.Security.User.UseDepartmentCode>[1,5]
    END

    EB.DataAccess.FRead(FN.USER,Y.OPERADOR,R.USER,F.USER,ERR.DETAIL)
    IF R.USER THEN 
        Y.SUCURSAL = R.USER<EB.Security.User.UseDepartmentCode>[1,5]
    END

    IF Y.SUCURSAL NE Y.SUCURSAL.DESTINO THEN
        ETEXT = "CAJERO PERTENECE A OTRA SUCURSAL"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    IF Y.USUARIO.DESTINO EQ Y.OPERADOR THEN
        ETEXT = "MISMO OPERADOR"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    RETURN
END

