* @ValidationCode : MjotMTMxMjY4MDM4NjpDcDEyNTI6MTc1MDk2NDEwNjk1MzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2025 15:55:06
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

SUBROUTINE ABC.CTA.ALT.PRN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING AC.AccountOpening
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    FIND "PRN" IN EB.SystemTables.getRNew(AC.ALT.ACCT.TYPE) SETTING Fm,Vm,Sm THEN
        Y.POS.ALT = Vm
    END

    Y.CUENTA = EB.SystemTables.getRNew(AC.AccountOpening.Account.LocalRef)<1,Y.POS.ALT>

    IF (LEN(Y.CUENTA) LT 1) AND (LEN(Y.CUENTA) GT 20) THEN

        ETEXT = "NO TIENE LA LONGITUD CORRECTA"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
        
    END ELSE

        IF EB.SystemTables.getROld(AC.AccountOpening.Account.AltAcctId)<1,Y.POS.ALT> NE Y.CUENTA THEN
            
            R.ALT.CTA = AC.AccountOpening.AlternateAccount.Read(Y.CUENTA, Error)
            
            IF R.ALT.CTA NE '' THEN
                ETEXT = "LA CUENTA ALTERNA YA EXISTE CON OTRO CLIENTE"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                EB.SystemTables.setComi('')
                CALL REBUILD.SCREEN
                RETURN
            END
        END
    END

RETURN

END
