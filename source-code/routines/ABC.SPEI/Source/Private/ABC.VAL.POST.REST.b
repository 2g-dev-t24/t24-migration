* @ValidationCode : MjotMTM3Mjc5MzgxNzpDcDEyNTI6MTc0OTAwMTYyNTIwNzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jun 2025 22:47:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.VAL.POST.REST(Y.ID.ACCT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess

    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AC.Config
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.APPL = EB.SystemTables.getApplication()

*    FN.ACCT="F.ACCOUNT"
*    F.ACCT  = ""
*    EB.DataAccess.Opf(FN.ACCT, F.ACCT)

*    FN.POST="F.POSTING.RESTRICT"
*    F.POST=""
*    EB.DataAccess.Opf(FN.POST, F.POST)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.POST.REST = ''
    R.POST = ''
    ERR.POST = ''
    Y.REST.TYPE = ''

    REC.ACCT = AC.AccountOpening.Account.Read(Y.ID.ACCT, Y.AC.ERR)
    
    Y.POST.REST = REC.ACCT<AC.AccountOpening.Account.PostingRestrict>
    IF Y.POST.REST NE "" THEN
        R.POST = AC.Config.PostingRestrict.Read(Y.POST.REST, Error)
        Y.REST.TYPE=R.POST<AC.Config.PostingRestrict.PosRestrictionType>
        
        IF Y.REST.TYPE EQ 'ALL' THEN
            EB.SystemTables.setComi("")
            EB.SystemTables.setEtext("La Cuenta: ":Y.ID.ACCT:" tiene restricciones")
            EB.ErrorProcessing.StoreEndError()
        END

        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
END
