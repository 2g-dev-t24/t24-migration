* @ValidationCode : MjotMTk4NjE4NTIxNzpDcDEyNTI6MTc0ODExMzcyMjYwMTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 May 2025 16:08:42
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

SUBROUTINE ABC.VALIDA.CANAL.FT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.ErrorProcessing
    

    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

RETURN

***********
INICIALIZA:
***********

    Y.CANAL = ''
    Y.ERROR = ''



    NOM.CAMPOS     = 'L.CANAL.ENTIDAD'
    POS.CAMP.LOCAL = ""
    
    
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)

    YPOS.CANAL     = POS.CAMP.LOCAL<1,1>


RETURN

***************
VALIDA.USUARIO:
***************

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)

    Y.CANAL = Y.LOCAL.REF<1,YPOS.CANAL>
    
    AbcSpei.abcValidaCanal(Y.CANAL, Y.ERROR)

    IF Y.ERROR NE '' THEN
        
        ETEXT = Y.ERROR
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()

    END

RETURN

END
