*-----------------------------------------------------------------------------
* <Rating>486</Rating>
*-----------------------------------------------------------------------------
*
*
$PACKAGE ABC.BP
      SUBROUTINE VPM.ESTADO
*
*
*    First Release :
*    Developed for :     DBS
*    Developed by  :     Mitesh Harlalka
*
$INSERT I_COMMON
$INSERT I_EQUATE

*
*
*
*************************************************************************

      GOSUB DEFINE.PARAMETERS

      IF LEN(V$FUNCTION) GT 1 THEN
         GOTO V$EXIT
      END

      CALL MATRIX.UPDATE

      GOSUB INITIALISE                   ; * Special Initialising

*************************************************************************

* Main Program Loop

      LOOP

         CALL RECORDID.INPUT

      UNTIL MESSAGE = 'RET' DO

         V$ERROR = ''

         IF MESSAGE = 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION         ; * Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
               CALL FUNCTION.DISPLAY
               V$FUNCTION = ''
            END

         END ELSE

            GOSUB CHECK.ID               ; * Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ


            IF MESSAGE = 'REPEAT' THEN
               GOTO MAIN.REPEAT
            END


            GOSUB CHECK.RECORD           ; * Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL MATRIX.ALTER

            GOSUB PROCESS.DISPLAY        ; * For Display applications

            LOOP
               GOSUB PROCESS.FIELDS      ; * ) For Input
               GOSUB PROCESS.MESSAGE     ; * ) Applications
            WHILE MESSAGE = 'ERROR' DO REPEAT

         END

MAIN.REPEAT:

      REPEAT


V$EXIT:
      RETURN                             ; * From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************


PROCESS.FIELDS:

* Input or display the record fields.

      LOOP

         IF SCREEN.MODE EQ 'MULTI' THEN
            IF FILE.TYPE EQ 'I' THEN
               CALL FIELD.MULTI.INPUT
            END ELSE
               CALL FIELD.MULTI.DISPLAY
            END
         END ELSE
            IF FILE.TYPE EQ 'I' THEN
               CALL FIELD.INPUT
            END ELSE
               CALL FIELD.DISPLAY
            END
         END

      UNTIL MESSAGE <> "" DO

         GOSUB CHECK.FIELDS              ; * Special Field Editing

         IF T.SEQU NE '' THEN T.SEQU<-1> = A + 1

      REPEAT

      RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

      IF MESSAGE = 'VAL' THEN
         MESSAGE = ''
         BEGIN CASE
            CASE V$FUNCTION EQ 'D'
REM >          GOSUB CHECK.DELETE              ;* Special Deletion checks
            CASE V$FUNCTION EQ 'R'
               GOSUB CHECK.REVERSAL      ; * Special Reversal checks
            CASE OTHERWISE
               GOSUB CROSS.VALIDATION    ; * Special Cross Validation
         END CASE
         IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE      ; * Special Processing before write
         END
         IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
            IF MESSAGE <> "ERROR" THEN
               GOSUB AFTER.UNAU.WRITE    ; * Special Processing after write
            END
         END
      END

      IF MESSAGE = 'AUT' THEN
         GOSUB AUTH.CROSS.VALIDATION     ; * Special Cross Validation
         IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE      ; * Special Processing before write
         END

         IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

            IF MESSAGE <> "ERROR" THEN
               GOSUB AFTER.AUTH.WRITE    ; * Special Processing after write
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
      ID.F = "ID" ; ID.N = "3.1" ; ID.T = "A"
      ID.CONCATFILE = "AR"
      ID.T<4>= ""
      Z = 0
      Z += 1 ; F(Z) = "ESTADO"     ; N(Z) = "60" ; T(Z) = "A"
      Z += 1 ; F(Z) = "CLAVE"      ; N(Z) = "2"  ; T(Z) = "A" 
      Z += 1 ; F(Z) = "CLAVE.BURO" ; N(Z) = "4"  ; T(Z) = "A"
      Z+=1 ; F(Z)="RESERVED.3" ; N(Z)="9" ; T(Z)<3>="NOINPUT"
      Z+=1 ; F(Z)="RESERVED.2" ; N(Z)="9" ; T(Z)<3>="NOINPUT"
      Z+=1 ; F(Z)="RESERVED.1" ; N(Z)="9" ; T(Z)<3>="NOINPUT"
      V = Z+9 ; PREFIX = "VPM.ESTADO"

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
REM TO CHECK WHETHER THE DESCRIPTION IS BLANK
*
      AF = 1                             ; REM AF = 1 : DESCRIPTION
*

      IF R.NEW(AF) = '' THEN
         ETEXT = 'Please Enter Description'
         CALL STORE.END.ERROR
      END
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
