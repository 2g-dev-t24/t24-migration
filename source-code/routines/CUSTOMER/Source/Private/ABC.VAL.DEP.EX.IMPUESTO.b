*===============================================================================
* <Rating>-30</Rating>
*===============================================================================
$PACKAGE ABC.BP
    SUBROUTINE ABC.VAL.DEP.EX.IMPUESTO

*===============================================================================
* Nombre de Programa :  ABC VALIDA DEPENDENCIA EXENTO DE IMPUESTO
* Objetivo           :  Rutina para validar el campo exento de impuesto en customer y account
* Requerimiento      :  Hace la validacion de exento impuesto en cliente y cuenta
*===============================================================================
* Modificaciones:
*===============================================================================

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING ST.Customer
    $USING AbcGetGeneralParam

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    Y.EXENTO.IMP=''
    Y.ID.CATEGORY=''
    R.CUTOMER = ''
    Y.ERR.CUSTOMER = ''
    YPOS.EX.IMP = ''
    SEL.CMD = ''
    SEL.LIST = ''
    RET.CODE = ''
    NO.IDS.AC = ''
    Y.ID.GEN.PARAM =  'ABC.INVERSIONES'
    Y.LIST.PARAMS = ''
    Y.SEL.EX=''
    Y.NO.CAT=''
    Y.EXENTO.IMP = EB.SystemTables.getComi()
    Y.ID.CUSTOMER = EB.SystemTables.getIdNew()

    EB.LocalReferences.GetLocRef('CUSTOMER','EXENTO.IMPUESTO',YPOS.EX.IMP)
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.NO.CAT=COUNT(Y.LIST.PARAMS,FM)+1

    FOR Y.CAT=1 TO Y.NO.CAT
        Y.ID.CATEGORY:="CATEGORY NE ":Y.LIST.PARAMS<Y.CAT>
        IF Y.CAT NE Y.NO.CAT THEN
            Y.ID.CATEGORY:=" AND "
        END
    NEXT Y.CAT


    RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT   = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)



    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    IF Y.EXENTO.IMP  EQ 'S' THEN
        Y.SEL.EX= 'EXENTO.IMPUESTO NE "S"'
    END ELSE
        Y.SEL.EX= 'EXENTO.IMPUESTO EQ "S"'
    END

    SEL.CMD = "SELECT " :FN.ACCOUNT: " WITH CUSTOMER EQ ":DQUOTE(Y.ID.CUSTOMER): " AND ": DQUOTE(Y.SEL.EX):" AND ":DQUOTE(Y.ID.CATEGORY)
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'', NO.IDS.AC,RET.CODE)

    IF NO.IDS.AC NE 0 THEN

        BEGIN CASE
        CASE Y.EXENTO.IMP EQ 'N' OR Y.EXENTO.IMP EQ ''
            EB.SystemTables.setEtext("El cliente tiene cuentas que son exentas de impuestos")
            EB.ErrorProcessing.StoreEndError()
        CASE Y.EXENTO.IMP EQ 'S'
            EB.SystemTables.setEtext("El cliente tiene cuentas que no son exentas de impuestos")
            EB.ErrorProcessing.StoreEndError()
        END CASE

    END
    RETURN

END
