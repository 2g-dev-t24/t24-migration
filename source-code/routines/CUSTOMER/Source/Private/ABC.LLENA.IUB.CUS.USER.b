* @ValidationCode : MjotMTc1NTcyNDM3NzpDcDEyNTI6MTc0Njc0MTczNjkzNzptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 May 2025 19:02:16
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
$PACKAGE ABC.BP
SUBROUTINE ABC.LLENA.IUB.CUS.USER
*===============================================================================
* Nombre de Programa : ABC.LLENA.IUB.CUS.USER
* Objetivo           : AuthRtn para llenar campos IUB y ROL cuando se enrola un ejecutivo
* y IUB cuando se enrola un CLIENTE
* Desarrollador      : Enzo Corio
* Fecha Creacion     : 2025-04-09
* Modificaciones:
*===============================================================================

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Security
    $USING ABC.BP
    $USING EB.LocalReferences

    GOSUB INICIALIZA
    GOSUB PROCESO
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.USER = 'F.USER'
    F.USER  = ''
    EB.DataAccess.Opf(FN.USER, F.USER)

    EB.LocalReferences.GetLocRef("CUSTOMER","IUB",POS.IUB.CUS)
    EB.LocalReferences.GetLocRef("USER","IUB",POS.IUB.USER)
    EB.LocalReferences.GetLocRef("USER","L.ROL",POS.ROL.USER)

    Y.TIPO.ENROL = ''
    Y.IUB.BIO = ''
    Y.ID.CUST = ''
    Y.ID.USER = ''
    Y.USR.SGN = ''
    Y.ROL.USE = 'enroladorClientes'
    R.CSTOMER = ''
    R.USR.EJE = ''

RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------

    EB.SystemTables.setAf(ABC.BP.AbcBiometricos.AbcBiomEjecutivo)
    Y.IUB.BIO = EB.SystemTables.getIdNew()
    Y.ID.CUST = EB.SystemTables.getRNew(ABC.BP.AbcBiometricos.AbcBiomCuc)
    Y.USR.SGN = EB.SystemTables.getRNew(ABC.BP.AbcBiometricos.AbcBiomEjecutivo)

    IF (Y.ID.CUST NE '') AND (Y.USR.SGN NE '') THEN         ;*3 - AMBOS
        IUB.R.CUST = ''
        IUB.R.USER = ''
        GOSUB LEE.CLIENTE
        IF V$ERROR EQ 1 THEN
            EB.ErrorProcessing.Err()
            RETURN
        END
        IUB.R.CUST = Y.IUB.REG
        GOSUB LEE.EJECUTIVO
        IF V$ERROR EQ 1 THEN
            EB.ErrorProcessing.Err()
            RETURN
        END
        IUB.R.USER = Y.IUB.REG

        IF (IUB.R.CUST EQ '') AND (IUB.R.USER EQ '') THEN
            EB.SystemTables.setE('NO SE PUEDE INGRESAR CUC Y EJECUTIVO')
            EB.ErrorProcessing.Err()
        END ELSE
            EB.SystemTables.setRNew(ABC.BP.AbcBiometricos.AbcBiomTipoEnrolamiento, 'AMBOS')
            IF (Y.IUB.BIO EQ IUB.R.CUST) AND (IUB.R.USER EQ '') THEN  ;* SE ACTUALIZA EL REGISTRO EN USER
                GOSUB ACTUALIZA.EJECUTIVO
            END

            IF (Y.IUB.BIO EQ IUB.R.USER) AND (IUB.R.CUST EQ '') THEN  ;* SE ACTUALIZA EL REGISTRO EN CUSTOMER
                GOSUB ACTUALIZA.CLIENTE
            END
        END
    END ELSE        ;* 1er ENROLAMIENTO
        IF Y.ID.CUST THEN     ;*1 - CLIENTE
            EB.SystemTables.setRNew(ABC.BP.AbcBiometricos.AbcBiomTipoEnrolamiento, 'CLIENTE')
            GOSUB LEE.CLIENTE
            IF V$ERROR EQ 1 THEN
                EB.ErrorProcessing.Err()
                RETURN
            END ELSE
                GOSUB ACTUALIZA.CLIENTE
            END
        END
        IF Y.USR.SGN THEN     ;*2 - EJECUTIVO
            EB.SystemTables.setRNew(ABC.BP.AbcBiometricos.AbcBiomTipoEnrolamiento, 'EJECUTIVO')
            GOSUB LEE.EJECUTIVO
            IF V$ERROR EQ 1 THEN
                EB.ErrorProcessing.Err()
                RETURN
            END ELSE
                GOSUB ACTUALIZA.EJECUTIVO
            END
        END
    END

RETURN
*---------------------------------------------------------------
LEE.CLIENTE:
*---------------------------------------------------------------

    Y.IUB.REG = ''

    R.CSTOMER = ST.Customer.Customer.Read(Y.ID.CUST,Y.ERROR)
    Y.IUB.REG = R.CSTOMER<ST.Customer.Customer.EbCusLocalRef,POS.IUB.CUS>
    IF Y.IUB.REG NE '' THEN
        IF Y.IUB.BIO NE Y.IUB.REG THEN
            EB.SystemTables.setAf(ABC.BP.AbcBiometricos.AbcBiomCuc)
            V$ERROR = 1
            EB.SystemTables.setE('CLIENTE YA ENROLADO')
        END
    END

RETURN
*---------------------------------------------------------------
LEE.EJECUTIVO:
*---------------------------------------------------------------

    Y.IUB.REG = ''
    Y.SEL.CMD = ''; Y.LST.USER = ''; Y.NO.USER = ''
    Y.SEL.CMD = "SELECT " : FN.USER : " WITH SIGN.ON.NAME EQ '" : Y.USR.SGN : "'"
    EB.DataAccess.Readlist(Y.SEL.CMD,Y.LST.USER,'',Y.NO.USER, Y.ERROR)
    IF Y.NO.USER EQ 1 THEN
        Y.ID.USER = Y.LST.USER<1>
        EB.DataAccess.FRead(FN.USER,Y.ID.USER,R.USR.EJE,F.USER,USR.ERR)
        IF R.USR.EJE NE '' THEN
            Y.IUB.REG = R.USR.EJE<EB.Security.User.UseLocalRef, POS.IUB.USER>

            IF Y.IUB.REG NE '' THEN
                IF Y.IUB.BIO NE Y.IUB.REG THEN
                    V$ERROR = 1
                    EB.SystemTables.setE('EJECUTIVO YA ENROLADO')
                END
            END
        END
    END ELSE
        V$ERROR = 1
        EB.SystemTables.setE('EJECUTIVO NO ENCONTRADO')
    END

RETURN
*---------------------------------------------------------------
ACTUALIZA.EJECUTIVO:
*---------------------------------------------------------------

    R.USR.EJE<EB.Security.User.UseLocalRef,POS.IUB.USER> = Y.IUB.BIO
    R.USR.EJE<EB.Security.User.UseLocalRef,POS.ROL.USER> = Y.ROL.USE

    EB.DataAccess.FWrite(FN.USER,Y.ID.USER,R.USR.EJE)

RETURN
*---------------------------------------------------------------
ACTUALIZA.CLIENTE:
*---------------------------------------------------------------

    R.CSTOMER<ST.Customer.Customer.EbCusLocalRef,POS.IUB.CUS> = Y.IUB.BIO
    EB.DataAccess.FWrite(FN.CUSTOMER,Y.ID.CUST,R.CSTOMER)

RETURN
