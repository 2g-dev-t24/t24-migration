* @ValidationCode : MjoxNzMwNDM0NjEzOkNwMTI1MjoxNzUzMjAwMzg2ODQ2Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Jul 2025 13:06:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.VERIFICA.RFC.COMI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Display
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ID.COMISIONISTA = EB.SystemTables.getComi()

    F.ABC.COMISIONISTAS = ""
    FN.ABC.COMISIONISTAS = "F.ABC.COMISIONISTAS"
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS,F.ABC.COMISIONISTAS)
       
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.ID.COMISIONISTA NE '' THEN
        RECORD.COMI = ''
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS, Y.ID.COMISIONISTA, RECORD.COMI, F.ABC.COMISIONISTAS, Y.ERR.READ)
        IF RECORD.COMI THEN
            Y.RFC.COMISIONISTA = RECORD.COMI<AbcTable.AbcComisionistas.RfcComisionista>
            
            EB.SystemTables.setRNew(AbcTable.AbcComisionistasEstabl.RfcComisionista, Y.RFC.COMISIONISTA)
            
            tmp = EB.SystemTables.getT(AbcTable.AbcComisionistasEstabl.RfcComisionista)
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcComisionistasEstabl.RfcComisionista, tmp)
            EB.Display.RebuildScreen()
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END
