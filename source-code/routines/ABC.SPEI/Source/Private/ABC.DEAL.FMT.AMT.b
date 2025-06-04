*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE VPM.DEAL.FMT.AMT(FAMT)

    IF FAMT EQ '' THEN
        FAMT = '0.00'
    END

    FAMT = TRIM(FAMT," ",A)
    FAMT = FAMT[4,LEN(FAMT)-3]
    FAMT = FMT(FAMT,"R2")

    RETURN

END
