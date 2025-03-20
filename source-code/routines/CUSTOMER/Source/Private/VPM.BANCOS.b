* @ValidationCode : MjotMTkwMzA3MDA3ODpDcDEyNTI6MTc0MjUwMDc1NzIzNzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Mar 2025 16:59:17
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
*-----------------------------------------------------------------------------
* <Rating>486</Rating>
*-----------------------------------------------------------------------------
*
$PACKAGE ABC.BP
SUBROUTINE VPM.BANCOS

*
*-----------------------------------------------------------------------------
* Descripcion    : Se agrega el campo Bines para guardar los bines de cada
*                  Banco.
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
    IF LEN(Y.VFUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    EB.Display.MatrixUpdate()

    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

        EB.TransactionControl.RecordidInput()

    UNTIL EB.SystemTables.getMessage() EQ 'RET' DO

        V$ERROR = ''

        IF EB.SystemTables.getMessage() EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF Y.VFUNCTION EQ 'E' OR Y.VFUNCTION EQ 'L' THEN
                EB.Display.FunctionDisplay()
                EB.SystemTables.setVFunction('')
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            EB.TransactionControl.RecordRead()


            IF EB.SystemTables.getMessage() EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END


            GOSUB CHECK.RECORD          ;* Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT

            EB.Display.MatrixAlter()

            GOSUB PROCESS.DISPLAY       ;* For Display applications

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE EB.SystemTables.getMessage() EQ 'ERROR' DO REPEAT

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

    UNTIL EB.SystemTables.getMessage() NE "" DO

        GOSUB CHECK.FIELDS    ;* Special Field Editing

        Y.A = EB.SystemTables.getA()
        IF EB.SystemTables.getTSequ() NE '' THEN EB.SystemTables.setTSequ(Y.A + 1)

    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF EB.SystemTables.getMessage() EQ 'VAL' THEN
        EB.SystemTables.setMessage('')
        BEGIN CASE
            CASE Y.VFUNCTION EQ 'D'
REM >          GOSUB CHECK.DELETE              ;* Special Deletion checks
            CASE Y.VFUNCTION EQ 'R'
                GOSUB CHECK.REVERSAL        ;* Special Reversal checks
            CASE 1
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
            EB.TransactionControl.UnauthRecordWrite()
            IF EB.SystemTables.getMessage() NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END
    END

    IF EB.SystemTables.getMessage() EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

            EB.TransactionControl.AuthRecordWrite()

            IF EB.SystemTables.getMessage() NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
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
    EB.SystemTables.setIdN("6.1")
    EB.SystemTables.setIdT("")
    
    EB.SystemTables.setIdConcatfile("AR")
    tmp = EB.SystemTables.getIdT()
    tmp <4>= ""
    EB.SystemTables.setIdT(tmp)
    Z = 0
    Z += 1 ; EB.SystemTables.setF(Z,"BANCO")        ; EB.SystemTables.setN(Z,"40")   ; EB.SystemTables.setT(Z,"A")
    Z += 1 ; EB.SystemTables.setF(Z,"TIPO")         ; EB.SystemTables.setN(Z,"3")    ; EB.SystemTables.setT(Z,"A")
    Z += 1 ; EB.SystemTables.setF(Z,"XX.LOCAL.REF") ; EB.SystemTables.setN(Z,"35")   ; EB.SystemTables.setT(Z,"A")
    Z += 1 ; EB.SystemTables.setF(Z,"XX.BINES")     ; EB.SystemTables.setN(Z,"6..C") ; EB.SystemTables.setT(Z,"")
    EB.SystemTables.setV(Z+9) ; EB.Template.setTableEquateprefix("VPM.BANCOS")

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
    BEGIN CASE

        CASE EB.SystemTables.getAf() EQ VpmBBines
            IF EB.SystemTables.getComi() EQ '' THEN
                EB.SystemTables.setE('EL VALOR NO PUEDE SER VACIO')
            END ELSE
                IF NOT(ISDIGIT(EB.SystemTables.getComi())) THEN
                    EB.SystemTables.setE('EL BIN DEBE SER NUMERICO')
                END
            END



    END CASE

    IF EB.SystemTables.getE() THEN
        EB.SystemTables.setTSequ("IFLD")
        EB.ErrorProcessing.Err()
    END


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
    EB.SystemTables.setAf(VpmBBines)
    EB.Template.Dup()

    EB.SystemTables.setAf(1)          ;REM AF = 1 : DESCRIPTION
*

    IF EB.SystemTables.getRNew(AF) EQ '' THEN
        Y.ERROR = 'Please Enter Description'
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
