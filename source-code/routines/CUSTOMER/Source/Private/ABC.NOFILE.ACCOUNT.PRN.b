* @ValidationCode : MjoxNjQ0ODUyNTE6Q3AxMjUyOjE3NTA5NjU2NjM0NzE6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Jun 2025 16:21:03
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
*===============================================================================
$PACKAGE ABC.BP
*===============================================================================
SUBROUTINE ABC.NOFILE.ACCOUNT.PRN(R.DATA)
*===============================================================================
* Nombre de Programa :  ABC.NOFILE.ACCOUNT.PRN

* CODIGOS DE ERRORES :  0 - Falta informaci�n obligatoria
*      1 - Longitud de cuenta inv�lida
*      2  - Longitud de PRN incorrecta
*      3  - No existe la CLABE
*      4 - PRN ya asignado a otra cuenta
*      5 - El PRN y/o BalanceId ya se encuentra registrado en esta cuenta
*      6 - Error en la actualizaci�n
*      7 - Longitud de BalanceId incorrecta
*      8 - BalanceId ya asignado a otra cuenta
*
*===============================================================================
* Modificaciones:
*===============================================================================

    $USING EB.DataAccess
    $USING EB.Reports
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING AbcGetGeneralParam
    $USING EB.Updates
    $USING EB.Interface
    $USING EB.TransactionControl
    
    GOSUB INICIA
    IF R.DATA EQ '' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESO
        GOSUB FINALLY
    END

RETURN

*******
INICIA:
*******

    R.DATA = ''
    Y.OFS = ''
    Y.ERROR = ''
    Y.DESCRIPCION.ERROR = ''
    Y.FUNCION.APLICA = 'I'
    Y.ID.PARAM = 'ABC.ACCOUNT.PRN'

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

    LOCATE "PRN" IN SEL.FIELDS SETTING PRN.POS THEN
        Y.PRN = SEL.VALUES<PRN.POS>
    END

    LOCATE "CLABE" IN SEL.FIELDS SETTING CLABE.POS THEN
        Y.CLABE = SEL.VALUES<CLABE.POS>
    END

    LOCATE "BALANCE.ID" IN SEL.FIELDS SETTING BALANCE.ID.POS THEN
        Y.BALANCE.ID = SEL.VALUES<BALANCE.ID.POS>
    END
    
    GOSUB VALIDA.DATOS

RETURN

*************
VALIDA.DATOS:
*************

    IF Y.CLABE EQ '' THEN
        R.DATA<-1> = Y.CLABE:"|||0"
        RETURN
    END ELSE
        IF Y.PRN EQ '' AND Y.BALANCE.ID EQ '' THEN
            R.DATA<-1> = Y.CLABE:"|||0"
            RETURN
        END
    END

    IF LEN(Y.PRN) GT 20 THEN
        R.DATA<-1> = Y.CLABE:"|||2"
        RETURN
    END

    IF LEN(Y.BALANCE.ID) GT 35 THEN
        R.DATA<-1> = Y.CLABE:"|||7"
        RETURN
    END

    IF LEN(Y.CLABE) EQ 18 THEN
        Y.CUENTA = Y.CLABE[7,11]
        GOSUB OBTIENE.PARAMETRIZACION
    END ELSE
        R.DATA<-1> = Y.CLABE:"|||1"
    END

RETURN

************************
OBTIENE.PARAMETRIZACION:
************************

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'OFS.APLICACION' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.OFS.APLICACION = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'OFS.VERSION' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.OFS.VERSION = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'OFS.SOURCE' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.OFS.SOURCE = Y.LIST.VALUES<Y.POS>
    END

RETURN

***********
OPEN.FILES:
***********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT   = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    V.APP      = 'ACCOUNT'
    V.FLD.NAME = 'CLABE'
    YPOS.CLABE  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, YPOS.CLABE)

RETURN

********
PROCESO:
********

    EB.DataAccess.FRead(FN.CUENTA,Y.CUENTA,R.CUENTA,F.CUENTA,ER.CUENTA)

    IF R.CUENTA NE '' THEN
        Y.CLABE.CUENTA = R.CUENTA<AC.AccountOpening.Account.LocalRef,YPOS.CLABE>
        IF Y.CLABE.CUENTA EQ Y.CLABE THEN
            Y.OFS = Y.OFS.APLICACION:Y.OFS.VERSION:"/":Y.FUNCION.APLICA:",,":Y.CUENTA
            IF Y.PRN NE '' THEN
                Y.OFS := ',ALT.ACCT.TYPE::=PRN,ALT.ACCT.ID::="':Y.PRN:'"'
            END
*            IF Y.BALANCE.ID NE '' THEN
*                Y.OFS := ',BALANCE.ID::="':Y.BALANCE.ID:'"'
*            END

            GOSUB APLICA.OFS

            IF Y.RESPONSE.OFS EQ 1 THEN
                R.DATA<-1> = Y.CLABE:"|":Y.PRN:"|":Y.BALANCE.ID:"|"
            END ELSE
                GOSUB OBTIENE.ERROR
*          R.DATA<-1> = Y.CLABE:"|||8"
            END
        END ELSE
            R.DATA<-1> = Y.CLABE:"|||3":
        END
    END ELSE
        R.DATA<-1> = Y.CLABE:"|||3":
    END

RETURN

***********
APLICA.OFS:
***********

    EB.Interface.OfsGlobusManager(Y.OFS.SOURCE,Y.OFS)
    EB.TransactionControl.JournalUpdate("")
    Y.ID.SEND.OFS     = ''
    Y.RESPONSE.OFS = ''
    Y.ID.SEND.OFS    =  TRIM(FIELD(Y.OFS, '/', 1))
    Y.RESPONSE.OFS = TRIM(FIELD(Y.OFS, '/', 3))
    Y.RESPONSE.OFS = TRIM(FIELD(Y.RESPONSE.OFS,",",1))
    Y.ERROR = TRIM(FIELD(Y.OFS, '/', 4))

RETURN

**************
OBTIENE.ERROR:
**************

    FINDSTR 'PRN:1:1' IN Y.ERROR SETTING Y.AF,Y.AV,Y.AS THEN
        R.DATA<-1> = Y.CLABE:"|||4"
        RETURN
    END

    FINDSTR 'BALANCE.ID:1:1' IN Y.ERROR SETTING Y.AF,Y.AV,Y.AS THEN
        R.DATA<-1> = Y.CLABE:"|||8"
        RETURN
    END

    FINDSTR 'LIVE RECORD NOT CHANGED' IN Y.ERROR SETTING Y.AF,Y.AV,Y.AS THEN
        R.DATA<-1> = Y.CLABE:"|||5"
        RETURN
    END

    R.DATA<-1> = Y.CLABE:"|||6"

    PRINT Y.OFS

RETURN

********
FINALLY:
********

RETURN

END
