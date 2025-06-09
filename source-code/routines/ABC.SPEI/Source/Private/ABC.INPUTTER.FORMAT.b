*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.INPUTTER.FORMAT(Y.INP)

* CONVERT THE INPUTTER TO THE FORMAT

    Y.INP = FIELD(Y.INP,"_",2)

    RETURN
