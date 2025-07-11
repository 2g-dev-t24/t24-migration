* @ValidationCode : MjotMTg5OTI5NjE3OTpDcDEyNTI6MTc1MjE5NzY2Njg0MTp0cmFiYWpvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Jul 2025 22:34:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : trabajo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.CHECA.CAJA.ABIERTO
*
*
*    First Release :
*    Developed for :
*    Developed by  :
*
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
*************************************************************************
*INICIALIZA
*
    TELLER.ID= EB.SystemTables.getComi()
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID = ""
    EB.DataAccess.Opf(FN.TELLER.ID, F.TELLER.ID)



*PROCESA

    EB.DataAccess.FRead(FN.TELLER.ID,TELLER.ID,R.TELLER.ID,F.TELLER.ID,ERR.DETAIL)
    Y.ESTADO = ''
    IF R.TELLER.ID THEN
        Y.ESTADO = R.TELLER.ID<TT.Contract.TellerId.TidStatus>
    END
*VERIFICA SE ESTADO ES OPEN
    IF Y.ESTADO EQ "OPEN" THEN
        E="CAJA YA ABIERTA"
    END

END
