*-----------------------------------------------------------------------------
* <Rating>595</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.EMAIL
*----------------------------------------------------------------
* Descripcion  : Rutina para validar correo
*----------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING ABC.BP

    IF EB.SystemTables.getMessage() NE 'VAL' THEN

        GOSUB INIT
        GOSUB OPEN.FILES

        IF Y.EMAIL THEN
            EB.DataAccess.FRead(FN.ABC.EMAIL.SMS.PARAMETER, 'SYSTEM', Y.ABC.EMAIL.PARAM.REC, F.ABC.EMAIL.SMS.PARAMETER, AESP.ERR1)
            IF Y.ABC.EMAIL.PARAM.REC THEN
                Y.EMAIL.ACC.MIN = Y.ABC.EMAIL.PARAM.REC<ABC.BP.AbcEmailSmsParameter.AEspEmailAccMin>
                Y.EMAIL.DOM.MIN = Y.ABC.EMAIL.PARAM.REC<ABC.BP.AbcEmailSmsParameter.AEspEmailDomMin>
                Y.EMAIL.MAX.DOT = Y.ABC.EMAIL.PARAM.REC<ABC.BP.AbcEmailSmsParameter.AEspEmailMaxDot>
                VAL.GEN.DOM = Y.ABC.EMAIL.PARAM.REC<ABC.BP.AbcEmailSmsParameter.AEspValGenDom>
                Y.INVALID.CHAR = Y.ABC.EMAIL.PARAM.REC<ABC.BP.AbcEmailSmsParameter.AEspInvalidChar>

                CONVERT "." TO "" IN VAL.GEN.DOM
                CONVERT @SM TO @VM IN VAL.GEN.DOM
            END ELSE
                Y.ERROR = "NO EXISTE PARAMETROS PARA EMAIL"
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            IF Y.DOM.TERR.LIST EQ '' THEN
                Y.ERROR = "NO EXISTE DOMINIOS TERRITORIALES"
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                Y.DOM.TERR = Y.DOM.TERR.LIST
                CONVERT "." TO "" IN Y.DOM.TERR
                CONVERT @FM TO @VM IN Y.DOM.TERR
            END


            IF COUNT(Y.EMAIL,"@") NE 1 THEN
                Y.ERROR = "EL CORREO DEBE CONTENER UN @"
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            Y.EMAIL.ACCT =  FIELD(Y.EMAIL,"@",1)
            Y.EMAIL.DOM = FIELD(Y.EMAIL,"@",2)

            IF LEN(Y.EMAIL.ACCT) LT Y.EMAIL.ACC.MIN THEN
                Y.ERROR = "LONGITUD MINIMA ANTES DE @ DEBE SER ":Y.EMAIL.ACC.MIN
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            FOR I=1 TO LEN(Y.EMAIL.ACCT)
                IF INDEX(Y.INVALID.CHAR, Y.EMAIL.ACCT[I,1], 1)  THEN
                    Y.ERROR = "CARACTER INVALIDO ":Y.EMAIL.ACCT[I,1]
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                    RETURN
                END
            NEXT I

            IF COUNT(Y.EMAIL.DOM,".") GT Y.EMAIL.MAX.DOT THEN
                Y.ERROR = "DESPUES DE @ SOLO DEBE HABER ":Y.EMAIL.MAX.DOT:" PUNTO(S)"
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                IF COUNT(Y.EMAIL.DOM,".") LT 1 THEN
                    Y.ERROR = "DESPUES DE @ DEBE HABER AL MENOS UN PUNTO"
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END

            Y.POS.PUNTO = INDEX(Y.EMAIL.DOM,".",1)
            Y.COMPLEMEN = Y.EMAIL.DOM[1,Y.POS.PUNTO -1]
            YLEN.DOM = LEN(Y.COMPLEMEN)

            IF YLEN.DOM LT Y.EMAIL.DOM.MIN THEN
                Y.ERROR = "EL DOMINIO DEBE SER AL MENOS DE ":Y.EMAIL.DOM.MIN:"CARACTERES"
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            FOR I=1 TO LEN(Y.COMPLEMEN)
                IF INDEX(Y.INVALID.CHAR, Y.COMPLEMEN[I,1], 1)  THEN
                    Y.ERROR = "CARACTER INVALIDO ":Y.COMPLEMEN[I,1]
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                    RETURN
                END
            NEXT I

            Y.PUNTOS = DCOUNT(Y.EMAIL.DOM,".")
            Y.DOMINIO1 = DOWNCASE(FIELD(Y.EMAIL.DOM,".",Y.PUNTOS))

            IF NOT(Y.DOMINIO1 MATCHES Y.DOM.TERR) THEN
                IF NOT(Y.DOMINIO1 MATCHES VAL.GEN.DOM) THEN
                    Y.ERROR = "EL DOMINIO .":Y.DOMINIO1:" NO ES VALIDO"
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
        END
    END

    RETURN


OPEN.FILES:

    FN.ABC.EMAIL.SMS.PARAMETER = 'F.ABC.EMAIL.SMS.PARAMETER'
    F.ABC.EMAIL.SMS.PARAMETER = ''
    EB.DataAccess.Opf(FN.ABC.EMAIL.SMS.PARAMETER,F.ABC.EMAIL.SMS.PARAMETER)

    FN.ABC.EMAIL.DOM.TERR = 'F.ABC.EMAIL.DOM.TERR'
    F.ABC.EMAIL.DOM.TERR = ''
    EB.DataAccess.Opf(FN.ABC.EMAIL.DOM.TERR,F.ABC.EMAIL.DOM.TERR)

    SEL.CMD = "SELECT ":FN.ABC.EMAIL.DOM.TERR
    SEL.CMD := \ SAVING EVAL "DOMINIO"\

    Y.NO = ''
    Y.ERR = ''
    EB.DataAccess.ReadList(SEL.CMD,Y.DOM.TERR.LIST,'',Y.NO,Y.ERR)

    RETURN

INIT:
    Y.ABC.EMAIL.PARAM.REC = ''
    Y.ABC.DOM.TERR.REC = ''

    Y.EMAIL = EB.SystemTables.getComi()

    Y.EMAIL.ACCT = ''
    Y.EMAIL.DOM = ''

    Y.EMAIL.ACC.MIN = ''
    Y.EMAIL.DOM.MIN = ''
    Y.EMAIL.MAX.DOT = ''
    VAL.GEN.DOM = ''
    Y.POS.PUNTO = ''
    Y.COMPLEMEN = ''
    Y.DOMINIO1 = ''
    Y.DOMINIO2 = ''
    Y.PUNTOS = ''
    Y.DOM.TERR = ''

    Y.DOM.TERR.LIST = ''
    Y.INVALID.CHAR = ''


    RETURN
END
