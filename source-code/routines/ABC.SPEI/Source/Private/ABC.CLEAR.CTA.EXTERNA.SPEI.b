$PACKAGE AbcSpei
SUBROUTINE ABC.CLEAR.CTA.EXTERNA.SPEI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* 22 MAY 2004 - PIF - CEHV - Agregado bloque para validación de Call Center
* 17 MAR 2005 - FGV - Validación de versiones OFS para no borrar campos
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Updates
    $USING FT.Contract
    $USING AbcSpei

    Y.ID.ACCT = EB.SystemTables.getComi()
    AbcSpei.AbcValPostRest(Y.ID.ACCT)

    IF EB.SystemTables.getMessage() NE "VAL" THEN
        GOSUB GET.FIELDS.LOCAL

        IF (EB.SystemTables.getPgmVersion() NE ",SPEI.T.T.OFS") AND (EB.SystemTables.getPgmVersion() NE ",VPM.2FX.OFS.SPEI") AND (EB.SystemTables.getPgmVersion() NE ",VPM.2BR.OFS.SPEI.DISP") THEN
            Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            IF Y.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF> THEN
                Y.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF> = ""
                Y.LOCAL.REF<1,YPOS.RFC.BENEF.SPEI> = ""
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
                EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, "")
            END
        END
    END

    IF EB.SystemTables.getApplication() EQ "FUNDS.TRANSFER" AND EB.SystemTables.getPgmVersion()[1,8] EQ ",VPM.CC." THEN
        AbcSpei.VpmCcCheckCustnoDr()
        IF EB.SystemTables.getE() THEN 
            EB.SystemTables.setComi("")
        END
    END

    AbcSpei.AbcFtGicDbAcct()
    AbcSpei.AbcVFtToday()
    RETURN
END

*-------------------------------------------------------------------------------
GET.FIELDS.LOCAL:
*-------------------------------------------------------------------------------
    Y.NOMBRE.APP = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "CTA.EXT.TRANSF":@VM:"RFC.BENEF.SPEI"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    YPOS.CTA.EXT.TRANSF = R.POS.CAMPO<1,1>
    YPOS.RFC.BENEF.SPEI = R.POS.CAMPO<1,2>
    RETURN 