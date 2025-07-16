* @ValidationCode : MjoxMjcyNDM2ODkyOkNwMTI1MjoxNzUyNjMwNDU4NjcyOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jul 2025 22:47:38
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

*    REC.AP = R.NEW(VPM.APLICACION)
*    NO.CAT = R.NEW(VPM.CATEGORIA)
*    NO.AP = DCOUNT(REC.AP, VM)
*    FOR I.P = 1 TO NO.AP
*        P.P = R.NEW(VPM.APLICACION)<1, I.P>
*        C.P = R.NEW(VPM.CATEGORIA)<1, I.P>
*        IF P.P EQ 'LD.LOANS.AND.DEPOSITS' THEN
*            IF C.P EQ '' THEN
*                AF = VPM.CATEGORIA
*                AV = I.P
*                ETEXT = "E!= DEBE ESPECIFICAR PARA LD"
*                CALL STORE.END.ERROR
*                BREAK
*            END
*            IF NOT(C.P >= 21000 AND C.P <= 21100) THEN
*                AF = VPM.CATEGORIA
*                AV = I.P
*                ETEXT = "E!= CATEGORIA NO PERMITIDA PARA LD"
*                CALL STORE.END.ERROR
*                BREAK
*            END
*        END
*        IF P.P EQ 'FUNDS.TRANSFER' THEN
*            IF C.P NE '' THEN
*                AF = VPM.CATEGORIA
*                AV = I.P
*                ETEXT = "E!= NO DEBE ESPECIFICAR CATEGORIA"
*                CALL STORE.END.ERROR
*                BREAK
*            END
*        END
*    NEXT I.P
*
*
*    REC.FT = R.NEW(VPM.APLICACION)
*    NO.FT = DCOUNT(REC.FT, VM)
*    Y.FT = ''
*    FOR I.F = 1 TO NO.FT
*        Y.FT.V = 0
*        Y.FT = R.NEW(VPM.APLICACION)<1, I.F>
*        IF Y.FT EQ 'FUNDS.TRANSFER' THEN
*            Y.FT.V = COUNT(REC.FT, Y.FT)
*            IF Y.FT.V GT 1 THEN
*                AF = VPM.APLICACION
*                AV = I.F
*                ETEXT = "E!= ESPECIFICAR FT UNA SOLA VEZ"
*                CALL STORE.END.ERROR
*                BREAK
*            END
*        END
*    NEXT I.F
*
*
*    REC.CAT = R.NEW(VPM.CATEGORIA)
*    NO.CAT = DCOUNT(REC.CAT, VM)
*    Y.CAT = ''
*    FOR I.C = 1 TO NO.CAT
*        Y.CAT.V = 0
*        Y.CAT = R.NEW(VPM.CATEGORIA)<1, I.C>
*        IF Y.CAT NE '' THEN
*            Y.CAT.V = COUNT(REC.CAT, Y.CAT)
*            IF Y.CAT.V GT 1 THEN
*                AF = VPM.CATEGORIA
*                AV = I.C
*                ETEXT = "E!= CATEGORIA REPETIDA"
*                CALL STORE.END.ERROR
*                BREAK
*
*            END
*        END
*        Y.CAT = ''
*    NEXT I.C
*
*
*    REC.HI = R.NEW(VPM.HORA.INI)
*    REC.HF = R.NEW(VPM.HORA.FIN)
*    N.HI = ''
*    N.HF = ''
*    FOR I.H = 1 TO DCOUNT(REC.HI, VM)
*        N.HI = R.NEW(VPM.HORA.INI)<1, I.H>
*        N.HF = R.NEW(VPM.HORA.FIN)<1, I.H>
*
*        IF (N.HI[1,2] > N.HF[1,2]) THEN
*            ETEXT = "E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN"
*            AF = VPM.HORA.INI
*            AV = I.H
*            CALL STORE.END.ERROR
*            BREAK
*        END ELSE
*            IF (N.HI[1,2] = N.HF[1,2]) AND (N.HI[3,2] > N.HF[3,2]) THEN
*                ETEXT = "E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN"
*                AF = VPM.HORA.INI
*                AV = I.H
*                CALL STORE.END.ERROR
*                BREAK
*            END ELSE
*                IF (N.HI[1,2] = N.HF[1,2]) AND (N.HI[3,2] = N.HF[3,2]) AND (N.HI[5,2] > N.HF[5,2]) THEN
*                    ETEXT = "E!= HORA DE INICIO DEBE SER MENOR A HORA DE FIN"
*                    AF = VPM.HORA.INI
*                    AV = I.H
*                    CALL STORE.END.ERROR
*                    BREAK
*                END
*            END
*        END
*    NEXT I.H
RETURN
END

