* @ValidationCode : MjotNjQ5NzY5OTU0OkNwMTI1MjoxNzQzMjAyMzc1OTY4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Mar 2025 19:52:55
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
$PACKAGE AbcEscribeRegistroComisionistas
SUBROUTINE ABC.ESCRIBE.REGISTRO.COMISIONISTAS

*-----------------------------------------------------------------------------
*
*-------- ---------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcRegistroComisionistas

    
    GOSUB INICIO
    GOSUB ELIMINA.REGISTROS
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN

INICIO:
    Y.FILE.PATH  = '../interfaces/ABC.CARGAS/COMISIONISTAS'
    Y.FILE.NAME  = 'REGISTROS_COMISIONISTAS.txt'

*    -TABLA DE COMISIONISTAS
    FN.ABC.REGISTRO.COMISIONISTAS = "F.ABC.REGISTRO.COMISIONISTAS"
    F.ABC.REGISTRO.COMISIONISTAS  = ""
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS,F.ABC.REGISTRO.COMISIONISTAS)

    FN.ABC.REGISTRO.COMISIONISTAS.HIS = 'F.ABC.REGISTRO.COMISIONISTAS$HIS'
    F.ABC.REGISTRO.COMISIONISTAS.HIS  = ''
    EB.DataAccess.Opf(FN.ABC.REGISTRO.COMISIONISTAS.HIS,F.ABC.REGISTRO.COMISIONISTAS.HIS)

RETURN


PROCESS:

    Y.SEL.FILES  = ''
    Y.LIST.FILES = ''
    Y.NO.FILES   = ''
    Y.SEL.ERR    = ''


*---Seleccionamos del path parametrizado todos los archivos que cumplan con el criterio de nombre establecido
    Y.SEL.FILES = "SSELECT " : Y.FILE.PATH : " EQ " : DQUOTE(Y.FILE.NAME)  ; * ITSS - NYADAV - Added DQUOTE
*    DISPLAY Y.SEL.FILES
    EB.DataAccess.Readlist(Y.SEL.FILES,Y.LIST.FILES,'',Y.NO.FILES,Y.SEL.ERR)
*    DISPLAY Y.LIST.FILES
    Y.FILE.TO.READ= Y.LIST.FILES
    IF Y.NO.FILES GT 0 THEN
        GOSUB READ.FILE
    END
RETURN

READ.FILE:

*---Apertura de Archivo
*   EXECUTE "sh dos2unix -c":Y.FILE.PATH::"/" :Y.FILE.TO.READ

    OPENSEQ Y.FILE.PATH:"/" :Y.FILE.TO.READ TO FILE.RECORD THEN
        LOOP
            Y.MESSAGE.LOG     = ""
            Y.MESSAGE.LOG.ERR = ""
            Y.VALOR.VAL       = ""
            Y.FILE.SEP = "|"
            Y.CUENTA = ""
            ARR.REG.COMI = ""
            Y.ID.EMISION =""

*---Lectura de Cada Linea
            READSEQ Y.LINE FROM FILE.RECORD ELSE  RETURN
            Y.NUM.OF.LINE           = Y.NUM.OF.LINE+1
            YARR.CADENA.CAMPOS.OFS  = ''
            YARR.CAMPOS.VALIDAR.OFS = ''

            Y.ARR.LINE = UTF8(Y.LINE)

            IF Y.ARR.LINE NE '' THEN
                Y.NUM.OF.LINE.LEE  += 1
*luis               CONVERT Y.FILE.SEP TO FM IN Y.ARR.LINE
                Y.TOTAL.SEPARADORES.LINEA = DCOUNT(Y.ARR.LINE,@FM)

                Y.ID.EMISION=TRIM(Y.ARR.LINE<1>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.IdComisionista> =TRIM(Y.ARR.LINE<2>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.NoCliente>  = TRIM(Y.ARR.LINE<3>)
                Y.CUENTA = TRIM(Y.ARR.LINE<4>)
                Y.CUENTA = FMT(Y.CUENTA,"11'0'R")
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.NoCuenta>  = Y.CUENTA
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.NoFt>  = TRIM(Y.ARR.LINE<5>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.NoInvCta>  = TRIM(Y.ARR.LINE<6>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.FechaApeCta>  = TRIM(Y.ARR.LINE<7>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.FechaInv>  = TRIM(Y.ARR.LINE<8>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.FechaVencimiento>  = TRIM(Y.ARR.LINE<9>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.NombreArchivo>  = TRIM(Y.ARR.LINE<10>)
                ARR.REG.COMI<AbcRegistroComisionistas.AbcRegistroComisionistas.Comisionista>  = 'VECTOR'

                WRITE ARR.REG.COMI TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.EMISION

            END
        REPEAT
    END

RETURN

ELIMINA.REGISTROS:
    Y.CURR.NO = ''
    Y.ID.REGISTRO.COMISIONISTA.HIS =''
    SELECT.CMD = "SSELECT " : FN.ABC.REGISTRO.COMISIONISTAS
    EB.DataAccess.Readlist(SELECT.CMD,Y.LIST.REG,'',Y.NO.REG,Y.CMD.ERR)

    FOR REC.REG = 1 TO Y.NO.REG
        Y.ID.REGISTRO.COMISIONISTA = Y.LIST.REG<REC.REG>
        EB.DataAccess.FRead(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.REGISTRO.COMISIONISTA,R.REGISTRO,F.ABC.REGISTRO.COMISIONISTAS,ERR.RELACION)
        Y.CURR.NO = R.REGISTRO<AbcRegistroComisionistas.AbcRegistroComisionistas.CurrNo>
        IF Y.CURR.NO EQ '' THEN
            Y.ID.REGISTRO.COMISIONISTA.HIS = Y.LIST.REG<REC.REG> : ";1"
        END ELSE
            Y.ID.REGISTRO.COMISIONISTA.HIS = Y.LIST.REG<REC.REG> : ";":Y.CURR.NO
        END
*luis
        EB.DataAccess.FWrite(FN.ABC.REGISTRO.COMISIONISTAS.HIS,Y.ID.REGISTRO.COMISIONISTA.HIS,R.REGISTRO)
        EB.DataAccess.FDelete(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.REGISTRO.COMISIONISTA)
        CALL JOURNAL.UPDATE('')
    NEXT REC.REG
RETURN

FINALIZE:
    COMMAND = 'mv ' :Y.FILE.PATH:"/":Y.FILE.TO.READ:' ':Y.FILE.PATH:"/Procesado/":Y.FILE.TO.READ
    EXECUTE COMMAND CAPTURING Y.RESPUESTA

RETURN

END
