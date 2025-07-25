$PACKAGE AbcAccount
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CAMB.CAT.REMUNERA
*===============================================================================
    
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening

    GOSUB INICIO
    GOSUB OPEN.FILES
    GOSUB LEER.PARAMETROS
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    Y.PARAM.ID = 'ABC.PARAM.CUENTA.REMUNERADA'
    R.ABC.GENERAL.PARAM = ''
    Y.ERR.PARAM = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ARRANGEMENT.ID = ''
    Y.ACCOUNT.NO = ''
    Y.ACCOUNT.CATEGORY = ''

RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

RETURN

*-----------------------------------------------------------------------------
LEER.PARAMETROS:
*-----------------------------------------------------------------------------
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el parámetro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ARRANGEMENT.ID = EB.SystemTables.getComi()
    
    IF Y.ARRANGEMENT.ID THEN
        R.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.ARRANGEMENT.ID, Error)
        Y.ACCOUNT.NO = R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedApplId>
        IF Y.ACCOUNT.NO THEN
            R.ACCOUNT = ''
            Y.ERR.ACCOUNT = ''
            EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNT.NO, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
            
            IF R.ACCOUNT THEN
                Y.ACCOUNT.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>
                
                IF R.ACCOUNT<AC.AccountOpening.Account.PostingRestrict> THEN
                    ETEXT = 'La cuenta ':Y.ACCOUNT.NO:' tiene posting restriction'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
                
                LOCATE Y.ACCOUNT.CATEGORY IN Y.LIST.PARAMS SETTING Y.POS.CATEGORY ELSE
                    ETEXT = 'Categoría ':Y.ACCOUNT.CATEGORY:' no encontrada en la lista de parámetros'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
                Y.NEW.PRODUCT = Y.LIST.VALUES<Y.POS.CATEGORY>
                EB.SystemTables.setRNew(AA.Framework.ArrangementActivity.ArrActProduct, Y.NEW.PRODUCT)
            END 
        END
    END

RETURN
END 