* @ValidationCode : Mjo4OTAxMjczNDpDcDEyNTI6MTc1MjExMzE4MzM1MzptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jul 2025 23:06:23
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
*-----------------------------------------------------------------------------
* <Rating>2224</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.E.MOV.FT(Y.ARR)
*-----------------------------------------------------------------------------
* Nombre de Programa : ABC.E.MOV.FT
* Objetivo           : Rutina nofile para consulta de detalles de movimientos FT
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2021-05-31
*ENQUIRY             : ABC.E.MOV.FT
*STANDARD.SELECTION  : NOFILE.ABC.E.MOV.FT
*RUTINA              : ABC.E.MOV.FT
*-----------------------------------------------------------------------------
*===============================================================================
* Modificaciones:
*-----------------------------------------------------------------------------
* Modificado por : Luis Cruz - FyG Solutions
* Fecha          : 2021-10-11
* Descripcion    : Se agrega el campo EXT.TRANS.ID como criterio de seleccion
*                  adicional, para buscar por ID de FT o EXT.TRANS.ID
*-----------------------------------------------------------------------
* Modificado por : CAST - FyG Solutions CAST20220908
* Fecha          : 2022-09-08
* Descripcion    : Se agrega funcionalidad para consultar en el archivo $DEL cuando se hace la consulta por FT
*
*-----------------------------------------------------------------------
* Modificado por : Luis Cruz - FyG Solutions LFCR20221228
* Fecha          : 2022-12-28
* Descripcion    : Se sustituyen SELECTs a FT con EXT.TRANS.ID por READs a tabla concat nueva
*                  ABC.L.FT.TXN.DETAIL para obtener ID de FT
*-----------------------------------------------------------------------
*===============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_TSA.COMMON
*    $INSERT ../T24_BP I_ENQUIRY.COMMON
*    $INCLUDE ../T24_BP I_F.HOLIDAY
*    $INSERT ../T24_BP I_F.ACCOUNT
*    $INSERT ../T24_BP I_F.STMT.ENTRY
*    $INSERT ../T24_BP I_F.TRANSACTION
*    $INSERT ../T24_BP I_F.POSTING.RESTRICT
*    $INSERT ../T24_BP I_F.DATA.CAPTURE
*    $INSERT ../T24_BP I_F.FUNDS.TRANSFER
*    $INSERT ../T24_BP I_F.FT.TXN.TYPE.CONDITION
*    $INSERT ABC.BP I_F.VPM.BANCOS
*    $INSERT ../T24_BP I_F.EB.SYSTEM.ID
*    $INCLUDE ABC.BP I_F.ABC.L.FT.TXN.DETAIL
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING ABC.BP
    $USING AC.ModelBank
    $USING FT.Config
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING AC.Config
    $USING AC.EntryCreation
    $USING ST.Config
    $USING AbcTable
    $USING EB.SystemTables
    $USING EB.Template

    GOSUB OPEN.FILES
    GOSUB INITIALISE
    GOSUB PROCESA.ENCABEZADO

    IF CATEGORY GE 6601 AND CATEGORY LE 6609 THEN
    END ELSE
        GOSUB PROCESA.MOVIMIENTO
        GOSUB ARMA.ARREGLO
    END

RETURN


*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    D.FIELDS            = EB.Reports.getDFields()
    D.RANGE.AND.VALUE   = EB.Reports.getDRangeAndValue()

    LOCATE  "ID.FT" IN D.FIELDS<1> SETTING Y.POS.FT THEN
        ID.CUENTA.FT = TRIM(D.RANGE.AND.VALUE<Y.POS.FT>)
        CHANGE "'" TO "" IN ID.CUENTA.FT
    END
    LOCATE  "ACCOUNT.ID" IN D.FIELDS<1> SETTING Y.POS.ACC THEN
        ID.ACC = TRIM(D.RANGE.AND.VALUE<Y.POS.ACC>)
        CHANGE "'" TO "" IN ID.ACC
    END
    LOCATE  "EXT.TRANS.ID" IN D.FIELDS<1> SETTING Y.POS.EXT.ID THEN
        ID.EXT.TRANS = TRIM(D.RANGE.AND.VALUE<Y.POS.EXT.ID>)
        CHANGE "'" TO "" IN ID.EXT.TRANS
    END

* SE VALIDAN LOS PARAMETROS RECIBIDOS
    IF (ID.CUENTA.FT EQ '') AND (ID.EXT.TRANS EQ '') THEN
        EB.Reports.setEnqError("SE REQUIERE MOVIMIENTO O EXT TRANS ID")
        RETURN
    END ELSE
        IF (ID.CUENTA.FT NE '') AND (ID.EXT.TRANS NE '') THEN
            EB.Reports.setEnqError("INGRESAR MOVIMIENTO UNICAMENTE")
            RETURN
        END ELSE
            IF ID.EXT.TRANS NE '' THEN
                GOSUB OBTENER.ID.FT
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------
OBTENER.ID.FT:
*-----------------------------------------------------------------------------
*TODO CUANDO ESTE LA TABLA ABC.L.FT.TXN.DETAIL
    EXT.SEL.CMD = '' ; Y.NO.IDS = '' ; Y.LIST.IDS = ''
    REC.FT.DETS = "" ; ID.CUENTA.FT = ""
    Y.ERR = ""
    EB.DataAccess.FRead(FN.ABC.FT.DETAIL, ID.EXT.TRANS, REC.FT.DETS, FV.ABC.FT.DETAIL, Y.ERR)
    IF NOT(Y.ERR) THEN
        ID.CUENTA.FT = REC.FT.DETS<FT.TXN.DET.ID.FT>
    END ELSE
        EB.DataAccess.FReadHistory(FN.ABC.FT.DETAIL.HIS, ID.EXT.TRANS, REC.FT.DETS, FV.ABC.FT.DETAIL.HIS, Y.ERR)
        ID.CUENTA.FT = FIELD(REC.FT.DETS<FT.TXN.DET.ID.FT>,';',1)
    END

    IF REC.FT.DETS EQ '' THEN
*        EXT.SEL.CMD = "SELECT " : FN.FUNDS.TRANSFER.DEL : " WITH EXT.TRANS.ID EQ " : DQUOTE(ID.EXT.TRANS)
*        EB.DataAccess.Readlist(EXT.SEL.CMD, Y.LIST.IDS, "", Y.NO.IDS, Y.STATUS)

*        IF Y.NO.IDS EQ 1 THEN
*            ID.CUENTA.FT = Y.LIST.IDS<1>
*            FINDSTR ";" IN ID.CUENTA.FT SETTING POS.ID.HIS THEN
*                ID.CUENTA.FT = FIELD(ID.CUENTA.FT, ";", 1)
*            END
*        END
    END

    IF ID.CUENTA.FT EQ '' THEN
        EB.Reports.setEnqError("NO SE ENCONTRO EL EXT TRANS ID INGRESADO " : ID.EXT.TRANS)
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.HOLI        = 'F.HOLIDAY'                ;F.HOLI         = ''; EB.DataAccess.Opf(FN.HOLI,F.HOLI)
    FN.TRANSACCION = 'F.TRANSACTION'            ; F.TRANSACCION = ''; EB.DataAccess.Opf(FN.TRANSACCION,F.TRANSACCION)
    FN.STMT        = 'F.STMT.ENTRY'             ; F.STMT        = ''; EB.DataAccess.Opf(FN.STMT,F.STMT)
    FN.ACC         = 'F.ACCOUNT'              ; F.ACC         = ''; EB.DataAccess.Opf(FN.ACC,F.ACC)
    FN.POST.REST   = 'F.POSTING.RESTRICT'  ; F.POST.REST = ''; EB.DataAccess.Opf(FN.POST.REST,F.POST.REST)
    FN.DC          = 'F.DATA.CAPTURE'           ; F.DC          = ''; EB.DataAccess.Opf(FN.DC,F.DC)
    FN.FT          = 'F.FUNDS.TRANSFER'         ; F.FT          = ''; EB.DataAccess.Opf(FN.FT,F.FT)
    FN.FT.HIS      = 'F.FUNDS.TRANSFER$HIS'     ; F.FT.HIS      = ''; EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)
    FN.EB.SYSTEM.ID= 'F.EB.SYSTEM.ID'           ; F.EB.SYSTEM.ID= ''; EB.DataAccess.Opf(FN.EB.SYSTEM.ID,F.EB.SYSTEM.IDS)
    FN.FT.TXN.TYPE='F.FT.TXN.TYPE.CONDITION'; F.FT.TXN.TYPE= ''; EB.DataAccess.Opf(FN.FT.TXN.TYPE,F.FT.TXN.TYPE)
    YSEP.1 = '*'
    YSEP.2 = '|'

    EB.LocalReferences.GetLocRef("ACCOUNT","CLABE",Y.POS.CLABE)
    EB.LocalReferences.GetLocRef('ACCOUNT','GPO.CLUB.AHORRO',YGPO.CLUB.AHORRO)
    EB.LocalReferences.GetLocRef('ACCOUNT','EXENTO.IMPUESTO',YPOS.EXENTO.IMPUESTO)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','RASTREO',YPOS.RASTREO)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','CTA.EXT.TRANSF',YPOS.CTA.EXT.TRANSF)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','REFERENCIA',YPOS.REFERENCIA)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','EXT.TRANS.ID',YPOS.EXT.TRANS.ID)

*CAST20220908.I
*    FN.FUNDS.TRANSFER.DEL = 'F.FUNDS.TRANSFER$DEL'; F.FUNDS.TRANSFER.DEL = ''; EB.DataAccess.Opf(FN.FUNDS.TRANSFER.DEL,F.FUNDS.TRANSFER.DEL)
    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'; F.FUNDS.TRANSFER.NAU = ''; EB.DataAccess.Opf(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)

*CAST20220908.F

    FN.ABC.FT.DETAIL = "F.ABC.L.FT.TXN.DETAIL"
    FV.ABC.FT.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL, FV.ABC.FT.DETAIL)

    FN.ABC.FT.DETAIL.HIS = "F.ABC.L.FT.TXN.DETAIL$HIS"
    FV.ABC.FT.DETAIL.HIS = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL.HIS, FV.ABC.FT.DETAIL.HIS)

RETURN

*-----------------------------------------------------------------------------
PROCESA.ENCABEZADO:
*-----------------------------------------------------------------------------
*CAST20220908.I
    IF ID.CUENTA.FT EQ '' THEN
        RETURN
    END
*CAST20220908.F

    EB.DataAccess.FRead(FN.FT, ID.CUENTA.FT, REC.FT, F.FT, ERR.FT)
*CAST20220908.I
    IF REC.FT EQ '' THEN
        EB.DataAccess.FRead(FN.FUNDS.TRANSFER.NAU, ID.CUENTA.FT, REC.FT, F.FUNDS.TRANSFER.NAU, ERR.FT.DEL)
        IF REC.FT NE '' THEN  ;*Si la transaccion esta en $NAU
            DETALLE.MOVIMIENTOS = YSEP.1:YSEP.1:YSEP.1:YSEP.1:ID.CUENTA.FT:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:ID.CUENTA.FT:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:'FUNDS.TRANSFER':YSEP.1:YSEP.1:YSEP.1:'P'
            RETURN
        END ELSE

*            EXT.SEL.CMD = "SELECT " : FN.FUNDS.TRANSFER.DEL : " WITH @ID LIKE " :ID.CUENTA.FT:"..."
*            EB.DataAccess.Readlist(EXT.SEL.CMD, Y.LIST.IDS, "", Y.NO.IDS, Y.STATUS)
*            IF Y.LIST.IDS NE '' THEN    ;*Si la transaccion esta en $DEL
*                ID.CUENTA.FT = Y.LIST.IDS<1>
*                DETALLE.MOVIMIENTOS = YSEP.1:YSEP.1:YSEP.1:YSEP.1:ID.CUENTA.FT:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:ID.CUENTA.FT:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:'FUNDS.TRANSFER':YSEP.1:YSEP.1:YSEP.1:'D'
*                RETURN
*            END ELSE
*                ID.CUENTA.FT = ID.CUENTA.FT :';1'
*                EB.DataAccess.FRead(FN.FT.HIS, ID.CUENTA.FT, REC.FT, F.FT.HIS, ERR.FT.HIS)
*                IF REC.FT NE '' THEN
*                    Y.STATUS = ''
*                    Y.STATUS = REC.FT<FT.Contract.FundsTransfer.RecordStatus>
*                END
*            END
*CAST20220908.F
        END
    END



    IF REC.FT THEN
        DATE.FT = ''
        DATE.FT = REC.FT<FT.Contract.FundsTransfer.DebitValueDate>

        IF ID.ACC NE '' THEN
            EB.DataAccess.FRead(FN.ACC,ID.ACC,R.INFO.ACC,F.ACC,ERROR.ACC)
            IF ERROR.ACC EQ '' THEN

                CUSTOMER = R.INFO.ACC<AC.AccountOpening.Account.Customer>
                CURRENCY = R.INFO.ACC<AC.AccountOpening.Account.Currency>
                CLABE = R.INFO.ACC<AC.AccountOpening.Account.LocalRef>
                CLABE = CLABE<1,Y.POS.CLABE>
                LAST.UPDATE = R.INFO.ACC<AC.AccountOpening.Account.DateLastUpdate>
                ID.POST.REST = R.INFO.ACC<AC.AccountOpening.Account.PostingRestrict>
                CATEGORY = R.INFO.ACC<AC.AccountOpening.Account.Category>

                IF CUSTOMER NE '' THEN
                    EB.SystemTables.setComi(CUSTOMER)
                    ABC.BP.VpmVCustomerName()
                    CUSTOMER.NAME = EB.SystemTables.getComiEnri()
                END


                IF POSTING.RESTRICT NE '' THEN
                    EB.DataAccess.FRead(FN.POST.REST,ID.POST.REST,R.INFO.POST.REST,F.POST.REST,ERROR.POST.REST)
                    IF ERROR.POST.REST EQ '' THEN
                        POSTING.RESTRICT = R.INFO.POST.REST<AC.Config.PostingRestrict.PosDescription>
                    END
                END

            END
        END
    END
RETURN
*-----------------------------------------------------------------------------
PROCESA.MOVIMIENTO:
*-----------------------------------------------------------------------------

    IF R.INFO.ACC NE '' THEN

        Y.LISTA.STMTS = ''; TOTAL.STMT = ''; LINEA.STMT = '';
        EB.Reports.setDFields('ACCOUNT':FM:'BOOKING.DATE')
        EB.Reports.setDRangeAndValue(ID.ACC:FM:DATE.FT)
        EB.Reports.setOperandList('1':FM:'1')
        AC.ModelBank.EStmtEnqByConcat(Y.LISTA.STMTS)


        TOTAL.STMT = DCOUNT(Y.LISTA.STMTS, FM)
        IDEN.FT = FIELD(ID.CUENTA.FT, ';', 1)
        Y.STMT.FT = ''
        Y.STMT.SALDO = ''

        FOR ITER.STMT = 1 TO TOTAL.STMT
            STMT.IN.LISTA = ''
            TRANS.REF.STMT = ''
            STMT.IN.LISTA = FIELD(Y.LISTA.STMTS<ITER.STMT> ,'*',2)
            STMT.SALDO.AN = FIELD(Y.LISTA.STMTS<ITER.STMT> ,'*',3)
            EB.DataAccess.FRead(FN.STMT,STMT.IN.LISTA,R.INFO.STMT,F.STMT,ERROR.STMT1)
            TRANS.REF.STMT = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteTransReference>
            IF TRANS.REF.STMT EQ IDEN.FT THEN

                Y.STMT.FT = STMT.IN.LISTA
                Y.STMT.SALDO = STMT.SALDO.AN
                BREAK
            END

        NEXT ITER.STMT

        ID.STMT1 = Y.STMT.FT

        ID.STMT = ID.STMT1
        SALDO.ANTERIOR = Y.STMT.SALDO


        SALDO.CORTE = SALDO.ANTERIOR


        EB.DataAccess.FRead(FN.STMT,ID.STMT1,R.INFO.STMT,F.STMT,ERROR.STMT1)
        IF ERROR.STMT1 EQ '' THEN

            ID.SYSTEM = ''
            ID.SYSTEM = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteSystemId>
            Y.STATUS.STMT = ''
            Y.STATUS.STMT = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteRecordStatus>
            AMOUNT.LCY = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>
            Y.DATE.TIME.NARR = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteDateTime>

            IF Y.STATUS.STMT NE 'REVE' THEN
                IMPORTE.STMT = '0'; DEPOSITOS = '0'; DEPOSITOS.1 = '0'; RETIROS = '0';
                FECHA.MOVIMIENTO = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteValueDate>
                Y.VALUE.DATE = FECHA.MOVIMIENTO

                IF ID.SYSTEM EQ 'FT' THEN

                    Y.BOOKING.DATE = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteDateTime>
                    Y.BOOKING.DATE = "20":Y.BOOKING.DATE[1,6]
                    IMPORTE.STMT = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>
                    IF Y.STATUS NE 'REVE' THEN
                        SALDO.CORTE += IMPORTE.STMT
                        IF IMPORTE.STMT LT 0 THEN
                            RETIROS = IMPORTE.STMT
                            RETIROS.CUENTA += RETIROS
                        END ELSE
                            DEPOSITOS = IMPORTE.STMT
                            DEPOSITOS.CUENTA += DEPOSITOS
                        END
                    END


                END ELSE
                    Y.BOOKING.DATE = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteBookingDate>
                END

                FECHA.MOVIMIENTO = ''
                FECHA.MOVIMIENTO = R.INFO.STMT <AC.EntryCreation.StmtEntry.SteBookingDate>
                
                IMPORTE.STMT     = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>
                MONEDA.STMT      = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteCurrency>
                REFERENCIA.STMT  = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteOurReference>
                ID.TRANSACCION   = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteTransactionCode>
                ID.SYSTEM        = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteSystemId>
                TRANS.REFERENCIA = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteTransReference>
                TRANS.REFERENCE  = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteTransReference>

                DETALLE.FT = '';  ID.CUENTA.FT = '';
                REFERENCIA = ''
                IF ID.TRANSACCION MATCH '1':@VM:'2':@VM:'17':@VM:'35':@VM:'38':@VM:'51':@VM:'52':@VM:'89':@VM:'107':@VM:'108':@VM:'213':@VM:'245':@VM:'910':@VM:'913':@VM:'956':@VM:'982':@VM:'983':@VM:'985':@VM:'989':@VM:'991':@VM:'995':@VM:'996':@VM:'915' THEN
                    GOSUB PROCESA.TRANSACCION
                END
            END

            FEC.MOV = ''
            FEC.MOV = FECHA.MOVIMIENTO
            RETIROS = ''; DEPOSITOS = ''; ABONO = ''; DEPOSITOS.1= '';
            GOSUB PROCESA.DETALLE.ID

            IF Y.STATUS.STMT NE 'REVE' THEN
                SALDO.CORTE += IMPORTE.STMT
                IF IMPORTE.STMT LT 0 THEN
                    RETIROS = IMPORTE.STMT
                    RETIROS.CUENTA += RETIROS
                END ELSE
                    DEPOSITOS = IMPORTE.STMT
                    DEPOSITOS.CUENTA += DEPOSITOS
                END
                GOSUB LEE.TRANSACCION
*CAST20220908.I
*                       DETALLE.MOVIMIENTOS <-1>= ID.ACC:YSEP.1:CUSTOMER.NAME:YSEP.1:CURRENCY:YSEP.1:Y.BOOKING.DATE:YSEP.1:TRANS.REFERENCIA:YSEP.1:REFERENCIA:YSEP.1:RETIROS:YSEP.1:DEPOSITOS:YSEP.1:SALDO.CORTE:YSEP.1:SALDO.ANTERIOR:YSEP.1:ID.SYSTEM:YSEP.1:TRANS.REFERENCE:YSEP.1:ID.STMT:YSEP.1:CLABE:YSEP.1:POSTING.RESTRICT:YSEP.1:LAST.UPDATE:YSEP.1::YSEP.1:Y.VALUE.DATE:YSEP.1:Y.APP:YSEP.1:CUSTOMER:YSEP.1:Y.DATE.TIME.NARR      ;*ROHH_20180723 (:YSEP.1:Y.DATE.TIME
                DETALLE.MOVIMIENTOS <-1>= ID.ACC:YSEP.1:CUSTOMER.NAME:YSEP.1:CURRENCY:YSEP.1:Y.BOOKING.DATE:YSEP.1:TRANS.REFERENCIA:YSEP.1:REFERENCIA:YSEP.1:RETIROS:YSEP.1:DEPOSITOS:YSEP.1:SALDO.CORTE:YSEP.1:SALDO.ANTERIOR:YSEP.1:ID.SYSTEM:YSEP.1:TRANS.REFERENCE:YSEP.1:ID.STMT:YSEP.1:CLABE:YSEP.1:POSTING.RESTRICT:YSEP.1:LAST.UPDATE:YSEP.1::YSEP.1:Y.VALUE.DATE:YSEP.1:Y.APP:YSEP.1:CUSTOMER:YSEP.1:Y.DATE.TIME.NARR:YSEP.1:'A'
*CAST20220908.F
            END

            ID.INVERSION = ''; IMPORTE.STMT = '0'; DEPOSITOS = '0'; DEPOSITOS.1 = '0'; RETIROS = '0';
        END

        IF NOT(DETALLE.MOVIMIENTOS) THEN
*CAST20220908.I
*            DETALLE.MOVIMIENTOS <-1>= ID.ACC:YSEP.1:CUSTOMER.NAME:YSEP.1:CURRENCY:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:SALDO.CORTE:YSEP.1:SALDO.ANTERIOR:YSEP.1:ID.SYSTEM:YSEP.1:TRANS.REFERENCE:YSEP.1:ID.STMT:YSEP.1:CLABE:YSEP.1:POSTING.RESTRICT:YSEP.1:LAST.UPDATE:YSEP.1::YSEP.1:Y.VALUE.DATE:YSEP.1:Y.APP:YSEP.1:CUSTOMER:YSEP.1:Y.DATE.TIME.NARR ;*ROHH_20180723 (:YSEP.1:Y.DATE.TIME)
            DETALLE.MOVIMIENTOS <-1>= ID.ACC:YSEP.1:CUSTOMER.NAME:YSEP.1:CURRENCY:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:YSEP.1:SALDO.CORTE:YSEP.1:SALDO.ANTERIOR:YSEP.1:ID.SYSTEM:YSEP.1:TRANS.REFERENCE:YSEP.1:ID.STMT:YSEP.1:CLABE:YSEP.1:POSTING.RESTRICT:YSEP.1:LAST.UPDATE:YSEP.1::YSEP.1:Y.VALUE.DATE:YSEP.1:Y.APP:YSEP.1:CUSTOMER:YSEP.1:Y.DATE.TIME.NARR:YSEP.1:'A'
*CAST20220908.F
        END
    END

RETURN

*-----------------------------------------------------------------------------
PROCESA.TRANSACCION:
*-----------------------------------------------------------------------------

    ERROR.TRANSACCION = ''; R.INFO.TRANSACCION = ''; YNARR.FORMAT = ''; YNARRATIVA.STMT = '';
    EB.DataAccess.FRead(FN.TRANSACCION,ID.TRANSACCION,R.INFO.TRANSACCION,F.TRANSACCION,ERROR.TRANSACCION)
    IF R.INFO.TRANSACCION NE '' THEN
        YNARR.FORMAT = R.INFO.TRANSACCION<ST.Config.Transaction.AcTraNarrative,1>
    END
    REFERENCIA = ''
    IF ID.SYSTEM EQ 'FT' THEN
        ID.CUENTA.FT = REFERENCIA.STMT:';1'
        REC.FT = ''; ERR.FT = ''; RECP.EMIS.PAGO = ''; FECHA.OPERACION = ''; MONTO.PAGO.FT = ''; CTA.BENEF.ORDEN = ''; NOMBRE.BENEF.ORDEN = ''
        CLAVE.RASTREO = '';  NUM.REFERENCIA = ''; CONCEPTO.PAGO = ''; REC.CUENTA = '';
        EB.DataAccess.FRead(FN.FT.HIS,ID.CUENTA.FT,REC.FT,F.FT.HIS,ERR.FT)
        IF REC.FT EQ '' THEN
            ID.CUENTA.FT = '';
            ID.CUENTA.FT = REFERENCIA.STMT
            EB.DataAccess.FRead(FN.FT,ID.CUENTA.FT,REC.FT,F.FT,ERR.FT)
        END

        DETAIL.PAY = ''
        DETAIL.PAY = REC.FT<FT.Contract.FundsTransfer.InPaymentDetails,1>
        CHANGE @SM TO '' IN DETAIL.PAY
        DETAIL.PAY = TRIM(DETAIL.PAY)

        BEGIN CASE
            CASE ID.TRANSACCION EQ '913'    ;* COMPRA POS
                REFERENCIA = YNARR.FORMAT:' ':DETAIL.PAY
            CASE ID.TRANSACCION EQ '910'
                REFERENCIA = YNARR.FORMAT:' ':DETAIL.PAY
            CASE ID.TRANSACCION EQ '213'
                DETAIL.PAY = ''
                IF DETAIL.PAY EQ '' THEN
                    IF REC.FT<FT.Contract.FundsTransfer.DebitAcctNo> NE ID.ACC THEN
                        ACC.AUX = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
                    END ELSE
                        ACC.AUX = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
                    END
                    GOSUB OBTIENE.DESCRIPCION
                END
                REFERENCIA = DETAIL.PAY

            CASE ID.TRANSACCION EQ '985'
                ID.CUENTA.AC = ''
                ID.CUENTA.AC = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
                RECP.EMIS.PAGO = TRIM(R.INFO.ACC<AC.AccountOpening.Account.AccountTitleOne>)
                CTA.BENEF.ORDEN = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.CTA.EXT.TRANSF>
                CLAVE.RASTREO = REFERENCIA.STMT[3,17]
                CONCEPTO.PAGO= REC.FT<FT.Contract.FundsTransfer.ExtendInfo>
                NUM.REFERENCIA=REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
                YBANK.ID = ''; R.BANCOS = ''; NOMBRE.BANCO = '';
                YBANK.ID = '40':CTA.BENEF.ORDEN[1,3]
                R.BANCOS = EB.Template.Lookup.Read(YBANK.ID, YF.ERROR)
                IF R.BANCOS EQ '' THEN
                    YBANK.ID = '40':REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>
                    R.BANCOS = EB.Template.Lookup.Read(YBANK.ID, YF.ERROR)
                END
                IF R.BANCOS THEN
                    NOMBRE.BANCO = R.BANCOS<EB.Template.Lookup.LuDescription>
                END
                REFERENCIA = 'TRANSFERENCIA SPEI ENVIADO'
                REFERENCIA := ' ':NOMBRE.BANCO
                REFERENCIA := ' RASTREO: ':CLAVE.RASTREO
                REFERENCIA := ' CONCEPTO: ':CONCEPTO.PAGO
                REFERENCIA := ' REFERENCIA: ':NUM.REFERENCIA
            CASE ID.TRANSACCION EQ '989'
                RECP.EMIS.PAGO = REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>
                CLAVE.RASTREO = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.RASTREO>
                CONCEPTO.PAGO= REC.FT<FT.Contract.FundsTransfer.ExtendInfo>
                NUM.REFERENCIA=REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
                YBANK.ID = ''; R.BANCOS = ''; NOMBRE.BANCO = '';
                YBANK.ID = REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>
                R.BANCOS = EB.Template.Lookup.Read(YBANK.ID, YF.ERROR)
                IF R.BANCOS THEN
                    NOMBRE.BANCO = R.BANCOS<EB.Template.Lookup.LuDescription>
                END
                REFERENCIA = 'TRANSFERENCIA SPEI RECIBIDO'
                REFERENCIA := ' ':NOMBRE.BANCO
                REFERENCIA := ' RASTREO: ':CLAVE.RASTREO
                REFERENCIA := ' CONCEPTO: ':CONCEPTO.PAGO
                REFERENCIA := ' REFERENCIA: ':NUM.REFERENCIA
            CASE ID.TRANSACCION EQ '991'
                FT.ANT.ID = REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>
                ID.CUENTA.FT = FT.ANT.ID:';1'
                REC.FT = ''; ERR.FT = ''; RECP.EMIS.PAGO = ''; FECHA.OPERACION = ''; MONTO.PAGO.FT = ''; CTA.BENEF.ORDEN = ''; NOMBRE.BENEF.ORDEN = ''
                CLAVE.RASTREO = '';  NUM.REFERENCIA = ''; CONCEPTO.PAGO = ''; REC.CUENTA = '';
                EB.DataAccess.FRead(FN.FT.HIS,ID.CUENTA.FT,REC.FT,F.FT.HIS,ERR.FT)
                IF REC.FT EQ '' THEN
                    ID.CUENTA.FT = '';
                    ID.CUENTA.FT = REFERENCIA.STMT
                    EB.DataAccess.FRead(FN.FT,ID.CUENTA.FT,REC.FT,F.FT,ERR.FT)
                END
                RECP.EMIS.PAGO = TRIM(R.INFO.ACC<AC.AccountOpening.Account.AccountTitleOne>)
                CTA.BENEF.ORDEN = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.CTA.EXT.TRANSF>
                CLAVE.RASTREO = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.RASTREO>
                YBANK.ID = ''; R.BANCOS = ''; NOMBRE.BANCO = '';
                YBANK.ID = '40':CTA.BENEF.ORDEN[1,3]
                R.BANCOS = EB.Template.Lookup.Read(YBANK.ID, YF.ERROR)
                IF R.BANCOS THEN
                    NOMBRE.BANCO = R.BANCOS<EB.Template.Lookup.LuDescription>
                END
                REFERENCIA = 'TRANSFERENCIA SPEI DEVUELTO'
                REFERENCIA := ' ':NOMBRE.BANCO
                REFERENCIA := ' RASTREO: ':CLAVE.RASTREO

            CASE ID.TRANSACCION EQ '245'
                DETAIL.PAY = ''
                GOSUB OBTIENE.DESCRIPCION
                REFERENCIA = DETAIL.PAY

            CASE ID.TRANSACCION EQ '982'
                DETAIL.PAY = ''
                GOSUB OBTIENE.DESCRIPCION
                REFERENCIA = DETAIL.PAY

            CASE ID.TRANSACCION EQ '983'
                DETAIL.PAY = ''
                GOSUB OBTIENE.DESCRIPCION
                REFERENCIA = DETAIL.PAY

            CASE ID.TRANSACCION EQ '995'
                DETAIL.PAY = ''
                GOSUB OBTIENE.DESCRIPCION
                REFERENCIA = DETAIL.PAY

            CASE ID.TRANSACCION EQ '996'
                DETAIL.PAY = ''
                GOSUB OBTIENE.DESCRIPCION
                REFERENCIA = DETAIL.PAY

            CASE ID.TRANSACCION EQ '915'
                DETAIL.PAY = ''
                GOSUB OBTIENE.DESCRIPCION
                REFERENCIA = DETAIL.PAY
        END CASE

        REC.FT.HIS = ''; ERR.FT.HIS = ''; ID.CUENTA.FT.HIS = '';
        ID.CUENTA.FT.HIS = REFERENCIA.STMT:";1"
        EB.DataAccess.FRead(FN.FT.HIS,ID.CUENTA.FT.HIS,REC.FT.HIS,F.FT.HIS,ERR.FT.HIS)
        IF REC.FT.HIS NE '' THEN
            Y.STATUS = ''
            Y.STATUS = REC.FT.HIS<FT.Contract.FundsTransfer.RecordStatus>
        END

    END

    REFERENCIA = EREPLACE(REFERENCIA,'*',' ')

RETURN

*-----------------------------------------------------------------------------
OBTIENE.DESCRIPCION:
*-----------------------------------------------------------------------------

    Y.TIPO.TRANSACCION= REC.FT<FT.Contract.FundsTransfer.TransactionType>
    Y.REFERENCIA = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
    Y.REF.FT=''
    IF Y.REFERENCIA NE '' THEN
        Y.REF.FT=' REFERENCIA: ':Y.REFERENCIA
    END ELSE
        Y.REF.FT=''
    END
    REG.TRANSACCION=''
    Y.DESC=''
    Y.ERR.TXN.TYPE = ''
    EB.DataAccess.FRead(FN.FT.TXN.TYPE, Y.TIPO.TRANSACCION, REG.TRANSACCION, F.FT.TXN.TYPE, Y.ERR.TXN.TYPE)
    IF Y.ERR.TXN.TYPE EQ '' THEN
        Y.DESC =REG.TRANSACCION<FT.Config.TxnTypeCondition.FtSixDescription>
    END

    IF Y.TIPO.TRANSACCION EQ 'AC' THEN
        DETAIL.PAY = Y.DESC:' '::ACC.AUX:' ':REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>:Y.REF.FT
    END ELSE
        IF Y.TIPO.TRANSACCION EQ 'ACTC' THEN
            DETAIL.PAY = Y.DESC:' ':REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>[10,6]:Y.REF.FT
        END ELSE
            DETAIL.PAY = Y.DESC:' ':REC.FT<FT.Contract.FundsTransfer.ExtendInfo>:Y.REF.FT
        END
    END

RETURN
*-----------------------------------------------------------------------------
LEE.TRANSACCION:
*-----------------------------------------------------------------------------

    ERROR.TRANSACCION = ''; R.INFO.TRANSACCION = ''; YNARR.FORMAT = ''; YNARRATIVA.STMT = '';
    EB.DataAccess.FRead(FN.TRANSACCION,ID.TRANSACCION,R.INFO.TRANSACCION,F.TRANSACCION,ERROR.TRANSACCION)
    IF R.INFO.TRANSACCION NE '' THEN
        YNARR.FORMAT = R.INFO.TRANSACCION<ST.Config.Transaction.AcTraNarrative,1>
        IF ID.TRANSACCION EQ '468' THEN
            YNARR.FORMAT = ''
            YNARR.FORMAT = R.INFO.TRANSACCION<ST.Config.Transaction.AcTraNarrative,1>:' ':ID.ACC
            REFERENCIA = ''
            REFERENCIA = YNARR.FORMAT
        END
        IF ID.TRANSACCION EQ '381' THEN
            YNARR.FORMAT = ''
            YNARR.FORMAT = R.INFO.TRANSACCION<ST.Config.Transaction.AcTraNarrative,1>:' ':ID.ACC
            REFERENCIA = ''
            REFERENCIA = YNARR.FORMAT
        END
        IF ID.SYSTEM EQ 'AC' THEN
            REFERENCIA = ''
            REFERENCIA = YNARR.FORMAT
        END
    END
RETURN
*-----------------------------------------------------------------------------
PROCESA.DETALLE.ID:
*-----------------------------------------------------------------------------

    EB.DataAccess.FRead(FN.EB.SYSTEM.ID,ID.SYSTEM,R.INFO.EB.SYSTEM.ID,F.EB.SYSTEM.ID,ERROR.EB.SYSTEM.ID)
    IF R.INFO.EB.SYSTEM.ID NE '' THEN
        Y.APP = R.INFO.EB.SYSTEM.ID<EB.SystemTables.SystemId.SidApplication>
        IF NOT(Y.APP) THEN
            Y.APP = "STMT.ENTRY"
            TRANS.REFERENCE = ID.STMT
        END
        IF ID.SYSTEM EQ 'CQ' THEN
            Y.APP = 'TELLER'
        END
    END

RETURN
*-----------------------------------------------------------------------------
ARMA.ARREGLO:
*-----------------------------------------------------------------------------

    INFORMACION.MOVIMIENTOS = ''
    INFORMACION.MOVIMIENTOS = DETALLE.MOVIMIENTOS
    Y.ARR = DETALLE.MOVIMIENTOS

RETURN
