* @ValidationCode : MjoyMDI3NjMyODczOkNwMTI1MjoxNzQ0ODM0OTc3Njc5OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 15:22:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
*=============================================================================
*    First Release :     20/05/2014
*    Developed for :
*    by BOND *~*
*=============================================================================
SUBROUTINE PBS.INSLOG(Y.ARCHIVO.GUARDAR, Y.MENSAJE, Y.INICIANDO)
*
*=============================================================================
* Extractor de Informacion Contable y Operativa (EICO)
*=============================================================================
*    INCLUDE ../T24_BP I_COMMON
*    INCLUDE ../T24_BP I_EQUATE
******************************************************************************
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INIT.VARS
    GOSUB PROCESS
RETURN

**********
INIT.VARS:
**********
    Y.HORA.LOG = OCONV(TIME(), "MTS")       ;*EB.SystemTables.GetTime(retrunValue, reserved1, reserved2, errValue)
    Y.HOY = EB.SystemTables.getToday()        ;*TODAY


    Y.LT = "<"
    Y.TAB = CHAR(9)
    Y.ENTER = CHAR(13)
    Y.SEP3 = "/"
    Y.PATH.ARCH.LOG = Y.ARCHIVO.GUARDAR
    Y.RUTA = ""
    Y.NUM.SLASHS = DCOUNT(Y.ARCHIVO.GUARDAR, Y.SEP3)
    FOR Y.I = 1 TO Y.NUM.SLASHS - 1
        Y.RUTA := FIELDS(Y.ARCHIVO.GUARDAR, Y.SEP3, Y.I) : Y.SEP3
    NEXT Y.I
RETURN

********
PROCESS:
********
    IF Y.INICIANDO EQ 1 THEN
        DELETESEQ Y.PATH.ARCH.LOG ELSE NULL
    END

    OPENSEQ Y.PATH.ARCH.LOG TO F.ARCHIVO.LOG ELSE
        EXECUTE "mkdir -p " : Y.RUTA
        CREATE F.ARCHIVO.LOG ELSE
            DISPLAY "Ruta o archivo inexistente" : Y.PATH.ARCH.LOG
            ABORT
        END
    END

    Y.MENSAJE = Y.HOY : " - " : Y.HORA.LOG : " - " : Y.MENSAJE
    WRITESEQ Y.MENSAJE APPEND TO F.ARCHIVO.LOG ELSE
        DISPLAY "No se logro crear el archivo"
        ABORT
    END
    CLOSESEQ F.ARCHIVO.LOG
RETURN
END
