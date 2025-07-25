* @ValidationCode : Mjo0NTg3ODgzNzE6Q3AxMjUyOjE3NTMwNjg4MDg1MzE6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Jul 2025 00:33:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.VAL.RFC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Display
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.RFC = EB.SystemTables.getComi()
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF LEN(Y.RFC) NE '13' THEN
        IF LEN(Y.RFC) EQ '12' THEN
            E = "SI EL RFC ES DE PERSONA MORAL AGREGAR '_' AL INICIO"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END ELSE
            E = "LONGITUD DEL RFC INVALIDA"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END
    END ELSE
        Y.AA = Y.RFC[5,2]
        Y.MM = Y.RFC[7,2]
        Y.DD = Y.RFC[9,2]
        Y.ALF = Y.RFC[2,3]
        IF NOT (Y.ALF MATCH '3A') THEN
            E = "PRIMEROS 4 CARACTERES DEBEN SER ALFABETICOS"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
            RETURN
        END

        IF (Y.MM < 1) OR (Y.MM > 12) THEN
            E = "ERROR EN EL MES DEL RFC"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
            RETURN
        END

        IF (Y.DD < 1) OR (Y.DD > 31) THEN
            E = "ERROR EN EL DIA DEL RFC"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
            RETURN
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END
