* @ValidationCode : MjoxNzI4MjEyMTY4OkNwMTI1MjoxNzUzMTQ4MDgyODg5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2025 22:34:42
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

SUBROUTINE ABC.VERIFICA.RFC.ADMIN
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
    Y.AC.ID.ADMINISTRADOR = EB.SystemTables.getComi()
    Y.AC.OP.ADMIN = EB.SystemTables.getRNew(AbcTable.AbcComisionistas.OpAdmin)
    
    F.ABC.COMISIONISTAS.ADMIN = ""
    FN.ABC.COMISIONISTAS.ADMIN = "F.ABC.COMISIONISTAS.ADMIN"
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.ADMIN,F.ABC.COMISIONISTAS.ADMIN)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.AC.ID.ADMINISTRADOR NE '' THEN
        RECORD.COMI = ''
        EB.DataAccess.FRead(FN.ABC.COMISIONISTAS.ADMIN, Y.AC.ID.ADMINISTRADOR, RECORD.COMI, F.ABC.COMISIONISTAS.ADMIN, ERR.READ)
        IF (RECORD.COMI) THEN
            Y.ACA.RFC = RECORD.COMI<AbcTable.AbcComisionistasAdmin.Rfc>
            EB.SystemTables.setRNew(AbcTable.AbcComisionistas.RfcAdmin, Y.ACA.RFC)
            
            tmpAdmin = EB.SystemTables.getT(AbcTable.AbcComisionistas.RfcAdmin)
            tmpAdmin<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcComisionistas.RfcAdmin, tmpAdmin)
            EB.Display.RebuildScreen()
        END
    END ELSE
        IF Y.AC.OP.ADMIN EQ 'SI' THEN
            ETEXT = "SELECCIONAR EL ID DE ADMINISTRADOR "
            EB.SystemTables.setEtext(ETEXT)
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END
