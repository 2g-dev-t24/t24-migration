*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
*   Descripcion : Calcula el Ingreso Total del Cliente
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.CALC.ING.TOTAL.CUST

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING ABC.BP

    GOSUB INIT
    GOSUB PROCESO
    GOSUB VALIDA.REGISTRO
	CALL REBUILD.SCREEN
RETURN

************
INIT:
**********************
    Y.ING.COMI  = EB.SystemTables.getComi()

    Y.APP.LOC = 'CUSTOMER'
    Y.NOM.CAMPOS   = 'TOT.ING':@VM:'ING.SEC'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.NOM.CAMPOS, Y.POS.LOC)

    Y.POS.TOT.INGL = Y.POS.LOC<1,1>
    Y.POS.ING.SEC = Y.POS.LOC<1,2>

    RETURN

************
PROCESO:
**********************
    IF EB.SystemTables.getAf() EQ EbCusLocalRef THEN
        Y.ING.CAMPO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSalary)
        Y.TOT.ING = Y.ING.COMI + Y.ING.CAMPO
        Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.LOCAL.REF<1,Y.POS.TOT.ING>  = Y.TOT.ING
    END

    IF EB.SystemTables.getAf() EQ EbCusSalary THEN
        Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
        Y.ING.CAMPO = Y.LOCAL.REF<1,Y.POS.ING.SEC>
        Y.TOT.ING = Y.ING.COMI + Y.ING.CAMPO
        Y.LOCAL.REF<1,Y.POS.TOT.ING>  = Y.TOT.ING
    END
RETURN

****************
VALIDA.REGISTRO:
****************
	Y.VAL.ACTUAL = EB.SystemTables.getComi()
	Y.ORIGEN = "INGRESOS"
	CALL ABC.BP.AbcCustValidaTodo(Y.VAL.ACTUAL, Y.ORIGEN)
RETURN
END
