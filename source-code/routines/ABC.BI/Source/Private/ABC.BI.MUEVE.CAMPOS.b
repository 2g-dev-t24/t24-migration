* @ValidationCode : MjotMTk3OTI3NjUwMTpDcDEyNTI6MTc0MzEyNjM4NzEzNDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Mar 2025 22:46:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcBi
SUBROUTINE ABC.BI.MUEVE.CAMPOS
*===============================================================================
* First Release :
* Desarrollador:        C�sar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha:          2017-04-21
* Descripci�n:          Rutina que reacomoda los valores en sus campos correspondientes
*                       despu�s de realizada la adici�n de campos
*===============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_TSA.COMMON
*
*
*    $INSERT ABC.BP I_F.ABC.BANCA.INTERNET
*
*******************************************************************************
*
*    GOSUB OPENFILES
*    GOSUB INITIALISE
*    GOSUB PROCESS
*    GOSUB FINALLY
*
*    RETURN
*
*
**---------------
*INITIALISE:
**---------------
*
*
*    RETURN
*
**---------------
*OPENFILES:
**---------------
*
*    FN.ABC.BANCA.INTERNET = 'F.ABC.BANCA.INTERNET'
*    F.ABC.BANCA.INTERNET = ''
*    CALL OPF(FN.ABC.BANCA.INTERNET,F.ABC.BANCA.INTERNET)
*
*    RETURN
*
**---------------
*LIMPIA.VARIABLES:
**---------------
*
*    Y.RECORD.STATUS = ''
*    Y.CURR.NO = ''
*    Y.INPUTTER = ''
*    Y.DATE.TIME = ''
*    Y.AUTHORISER = ''
*    Y.CO.CODE = ''
*    Y.DEPT.CODE = ''
*    Y.AUDITOR.CODE = ''
*    Y.AUDIT.DATE.TIME = ''
*    ID.BI = ''
*    R.INFO.BI = ''
*    ERR.BI = ''
*
*    RETURN
*
**---------------
*PROCESS:
**---------------
*
*    SEL.BI = ''; LISTA.BI = ''; TOTAL.BI = ''; ERROR.BI = '';
*    SEL.BI = 'SELECT ':FN.ABC.BANCA.INTERNET:' WITH @ID NE "1000096424" AND @ID NE "1000000358" BY @ID'  ; * ITSS - BINDHU - Added "
*    CALL EB.READLIST(SEL.BI,LISTA.BI,'',TOTAL.BI,ERROR.BI)
*
*    FOR X = 1 TO TOTAL.BI
*        DISPLAY X
*        GOSUB LIMPIA.VARIABLES
*        ID.BI = LISTA.BI<X>
*        CALL F.READ(FN.ABC.BANCA.INTERNET,ID.BI,R.INFO.BI,F.ABC.BANCA.INTERNET,ERR.BI)
*        IF ERR.BI EQ '' THEN
*            Y.RECORD.STATUS = R.INFO.BI<ABC.BAN.INT.ID.ADMIN>
*            Y.CURR.NO = R.INFO.BI<ABC.BAN.INT.NOMBRE.ADMIN>
*            Y.INPUTTER = R.INFO.BI<ABC.BAN.INT.STATUS.ADMIN>
*            Y.DATE.TIME = R.INFO.BI<ABC.BAN.INT.FACULTADES.ADMIN>
*            Y.AUTHORISER = R.INFO.BI<ABC.BAN.INT.RESERVED01>
*            Y.CO.CODE = R.INFO.BI<ABC.BAN.INT.RESERVED02>
*            Y.DEPT.CODE = R.INFO.BI<ABC.BAN.INT.RESERVED03>
*            Y.AUDITOR.CODE = R.INFO.BI<ABC.BAN.INT.RESERVED04>
*            Y.AUDIT.DATE.TIME = R.INFO.BI<ABC.BAN.INT.RESERVED05>
*
*            R.INFO.BI<ABC.BAN.INT.ID.ADMIN> = ''
*            R.INFO.BI<ABC.BAN.INT.NOMBRE.ADMIN> = ''
*            R.INFO.BI<ABC.BAN.INT.STATUS.ADMIN> = ''
*            R.INFO.BI<ABC.BAN.INT.FACULTADES.ADMIN> = ''
*            R.INFO.BI<ABC.BAN.INT.RESERVED01> = ''
*            R.INFO.BI<ABC.BAN.INT.RESERVED02> = ''
*            R.INFO.BI<ABC.BAN.INT.RESERVED03> = ''
*            R.INFO.BI<ABC.BAN.INT.RESERVED04> = ''
*            R.INFO.BI<ABC.BAN.INT.RESERVED05> = ''
*
*            R.INFO.BI<ABC.BAN.INT.RECORD.STATUS> = Y.RECORD.STATUS
*            R.INFO.BI<ABC.BAN.INT.CURR.NO> = Y.CURR.NO
*            R.INFO.BI<ABC.BAN.INT.INPUTTER> = Y.INPUTTER
*            R.INFO.BI<ABC.BAN.INT.DATE.TIME> = Y.DATE.TIME
*            R.INFO.BI<ABC.BAN.INT.AUTHORISER> = Y.AUTHORISER
*            R.INFO.BI<ABC.BAN.INT.CO.CODE> = Y.CO.CODE
*            R.INFO.BI<ABC.BAN.INT.DEPT.CODE> = Y.DEPT.CODE
*            R.INFO.BI<ABC.BAN.INT.AUDITOR.CODE> = Y.AUDITOR.CODE
*            R.INFO.BI<ABC.BAN.INT.AUDIT.DATE.TIME> = Y.AUDIT.DATE.TIME
*
*            WRITE R.INFO.BI TO F.ABC.BANCA.INTERNET, ID.BI
*
*        END
*    NEXT X
*
*    RETURN
*
*
*********
*FINALLY:
*********
*
*    DISPLAY 'MOVIMIENTO DE CAMPOS FINALIZADO'
*
*    RETURN
*
*END