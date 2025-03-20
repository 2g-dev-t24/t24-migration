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
*
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING ABC.BP


*
*
*
*************************************************************************

      GOSUB DEFINE.PARAMETERS

      Y.FUNCTION = EB.SystemTables.getVFunction()
      IF LEN(Y.FUNCTION) GT 1 THEN
         GOTO V$EXIT
      END

      CALL MATRIX.UPDATE

      GOSUB INITIALISE                   ; * Special Initialising

*************************************************************************

* Main Program Loop

      LOOP

         CALL RECORDID.INPUT

      UNTIL EB.SystemTables.getMessage() EQ 'RET' DO

         V$ERROR = ''

         IF EB.SystemTables.getMessage() EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION         ; * Special Editing of Function

            IF EB.SystemTables.getVFunction() EQ 'E' OR EB.SystemTables.getVFunction() EQ 'L' THEN
               CALL FUNCTION.DISPLAY
               EB.SystemTables.setVFunction('')
            END

         END ELSE

            GOSUB CHECK.ID               ; * Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ


            IF EB.SystemTables.getMessage() EQ 'REPEAT' THEN
               GOTO MAIN.REPEAT
            END


            GOSUB CHECK.RECORD           ; * Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL MATRIX.ALTER

            GOSUB PROCESS.DISPLAY        ; * For Display applications

            LOOP
               GOSUB PROCESS.FIELDS      ; * ) For Input
               GOSUB PROCESS.MESSAGE     ; * ) Applications
            WHILE EB.SystemTables.getMessage() EQ 'ERROR' DO REPEAT

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

         IF EB.SystemTables.getScreenMode() EQ 'MULTI' THEN
            IF EB.SystemTables.getFileType() EQ 'I' THEN
               CALL FIELD.MULTI.INPUT
            END ELSE
               CALL FIELD.MULTI.DISPLAY
            END
         END ELSE
            IF EB.SystemTables.getFileType() EQ 'I' THEN
               CALL FIELD.INPUT
            END ELSE
               CALL FIELD.DISPLAY
            END
         END

      UNTIL EB.SystemTables.getMessage() <> "" DO

         GOSUB CHECK.FIELDS              ; * Special Field Editing
         Y.A = EB.SystemTables.getA()
         IF EB.SystemTables.getTSequ() NE '' THEN EB.SystemTables.setTSequ(Y.A + 1)

      REPEAT

      RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

      IF EB.SystemTables.getMessage() = 'VAL' THEN
         EB.SystemTables.setMessage('') 
         BEGIN CASE
            CASE EB.SystemTables.getVFunction() EQ 'D'
REM >          GOSUB CHECK.DELETE              ;* Special Deletion checks
            CASE EB.SystemTables.getVFunction() EQ 'R'
               GOSUB CHECK.REVERSAL      ; * Special Reversal checks
            CASE 1
               GOSUB CROSS.VALIDATION    ; * Special Cross Validation
         END CASE
         IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE      ; * Special Processing before write
         END
         IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
            IF EB.SystemTables.getMessage() NE "ERROR" THEN
               GOSUB AFTER.UNAU.WRITE    ; * Special Processing after write
            END
         END
      END

      IF EB.SystemTables.getMessage() EQ 'AUT' THEN
         GOSUB AUTH.CROSS.VALIDATION     ; * Special Cross Validation
         IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE      ; * Special Processing before write
         END

         IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

            IF EB.SystemTables.getMessage() NE "ERROR" THEN
               GOSUB AFTER.AUTH.WRITE    ; * Special Processing after write
            END
         END

      END

      RETURN

*************************************************************************
DEFINE.PARAMETERS:
*========================================================================
      
      EB.SystemTables.setIdT("")
      EB.SystemTables.setIdCheckfile("")
      EB.SystemTables.setIdConcatfile("")
*========================================================================
REM "DEFINE PARAMETERS - SEE 'I_RULES'-DESCRIPTION:
*
      EB.SystemTables.setIdF("ID")
      EB.SystemTables.setIdN("3.1")
      EB.SystemTables.setIdT("A")
      EB.Template.TableDefineid("AR", EB.Template.T24String)

    fieldName = 'ESTADO'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLAVE'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLAVE.BURO'
    fieldLength = 20
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

    EB.Template.setTableEquateprefix("VPM.ESTADO")
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
      EB.SystemTables.setAf(1)                            ; REM EB.SystemTables.setAf(1) : DESCRIPTION
*

      IF EB.SystemTables.getAf() EQ '' THEN
         Y.ERROR = "Please Enter Description "
         EB.SystemTables.setEtext(Y.ERROR)
         EB.ErrorProcessing.StoreEndError()
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
