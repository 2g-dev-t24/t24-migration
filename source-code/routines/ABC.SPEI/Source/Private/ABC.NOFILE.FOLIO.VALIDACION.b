* @ValidationCode : Mjo1MjA2MjM0NjQ6Q3AxMjUyOjE3NDg5NjgyNzY2Nzk6dHJhYmFqbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Jun 2025 13:31:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : trabajo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei
SUBROUTINE ABC.NOFILE.FOLIO.VALIDACION(R.DATA)
*===============================================================================
* Nombre de Programa : ABC.NOFILE.FOLIO.VALIDACION
* Objetivo           : Rutina nofile para leer los folios de validacion en
* ABC.VALIDACION.BIOMETRICOS de cliente para la cuenta de transaccion
* Desarrollador      : Luis Cruz - FyG Solutions
* ENQ: ABC.E.FOLIO.VALIDACION
* SS : NOFILE.ABC.FOLIO.VALIDACION
* RTN: ABC.NOFILE.FOLIO.VALIDACION
* Fecha Creacion     :
* Modificaciones:
*===============================================================================

    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING AC.AccountOpening
    $USING AbcTable
    

    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    FN.ABC.VAL.BIOME = 'F.ABC.VALIDACION.BIOMETRICOS'
    F.ABC.VAL.BIOME = ''
    EB.DataAccess.Opf(FN.ABC.VAL.BIOME, F.ABC.VAL.BIOME)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT   = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    Y.ID.ACC = ''
    Y.ID.CUS = ''
    R.DATA = ''
    Y.SEP = '*'


RETURN
*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()
    LOCATE "NO.CUENTA" IN SEL.FIELDS SETTING ACC.POS THEN
        Y.ID.ACC = SEL.VALUES<ACC.POS>
    END

    EB.DataAccess.FRead(FN.ACCOUNT, Y.ID.ACC, R.ACCOUNT, F.ACCOUNT, ERR.ACC)
    IF R.ACCOUNT THEN
        Y.ID.CUS = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    END

    Y.SEL.CMD = ''
    Y.LIST.IDS = ''
    Y.NO.IDS = ''
    
    Y.SEL.CMD  = "SELECT " : FN.ABC.VAL.BIOME : " WITH CUC EQ " : DQUOTE(Y.ID.CUS) : " AND RESPUESTA EQ 'TRUE' "  ; *ITSS - TEJASHWINI - Added DQUOTE / '
    Y.SEL.CMD := "AND WITH VERIFICADO NE 'SI' BY @ID"  ; *ITSS - TEJASHWINI - Added '
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.LIST.IDS, '', Y.NO.IDS, Y.ERR)

    FOR Y.ITE = 1 TO Y.NO.IDS
        Y.ID.VAL.BIO = ''
        Y.CLIENTE = ''
        Y.RESPUESTA = ''

        Y.ID.VAL.BIO = Y.LIST.IDS<Y.ITE>
        EB.DataAccess.FRead(FN.ABC.VAL.BIOME, Y.ID.VAL.BIO, R.VAL.BIO, F.ABC.VAL.BIOME, ERR.VAL.BIO)
        IF R.VAL.BIO THEN
            Y.CLIENTE = R.VAL.BIO<AbcTable.AbcValidacionBiometricos.Cuc>
            Y.RESPUESTA = R.VAL.BIO<AbcTable.AbcValidacionBiometricos.Respuesta>
            IF Y.CLIENTE AND Y.RESPUESTA THEN
                R.DATA<-1> = Y.ID.VAL.BIO : Y.SEP : Y.CLIENTE : Y.SEP : Y.RESPUESTA
            END
        END

    NEXT Y.ITE

    IF R.DATA EQ '' THEN
        R.DATA = "CLIENTE SIN FOLIOS"
    END

*---------------------------------------------------------------
FINAL:
*------------------------------------------------------------------------------------------------------------------------------------------

END
