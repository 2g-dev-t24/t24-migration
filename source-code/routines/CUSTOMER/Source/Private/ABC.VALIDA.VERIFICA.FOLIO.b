$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VALIDA.VERIFICA.FOLIO(Y.DATOS, Y.ERROR)
*===============================================================================
* Nombre de Programa : ABC.VALIDA.VERIFICA.FOLIO
* Objetivo           : Rutina general para validar el registro de FOLIO.VALIDACION
* en ABC.VALIDACION.BIOMETRICOS
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING EB.Template
    $USING AbcGetGeneralParam
    $USING AbcTable
    
    GOSUB INICIALIZA
    GOSUB PROCESO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ABC.VAL.BIOM = 'F.ABC.VALIDACION.BIOMETRICOS'
    F.ABC.VAL.BIOM = ''
    EB.DataAccess.Opf(FN.ABC.VAL.BIOM,F.ABC.VAL.BIOM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    
    FN.EB.LOOKUP    = 'F.EB.LOOKUP'
    F.EB.LOOKUP    = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP,F.EB.LOOKUP)

    Y.ID.GEN.PARAM = 'ABC.MONTO.UDIS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'MONTO.MAXIMO.PESOS' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.MONTO.MAX = Y.LIST.VALUES<YPOS.PARAM>
    END

    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER', 'FOL.VALIDACION', POS.FOL.VAL)
    EB.LocalReferences.GetLocRef("CUSTOMER", "CLASSIFICATION", POS.CLASSIFICATION)

    Y.ACC.CUS = ''
    Y.ID.CUST = ''
    R.ACC.CUS = ''
    Y.FOL.VAL = ''
    R.FOL.VAL = ''
    Y.FOL.CUS = ''
    Y.FOL.RES = ''
    Y.FOL.VER = ''
    Y.CLASS.CUST = ''

    RETURN
*---------------------------------------------------------------
PROCESO:
*---------------------------------------------------------------
    Y.ACC.CUS = Y.DATOS<1>
    Y.FOL.VAL = Y.DATOS<2>
    Y.MONTO.TRA = Y.DATOS<3>

    Y.FNCTION = EB.SystemTables.getVFunction()

*LEEMOS EL REGISTRO DE LA CUENTA PARA OBTENER EL CLIENTE Y EL NIVEL
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACC.CUS, R.ACC.CUS, F.ACCOUNT, ERR.FOL)

    IF R.ACC.CUS THEN
        Y.ID.CUST = R.ACC.CUS<AC.AccountOpening.Account.Customer>
        Y.ACCOUNT.CATEGORY = R.ACC.CUS<AC.AccountOpening.Account.Category>
        GOSUB LEER.NIVEL
    END

*LEEMOS EL REGISTRO DEL CLIENTE PARA OBTENER CLASSIFICATION
    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUST, REC.CUSTO, F.CUSTOMER, ERR.CUS)

    IF REC.CUSTO THEN
        Y.CLASS.CUST = REC.CUSTO<ST.Customer.Customer.EbCusLocalRef, POS.CLASSIFICATION>
    END

    BEGIN CASE
    CASE Y.FNCTION EQ 'R'
        EB.DataAccess.FRead(FN.ABC.VAL.BIOM, Y.FOL.VAL, R.FOL.VAL, F.ABC.VAL.BIOM, ERR.FOL)
        Y.FOL.VER = R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Verificado>
        BANDE.EST = Y.FOL.VER
        GOSUB REVERSA.FOLIO

    CASE Y.FNCTION EQ 'D'
        EB.DataAccess.FRead(FN.ABC.VAL.BIOM, Y.FOL.VAL, R.FOL.VAL, F.ABC.VAL.BIOM, ERR.FOL)
        Y.FOL.VER = R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Verificado>
        BANDE.EST = Y.FOL.VER
        GOSUB REVERSA.FOLIO

    CASE Y.FNCTION EQ 'I'
        IF (Y.CLASS.CUST EQ 1) OR (Y.CLASS.CUST EQ 2) THEN
            IF (Y.NIVEL.CTA NE 'NIVEL.1') AND (Y.NIVEL.CTA NE 'NIVEL.2') THEN   ;*AND (Y.NIVEL.CTA NE '') THEN
                IF Y.MONTO.TRA GT Y.MONTO.MAX THEN
*SE VALIDA QUE EXISTA REGISTRO EN ABC.VALIDACION.BIOMETRICOS CON ID DE FOLIO.VALIDACION
                    EB.DataAccess.FRead(FN.ABC.VAL.BIOM, Y.FOL.VAL, R.FOL.VAL, F.ABC.VAL.BIOM, ERR.FOL)

                    IF R.FOL.VAL THEN
                        Y.FOL.CUS = R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Cuc>
                        Y.FOL.RES = R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Respuesta>
                        Y.FOL.VER = R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Verificado>

                        IF Y.FOL.CUS AND Y.FOL.RES THEN
                            GOSUB VALIDA.FOLIO
                        END ELSE
                            Y.ERROR = "FOLIO INVALIDO"      ;* datos incompletos
                            RETURN
                        END
                    END ELSE
                        Y.ERROR = "FOLIO INVALIDO"          ;* no existe
                        RETURN
                    END
                END
            END
        END
    END CASE

    RETURN
*---------------------------------------------------------------
VALIDA.FOLIO:
*---------------------------------------------------------------
*VALIDAMOS QUE CLIENTE DE TRANSACCION CORRESPONDA AL DE VALIDACION BIOMETRICOS Y QUE RESPUESTA SEA TRUE
    IF Y.FOL.CUS NE Y.ID.CUST THEN
        Y.ERROR = "FOLIO INVALIDO"      ;* por cliente
        RETURN
    END ELSE
        IF Y.FOL.RES NE "TRUE" THEN
            Y.ERROR = "FOLIO INVALIDO"  ;* por respuesta
            RETURN
        END ELSE
            IF Y.FOL.VER EQ "SI" THEN
                Y.ERROR = "FOLIO INVALIDO"        ;* ya se verifico
                RETURN
            END
        END
    END

    Y.FNCTION.AUX = EB.SystemTables.getVFunction()
    IF Y.FNCTION.AUX EQ 'I' AND Y.ERROR EQ '' THEN
        BANDE.EST = Y.FOL.VER
        GOSUB REVERSA.FOLIO
    END
    RETURN

*---------------------------------------------------------------
REVERSA.FOLIO:
*---------------------------------------------------------------
    IF BANDE.EST EQ 'SI' THEN
        R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Verificado> = 'NO'
    END

    IF BANDE.EST NE 'SI' THEN
        R.FOL.VAL<AbcTable.AbcValidacionBiometricos.Verificado> = 'SI'
    END

    EB.DataAccess.FWrite(FN.ABC.VAL.BIOM,Y.FOL.VAL,R.FOL.VAL)

    BANDE.EST = ''

RETURN

*---------------------------------------------------------------
LEER.NIVEL:
*---------------------------------------------------------------

    Y.EB.LOOKUP = "ABC.NIVEL.CUENTA*":Y.ACCOUNT.CATEGORY
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, ERR.EB.LOOKUP)

    IF R.EB.LOOKUP NE '' THEN
        Y.NIVEL.CTA = R.EB.LOOKUP<EB.Template.Lookup.LuDescription,1>
    END ELSE
        Y.ERROR = "NIVEL DE CUENTA NO CONFIGURADO"
    END

RETURN

END