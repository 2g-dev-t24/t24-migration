* @ValidationCode : MjoxNTk5Nzc0Nzg5OkNwMTI1MjoxNzUzNDc1NTQ2NzgyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2025 17:32:26
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
$PACKAGE AbcTable
SUBROUTINE ABC.TEMP.GENE.FT.ID
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
    $USING EB.Updates
    $USING AbcGetGeneralParam

    GOSUB INITIALIZE ; *
    GOSUB PROCESS ; *


*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.FT = "F.FUNDS.TRANSFER"
    FV.FT = ''
    EB.DataAccess.Opf(FN.FT,FV.FT)

    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    FV.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,FV.FT.HIS)

    FN.GENE = "F.ABC.TEMP.GENE.FT"
    FV.GENE = ''
    EB.DataAccess.Opf(FN.GENE,FV.GENE)

    FN.ACLK = "F.AC.LOCKED.EVENTS"
    FV.ACLK = ''
    EB.DataAccess.Opf(FN.ACLK,FV.ACLK)

    FN.ACLK.HIS = "F.AC.LOCKED.EVENTS$HIS"
    FV.ACLK.HIS = ''
    EB.DataAccess.Opf(FN.ACLK.HIS,FV.ACLK.HIS)

    FN.ABC.PEND.GALILEO = "F.ABC.PENDIENTES.GALILEO"        ;*LFCR23052022-S
    F.ABC.PEND.GALILEO = ""
    EB.DataAccess.Opf(FN.ABC.PEND.GALILEO, F.ABC.PEND.GALILEO)       ;*LFCR23052022-E

    FN.ABC.CONCAT.GALILEO = "F.ABC.CONCAT.GALILEO"          ;*LFCR080721-S
    F.ABC.CONCAT.GALILEO = ""
    EB.DataAccess.Opf(FN.ABC.CONCAT.GALILEO, F.ABC.CONCAT.GALILEO)
 
    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'AT.UNIQUE.ID', POS.UNIQUE.ID)
    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'AT.AUTH.CODE', POS.AUTH.CODE)      ;*LFCR080721-E

    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER', 'ORIG.AMOUNT', POS.ORIG.MONTO)        ;*LFCR260521-S
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER', 'ORIG.CURRENCY', POS.ORIG.CURRN)
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER', 'COMISION', POS.COMI.CAJERO)
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER', 'TIPO.CAMB', POS.TIPO.CAMB)

    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'ORIG.AMOUNT', POS.ORIG.MONTO.AC)
    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'ORIG.CURRENCY', POS.ORIG.CURRN.AC)
    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'TIPO.CAMB', POS.TIPO.CAMB.AC)
    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'MCC', POS.MCC)
    EB.Updates.MultiGetLocRef('AC.LOCKED.EVENTS', 'COMISION', POS.ACLK.COMIS)

    Y.ID.GEN.PARAM = 'ABC.CTAS.COMPENSACION'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    CTA.COMPENSACION.POS = '' ; CTA.DEBITO.POS = '' ; CTA.COMPENSACION.ATM = '' ; CTA.DEBITO.ATM = ''

    LOCATE 'CUENTA.COMPENSACION.POS' IN Y.LIST.PARAMS SETTING POS.CTA.COM.POS THEN
        CTA.COMPENSACION.POS = Y.LIST.VALUES<POS.CTA.COM.POS>
    END

    LOCATE 'CUENTA.DEBITO.POS' IN Y.LIST.PARAMS SETTING POS.CTA.DEB.POS THEN
        CTA.DEBITO.POS = Y.LIST.VALUES<POS.CTA.DEB.POS>
    END

    IF CTA.DEBITO.POS EQ 'NA' THEN
        CTA.DEBITO.POS = ''
    END

    LOCATE 'CUENTA.COMPENSACION.ATM' IN Y.LIST.PARAMS SETTING POS.CTA.COM.ATM THEN
        CTA.COMPENSACION.ATM = Y.LIST.VALUES<POS.CTA.COM.ATM>
    END

    LOCATE 'CUENTA.DEBITO.ATM' IN Y.LIST.PARAMS SETTING POS.CTA.DEB.ATM THEN
        CTA.DEBITO.ATM = Y.LIST.VALUES<POS.CTA.DEB.ATM>
    END   ;*LFCR260521-E

    REC.FT = '' ; REC.GENE = '' ; A.RESULT = '' ; AUTH.ID.ACLK = ''

RETURN
*** </region>


*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    V$ERROR = 0
    E = ''
    ID.FT.C     = EB.SystemTables.getComi()
    Y.FUNCION   = EB.SystemTables.getVFunction()
    
    IF Y.FUNCION EQ "S" THEN
        GOSUB VAL.ID.ACLK.FT  ;*LFCR080721-S
    END ELSE
        GOSUB VAL.ID.ACLK.FT  ;*LFCR080721-E
        IF ID.FT.C[1,2] EQ 'FT' THEN
            READ REC.FT FROM FV.FT, ID.FT.C ELSE
                READ REC.GENE FROM FV.GENE, ID.FT.C THEN
                    J.STATUS = REC.GENE<AbcTable.AbcTempGeneFt.Status>
                    IF J.STATUS EQ "GENERADO" THEN
                        E = "TRANSFERENCIA REVERSADA Y GENERADA"
                    END
                END ELSE
                    E = "LA TRANSFERENCIA NO EXISTE"
                END
            END
        END ELSE
            IF ID.FT.C[1,4] EQ 'ACLK' THEN
                READ REC.ACLK FROM FV.ACLK, ID.FT.C ELSE
                    READ REC.GENE FROM FV.GENE, ID.FT.C THEN
                        J.STATUS = REC.GENE<AbcTable.AbcTempGeneFt.Status>
                        IF (J.STATUS EQ "GENERADO") OR (J.STATUS EQ "REVERSADO") THEN
                            E = "BLOQUEO REVERSADO"
                        END
                    END ELSE
                        E = "EL BLOQUEO NO EXISTE"
                    END
                END
            END
        END
    END

    IF E THEN
        ETEXT = E
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        BREAK
    END

RETURN

RETURN
*** </region>
*-----------------------------------------------------------------------------
VAL.ID.ACLK.FT:
*-----------------------------------------------------------------------------

    Y.VERSION = '' ; Y.VRSNS.AUTHID.BLOQ = '' ; Y.VRSNS.POS = '' ; Y.VRSINS.ATM = ''
    REC.AUTHID = '' ; Y.ESTATUS.AUTHID = ''
    Y.GUARDA.AUTHID.REVE = '' ; Y.EXISTE.REVE = ''
    Y.VERSION = EB.SystemTables.getPgmVersion
    Y.VRSN.APLI.POS = ",APLICA.COMPRA.MC"
    Y.VRSN.REVE.POS = ",REVERSO.COMPRA.MC"
    Y.VRSN.APLI.ATM = ",APLICA.RETIRO.ATM.MC"
    Y.VRSN.REVE.ATM = ",REVERSO.ATM.MC"
    Y.VRSNS.REVE.BLOQ = Y.VRSN.REVE.POS : @VM : Y.VRSN.REVE.ATM
    Y.VRSNS.AUTHID.BLOQ  = Y.VRSN.APLI.ATM : @VM : Y.VRSN.APLI.POS : @VM
    Y.VRSNS.AUTHID.BLOQ := Y.VRSNS.REVE.BLOQ
    Y.VRSNS.POS = Y.VRSN.APLI.POS : @VM : Y.VRSN.REVE.POS
    Y.VRSINS.ATM = Y.VRSN.APLI.ATM : @VM : Y.VRSN.REVE.ATM

    IF ((ID.FT.C[1,2] NE 'FT') AND (ID.FT.C[1,4] NE 'ACLK')) AND (Y.VERSION MATCHES Y.VRSNS.AUTHID.BLOQ) THEN

        Y.MONTO.REVE.PARCIAL = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.MontoRevParcial)
        Y.AUTH.ID.ORIGINAL = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.OrigAuthId)
        Y.A.ORIG.AMOUNT.REV = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.OrigAmount)
        
        
        IF Y.VERSION EQ Y.VRSN.REVE.POS AND (Y.MONTO.REVE.PARCIAL NE '') AND (Y.AUTH.ID.ORIGINAL NE '') AND (Y.MONTO.REVE.PARCIAL NE '0') AND (Y.AUTH.ID.ORIGINAL NE '0') THEN
            Y.AUTHID.NUEVO.REVE = ID.FT.C
            AUTH.ID.AUX = Y.AUTH.ID.ORIGINAL
            GOSUB VALIDA.EXISTE.ORIG.AUTHID

            IF Y.ERROR.EXISTE.ORIG.AUTHID NE '' THEN
                E = Y.ERROR.EXISTE.ORIG.AUTHID
            END

            GOSUB VALIDA.ESTATUS.AUTHID
            IF Y.ERROR.ESTATUS NE '' THEN
                E = Y.ERROR.ESTATUS
            END

            AUTH.ID.AUX = Y.AUTHID.NUEVO.REVE
            GOSUB VALIDA.ESTATUS.AUTHID
            IF Y.ERROR.ESTATUS NE '' THEN
                E = Y.ERROR.ESTATUS
                RETURN
            END
            GOSUB VALIDA.EXISTE.REVE.PAR.PEND     ;* LFCR_19042024_VALIDA_REVE_PAR - S

            AUTH.ID.AUX = Y.AUTH.ID.ORIGINAL


            IF (Y.EXISTE.AUTH.ID EQ 'NO') AND (Y.EXISTE.AUTH.ID.REVE.PAR EQ 'NO') THEN    ;* LFCR_07082024_GUARDA_REVE_PAR - S
                Y.AUTH.ID.PEND = "REVE.":Y.AUTHID.NUEVO.REVE
                Y.ID.ACLK = "SIN BLOQUEO"
                TRANSACTION.TYPE = "REV PARCIAL POS"
                ID.ACC = Y.AUTH.ID.ORIGINAL
                A.DEBIT.AMOUNT = Y.MONTO.REVE.PARCIAL
                A.ORIG.AMOUNT = Y.A.ORIG.AMOUNT.REV
                Y.FECHA.APL = OCONV(DATE(),'DY4'):FMT(OCONV(DATE(),"DM"),"2'0'R"):FMT(OCONV(DATE(),"DD"),"2'0'R")
                Y.ESTATUS.GUARDA.PEND = "REV PARCIAL PEND"
                Y.MSG.ERR = "1_REVERSO PARCIAL SIN ACLK"
                Y.SAVE.AUDIT.FLDS = 1

                GOSUB GUARDA.APLC.PENDIENTE
                E = "NO EXISTE BLOQUEO PARA AUTH.ID " : Y.AUTH.ID.ORIGINAL
                V$ERROR = 1
                RETURN        ;* LFCR_07082024_GUARDA_REVE_PAR - E
            END     ;* LFCR_19042024_VALIDA_REVE_PAR - E
            ID.FT.C = Y.AUTH.ID.ORIGINAL
        END         ;* LFCR_07082023_REVE_PAR - E

        AUTH.ID.ACLK = ID.FT.C
        AUTH.ID.AUX = AUTH.ID.ACLK
        GOSUB VALIDA.ESTATUS.AUTHID
        IF Y.ERROR.ESTATUS NE '' THEN
            E = Y.ERROR.ESTATUS
            RETURN
        END
*READ REC.AUTHID FROM F.ABC.CONCAT.GALILEO, ID.FT.C THEN LFCR_07082023_REVE_PAR S-E
        IF REC.AUTHID THEN
            Y.FT.GENERADO = REC.AUTH<AbcTable.AbcConcatGalile.FtGenerado>
            ID.FT.C = REC.AUTHID<AbcTable.AbcConcatGalile.AclkId>
            GOSUB VALIDA.TIPO.BLOQUEO
            ID.NEW = ID.FT.C
            RETURN
        END ELSE

            IF Y.VERSION MATCHES Y.VRSNS.REVE.BLOQ THEN
                GOSUB VALIDA.EXISTE.REVE
                IF Y.EXISTE.REVE EQ 1 THEN
                    E = "REVERSO DE BLOQUEO YA RECIBIDO"
                END ELSE
                    Y.GUARDA.AUTHID.REVE = "SI"
                END
            END ELSE
                E = "NO EXISTE BLOQUEO PARA AUTH.ID INGRESADO"
            END
        END
    END

RETURN

*----------------------------------------------------------------------------- ;* LFCR_19042024_VALIDA_REVE_PAR - S
VALIDA.EXISTE.ORIG.AUTHID:
*-----------------------------------------------------------------------------

    Y.EXISTE.AUTH.ID = ''
    READ REC.AUTHID FROM F.ABC.CONCAT.GALILEO, Y.AUTH.ID.ORIGINAL ELSE
        Y.ERROR.EXISTE.ORIG.AUTHID = "NO EXISTE BLOQUEO PARA AUTH.ID " : Y.AUTH.ID.ORIGINAL
        Y.EXISTE.AUTH.ID = 'NO'
        RETURN
    END

RETURN

*-----------------------------------------------------------------------------
VALIDA.ESTATUS.AUTHID:
*-----------------------------------------------------------------------------

    Y.ERROR.ESTATUS = ''
    READ REC.AUTHID FROM F.ABC.CONCAT.GALILEO, AUTH.ID.AUX THEN
        Y.ESTATUS.AUTHID = REC.AUTHID<AbcTable.AbcConcatGalile.Estatus>
        IF (Y.ESTATUS.AUTHID NE "PENDIENTE") AND (Y.ESTATUS.AUTHID NE "") AND (Y.ESTATUS.AUTHID NE 'REVERSO PARCIAL') THEN
            Y.ERROR.ESTATUS = "AUTH.ID " : AUTH.ID.AUX : " YA REGISTRADO CON ESTATUS: " : Y.ESTATUS.AUTHID
            RETURN
        END
    END

RETURN

*----------------------------------------------------------------------------- ;* LFCR_19042024_VALIDA_REVE_PAR - S
VALIDA.EXISTE.REVE.PAR.PEND:
*-----------------------------------------------------------------------------

    Y.EXISTE.AUTH.ID.REVE.PAR = '' ; REC.AUTHID.PEND = ''
    READ REC.AUTHID.PEND FROM F.ABC.PEND.GALILEO, Y.AUTH.ID.ORIGINAL ELSE
        Y.EXISTE.AUTH.ID.REVE.PAR = 'NO'
        RETURN
    END

RETURN

*-------------------------------------;*LFCR080721-E SE CAMBIA A TABLA DE PENDIENTES.GALILEO
GUARDA.APLC.PENDIENTE:
*-------------------------------------

    Y.ID.PENDIENTE = '' ; Y.TIPO.TRANS = '' ; Y.DESC.TRANS = '' ; Y.ID.BLOQUEO = ''
    Y.FECHA.SYS = '' ; Y.HORA.SYS = '' ; REC.PEND.GALI = '' ; Y.ESTATUS.PENDIENTE = ''
    Y.MENSAJE.ERROR = ''
    Y.ID.BLOQUEO = Y.ID.ACLK
    Y.ID.PENDIENTE = Y.AUTH.ID.PEND
    Y.ESTATUS.PENDIENTE = Y.ESTATUS.GUARDA.PEND
    Y.MENSAJE.ERROR = Y.MSG.ERR
    Y.FECHA.SYS = Y.FECHA.APL
    Y.HORA.SYS = OCONV(TIME(), 'MTS')

    REC.PEND.GALI<PEND.GALI.TIPO.TRANS> = TRANSACTION.TYPE
    REC.PEND.GALI<PEND.GALI.DESCRIPCION> = Y.TIPO.BLOQUEO
    REC.PEND.GALI<PEND.GALI.CUENTA.CLIENTE> = ID.ACC
    REC.PEND.GALI<PEND.GALI.MONTO.LOCAL> = A.DEBIT.AMOUNT
    REC.PEND.GALI<PEND.GALI.COMISION> = A.COMISION
    REC.PEND.GALI<PEND.GALI.MONTO.ORIG> = A.ORIG.AMOUNT
    REC.PEND.GALI<PEND.GALI.MONEDA.ORIG> = A.ORIG.CURRENCY
    REC.PEND.GALI<PEND.GALI.ACLK.ID> = Y.ID.BLOQUEO
    REC.PEND.GALI<PEND.GALI.FECHA.INGRESO> = Y.FECHA.SYS
    REC.PEND.GALI<PEND.GALI.HORA.INGRESO> = Y.HORA.SYS
    REC.PEND.GALI<PEND.GALI.ESTATUS> = Y.ESTATUS.PENDIENTE
    REC.PEND.GALI<PEND.GALI.MSG.ERROR> = Y.MENSAJE.ERROR

    IF Y.SAVE.AUDIT.FLDS = 1 THEN       ;* LFCR_07082024_GUARDA_REVE_PAR - S
        YTIME = TIMEDATE()
        REC.PEND.GALI<PEND.GALI.CURR.NO> = "1"
        REC.PEND.GALI<PEND.GALI.INPUTTER> = OPERATOR:"_REVPAR"        ;*"23_USERFYG03__OFS_BROWSERTC"
        REC.PEND.GALI<PEND.GALI.DATE.TIME> = TODAY[3,6]:YTIME[1,2]:YTIME[4,2]
        REC.PEND.GALI<PEND.GALI.AUTHORISER> = OPERATOR:"_REVPAR"      ;*"23_USERFYG03_OFS_BROWSERTC"
        REC.PEND.GALI<PEND.GALI.CO.CODE> = "MX0010001"
        REC.PEND.GALI<PEND.GALI.DEPT.CODE> = "901031003002003"
    END   ;* LFCR_07082024_GUARDA_REVE_PAR - E

    EB.DataAccess.FWrite(FN.ABC.PEND.GALILEO, Y.ID.PENDIENTE, REC.PEND.GALI)
*CALL JOURNAL.UPDATE('')

RETURN          ;*LFCR080721-E

*-----------------------------------------------------------------------------
VALIDA.TIPO.BLOQUEO:
*-----------------------------------------------------------------------------

    Y.TIPO.BLOQ = ''

    IF Y.VERSION MATCHES Y.VRSNS.POS THEN
        Y.TIPO.BLOQ = "ACTD"
    END

    IF Y.VERSION MATCHES Y.VRSINS.ATM THEN
        Y.TIPO.BLOQ = "ACAT"
    END

    ID.ACLK = ID.FT.C
    ACLK.FILE = FV.ACLK
    GOSUB LEE.REC.ACLK
    IF (TRANSACTION.TYPE NE Y.TIPO.BLOQ) AND (TRANSACTION.TYPE NE "") THEN
        E = "TIPO DE TRANSACCION NO PERMITIDA"
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.REVE:
*-----------------------------------------------------------------------------

    Y.REG.REVE = ''
    READ Y.REG.REVE FROM F.ABC.PEND.GALILEO, AUTH.ID.ACLK THEN
        Y.EXISTE.REVE = 1
    END

RETURN
*-----------------------------------------------------------------------------
*-------------------------------------
LEE.REC.ACLK:
*-------------------------------------

    READ REC.ACLK FROM ACLK.FILE, ID.ACLK THEN

        TRANSACTION.TYPE = REC.ACLK<AC.LCK.LOCAL.REF, POS.UNIQUE.ID>
        Y.TIPO.BLOQUEO = REC.ACLK<AC.LCK.LOCAL.REF, POS.AUTH.CODE>
        ID.ACC = REC.ACLK<AC.LCK.ACCOUNT.NUMBER>
        J.DESC = REC.ACLK<AC.LCK.DESCRIPTION>
        LOC.AMT = REC.ACLK<AC.LCK.LOCKED.AMOUNT>

*LFCR260521-S  CAMPOS DE COMPRAS INTERNACIONALES
        ACLK.ORIG.AMOUNT = REC.ACLK<AC.LCK.LOCAL.REF, POS.ORIG.MONTO.AC>
        ACLK.ORIG.CURRENCY = REC.ACLK<AC.LCK.LOCAL.REF, POS.ORIG.CURRN.AC>
        ACLK.TIPO.CAMBIO = LOC.AMT / ACLK.ORIG.AMOUNT       ;*SE VUELVE A CALCULAR TIPO DE CAMBIO DE BLOQUEO
        ACLK.MCC = REC.ACLK<AC.LCK.LOCAL.REF, POS.MCC>
*LFCR260521-E

        ACLK.COMISION = REC.ACLK<AC.LCK.LOCAL.REF, POS.ACLK.COMIS>    ;*LFCR23052022 S-E
*SFE-20250523
        ACLK.DATE=REC.ACLK<AC.LCK.FROM.DATE>
        J.DESC=EREPLACE (J.DESC,CHAR(34),"")
        J.DESC.DET= J.DESC:"*FECHA OPERACION*":ACLK.DATE
        J.DESC=J.DESC[1,35]

*SFE-20250523
    END
RETURN

END


