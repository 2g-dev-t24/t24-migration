$PACKAGE AbcSpei

SUBROUTINE ABC.CALCULA.CCC(IN.CADENA,OUT.ERROR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    OUT.ERROR = 0

    IF LEN(IN.CADENA)<17 THEN
       OUT.ERROR = 1
       RETURN
    END ELSE
       IF LEN(IN.CADENA)>17 THEN
          IN.CADENA = SUBSTRINGS(IN.CADENA,1,17)
       END
    END 
    
    YERROR = 0
    
    FOR YI = 1 TO 17
        IF NOT(NUM(IN.CADENA<YI>)) THEN
           YERROR = 1
        END 
    NEXT
    
    IF YERROR THEN
       OUT.ERROR = 2
       RETURN
    END 
    
    YBANCO = IN.CADENA[1,3]
    YPLAZA = IN.CADENA[4,3]
    YCUENTA = IN.CADENA[7,11]

    YPESO = "37137137137137137"
    
    YMULTIPLICACION = ""
    
    FOR YI=1 TO 17
        YMULTIPLICACION<YI> = MOD(IN.CADENA[YI,1]*YPESO[YI,1],10)
    NEXT

    YCADENA.MULT = ""
    FOR YI= 1 TO 17
        YCADENA.MULT = YCADENA.MULT:YMULTIPLICACION<YI>
    NEXT
    
    YSUMA = 0
    
    FOR YI= 1 TO 17
       YSUMA = YSUMA + YMULTIPLICACION<YI>     
    NEXT
    
    YDIGITO = MOD(YSUMA,10)
        
    YDIGITO = 10 - YDIGITO
    
    IF YDIGITO = 10 THEN
       YDIGITO = 0
    END
    
    IN.CADENA = IN.CADENA:YDIGITO
    
    RETURN

END