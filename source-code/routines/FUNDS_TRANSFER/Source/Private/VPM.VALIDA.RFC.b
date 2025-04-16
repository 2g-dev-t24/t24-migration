* @ValidationCode : MjoxOTY0NDYzOTMyOkNwMTI1MjoxNzQ0ODM5NTkyOTEwOm1hcmNvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:39:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.VALIDA.RFC(Y.RFC,Y.ERR)

********************************************
* RUTINA : VPM.RTN.VAL.RFC.GENERICO
* AUTOR  : MIGUEL ANGEL GARCIA
* FECHA  : 2004-MZO-15
*
* VALIDA CAMPO DE RFC SEA:
*     MORAL, FIDEICOMISO:
*               3 CARACTERES ALFABETICOS, *** NO APLICA *** PIF-20041019-001
*               6 NUMERICOS 2 A�O 2 MESES 2 DIA
*               3 ALFANUMERICOS
*
*     FISICA, FISICA CON ACTIVIDAD EMPRESARIAL:
*               4 CARACTERES ALFABETICOS, *** NO APLICA *** PIF-20041019-001
*               6 NUMERICOS 2 A�O 2 MES 2 DIA,
*               3 ALFANUMERICOS
*
*
* NOTAS:
*     DEBE CREAR UN REGISTRO EN PGM.FILE
*     PARA PODERLO USAR EN UNA VERSION
*
*
*    Modificado por Christian Heredia - 19 Octubre 2004
*    PIF-20041019-001: Cambio para omitir validacion de los primeros
*    caracteres alfanumericos del RFC
*
*    Modification by Mohsin 10 Feb 2005
*    PIF-20050210: The original VPM.RTN.VAL.RFC.GENERICO Which was a
*    Validation Rtn now changed to a Generic one with Arguments
*
*    Y.RFC - In Parameter consist of Value of RFC to be Validated
*    Y.ERR - Out Parameter
*            0 - No Error
*            1 - On Error
********************************************
**-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.CUSTOMER - Not Used anymore;
    
    $USING EB.SystemTables
    $USING ABC.BP
    
    Y.ERR = 0
    IF EB.SystemTables.getMessage() NE 'VAL' THEN
        GOSUB VALIDA
    END

RETURN


VALIDA:

    IF (LEN(Y.RFC) LT 10) THEN
        Y.ERR = 1
        RETURN
    END

*FISICAS/ACTIVIDAD EMPRESARIAL
    IF (LEN(Y.RFC) EQ 13) OR (LEN(Y.RFC) EQ 10) THEN
        Y.ALF = Y.RFC[1,4]
        Y.FECHA = Y.RFC[5,6]
        IF NOT(Y.FECHA  MATCH '6N') THEN
            Y.ERR = 1
            RETURN
        END
        Y.AA = Y.RFC[5,2]
        Y.MM = Y.RFC[7,2]
        Y.DD = Y.RFC[9,2]

********************************************************************
**    PIF-20041019-001 ****************
**
**        IF NOT (Y.ALF MATCH '4A') THEN
**            E = "PRIMEROS 4 CARACTERES DEBEN SER ALFABETICOS"
**            CALL ERR
**            RETURN
**        END
**   END PIF-20041019-001 ****************
********************************************************************
    END
    IF (LEN(Y.RFC) EQ 12) THEN
*MORALES/FIDEICOMISO
        Y.ALF = Y.RFC[1,3]
        Y.FECHA = Y.RFC[4,6]
        IF NOT(Y.FECHA  MATCH '6N') THEN
            Y.ERR = 1
            RETURN
        END

        Y.AA = Y.RFC[4,2]
        Y.MM = Y.RFC[6,2]
        Y.DD = Y.RFC[8,2]

********************************************************************
**    PIF-20041019-001 ****************
**
**        IF NOT (Y.ALF MATCH '3A') THEN
**            E = "PRIMEROS 3 CARACTERES DEBEN SER ALFABETICOS"
**            CALL ERR
**            RETURN
**        END
**  END PIF-20041019-001 ****************
*******************************************************************
    END

    IF (Y.MM < 1) OR (Y.MM > 12) THEN
        Y.ERR = 1
        RETURN
    END

    IF (Y.DD < 1) OR (Y.DD > 31) THEN
        Y.ERR = 1
        RETURN
    END

RETURN

END
