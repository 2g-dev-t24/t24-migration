* @ValidationCode : Mjo4NzU2OTU0Nzc6Q3AxMjUyOjE3NDQ0MTk2MzIxNTE6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2025 20:00:32
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
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BMV.ID.CAJA
*
*
*-----------------------------------------------------------------------------
* Modificado por : Jesus Andres Rivera Equiuha
* Fecha          : 13/Marzo/2015
* Descripcion    : Se cambio la llamada directa a los campos locales,
*                  por la funcion que regresa la posicion del campo local
*                  proporcionando el nombre del campo
*-----------------------------------------------------------------------
*    First Release :             14/11/2006
*    Developed for :     BANCO MULTIVA
*    Developed by  :     KLEBER COSTA
*
*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*    $INSERT I_F.FUNDS.TRANSFER
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.FUNDS.TRANSFER

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.Updates
*
*
*
*************************************************************************

*LEER REGISTRO ACTUAL CAMPO ESTADO
    USUARIO = EB.SystemTables.getOperator() ;*OPERATOR
    
*INICIALIZA

*    FN.TELLER.USER = "FBNK.TELLER.USER"
*    F.TELLER.USER = ""
**    CALL OPF(FN.TELLER.USER, F.TELLER.USER)
*    EB.DataAccess.Opf(FN.TELLER.USER, F.TELLER.USER)
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","CHQ.ISSUE.ID",CHQ.ISSUE.ID.POS)
    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = "CHQ.ISSUE.ID"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    CHQ.ISSUE.ID.POS     = field_Positions<1,1>
*PROCESA

*    READ TELLER.USER.REC FROM F.TELLER.USER, USUARIO THEN
    TELLER.USER.REC = TT.Contract.TellerUser.Read(USUARIO, TTEr)
    IF TELLER.USER.REC THEN
*        ID.CAJA = TELLER.USER.REC<1>
*        R.NEW(FT.LOCAL.REF)<1,CHQ.ISSUE.ID.POS>=ID.CAJA
        ID.CAJA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        ID.CAJA<1,CHQ.ISSUE.ID.POS> = TELLER.USER.REC<1>
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,ID.CAJA)
    END
*VERIFICA SE ESTADO ES OPEN

END
