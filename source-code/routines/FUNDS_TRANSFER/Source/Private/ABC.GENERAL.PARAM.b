* @ValidationCode : MjoxMzA5OTUwOTcyOkNwMTI1MjoxNzQ0NjQ5MTk5MTc0OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Apr 2025 11:46:39
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
*-----------------------------------------------------------------------------
* <Rating>488</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.GENERAL.PARAM
*
*    First Release :     2O15 abril
*    Developed for :     ABC CAPITAL
*    Developed by  :     LEO BASABE *~*
*
*
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*
*
*
*************************************************************************
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.TransactionControl
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB DEFINE.PARAMETERS

    IF LEN(EB.SystemTables.getTFunction()) GT 1 THEN
        GOTO V$EXIT
    END

*    CALL MATRIX.UPDATE
    EB.Display.MatrixUpdate()


    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

*        CALL RECORDID.INPUT
        EB.TransactionControl.RecordidInput()

        sGetMessasge = EB.SystemTables.getMessage()
    UNTIL sGetMessasge = 'RET' DO

        V$ERROR = ''        ;*falta comp V$ERROR
        IF sGetMessasge EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF EB.SystemTables.getTFunction() EQ 'E' OR EB.SystemTables.getTFunction() EQ 'L' THEN
*                CALL FUNCTION.DISPLAY
                EB.Display.FunctionDisplay()
                EB.SystemTables.setTFunction("")
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
;*falta comp V$ERROR
            IF V$ERROR THEN GOTO MAIN.REPEAT

*            CALL RECORD.READ
            EB.TransactionControl.RecordRead()


            IF sGetMessasge EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END


            GOSUB CHECK.RECORD          ;* Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT
;*falta comp V$ERROR
*            CALL MATRIX.ALTER
            EB.Display.MatrixAlter()

            GOSUB PROCESS.DISPLAY       ;* For Display applications

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE sGetMessasge EQ 'ERROR' DO REPEAT

        END

MAIN.REPEAT:

    REPEAT


V$EXIT:
RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************


PROCESS.FIELDS:

* Input or display the record fields.

    LOOP

        IF EB.SystemTables.getScreenMode() EQ 'MULTI' THEN
            IF EB.SystemTables.getFileType() EQ 'I' THEN
*                CALL FIELD.MULTI.INPUT
                EB.Display.FieldMultiInput()
            END ELSE
*                CALL FIELD.MULTI.DISPLAY
                EB.Display.FieldMultiDisplay()
            END
        END ELSE
            IF EB.SystemTables.getFileType() EQ 'I' THEN
*                CALL FIELD.INPUT
                EB.Display.FieldInput()
            END ELSE
*                CALL FIELD.DISPLAY
                EB.Display.FieldDisplay()
            END
        END
        A = "0"      ;*EAGUILAR - SE INICIALIZA PARA SU USO
    UNTIL sGetMessasge NE "" DO

        GOSUB CHECK.FIELDS    ;* Special Field Editing
        
;*EAGUILAR - SE CAMBIA LA FOMRA DE EJECUTAR LA SENTENCIA IF
        VT.SEQU = EB.SystemTables.getTSequ()
        IF VT.SEQU NE '' THEN
            VT.SEQU<-1> = A + 1
            EB.SystemTables.setTSequ(VT.SEQU)
            
        END
;*EAGUILAR - SE CAMBIA LA FOMRA DE EJECUTAR LA SENTENCIA IF
    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF sGetMessasge EQ 'VAL' THEN
        sGetMessasge = ''
        BEGIN CASE
            CASE EB.SystemTables.getTFunction() EQ 'D'
REM >          GOSUB CHECK.DELETE              ;* Special Deletion checks
            CASE EB.SystemTables.getTFunction() EQ 'R'
                GOSUB CHECK.REVERSAL        ;* Special Reversal checks
            CASE 1
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
*            CALL UNAUTH.RECORD.WRITE
            EB.TransactionControl.UnauthRecordWrite()
            IF sGetMessasge NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END
    END

    IF sGetMessasge EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

*            CALL AUTH.RECORD.WRITE
            EB.TransactionControl.AuthRecordWrite()

            IF sGetMessasge NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

RETURN

*************************************************************************
DEFINE.PARAMETERS:
*========================================================================
    MAT F = "" ; MAT N = "" ; MAT T = "" ; ID.T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
*========================================================================
REM "DEFINE PARAMETERS - SEE 'I_RULES'-DESCRIPTION:
*
    ID.F = "ID" ; ID.N = "40.1" ; ID.T = "A"
    ID.T<4>= ""
    Z = 0

    Z += 1 ; F(Z) = "MODULO"                          ; N(Z) = "100.1"         ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX<NOMB.PARAMETRO"       ; N(Z) = "80.1"         ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX-DATO.PARAMETRO"       ; N(Z) = "80.1"         ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX>COMENTARIO"           ; N(Z) = "80"           ; T(Z) = "A"

    V = Z+9 ; PREFIX = "PBS.GEN.PARAM."

*
RETURN
**********************************************************************
INITIALISE:
*
RETURN
*********************************************************************
CHECK.FUNCTION:
*
RETURN
*******************************************************************
CHECK.ID:
*
RETURN
*******************************************************************
CHECK.RECORD:
*
RETURN
*******************************************************************
PROCESS.DISPLAY:
*
RETURN
*******************************************************************
CHECK.FIELDS:
*
RETURN
******************************************************************
CHECK.DELETE:
*
RETURN
*******************************************************************
CHECK.REVERSAL:
*
RETURN
********************************************************************
CROSS.VALIDATION:
*
RETURN
********************************************************************
BEFORE.UNAU.WRITE:
*
RETURN
********************************************************************
AFTER.UNAU.WRITE:
*
RETURN
********************************************************************
AUTH.CROSS.VALIDATION:
*
RETURN
********************************************************************
BEFORE.AUTH.WRITE:
*
RETURN
********************************************************************
AFTER.AUTH.WRITE:
*
RETURN
*********************************************************************
END
