* @ValidationCode : MjotNDE4OTUyMTg5OkNwMTI1MjoxNzQ0NzczMjc5NDUyOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Apr 2025 22:14:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VALIDA.CANAL.FT
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.VALIDA.CANAL.FT
* Objetivo:             Rutina que valida que el usuario corresponda al canal
*                                               del registro
* Desarrollador:        Cr Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC CAPITAL
* Fecha Creacion:       06 - Jul - 2020
* Modificaciones:
*-----------------------------------------------------------------------------

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates

    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

RETURN

***********
INICIALIZA:
***********

    Y.CANAL = ''
    Y.ERROR = ''
*    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","CANAL.ENTIDAD",YPOS.CANAL)
    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = "CANAL.ENTIDAD"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    YPOS.CANAL       = field_Positions<1,1>

RETURN

***************
VALIDA.USUARIO:
***************

    Y.CANAL = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,YPOS.CANAL> ;* R.NEW(FT.LOCAL.REF)<1,YPOS.CANAL>

*    CALL ABC.VALIDA.CANAL(Y.CANAL, Y.ERROR)
    ABC.BP.abcValidaCanal(Y.CANAL, Y.ERROR)
    IF Y.ERROR NE '' THEN
        EB.SystemTables.setEtext(Y.ERROR)
        EB.SystemTables.setE("")
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

END
