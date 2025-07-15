* @ValidationCode : Mjo1MDU3OTI3OTQ6Q3AxMjUyOjE3NTI1Mzk2OTk1NTg6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2025 21:34:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.2BR.GET.BANK.NAME.SPEI(YINPUT.DATA)

*--------------------------------------------------------------------
    $USING EB.Template
*-----------------------
* Main Loop Program
*-----------------------

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    YBANK.ID = YINPUT.DATA[1,3]
    YBANK.ID = '40':YBANK.ID
    YBANK.ID = TRIM(YBANK.ID,"0","L")
    
    R.VPM.BANCOS = EB.Template.Lookup.Read(YBANK.ID, Error)

    IF R.VPM.BANCOS THEN
        YINPUT.DATA = R.VPM.BANCOS<EB.Template.Lookup.LuDescription>
    END ELSE
        YINPUT.DATA = "BANCO NO ESTA EN CATALOGO"
    END

RETURN

END


