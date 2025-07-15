* @ValidationCode : MjoxNjQyMjcwOTE5OkNwMTI1MjoxNzUyNTQ5MDczOTU4Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jul 2025 00:11:13
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
* rights reserved.
*======================================================================================
*-----------------------------------------------------------------------------
* <Rating>-25</Rating>
*-----------------------------------------------------------------------------
* Nombre de Programa : SUBROUTINE ABC.EXT.DESC.SPEI
* Objetivo           : Rutina para agregar narrativa de FT en enquery "ENQ STMT.ENT.BOOK.MOVS"
* Desarrollador      :
* Fecha Creacion     : 2017-07-14
* Fecha Modificacion : ROHH_20180723
* Desarrollador      : Rodrigo Oscar Hern�ndez Hern�ndez - F&GSolutions
* Modificaciones     : Agregar narrativa de traspasos de tipo "AC" Traspasos entre cuentas
* Fecha Modificacion : ROHH_20180823
* Desarrollador      : Rodrigo Oscar Hern�ndez Hern�ndez - F&GSolutions
* Modificacion1     : Modificar narrativa de transferencia tipo "ACSE" (SPEI ENVIADO) para mostrar BANCO destino
* Modificacion2     : Modificar narrativa de transferencia tipo "ACSR" (SPEI RECIBIDO) para mostrar correctamente BANCO origen
*======================================================================================
$PACKAGE AbcSpei
SUBROUTINE ABC.EXT.DESC.SPEI

    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING AC.AccountOpening
    $USING EB.Template
    $USING EB.SystemTables
    $USING ABC.BP


***************************************************************ROHH_20180723*INICIO
    Y.CUENTA.CLIENTE ='' ;
    ID.PRD = ''
    Y.CUENTA.CLIENTE = FIELD(O.DATA,'*',1)
    ID.CUENTA.FT =  TRIM(FIELD(O.DATA,'*',5):';1')
    ID.PRD = TRIM(ID.CUENTA.FT[1,2])

***************************************************************ROHH_20180723*INICIO

    IF ID.PRD NE 'FT' THEN
        O.DATA=''
        RETURN
    END
    GOSUB INICIO
    GOSUB PROCESA

RETURN
*******
INICIO:
*******
    YSEP = "|";
    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS';    F.FT.HIS      = '';   EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)
    FN.FT     = 'F.FUNDS.TRANSFER'    ;    F.FT          = '';   EB.DataAccess.Opf(FN.FT,F.FT)
    FN.CUENTA = 'F.ACCOUNT'           ;    F.CUENTA      = '';   EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)
    FN.ACCOUNT = 'F.ACCOUNT'          ;    F.ACCOUNT     = '';   EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    FN.DESTINO = 'F.ABC.CUENTAS.DESTINO';  F.DESTINO     = '';  EB.DataAccess.Opf(FN.DESTINO,F.DESTINO)


    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','RASTREO',YPOS.RASTREO)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','CTA.EXT.TRANSF',YPOS.CTA.EXT.TRANSF)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','REFERENCIA',YPOS.REFERENCIA)

RETURN
********
PROCESA:
********

    REC.FT = ''; ERR.FT = ''; RECP.EMIS.PAGO = ''; FECHA.OPERACION = ''; MONTO.PAGO.FT = ''; CTA.BENEF.ORDEN = ''; NOMBRE.BENEF.ORDEN = ''
    CLAVE.RASTREO = ''; CONCEPTO.PAGO = ''; REC.CUENTA = ''; ID.TRANSACCION = ''; REFERENCIA = '';DETALLE.FT= ''        ;*ROHH_20180823
    EB.DataAccess.FRead(FN.FT.HIS,ID.CUENTA.FT,REC.FT,F.FT.HIS,ERR.FT)
    IF REC.FT EQ '' THEN
        ID.CUENTA.FT = ''
        ID.CUENTA.FT = FIELD(O.DATA,'*',5)
        EB.DataAccess.FRead(FN.FT,ID.CUENTA.FT,REC.FT,F.FT,ERR.FT)
    END

    ID.TRANSACCION = REC.FT<FT.Contract.FundsTransfer.TransactionType>
    IF ID.TRANSACCION EQ 'ACSE' THEN    ;*(985)CARGO TRANSF.SPEI ENVIADA
        ID.CUENTA.AC = ''
        ID.CUENTA.AC = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
        EB.DataAccess.FRead(FN.CUENTA,ID.CUENTA.AC,REC.CUENTA,F.CUENTA,ERR.CUENTA)
        RECP.EMIS.PAGO = TRIM(REC.CUENTA<AC.AccountOpening.Account.AccountTitleOne>)
        CTA.BENEF.ORDEN = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.CTA.EXT.TRANSF>
        REFERENCIA=REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
        NOMBRE.BENEF.ORDEN = REC.FT<FT.Contract.FundsTransfer.PaymentDetails>
        ID.CUENTA.FT = FIELD(ID.CUENTA.FT,';',1)
        CLAVE.RASTREO = ID.CUENTA.FT[3,17]
        CONCEPTO.PAGO = REC.FT<FT.Contract.FundsTransfer.ExtendInfo>


******************************************************************************************ROHH_20180823
        Y.ID.CLIENTE = '';Y.ID.ABC.CUENTAS.DESTINO = '';Y.NOMBRE.BANCO=''
        Y.ID.CLIENTE = REC.CUENTA<AC.AccountOpening.Account.Customer>
        Y.ID.ABC.CUENTAS.DESTINO = Y.ID.CLIENTE:".":CTA.BENEF.ORDEN

*ITSS-SINDHU-START
*        CALL DBR("ABC.CUENTAS.DESTINO":FM:2,Y.ID.ABC.CUENTAS.DESTINO,Y.BANK.ID)
*        CALL DBR("VPM.BANCOS":FM:1,Y.BANK.ID,Y.NOMBRE.BANCO)
        EB.DataAccess.FRead(FN.DESTINO, Y.ID.ABC.CUENTAS.DESTINO,REC.DESTINO,F.DESTINO, Y.DESTINO.ERR)
        Y.BANK.ID = REC.DESTINO<2>
        EB.DataAccess.FRead(FN.BANCOS, Y.BANK.ID, REC.BANCOS, F.BANCOS, Y.BANCO.ERR)
        Y.NOMBRE.BANCO = REC.BANCOS<1>
*ITSS-SINDHU-END
******************************************************************************************ROHH_20180823

        DETALLE.FT  = 'TRASFERENCIA SPEI ENVIADO ':YSEP
        DETALLE.FT := 'CUENTA DESTINO: ':CTA.BENEF.ORDEN:YSEP
        DETALLE.FT := ' BANCO: ':Y.NOMBRE.BANCO:YSEP
        DETALLE.FT := ' BENEFICIARIO: ':NOMBRE.BENEF.ORDEN:YSEP
        DETALLE.FT := ' CLAVE DE RASTREO: ':CLAVE.RASTREO:YSEP
        DETALLE.FT := ' REFERENCIA: ':REFERENCIA:YSEP
        DETALLE.FT := ' CONCEPTO: ':CONCEPTO.PAGO:YSEP


    END
    IF ID.TRANSACCION EQ 'ACSR' THEN    ;*(989) ABONO TRANSF.SPEI RECIBIDA
        RECP.EMIS.PAGO = REC.FT<FT.Contract.FundsTransfer.LocalRef><1,YPOS.CTA.EXT.TRANSF>
        Y.ORDENANTE = REC.FT<FT.Contract.FundsTransfer.OrderingCust>
        CLAVE.RASTREO = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.RASTREO>
        REFERENCIA=REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
        CONCEPTO.PAGO = REC.FT<FT.Contract.FundsTransfer.PaymentDetails>
        YBANK.ID = ''; R.BANCOS = ''; NOMBRE.BANCO = '';


        YBANK.ID = REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>    ;****************** ****ROHH_20180823
*ITSS-SINDHU-START
*        CALL DBR("VPM.BANCOS":FM:1,YBANK.ID,NOMBRE.BANCO)   ;****************** ****ROHH_20180823
        R.BANCOS = EB.Template.Lookup.Read(YBANK.ID, YF.ERROR)
        NOMBRE.BANCO = R.BANCOS<EB.Template.Lookup.LuDescription>
*ITSS-SINDHU-END

        DETALLE.FT := 'TRASFERENCIA SPEI RECIBIDO ':YSEP
        DETALLE.FT := 'CUENTA ORIGEN: ':RECP.EMIS.PAGO:YSEP
        DETALLE.FT := ' BANCO: ':NOMBRE.BANCO:YSEP
        DETALLE.FT := ' ORDENANTE: ':Y.ORDENANTE:YSEP
        DETALLE.FT := ' CLAVE DE RASTREO: ':CLAVE.RASTREO:YSEP
        DETALLE.FT := ' REFERENCIA: ':REFERENCIA:YSEP
        DETALLE.FT := ' CONCEPTO: ':CONCEPTO.PAGO:YSEP
    END



***************************************************************ROHH_20180723*INICIO
    IF ID.TRANSACCION EQ 'AC' THEN      ;*TRASPASO ENTRE CUENTAS *** CONSULTA INFORMACION DE FT

        Y.ID.CUENTA.AC = ''
        Y.ID.CUENTA.AC = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
        Y.ID.CUENTA.AD = ''
        Y.ID.CUENTA.AD = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
        Y.BANCO = REC.FT<FT.Contract.FundsTransfer.OrderingCust>

        IF (TRIM(Y.CUENTA.CLIENTE) EQ TRIM(Y.ID.CUENTA.AC)) THEN      ;* OBTIENE NOMBRE DEL ORDENANTE,CUENTA E IMPRIME
            Y.CUENTA.OB = ''
            Y.CUENTA.OD = ''
            Y.BENEFICIARIO = ''
            Y.NOMBRE.CUENTA.AD = ''
*ITSS-SINDHU-START
*            CALL DBR('ACCOUNT':FM:AC.AccountOpening.Account.Customer,Y.ID.CUENTA.AD,Y.RESUL.CUS)
            EB.DataAccess.FRead(FN.ACCOUNT, Y.ID.CUENTA.AD, REC.CUENTA, F.ACCOUNT, Y.ACCT.ERR)
            Y.RESUL.CUS = REC.CUENTA<AC.AccountOpening.Account.Customer>
*ITSS-SINDHU-END
            EB.SystemTables.setComi(CUSTOMERY.RESUL.CUS:'*1')
            ABC.BP.VpmVCustomerName()
            Y.NOMBRE.CUENTA.AD = EB.SystemTables.getComiEnri()
            Y.CUENTA.OB = ' ORDENANTE: ':Y.NOMBRE.CUENTA.AD:YSEP
            Y.CUENTA.OD = ' CUENTA ORIGEN: ':Y.ID.CUENTA.AD:YSEP

        END ELSE
            IF (TRIM(Y.CUENTA.CLIENTE) EQ TRIM(Y.ID.CUENTA.AD)) THEN  ;*OBTIENE EL NOMBRE DEL BENEFICIARIO, CUENTA E IMPRIME

                Y.BENEFICIARIO = ''
                Y.CUENTA.OB = ''
                Y.CUENTA.OD = ''
                Y.NOMBRE.CUENTA.AC =''
*ITSS-SINDHU-START
*                CALL DBR('ACCOUNT':FM:AC.AccountOpening.Account.Customer,Y.ID.CUENTA.AC,Y.RESUL.CUS)
                EB.DataAccess.FRead(FN.ACCOUNT, Y.ID.CUENTA.AC, REC.CUENTA, F.ACCOUNT, Y.ACCT.ERR)
                Y.RESUL.CUS = REC.CUENTA<AC.AccountOpening.Account.Customer>
*ITSS-SINDHU-END
                EB.SystemTables.setComi(CUSTOMERY.RESUL.CUS:'*1')
                ABC.BP.VpmVCustomerName()
                Y.NOMBRE.CUENTA.AC = EB.SystemTables.getComiEnri()
                Y.CUENTA.OB = ' BENEFICIARIO: ':Y.NOMBRE.CUENTA.AC:YSEP
                Y.CUENTA.OD = ' CUENTA DESTINO: ':Y.ID.CUENTA.AC:YSEP

            END
        END

        Y.REFERENCIA = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
        Y.CONCEPTO.PAGO = REC.FT<FT.Contract.FundsTransfer.ExtendInfo>


        DETALLE.FT  = ' TRASPASO ENTRE CUENTAS ':YSEP
        DETALLE.FT := Y.CUENTA.OD
        DETALLE.FT := ' BANCO: ':Y.BANCO:YSEP
        DETALLE.FT := Y.CUENTA.OB
        DETALLE.FT := ' CLAVE DE RASTREO: ':'':YSEP
        DETALLE.FT := ' REFERENCIA: ':Y.REFERENCIA:YSEP
        DETALLE.FT := ' CONCEPTO: ':Y.CONCEPTO.PAGO:YSEP

    END
***************************************************************ROHH_20180723*FIN
    O.DATA = DETALLE.FT
RETURN
************
END
