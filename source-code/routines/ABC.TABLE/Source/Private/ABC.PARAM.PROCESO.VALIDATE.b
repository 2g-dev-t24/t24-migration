* @ValidationCode : MjotMTkwNzYwNDc1MTpDcDEyNTI6MTc1MjYzNjgyNjcwODptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jul 2025 00:33:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.PARAM.PROCESO.VALIDATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Versions
    $USING EB.ErrorProcessing
    $USING AbcTable

    REC.AP = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Aplicacion)
    NO.CAT = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Categoria)
    NO.AP = DCOUNT(REC.AP, @VM)
    FOR I.P = 1 TO NO.AP
        P.P = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Aplicacion)
        P.P = P.P<1, I.P>
        C.P = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Categoria)<1, I.P>
        C.P = C.P<1, I.P>
        IF P.P EQ 'LD.LOANS.AND.DEPOSITS' THEN
            IF C.P EQ '' THEN
                EB.SystemTables.setAf(AbcTable.AbcParamProceso.Categoria)
                EB.SystemTables.setAv(I.P)
                ETEXT = "E!= DEBE ESPECIFICAR PARA LD"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
            IF NOT(C.P GE 21000 AND C.P LE 21100) THEN
                EB.SystemTables.setAf(AbcTable.AbcParamProceso.Categoria)
                EB.SystemTables.setAv(I.P)
                ETEXT = "E!= CATEGORIA NO PERMITIDA PARA LD"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
        END
        IF P.P EQ 'FUNDS.TRANSFER' THEN
            IF C.P NE '' THEN
                EB.SystemTables.setAf(AbcTable.AbcParamProceso.Categoria)
                EB.SystemTables.setAv(I.P)
                ETEXT = "E!= NO DEBE ESPECIFICAR CATEGORIA"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
        END
    NEXT I.P


    REC.FT = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Aplicacion)
    NO.FT = DCOUNT(REC.FT, @VM)
    Y.FT = ''
    FOR I.F = 1 TO NO.FT
        Y.FT.V = 0
        Y.FT = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Aplicacion)
        Y.FT = Y.FT<1, I.F>
        IF Y.FT EQ 'FUNDS.TRANSFER' THEN
            Y.FT.V = COUNT(REC.FT, Y.FT)
            IF Y.FT.V GT 1 THEN
                EB.SystemTables.setAf(AbcTable.AbcParamProceso.Aplicacion)
                EB.SystemTables.setAv(I.F)
                ETEXT = "E!= ESPECIFICAR FT UNA SOLA VEZ"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END
        END
    NEXT I.F


    REC.CAT = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Categoria)
    NO.CAT = DCOUNT(REC.CAT, @VM)
    Y.CAT = ''
    FOR I.C = 1 TO NO.CAT
        Y.CAT.V = 0
        Y.CAT = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.Categoria)
        Y.CAT = Y.CAT<1, I.C>
        IF Y.CAT NE '' THEN
            Y.CAT.V = COUNT(REC.CAT, Y.CAT)
            IF Y.CAT.V GT 1 THEN
                EB.SystemTables.setAf(AbcTable.AbcParamProceso.Categoria)
                EB.SystemTables.setAv(I.C)
                ETEXT = "E!= CATEGORIA REPETIDA"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                BREAK

            END
        END
        Y.CAT = ''
    NEXT I.C

    REC.HI = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.HoraIni)
    REC.HF = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.HoraFin)
    N.HI = ''
    N.HF = ''
    FOR I.H = 1 TO DCOUNT(REC.HI, VM)
        N.HI = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.HoraIni)
        N.HI = N.HI<1, I.H>
        N.HF = EB.SystemTables.getRNew(AbcTable.AbcParamProceso.HoraFin)<1, I.H>
        N.HF = N.HF<1, I.H>

        IF (N.HI[1,2] GT N.HF[1,2]) THEN
            ETEXT = "E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN"
            EB.SystemTables.setAf(AbcTable.AbcParamProceso.HoraIni)
            EB.SystemTables.setAv(I.H)
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            BREAK
        END ELSE
            IF (N.HI[1,2] EQ N.HF[1,2]) AND (N.HI[3,2] GT N.HF[3,2]) THEN
                ETEXT = "E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN"
                EB.SystemTables.setAf(AbcTable.AbcParamProceso.HoraIni)
                EB.SystemTables.setAv(I.H)
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                BREAK
            END ELSE
                IF (N.HI[1,2] EQ N.HF[1,2]) AND (N.HI[3,2] EQ N.HF[3,2]) AND (N.HI[5,2] GT N.HF[5,2]) THEN
                    ETEXT = "E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN"
                    EB.SystemTables.setAf(AbcTable.AbcParamProceso.HoraIni)
                    EB.SystemTables.setAv(I.H)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                END
            END
        END
    NEXT I.H
RETURN
END

