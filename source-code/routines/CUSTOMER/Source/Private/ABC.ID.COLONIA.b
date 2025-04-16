* @ValidationCode : Mjo2Mzc0MzQwMzg6Q3AxMjUyOjE3NDQ4MzI1MDE1NTA6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:41:41
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
$PACKAGE ABC.BP
SUBROUTINE ABC.ID.COLONIA(CODIGO.POSTAL,NOMBRE.COLONIA,ID.COLONIA,Y.MESSAGE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.Display
    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALIZE>
INITIALIZE:
***
    FN.ABC.CODIGO.POSTAL = 'F.ABC.CODIGO.POSTAL'
    F.ABC.CODIGO.POSTAL = ''
    EB.DataAccess.Opf(FN.ABC.CODIGO.POSTAL, F.ABC.CODIGO.POSTAL)

    FN.ABC.COLONIA = 'F.ABC.COLONIA'
    F.ABC.COLONIA = ''
    EB.DataAccess.Opf(FN.ABC.COLONIA, F.ABC.COLONIA)

    R.DATOS = ''
    ID.COLONIA = ''
    Y.MENSAGGE = ''

RETURN
*** </region>

************
COLONIA.FMT:
************

    IF Y.TOT.ESPACIOS GT 1 THEN
        FOR LOOP.POS =2 TO Y.TOT.ESPACIOS
            Y.NOMBRE.FMT :=FIELD(NOMBRE.COLONIA," ",LOOP.POS):" "
        NEXT LOOP.POS
        Y.NOMBRE.FMT=TRIM(Y.NOMBRE.FMT)
        Y.PRIMER.PALBRA =FIELD(NOMBRE.COLONIA," ",1)
        Y.ULTIMA.PALBRA =FIELD(NOMBRE.COLONIA," ",Y.TOT.ESPACIOS)
        PRINT Y.NOMBRE.FMT

    END ELSE
        Y.NOMBRE.FMT=''
        Y.ULTIMA.PALBRA=''
    END

RETURN
*** <region name= PROCESS>
PROCESS:
***

    CODIGO.POSTAL = FMT(CODIGO.POSTAL,"5'0'R")
    Y.TOT.ESPACIOS = DCOUNT(NOMBRE.COLONIA," ")
    R.DATOS.REMPLAZAR = ''
    R.DATOS.REMPLAZAR = NOMBRE.COLONIA
    GOSUB REMPLAZA.CARACTER
    NOMBRE.COLONIA = R.DATOS.REMPLAZAR
    GOSUB COLONIA.FMT
    Y.ESTADO=''
    Y.MUNICIPIO=''
    EB.DataAccess.FRead(FN.ABC.CODIGO.POSTAL,CODIGO.POSTAL, R.ADRESS, F.ABC.CODIGO.POSTAL, ERR.COD.POS)
    IF R.ADRESS NE '' THEN

        R.ID.COLONIA  = R.ADRESS<AbcTable.AbcColonia.Colonia>
        Y.ESTADO=R.ADRESS<AbcTable.AbcCodigoPostal.Estado>
        Y.MUNICIPIO=R.ADRESS<AbcTable.AbcCodigoPostal.Municipio>
        Y.CANT.COL = DCOUNT(R.ID.COLONIA,VM)
        FOR I = 1 TO Y.CANT.COL
            Y.ID.COL = FIELD(R.ID.COLONIA, VM, I)
            EB.DataAccess.FRead(FN.ABC.COLONIA, Y.ID.COL, R.COLONIA, F.ABC.COLONIA, ERR.COL.POS)
            Y.COL.DESC = R.COLONIA<AbcTable.AbcColonia.Colonia>
            R.DATOS<-1> = Y.COL.DESC
        NEXT I

        R.DATOS.REMPLAZAR = ''
        R.DATOS.REMPLAZAR = R.DATOS
        GOSUB REMPLAZA.CARACTER
        R.DATOS = R.DATOS.REMPLAZAR
        CONVERT @VM TO @FM IN R.ID.COLONIA

        FIND NOMBRE.COLONIA IN R.DATOS SETTING YPOS THEN
            ID.COLONIA = R.ID.COLONIA<YPOS>
        END ELSE
            IF Y.NOMBRE.FMT NE '' THEN
                FINDSTR Y.NOMBRE.FMT IN R.DATOS SETTING Ap, Vp THEN
                    ID.COLONIA = R.ID.COLONIA<Ap>
                    RESPUESTA.COLONIA = R.DATOS<Ap>
                    Y.MESSAGE = "VERIFICAR COLONIA, COLONIA RECIBIDA: '":NOMBRE.COLONIA: "' COLONIA COLOCADA: '":RESPUESTA.COLONIA:"'"
                END ELSE
                    FINDSTR Y.PRIMER.PALBRA IN R.DATOS SETTING Ap, Vp THEN
                        ID.COLONIA = R.ID.COLONIA<Ap>
                        RESPUESTA.COLONIA = R.DATOS<Ap>
                        Y.MESSAGE = "VERIFICAR COLONIA, COLONIA RECIBIDA: '":NOMBRE.COLONIA: "' COLONIA COLOCADA: '":RESPUESTA.COLONIA:"'"
                    END ELSE
                        FINDSTR Y.ULTIMA.PALBRA IN R.DATOS SETTING Ap, Vp THEN
                            ID.COLONIA = R.ID.COLONIA<Ap>
                            RESPUESTA.COLONIA = R.DATOS<Ap>
                            Y.MESSAGE = "VERIFICAR COLONIA, COLONIA RECIBIDA: '":NOMBRE.COLONIA: "' COLONIA COLOCADA: '":RESPUESTA.COLONIA:"'"
                        END ELSE
                            GOSUB BUSCA.COLONIA
                        END
                    END
                END
            END ELSE
                FINDSTR NOMBRE.COLONIA IN R.DATOS SETTING Ap, Vp THEN
                    ID.COLONIA = R.ID.COLONIA<Ap>
                    RESPUESTA.COLONIA = R.DATOS<Ap>
                    Y.MESSAGE = "VERIFICAR COLONIA, COLONIA RECIBIDA: '":NOMBRE.COLONIA: "' COLONIA COLOCADA: '":RESPUESTA.COLONIA:"'"
                END ELSE
                    GOSUB BUSCA.COLONIA
                END
            END
        END
    END ELSE
        GOSUB BUSCA.COLONIA
        Y.MESSAGE = "VERIFICAR CP Y COLONIA, COLONIA RECIBIDA: '":NOMBRE.COLONIA: "' COLONIA COLOCADA: '":RESPUESTA.COLONIA:"'"
    END

    NOMBRE.COLONIA= EREPLACE(NOMBRE.COLONIA,'�','�')

RETURN
**************
BUSCA.COLONIA:
**************

    ID.COLONIA = ''
    Y.NOMBRE.COL=NOMBRE.COLONIA

    IF Y.TOT.ESPACIOS GT 1 THEN
        Y.NOMBRE.COL=EREPLACE(Y.NOMBRE.COL," ","...")
        SEL.CMD= "SELECT " : FN.ABC.COLONIA : " WITH COLONIA LIKE ":DQUOTE(Y.NOMBRE.COL):" AND @ID LIKE ":DQUOTE(SQUOTE(Y.ESTADO):"...")    ;* ITSS - BINDHU - Added DQUOTE / SQUOTE
        EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
        IF Y.LIST.REG EQ '' THEN
            Y.NOMBRE.FMT=EREPLACE(Y.NOMBRE.FMT," ","...")
            SEL.CMD= "SELECT " : FN.ABC.COLONIA : " WITH COLONIA LIKE ":DQUOTE('...':SQUOTE(Y.NOMBRE.FMT)):" AND @ID LIKE ":DQUOTE(SQUOTE(Y.ESTADO):"...")      ;* ITSS - BINDHU - Added DQUOTE / SQUOTE
            EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
            IF Y.LIST.REG EQ '' THEN
                SEL.CMD= "SELECT " : FN.ABC.COLONIA : " WITH COLONIA LIKE ":DQUOTE('...':SQUOTE(Y.ULTIMA.PALBRA)):" AND @ID LIKE ":DQUOTE(SQUOTE(Y.ESTADO):"...")         ;* ITSS - BINDHU - Added DQUOTE / SQUOTE
                EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
            END
            IF Y.LIST.REG EQ '' THEN
                SEL.CMD= "SELECT " : FN.ABC.COLONIA : " WITH COLONIA LIKE ":DQUOTE(SQUOTE(Y.PRIMER.PALBRA):"..."):" AND @ID LIKE ":DQUOTE(SQUOTE(Y.ESTADO):"...")         ;* ITSS - BINDHU - Added DQUOTE / SQUOTE
                EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
            END
        END
    END ELSE
        SEL.CMD= "SELECT " : FN.ABC.COLONIA : " WITH COLONIA EQ ":DQUOTE(Y.NOMBRE.COL):" AND @ID LIKE ":DQUOTE(SQUOTE(Y.ESTADO):"...")      ;* ITSS - BINDHU - Added DQUOTE / SQUOTE
        EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
    END


    IF Y.LIST.REG NE '' THEN
        FOR REC = 1 TO Y.NO.REGISTROS
            Y.ID.COLO = FIELD(Y.LIST.REG, FM, REC)
            EB.DataAccess.FRead(FN.ABC.COLONIA, Y.ID.COLO, R.COLONIAS, F.ABC.COLONIA, ERR.COL.POS)
            Y.COL.DESCRIP = R.COLONIAS<AbcTable.AbcColonia.Colonia>
            R.DATOSS<-1> = Y.COL.DESCRIP
        NEXT REC

        R.DATOS.REMPLAZAR = ''
        R.DATOS.REMPLAZAR = R.DATOSS
        GOSUB REMPLAZA.CARACTER
        R.DATOSS = R.DATOS.REMPLAZAR
        FIND NOMBRE.COLONIA IN R.DATOSS SETTING App, Vpp THEN
            RESPUESTA.COLONIA = R.DATOSS<App>
            ID.COLONIA = Y.LIST.REG<App>
        END ELSE
            IF Y.NOMBRE.FMT NE '' THEN
                FINDSTR Y.NOMBRE.FMT IN R.DATOSS SETTING Apa, Vpa THEN
                    RESPUESTA.COLONIA = R.DATOSS<Apa>
                    ID.COLONIA = Y.LIST.REG<Apa>
                END ELSE
                    FINDSTR Y.PRIMER.PALBRA IN R.DATOSS SETTING Ap, Vp THEN     ;* MADM, se cambia variable R.DATOS por R.DATOSS
                        RESPUESTA.COLONIA = R.DATOSS<Ap>
                        ID.COLONIA = Y.LIST.REG<Ap>
                    END ELSE
                        FINDSTR Y.ULTIMA.PALBRA IN R.DATOSS SETTING Apa, Vpa THEN
                            RESPUESTA.COLONIA = R.DATOSS<Apa>
                            ID.COLONIA = Y.LIST.REG<Apa>
                        END ELSE
                            GOSUB MSG.DEFAULT
                        END
                    END
                END
            END ELSE
                FINDSTR  NOMBRE.COLONIA IN R.DATOSS SETTING Apa, Vpa THEN
                    RESPUESTA.COLONIA = R.DATOSS<Apa>
                    ID.COLONIA = Y.LIST.REG<Apa>
                END ELSE
                    GOSUB MSG.DEFAULT
                END
            END

        END

    END ELSE
        GOSUB MSG.DEFAULT
    END

RETURN
*** <region name= FINALIZE>
MSG.DEFAULT:

    ID.COLONIA = '05035271052472'
    Y.MESSAGE = 'CODIGO DE COLONIA POR DEFAULT'
RETURN
REMPLAZA.CARACTER:
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "¥","Ñ"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "A"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "O"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "U"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "U"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "A"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "E"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "I"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "O"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "U"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "A"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "E"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "I"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "O"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", "U"))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, " ", " "))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", CHAR(165)))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "�", CHAR(165)))
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, "'", ""))    ;* MADM
    R.DATOS.REMPLAZAR = TRIM(EREPLACE(R.DATOS.REMPLAZAR, ".", ""))    ;* MADM

RETURN

FINALIZE:
***
RETURN
*** </region>
END

