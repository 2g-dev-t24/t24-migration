*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE BA.2BR.GET.REF.SPEI(YINPUT.DATA)

*--------------------------------------------------------------------
* Subroutine :         BA.2BR.GET.REF.SPEI
* Objective  :         Proporciona la Referencia del SPEI para utilizarse en
*                      DEAL.SLIP.FORMAT FT.VPM.SPEUA
* First Released For : Banco Amigo, S.A.
* First Released :     Mar/29/2011
* Author :             Ali Maldonado
*--------------------------------------------------------------------

*-----------------------
* Main Loop Program
*-----------------------

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN
*-----------------------
PROCESS:
*-----------------------
    YINPUT.DATA = YINPUT.DATA[10,7]

    RETURN
*-----------------------
INITIALIZE:
*-----------------------

    RETURN
END
