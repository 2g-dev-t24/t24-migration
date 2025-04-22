* @ValidationCode : Mjo3NTk3NDcxMDE6Q3AxMjUyOjE3NDUzMzcyOTE5Mjk6bWF1dWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Apr 2025 12:54:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         :
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>17</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.BIOM.IUB.CURP
*===============================================================================
* Nombre de Programa : ABC.VALIDA.BIOM.IUB.CURP
* Objetivo           : Rutina para leer registro de ABC.BIOMETRICOS y validar que
* el CURP corresponda al CURP del registro de CUSTOMER
*===============================================================================

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING EB.Updates

    $USING ABC.BP


    GOSUB INICIALIZA
    GOSUB PROCESA
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

    FN.ABC.BIOM = 'F.ABC.BIOMETRICOS'
    F.ABC.BIOM = ''
    EB.DataAccess.Opf(FN.ABC.BIOM, F.ABC.BIOM)

    EB.Updates.MultiGetLocRef('CUSTOMER', 'IUB', POS.IUB)

    Y.ID.CUST = ''
    Y.IUB.CUS = ''
    Y.CURP.CUS = ''
    Y.CURP.BIO = ''
    R.IUB.BIO = ''

    Y.ID.CUST = EB.SystemTables.getIdNew()
    Y.IUB.CUS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)<1,POS.IUB>
    Y.CURP.CUS = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusExternCusId)

    IF NOT(Y.IUB.CUS) THEN
        GOSUB BUSCA.IUB.BIO
    END

RETURN
*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------

    IF Y.IUB.CUS THEN
*LEEMOS EL REGISTRO DE ABC.BIOMETRICOS CON EL IUB DE CUSTOMER
        EB.DataAccess.FRead(FN.ABC.BIOMETRICOS, Y.IUB.CUS, R.IUB.BIO, F.ABC.BIOMETRICOS, ERR.BIO)
*OBTENEMOS EL CURP REGISTRADOP EN ABC.BIOMETRICOS
        IF R.IUB.BIO THEN
            Y.CURP.BIO = R.IUB.BIO<ABC.BP.AbcBiometricos.AbcBiomCurp>
*VALIDAMOS SI EL CURP DE CUSTOMER COINCIDE CON EL DE BIOMETRICOS
            IF Y.CURP.BIO THEN
                IF Y.CURP.CUS NE Y.CURP.BIO THEN
                    EB.SystemTables.setAf(EB.CUS.EXTERN.CUS.ID)
                    EB.SystemTables.setAv(0)
                    EB.SystemTables.setE("CURP NO COINCIDE CON EL REGISTRADO EN BIOMETRICOS")
                    EB.ErrorProcessing.Err()  ;*STORE.END.ERROR
                END
            END ELSE
                EB.SystemTables.setAf(EB.CUS.EXTERN.CUS.ID)
                EB.SystemTables.setAv(0)
                EB.SystemTables.setE("NO SE REGISTRO CURP EN BIOMETRICOS")
                EB.ErrorProcessing.Err()      ;*STORE.END.ERROR
            END
        END ELSE
            EB.SystemTables.setAf(EB.CUS.LOCAL.REF)
            EB.SystemTables.setAv(POS.IUB)
            EB.SystemTables.setAs(0)
            EB.SystemTables.setE("NO EXISTE REGISTRO CON IUB INGRESADO")
            EB.ErrorProcessing.Err()          ;*STORE.END.ERROR
        END
    END ELSE
        EB.SystemTables.setAf(EB.CUS.LOCAL.REF)
        AV = POS.IUB
        AS = 0
        EB.SystemTables.setE("NO SE ENCONTRO IUB PARA ESTE CLIENTE")
        EB.ErrorProcessing.Err()    ;*STORE.END.ERROR
    END

RETURN

*---------------------------------------------------------------
BUSCA.IUB.BIO:
*---------------------------------------------------------------

    Y.IUB.BIO = ''
    R.CUSTOM  = ''

    Y.SEL.CMD = ''
    Y.LST.BIO = ''
    Y.NO.BIOM = ''

    Y.SEL.CMD = "SELECT " : FN.ABC.BIOM : " WITH CUC EQ " : DQUOTE(Y.ID.CUST)
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.LST.BIO, '', Y.NO.BIOM, Y.ERROR)
    IF Y.NO.BIOM EQ 1 THEN
        Y.IUB.BIO = Y.LST.BIO<1>
        Y.IUB.CUS = Y.IUB.BIO
        EB.SystemTables.setRNew((ST.Customer.Customer.EbCusLocalRef)<1, POS.IUB>, Y.IUB.CUS)
    END

RETURN
