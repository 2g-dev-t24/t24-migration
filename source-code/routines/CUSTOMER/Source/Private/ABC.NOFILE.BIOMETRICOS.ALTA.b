* @ValidationCode : MjotOTczMzYzMzY6Q3AxMjUyOjE3NDI5NTY1Njc5ODM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Mar 2025 23:36:07
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
SUBROUTINE ABC.NOFILE.BIOMETRICOS.ALTA(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
*    $USING ABC.BP
	$USING AbcTable
    
    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
    
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ABC.BIOMETRICOS = 'F.ABC.BIOMETRICOS'
    F.ABC.BIOMETRICOS = ''
    EB.DataAccess.Opf(FN.ABC.BIOMETRICOS, F.ABC.BIOMETRICOS)
    
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
    FN.USER      = 'F.USER'
    F.USER   = ''
    EB.DataAccess.Opf(FN.USER, F.USER)
    
    FN.ABC.ESTADO = 'F.ABC.ESTADO'
    F.ABC.ESTADO = ''
    EB.DataAccess.Opf(FN.ABC.ESTADO, F.ABC.ESTADO)
    
    FN.LOOKUP    = 'F.EB.LOOKUP'
    F.LOOKUP    = ''
    EB.DataAccess.Opf(FN.LOOKUP,F.LOOKUP)

*CAMPOS LOCALES IUB Y ROL DE USER

    V.APP      = 'USER'
    V.FLD.NAME = 'IUB' : @VM : 'L.ROL'
    V.FLD.POS  = ''

    EB.Updates.MultiGetLocRef(V.APP, V.FLD.NAME, V.FLD.POS)
    
    Y.POS.IUB = V.FLD.POS<1,1>
    Y.POS.ROL = V.FLD.POS<1,2>
    
    
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    ID.IUB.CUS = '' ; IUB.POS = ''
    LOCATE "IUB" IN SEL.FIELDS SETTING IUB.POS THEN
        ID.IUB.CUS = SEL.VALUES<IUB.POS>
    END

    R.DATA = ''
    Y.SEP = '*'


RETURN

*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------
    Y.OPERADOR = EB.SystemTables.getRUser()

    IF ID.IUB.CUS NE '' THEN
*EXTRACCION DE DATOS DEL REGISTRO EN ABC.BIOMETRICOS
        Y.OPERADOR = EB.SystemTables.getOperator()

        EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
        IF ERR.USER EQ '' THEN
*OBTENEMOS EL IUB Y EL ROL DEL USER QUE ESTA INGRESANDO
            IUB.USER = R.USER<EB.Security.User.UseLocalRef, Y.POS.IUB>
            ROL.USER = R.USER<EB.Security.User.UseLocalRef, Y.POS.ROL>

*VALIDAMOS QUE EL USER ESTE ENROLADO, ESTO ES QUE TENGA REGISTRO EN ABC.BIOMETRICOS
            EB.DataAccess.FRead(FN.ABC.BIOMETRICOS, IUB.USER, R.BIOM.USER, F.ABC.BIOMETRICOS, ERR.BIO.USER)
            IF R.BIOM.USER THEN
*VALIDAMOS QUE TENGA PRIVILEGIOS PARA ENROLAR CLIENTES
                IF ROL.USER MATCHES "enroladorClientes" THEN
                    GOSUB LEE.BIOMETRICO
                    GOSUB ARMA.ARREGLO
                END ELSE
                    ENQ.ERROR = "USUARIO SIN PRIVILEGIOS DE ENROLADOR"
                    EB.Reports.setEnqError(ENQ.ERROR)
                END
            END ELSE
                ENQ.ERROR = "USUARIO NO ENROLADO"
                EB.Reports.setEnqError(ENQ.ERROR)
            END
        END

    END

RETURN

*---------------------------------------------------------------
LEE.BIOMETRICO:
*---------------------------------------------------------------
*SI EL USUARIO ESTA ENROLADO Y TIENE ROL "Enrolador de Clientes" SE LEE EL REGISTRO DEL IUB QUE INGRESO
    R.BIOM.CUST = '' ; ERR.BIOM.CUST = ''
    R.APE.PAT = '' ; R.APE.MAT = '' ; R.NOMBRES = '' ; R.CURP = '' ; R.FEC.NAC = '' ; R.EST.NAC = '' ; R.SEXO = ''
    R.TIP.IDE = '' ; R.NUM.ID = '' ; R.FEC.EMI = '' ; R.FEC.VEN = '' ; R.CELULAR = '' ; R.EMAIL = '' ; R.VERIFICADO = ''
    EB.DataAccess.FRead(FN.ABC.BIOMETRICOS, ID.IUB.CUS, R.BIOM.CUST, F.ABC.BIOMETRICOS, ERR.BIOM.CUST)

    IF R.BIOM.CUST THEN
        R.APE.PAT = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomApp>
        R.APE.MAT = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomApm>
        R.NOMBRES = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomNombre>
        R.CURP    = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomCurp>
        
        GOSUB OBTEN.NACI
        
        R.FEC.NAC = FECHA.NAC
        R.EST.NAC = ESTADO.NAC
        R.SEXO    = SEXO
        R.TIP.IDE = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomIdIdentificacion>

        GOSUB OBTEN.TIPO.IDEN

        R.NUM.ID     = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomOcr>
        R.FEC.EMI    = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomFechaEmision>
        R.FEC.VEN    = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomFechaVencimiento>
        R.CELULAR    = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomCelular>
        R.EMAIL      = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomEmail>
        R.VERIFICADO = R.BIOM.CUST<ABC.BP.AbcBiometricos.AbcBiomVerificado>
        
        NOMBRE.ARR = R.NOMBRES : " " : R.APE.PAT : " " : R.APE.MAT

        IF R.VERIFICADO EQ 'SI' THEN
            ENQ.ERROR = 'ESTE REGISTRO YA SE HA UTILIZADO'
            EB.Reports.setEnqError(ENQ.ERROR)
        END

    END ELSE
        ENQ.ERROR = ID.IUB.CUS : " NO SE ENCUENTRA REGISTRADO"
        EB.Reports.setEnqError(ENQ.ERROR)
    END

RETURN
*---------------------------------------------------------------
OBTEN.NACI:
*---------------------------------------------------------------

    CAR.SIGLO = '' ; SIGLO.NAC = '' ; FECHA.NAC = '' ; ESTADO.NAC = '' ; SEXO = ''

    CAR.SIGLO = R.CURP[17,1]
    IF ISDIGIT(CAR.SIGLO) THEN
        SIGLO.NAC = "19"
    END ELSE
        SIGLO.NAC = "20"
    END

    FECHA.NAC = SIGLO.NAC : R.CURP[5,6]

    ESTADO.NAC = R.CURP[12,2]

    Y.LIST.EDOS = '' ; Y.TOT.EDOS = '' ; Y.ERR.EDOS = ''
    SEL.CMD = "SELECT " : FN.ABC.ESTADO : " WITH CLAVE EQ " : DQUOTE(ESTADO.NAC)  ; * ITSS - TEJASHWINI - Added DQUOTE

    EB.DataAccess.Readlist(SEL.CMD, Y.LIST.EDOS, '', Y.TOT.EDOS, Y.ERR.EDOS)
    

    IF Y.TOT.EDOS EQ 1 THEN
        ESTADO.NAC = Y.LIST.EDOS<1>
    END

    SEXO = R.CURP[11,1]

    IF SEXO EQ 'H' THEN
        SEXO = 'MASCULINO'
    END ELSE
        SEXO = 'FEMENINO'
    END

RETURN


*---------------------------------------------------------------
OBTEN.TIPO.IDEN:
*---------------------------------------------------------------

    Y.SEL.CMD = "SELECT " : FN.LOOKUP : " @ID LIKE CUS.LEGAL.DOC.NAME*..."
    Y.REG.LIST = '' ; Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.NO.REG
        Y.REG.ACT = Y.REG.LIST<Y.I>
        Y.R.EB.LOOKUP	= EB.Template.Lookup.Read(Y.REG.ACT, Y.READ.ERROR)
        IF Y.R.EB.LOOKUP NE '' THEN
            Y.DESCRIPCION = Y.R.EB.LOOKUP<EB.Template.Lookup.LuDescription,1>
            IF Y.DESCRIPCION MATCHES R.TIP.IDE THEN
                R.TIP.IDE = FIELDS(Y.REG.ACT,'*',2)
                RETURN
            END
        END
        Y.I++
    REPEAT

RETURN


*---------------------------------------------------------------
ARMA.ARREGLO:
*---------------------------------------------------------------

   R.DATA  = ID.IUB.CUS : Y.SEP
   R.DATA := NOMBRE.ARR : Y.SEP
   R.DATA := R.APE.PAT  : Y.SEP
   R.DATA := R.APE.MAT  : Y.SEP
   R.DATA := R.NOMBRES  : Y.SEP
   R.DATA := R.CURP     : Y.SEP
   R.DATA := R.FEC.NAC  : Y.SEP
   R.DATA := R.EST.NAC  : Y.SEP
   R.DATA := R.SEXO     : Y.SEP
   R.DATA := R.TIP.IDE  : Y.SEP
   R.DATA := R.NUM.ID   : Y.SEP
   R.DATA := R.FEC.EMI  : Y.SEP
   R.DATA := R.FEC.VEN  : Y.SEP
   R.DATA := R.CELULAR  : Y.SEP
   R.DATA := R.EMAIL    : Y.SEP

RETURN
*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END



