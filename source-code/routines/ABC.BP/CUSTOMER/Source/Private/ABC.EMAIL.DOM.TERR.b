* Version 9 15/11/00  GLOBUS Release No. R06.002 22/08/06
*-----------------------------------------------------------------------------
* <Rating>431</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
      SUBROUTINE ABC.EMAIL.DOM.TERR
******************************************************************
* Descripcion : Template para guardar los Dominios Territoriales validos
*-----------------------------------------------------------------------------


    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING ABC.BP
    $USING EB.Display
    $USING ST.Customer
    $USING EB.TransactionControl

*************************************************************************

      GOSUB DEFINE.PARAMETERS

      Y.VFUNCTION = EB.SystemTables.getVFunction()
      IF LENY.VFUNCTION) GT 1 THEN
         GOTO V$EXIT
      END

      EB.Display.MatrixUpdate()

      GOSUB INITIALISE                   ; * Special Initialising

*************************************************************************

* Main Program Loop

      LOOP

         EB.TransactionControl.RecordidInput()

      UNTIL (EB.SystemTables.getMessage() EQ 'RET')

         V$ERROR = ''

         IF EB.SystemTables.getMessage() EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION         ; * Special Editing of Function

            IF Y.VFUNCTION EQ 'E' OR Y.VFUNCTION EQ 'L' THEN
               EB.Display.FunctionDisplay()
               EB.SystemTables.setVFunction('')
            END

         END ELSE

            GOSUB CHECK.ID               ; * Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            EB.TransactionControl.RecordRead()

            IF EB.SystemTables.getMessage() EQ 'REPEAT' THEN
               GOTO MAIN.REPEAT
            END

            GOSUB CHECK.RECORD           ; * Special Editing of Record

            EB.Display.MatrixAlter()

            IF V$ERROR THEN GOTO MAIN.REPEAT

            LOOP
               GOSUB PROCESS.FIELDS      ; * ) For Input
               GOSUB PROCESS.MESSAGE     ; * ) Applications
            WHILE (EB.SystemTables.getMessage() EQ 'ERROR') REPEAT

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
               EB.Display.FieldMultiInput()
            END ELSE
               EB.Display.FieldMultiDisplay()
            END
         END ELSE
            IF EB.SystemTables.getFileType() EQ 'I' THEN
               EB.Display.FieldInput()
            END ELSE
               EB.Display.FieldDisplay()
            END
         END

      WHILE NOT(EB.SystemTables.getMessage())

         GOSUB CHECK.FIELDS              ; * Special Field Editing
        Y.A = EB.SystemTables.getA()
        IF EB.SystemTables.getTSequ() NE '' THEN EB.SystemTables.setTSequ(Y.A + 1)

      REPEAT

      RETURN

*************************************************************************
PROCESS.MESSAGE:
* Processing after exiting from field input (PF5)

      IF EB.SystemTables.getMessage() EQ 'DEFAULT' THEN
        EB.SystemTables.getMessage() EQ 'ERROR'               ; * Force the processing back
         IF Y.VFUNCTION NE 'D' AND Y.VFUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
         END
      END

      IF BROWSER.PREVIEW.ON THEN         ; * EN_10002679 - s
* Clear BROWSER.PREVIEW.ON once inside the template so that after preview
* it might exit from the template, otherwise there will be looping within the template.
         EB.SystemTables.setMessage('PREVIEW')
         BROWSER.PREVIEW.ON = 0
      END                                ; * EN_10002679 - e


      IF EB.SystemTables.getMessage() EQ 'PREVIEW' THEN
         EB.SystemTables.setMessage('ERROR')               ; * Force the processing back
         IF Y.VFUNCTION NE 'D' AND Y.VFUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
         END
      END

      IF EB.SystemTables.getMessage() EQ 'VAL' THEN
         EB.SystemTables.setMessage('')
         BEGIN CASE
            CASE Y.VFUNCTION EQ 'D'
               GOSUB CHECK.DELETE        ; * Special Deletion checks
            CASE Y.VFUNCTION EQ 'R'
               GOSUB CHECK.REVERSAL      ; * Special Reversal checks
            CASE OTHERWISE
               GOSUB CROSS.VALIDATION    ; * Special Cross Validation
               IF NOT(V$ERROR) THEN
                  GOSUB OVERRIDES
               END
         END CASE
         IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE      ; * Special Processing before write
         END
         IF NOT(V$ERROR) THEN
            EB.TransactionControl.UnauthRecordWrite()
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

            EB.TransactionControl.AuthRecordWrite()

            IF EB.SystemTables.getMessage() NE "ERROR" THEN
               GOSUB AFTER.AUTH.WRITE    ; * Special Processing after write
            END
         END

      END

      RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************
CHECK.ID:
* Validation and changes of the ID entered.  Sets V$ERROR to 1 if in error.

      V$ERROR = 0
      EB.SystemTables.setE('') 
      IF EB.SystemTables.getE() THEN
        V$ERROR = 1
        EB.ErrorProcessing.Err()
      END

      RETURN

*************************************************************************
CHECK.RECORD:
* Validation and changes of the Record.  Set V$ERROR to 1 if in error.
*
* A application runnin in browser will enter CHECK.RECORD multiple
* times during a transaction lifecycle. Any validation that must only
* run when the user first opens the contract must be put in the following
* IF statement
*
      IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN     ; * BG_100007114

      END


      RETURN

*************************************************************************
CHECK.FIELDS:

REM > CALL XX.CHECK.FIELDS
    EB.SystemTables.setE('')

    BEGIN CASE
        CASE EB.SystemTables.getAf() EQ AedtDominio
            EB.SystemTables.setComi(DOWNCASE(EB.SystemTables.getComi()))
            IF COUNT(EB.SystemTables.getComi(),'.') GT 1 THEN
                EB.SystemTables.setE('NO PUEDE CONTENER MAS DE UN PUNTO')
                GOSUB SEND.ERROR
                RETURN
            END
            Y.COMI = EB.SystemTables.getComi()
            IF Y.COMI[1,1] NE '.' THEN
                EB.SystemTables.setE('EL DOMINIO DEBE COMENZAR CON UN PUNTO')
                GOSUB SEND.ERROR
                RETURN
            END


    END CASE
*
    RETURN

SEND.ERROR:
    IF EB.SystemTables.getE() THEN
        EB.SystemTables.setTSequ("IFLD")
        EB.ErrorProcessing.Err()
    END
*
    RETURN

*************************************************************************
CROSS.VALIDATION:
*
      V$ERROR = ''
      ETEXT = ''
      TEXT = ''

      Y.LIST = ''
      Y.CNT = ''
      Y.ERROR = ''
      SEL.CMD = "SELECT ":FN.ABC.EMAIL.DOM.TERR:" WITH COUNTRY.ID EQ '":EB.SystemTables.getRNew(ABC.BP.AbcEmailDomTerr.AedtCountryId):"'"
      EB.DataAccess.ReadList(SEL.CMD,Y.LIST,'',Y.CNT,Y.ERROR)

      IF Y.LIST NE '' THEN
          EB.SystemTables.setAf(AedtCountryId)
          Y.ERROR = 'ERR.1 YA EXISTE UN DOMINIO REGISTRADO A ESTE PAIS'
          EB.SystemTables.setEtext(Y.ERROR)
          EB.ErrorProcessing.StoreEndError()
      END



REM > CALL XX.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*
      IF END.ERROR THEN
         EB.SystemTables.setAf(1)
         Y.A = EB.SystemTables.getAf()
      LOOP UNTIL T.ETEXT<Y.A> <> "" DO Y.A = Y.A+1 ; REPEAT
         Y.T.SEQU = "D"
         Y.T.SEQU<-1> = Y.A
         EB.SystemTables.setTSequ(Y.T.SEQU)
         V$ERROR = 1
         EB.SystemTables.setMessage('ERROR')
      END

RETURN                             ; * Back to field input via UNAUTH.RECORD.WRITE



*************************************************************************
OVERRIDES:
*
*  Overrides should reside here.
*
      V$ERROR = ''
      ETEXT = ''
      TEXT = ''
REM > CALL XX.OVERRIDE
*

*
      IF TEXT EQ "NO" THEN                ; * Said NO to override
         V$ERROR = 1
         EB.SystemTables.setMessage("ERROR")              ; * Back to field input

      END

      RETURN

*************************************************************************
AUTH.CROSS.VALIDATION:

      RETURN

*************************************************************************
CHECK.DELETE:


      RETURN

*************************************************************************
CHECK.REVERSAL:

      RETURN

*************************************************************************
DELIVERY.PREVIEW:

      RETURN

*************************************************************************
BEFORE.UNAU.WRITE:
*
*  Contract processing code should reside here.
*
REM > CALL XX.         ;* Accounting, Schedule processing etc etc

      IF TEXT EQ "NO" THEN                ; * Said No to override
         EB.TransactionControl.TransactionAbort()          ; * Cancel current transaction
         V$ERROR = 1
         EB.SystemTables.setMessage("ERROR")               ; * Back to field input
         RETURN
      END
*
* Additional updates should be performed here
*
REM > CALL XX...

      RETURN

*************************************************************************
AFTER.UNAU.WRITE:


      RETURN

*************************************************************************
AFTER.AUTH.WRITE:

      RETURN

*************************************************************************
BEFORE.AUTH.WRITE:
    tmp.V = EB.SystemTables.getV()
      BEGIN CASE
         CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] EQ "INA"    ; * Record status
         CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] EQ "HNA"
REM > CALL XX.AUTHORISATION
         CASE EB.SystemTables.getRNew(tmp.V-8)[1,3] EQ "RNA"    ; * Record status
REM > CALL XX.REVERSAL

      END CASE

      RETURN

*************************************************************************
CHECK.FUNCTION:
* Validation of function entered.  Sets V$FUNCTION to null if in error.

      IF INDEX('V',Y.VFUNCTION,1) THEN
         EB.SystemTables.setE('EB.RTN.FUNT.NOT.ALLOWED.APP')
         EB.ErrorProcessing.Err()
         V$FUNCTION = ''
      END

      RETURN

*************************************************************************
INITIALISE:

    BROWSER.PREVIEW.ON = (OFS$MESSAGE='PREVIEW')

    FN.ABC.EMAIL.DOM.TERR = 'F.ABC.EMAIL.DOM.TERR'
    F.ABC.EMAIL.DOM.TERR = ''
    EB.DataAccess.Opf(FN.ABC.EMAIL.DOM.TERR,F.ABC.EMAIL.DOM.TERR)



    RETURN

*************************************************************************
DEFINE.PARAMETERS:
* SEE 'I_RULES' FOR DESCRIPTIONS *

REM > CALL XX.FIELD.DEFINITIONS
*========================================================================
    EB.SystemTables.setIdT("")
    EB.SystemTables.setIdCheckfile("")
    EB.SystemTables.setIdConcatfile("")
*========================================================================
    
    EB.SystemTables.setIdF("ID")
    EB.SystemTables.setIdN("3.2")
    EB.SystemTables.setIdT("AAA")
    
    Z = 0
    Z+= 1;      EB.SystemTables.setF(Z, "COUNTRY.ID"); EB.SystemTables.setF(Z,"3.1"); EB.SystemTables.setZ(Z,"AAA")
    EB.SystemTables.setCheckfile(Z,"COUNTRY":FM:EB.COU.COUNTRY.NAME:FM:'A.')
    Z+= 1;      EB.SystemTables.setF(Z,"DOMINIO"); EB.SystemTables.setF(Z,"4.3.C")  ; EB.SystemTables.setZ(Z,"A")
    EB.SystemTables.setV(Z + 9);  EB.Template.setTableEquateprefix("AEDT")


   RETURN

*************************************************************************

   END
