*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.ONLY.NUMERIC

*------------------------------------------------------------------
* Update         : 
* By             : 
* Descripcion    : Validacion para que no se ingresen numeros
*                  en campos de nombres y apellidos
*-----------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.Display
    $USING EB.ErrorProcessing

;* Validando que solo se incluyan numeros
    Y.COMI  = EB.SystemTables.getComi()
    Y.LONG  = LEN(Y.COMI)

    FOR I = 1 TO Y.LONG
        IF ISDIGIT(Y.COMI[I,1]) THEN
        END ELSE
                ETEXT = "SOLO SE PERMITEN NUMEROS"
                E = ETEXT
                EB.SystemTables.setE(ETEXT)
                EB.ErrorProcessing.Err()
                EB.Display.RebuildScreen()
        END
    NEXT I

    RETURN
END
