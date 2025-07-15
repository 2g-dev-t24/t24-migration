$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.ARMA.REQUEST(Y.TAG.S, Y.TAG.I, Y.VALORES, Y.CADENA.SALIDA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    GOSUB INIT.VARS
    GOSUB PROCESS
    RETURN

**********
INIT.VARS:
**********
    Y.SEP.CAD = ","
    R.TAG.S = ""
    R.TAG.I = ""
    R.TAG.F = ""
    Y.CADENA.SALIDA = ""

    Y.DATS = DCOUNT(Y.TAG.S, Y.SEP.CAD)
    FOR Y.I = 1 TO Y.DATS
        Y.TAG.X = FIELD(Y.TAG.S, Y.SEP.CAD, Y.I)
        IF Y.TAG.X THEN
            R.TAG.S<-1> = "<" : Y.TAG.X : ">"
            R.TAG.S<-1> = "</" : Y.TAG.X : ">"
        END
    NEXT Y.I

    Y.DATS = DCOUNT(Y.TAG.I, Y.SEP.CAD)
    FOR Y.I = 1 TO Y.DATS
        Y.TAG.X = FIELD(Y.TAG.I, Y.SEP.CAD, Y.I)
        IF Y.TAG.X THEN
            R.TAG.I<-1> = "<" : Y.TAG.X : ">"
            R.TAG.F<-1> = "</" : Y.TAG.X : ">"
        END
    NEXT Y.I
    RETURN

********
PROCESS:
********
    Y.SEP = "|"
    Y.NUM.DATOS = DCOUNT(Y.VALORES, Y.SEP)

    Y.CADENA.DATOS = R.TAG.S<1>
    FOR Y.I = 1 TO Y.NUM.DATOS
        Y.CADENA.DATOS := R.TAG.I<Y.I>
        Y.CADENA.DATOS := FIELD(Y.VALORES, Y.SEP, Y.I)
        Y.CADENA.DATOS := R.TAG.F<Y.I>
    NEXT Y.I
    Y.CADENA.DATOS := R.TAG.S<2>
    Y.CADENA.SALIDA = Y.CADENA.DATOS
    RETURN
END 