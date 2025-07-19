* @ValidationCode : Mjo5ODkxNTM5MjU6Q3AxMjUyOjE3NTIzNjczMjQ3NTY6dHJhYmFqbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jul 2025 21:42:04
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
        EB.SystemTables.setE("CAJA YA ABIERTA")
    END
RETURN
END
