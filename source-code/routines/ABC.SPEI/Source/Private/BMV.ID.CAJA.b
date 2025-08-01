* @ValidationCode : MjoyMzE0NDcyMzU6Q3AxMjUyOjE3NDc1MDk2OTc3Njk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 May 2025 16:21:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcSpei
SUBROUTINE BMV.ID.CAJA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING FT.Contract
    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Updates

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    USUARIO = EB.SystemTables.getOperator()

    FN.TELLER.USER = "FBNK.TELLER.USER"
    F.TELLER.USER = ""
    EB.DataAccess.Opf(FN.TELLER.USER, F.TELLER.USER)

    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","CHQ.ISSUE.ID",CHQ.ISSUE.ID.POS)

RETURN


*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    TELLER.USER.REC = TT.Contract.Teller.Read(USUARIO, Error)

    ID.CAJA = TELLER.USER.REC<1>
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    
    Y.LOCAL.REF<1,CHQ.ISSUE.ID.POS> = ID.CAJA
    
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
    
RETURN

END



