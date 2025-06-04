*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.2BR.GET.BANK.NAME.SPEI(YINPUT.DATA)

*--------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
*-----------------------
* Main Loop Program
*-----------------------

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

*-------
PROCESS:
*-------

    YBANK.ID = YINPUT.DATA[1,3]
    YBANK.ID = '40':YBANK.ID
    YBANK.ID = TRIM(YBANK.ID,"0","L")

    EB.DataAccess.FRead(FN.VPM.BANCOS,YBANK.ID,R.VPM.BANCOS,FV.VPM.BANCOS,YF.ERROR)
    IF R.VPM.BANCOS THEN
        YINPUT.DATA = R.VPM.BANCOS<AbcTable.AbcBancos.ClavePuntoTrans>
    END ELSE
        YINPUT.DATA = "BANCO NO ESTA EN CATALOGO"
    END

    RETURN
*----------
INITIALIZE:
*----------

    FN.VPM.BANCOS = "F.ABC.BANCOS"
    FV.VPM.BANCOS = ""
    EB.DataAccess.Opf(FN.VPM.BANCOS,FV.VPM.BANCOS)

    RETURN
**********
END


