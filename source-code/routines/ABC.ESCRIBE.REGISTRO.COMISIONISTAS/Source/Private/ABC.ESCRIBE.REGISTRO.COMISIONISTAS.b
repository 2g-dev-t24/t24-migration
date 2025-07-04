* @ValidationCode : Mjo4ODQ4NTgxODY6Q3AxMjUyOjE3NDUxODczOTQ1NzU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2025 19:16:34
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
    $USING AbcTable

    
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
                CONVERT Y.FILE.SEP TO @FM IN Y.ARR.LINE
                Y.TOTAL.SEPARADORES.LINEA = DCOUNT(Y.ARR.LINE,@FM)

                Y.ID.EMISION=TRIM(Y.ARR.LINE<1>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.IdComisionista> =TRIM(Y.ARR.LINE<2>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoCliente>  = TRIM(Y.ARR.LINE<3>)
                Y.CUENTA = TRIM(Y.ARR.LINE<4>)
                Y.CUENTA = FMT(Y.CUENTA,"11'0'R")
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoCuenta>  = Y.CUENTA
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoFt>  = TRIM(Y.ARR.LINE<5>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NoInvCta>  = TRIM(Y.ARR.LINE<6>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.FechaApeCta>  = TRIM(Y.ARR.LINE<7>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.FechaInv>  = TRIM(Y.ARR.LINE<8>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.FechaVencimiento>  = TRIM(Y.ARR.LINE<9>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.NombreArchivo>  = TRIM(Y.ARR.LINE<10>)
                ARR.REG.COMI<AbcTable.AbcRegistroComisionistas.Comisionista>  = 'VECTOR'

                AbcTable.AbcRegistroComisionistas.Write(Y.ID.EMISION,ARR.REG.COMI)
* EB.DataAccess.FWrite(FN.ABC.REGISTRO.COMISIONISTAS,Y.ID.EMISION,ARR.REG.COMI)
*WRITE ARR.REG.COMI TO F.ABC.REGISTRO.COMISIONISTAS,Y.ID.EMISION

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
        Y.CURR.NO = R.REGISTRO<AbcTable.AbcRegistroComisionistas.CurrNo>
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
