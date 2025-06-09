*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.DATE.FT(Y.DT)

* CONVERT THE DATE.TIME TO THE FORMAT YYY/MM/DD

    Y.YEAR = Y.DT[1,4]
    Y.MM   = Y.DT[5,2]
    Y.DAY  = Y.DT[7,2]

    Y.DT = Y.DAY:"/":Y.MM:"/":Y.YEAR

    RETURN

END
