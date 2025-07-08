*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.VALIDA.LIMITE.MONTO(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,Y.ID,Y.CLIENTE)
*----------------------------------------------------------------
*----------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    
    $USING AbcTable

    GOSUB INICIO
    GOSUB APERTURA
    GOSUB MONTO.ACUMULADO

    Y.MONTO.CUENTA = Y.MONTO.ACUMULADO + Y.MONTO.TRANS
    Y.MONTO.RESTANTE = Y.MONTO.LIMITE - Y.MONTO.ACUMULADO

    IF Y.MONTO.CUENTA GT Y.MONTO.LIMITE THEN
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        Y.FECHAS = R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.FechaMov>
        Y.FECHAS.CONT = DCOUNT(Y.FECHAS,@VM)

        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.Customer> = Y.CLIENTE
        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.IdOperacion,Y.FECHAS.CONT+1> = Y.ID
        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.FechaMov,Y.FECHAS.CONT+1> = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")
        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoMov,Y.FECHAS.CONT+1> = Y.MONTO.TRANS
        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoTotal> = Y.MONTO.CUENTA

        EB.DataAccess.FWrite(FN.ABC.MOVS.CTA.NIVEL2,Y.ID.LIMITE,R.MOV.CTA) 
    END

    RETURN


****************
MONTO.ACUMULADO:
****************

    EB.DataAccess.FRead(FN.ABC.MOVS.CTA.NIVEL2,Y.ID.LIMITE,R.MOV.CTA,F.ABC.MOVS.CTA.NIVEL2,YMOV.CTA)
    IF R.MOV.CTA THEN
        Y.MONTO.ACUMULADO = R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoTotal>
    END

    RETURN

*********
APERTURA:
*********

    FN.ABC.MOVS.CTA.NIVEL2 = 'F.ABC.MOVS.CTA.NIVEL2'
    F.ABC.MOVS.CTA.NIVEL2 = ''
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.NIVEL2,F.ABC.MOVS.CTA.NIVEL2)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    EB.DataAccess.Opf(FN.CURRENCY,F.CURRENCY)

    RETURN

*******
INICIO:
*******

    Y.MONTO.ACUMULADO = 0
    Y.CURRENCY = 'UDI'

    RETURN

END
